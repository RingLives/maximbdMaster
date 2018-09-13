<?php

namespace App\Http\Controllers\taskController;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use App\Model\BookingFile;
use Illuminate\Http\Request;
use App\Model\MxpBookingBuyerDetails;
use App\Model\MxpBookingChallan;
use App\Model\MxpBooking;
use App\VendorPrice;
use App\MxpItemsQntyByBookingChallan;
use Validator;
use Auth;
use DB;

class BookingController extends Controller
{
    public function orderInputDetails(Request $request){

      return json_encode(DB::select('Call getProductSizeQuantityWithConcat("'.$request->item.'")'));
    }

    public function getVendorPrice(Request $request){
        $price  = VendorPrice::where('product_id',$request->productId)
            ->where('party_table_id', $request->company_id)
            ->orderBy('price_id', 'DESC')
            // ->get();
            ->first();

        if (count($price) > 0)
            return $price;
        else
            return new MxpBooking();
    }

    public function getordercode()
    {
      $results = array();
      $orderDetails = DB::select("SELECT `booking_order_id` FROM `mxp_booking` group by `booking_order_id` order by `id` DESC ");
      if(isset($orderDetails) && !empty($orderDetails)){
          foreach ($orderDetails as $orderKey => $orderValue) {
              
              $results[]['name'] = $orderValue->booking_order_id;
          }
      }
      print json_encode($results);
    }
    public function addBooking(Request $request){
      // $this->print_me($request->all());

      $roleManage = new RoleManagement();

      $validMessages = [
            'item_code.required' => 'Brand Name field is required.'
            ];
      $datas = $request->all();

      $validator = Validator::make($datas, 
            [
          'item_code' => 'required'
        ],
            $validMessages
        );

      if ($validator->fails()) {
        return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
      }

      $validationError = $validator->messages();
      $companySortName = '';
      $buyerDetails = json_decode($request['buyerDetails']);
      foreach ($buyerDetails as $getSortCname) {
          $companySortName = $getSortCname->sort_name;
      }

      $cc = MxpBookingBuyerDetails::count();
      $count = str_pad($cc + 1, 4, 0, STR_PAD_LEFT);
      $id = "BK"."-";
      $date = date('dmY') ;
      $customid = $id.$date."-".$companySortName."-".$count;

      foreach ($buyerDetails as $buyers) {

        $InserBuyerDetails = new MxpBookingBuyerDetails();
        $InserBuyerDetails->user_id = Auth::user()->user_id;
        $InserBuyerDetails->booking_order_id      = $customid;//'booking-abc-002';
        $InserBuyerDetails->Company_name          = $buyers->name;
        $InserBuyerDetails->C_sort_name           = $buyers->sort_name;
        $InserBuyerDetails->buyer_name            = $buyers->name_buyer;
        $InserBuyerDetails->address_part1_invoice = $buyers->address_part1_invoice;
        $InserBuyerDetails->address_part2_invoice = $buyers->address_part2_invoice;
        $InserBuyerDetails->attention_invoice     = $buyers->attention_invoice;
        $InserBuyerDetails->mobile_invoice        = $buyers->mobile_invoice;
        $InserBuyerDetails->telephone_invoice     = $buyers->telephone_invoice;
        $InserBuyerDetails->fax_invoice           = $buyers->fax_invoice;
        $InserBuyerDetails->address_part1_delivery = $buyers->address_part1_delivery;
        $InserBuyerDetails->address_part2_delivery = $buyers->address_part2_delivery;
        $InserBuyerDetails->attention_delivery    = $buyers->attention_delivery;
        $InserBuyerDetails->mobile_delivery       = $buyers->mobile_delivery;
        $InserBuyerDetails->telephone_delivery    = $buyers->telephone_delivery;
        $InserBuyerDetails->fax_delivery          = $buyers->fax_delivery;
        $InserBuyerDetails->shipmentDate          = $request->shipmentDate;
        $InserBuyerDetails->booking_status        = 'Booked';
        $InserBuyerDetails->is_complete           = 0;
        $InserBuyerDetails->save();
        $buyerId = $InserBuyerDetails->id;
      }

        $this->uploadBookingFiles($request, $buyerId);

        $data = $request->all();
        $item_description = (isset($data['item_description'])) ? $data['item_description'] : '';
        $item_gmts_color = (isset($data['item_gmts_color'])) ? $data['item_gmts_color'] : 0;
        $others_color = (isset($data['others_color'])) ? $data['others_color'] : 0;
        $oos_number = (isset($data['oos_number'])) ? $data['oos_number'] : '';
        $item_price = $data['item_price'];
        $item_size = (isset($data['item_size'])) ? $data['item_size'] : 0;
        $item_code = $data['item_code'];
        $item_qty = $data['item_qty'];
        $poCatNo = (isset($data['poCatNo'])) ? $data['poCatNo'] : '';
        $style = (isset($data['style'])) ? $data['style'] : '';
        $erp = (isset($data['erp'])) ? $data['erp'] : 0;
        $sku = $data['sku'];
      
      for ($i=0; $i < count($item_code); $i++) {
        $insertBooking = new MxpBooking();
        $insertBooking->user_id           = Auth::user()->user_id;
        $insertBooking->booking_order_id  = $customid ;//'booking-abc-001';
        $insertBooking->erp_code          = $erp[$i];
        $insertBooking->item_code         = $item_code[$i];
        $insertBooking->sku               = $sku[$i];
        $insertBooking->gmts_color        = $item_gmts_color[$i];//(!empty($item_gmts_color[$i]) ? $item_gmts_color[$i] : '');
        $insertBooking->others_color      = (!empty($others_color[$i]) ? $others_color[$i] : 0);
        $insertBooking->item_description  = (!empty($item_description[$i]) ? $item_description[$i] : 0);

        $insertBooking->oos_number  = (!empty($oos_number[$i]) ? $oos_number[$i] : 0);
        $insertBooking->poCatNo  = (!empty($poCatNo[$i]) ? $poCatNo[$i] : 0);
        $insertBooking->style  = (!empty($style[$i]) ? $style[$i] : 0);

        $insertBooking->item_size         = (!empty($item_size[$i]) ? $item_size[$i] : 0);
        $insertBooking->item_quantity     = (!empty($item_qty[$i]) ? $item_qty[$i] : 0 );
        $insertBooking->item_price        = (!empty($item_price[$i]) ? $item_price[$i] : 0 );
        $insertBooking->orderDate         = $request->orderDate;
        $insertBooking->orderNo           = $request->orderNo;
        $insertBooking->shipmentDate      = $request->shipmentDate;
        // $insertBooking->poCatNo           = $request->poCatNo;
        $insertBooking->season_code       = $request->season_code;
        $insertBooking->is_type           = $request->is_type;
        $insertBooking->save();
   		}

      $bookingValues = DB::select('SELECT erp_code,item_code,sku,others_color,item_description,item_price,orderDate,orderNo,shipmentDate,poCatNo, GROUP_CONCAT(gmts_color) as gmts_color,GROUP_CONCAT(item_size) as item_size, GROUP_CONCAT(item_quantity) as item_quantity FROM mxp_booking WHERE booking_order_id= "'.$customid.'" GROUP BY item_code');

      foreach ($bookingValues as $bookingValues) {
        /** insert mxp_booking_challan table need to create multiple challan **/        
        $insertBookingChallan = new MxpBookingChallan();
        $insertBookingChallan->user_id           = Auth::user()->user_id;
        $insertBookingChallan->booking_order_id  = $customid ;//'booking-abc-001';
        $insertBookingChallan->erp_code          = $bookingValues->erp_code;
        $insertBookingChallan->item_code         = $bookingValues->item_code;
        $insertBookingChallan->sku               = $bookingValues->sku;
        $insertBookingChallan->gmts_color        = $bookingValues->gmts_color;
        $insertBookingChallan->others_color      = $bookingValues->others_color;
        $insertBookingChallan->item_description  = $bookingValues->item_description;
        $insertBookingChallan->item_size         = $bookingValues->item_size;
        $insertBookingChallan->item_quantity     = $bookingValues->item_quantity;
        $insertBookingChallan->left_mrf_ipo_quantity     = $bookingValues->item_quantity;
        $insertBookingChallan->item_price        = $bookingValues->item_price;
        $insertBookingChallan->orderDate         = $bookingValues->orderDate;
        $insertBookingChallan->orderNo           = $bookingValues->orderNo;
        $insertBookingChallan->shipmentDate      = $bookingValues->shipmentDate;
        $insertBookingChallan->poCatNo           = $bookingValues->poCatNo;
        $insertBookingChallan->save();
        $bookingChallanId = $insertBookingChallan->id;

        $item_size = explode(',', $bookingValues->item_size);
        $item_qnty = explode(',', $bookingValues->item_quantity);
        $item_color = explode(',', $bookingValues->gmts_color);

        for ($i = 0; $i < count($item_size); $i++){
            $itemQntyByChalan = new MxpItemsQntyByBookingChallan();
            $itemQntyByChalan->booking_challan_id = $bookingChallanId;
            $itemQntyByChalan->booking_order_id = $insertBookingChallan->booking_order_id;
            $itemQntyByChalan->item_code = $insertBookingChallan->item_code;
            $itemQntyByChalan->erp_code = $insertBookingChallan->erp_code;
            $itemQntyByChalan->item_size = $item_size[$i];
            $itemQntyByChalan->item_quantity = $item_qnty[$i];
            $itemQntyByChalan->gmts_color = $item_color[$i];
            $itemQntyByChalan->save();
        }
      }

      $companyInfo = DB::table('mxp_header')->where('header_type',11)->get();

      $bookingReport = DB::select('call getBookinAndBuyerDeatils("'.$customid.'")');
      
      // $bookingReport = DB::table('mxp_booking as mb')
      //     ->join('mxp_bookingBuyer_details as mbd','mb.booking_order_id','mbd.booking_order_id')
      //     ->where('booking_order_id',$customid)
      //     ->get();

      $is_type = $request->is_type;

      $gmtsOrSizeGroup = DB::select("SELECT gmts_color,GROUP_CONCAT(item_size) as itemSize,GROUP_CONCAT(item_quantity) as quantity from mxp_booking WHERE booking_order_id = '".$customid."' GROUP BY gmts_color");
      $footerData = DB::select("select * from mxp_reportFooter");
      return view('maxim.orderInput.reportFile',compact('bookingReport','companyInfo','gmtsOrSizeGroup','footerData','is_type'));
    }



    public function uploadBookingFiles(Request $request, $buyerId)
    {
        $i = 9999;
        foreach ($_FILES["booking_files"]["tmp_name"] as $key => $tmp_name){
            $file_name_server =  date("dYimsH").$i.$buyerId.rand(100,999);
            $file_name= $_FILES["booking_files"]["name"][$key];
            $file_tmp =$_FILES["booking_files"]["tmp_name"][$key];
            $ext = pathinfo($file_name,PATHINFO_EXTENSION);
            $file_name_original = str_replace('.'.$ext, '', $file_name);

            if(move_uploaded_file($file_tmp=$_FILES["booking_files"]["tmp_name"][$key],"booking_files/".$file_name_server.'.'.$ext)){

                $saveData = new BookingFile();
                $saveData->booking_buyer_id = $buyerId;
                $saveData->file_name_original = $file_name_original;
                $saveData->file_name_server = $file_name_server;
                $saveData->file_ext = $ext;
                $saveData->save();

            }else{

                return 'false';
            }

            $i++;
        }
        return ture;
    }
}
