<?php

namespace App\Http\Controllers\taskController;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use App\Model\MxpBookingBuyerDetails;
use App\Model\MxpBookingChallan;
use App\Model\MxpBooking;
use Validator;
use Auth;
use DB;

class BookingController extends Controller
{
    public function orderInputDetails(Request $request){

      return json_encode(DB::select('Call getProductSizeQuantityWithConcat("'.$request->item.'")'));
     }

    public function getordercode()
    {
      $results = array();
      $orderDetails = DB::select("SELECT `booking_order_id` FROM `mxp_booking` order by `id` DESC ");
      if(isset($orderDetails) && !empty($orderDetails)){
          foreach ($orderDetails as $orderKey => $orderValue) {
              
              $results[]['name'] = $orderValue->booking_order_id;
          }
      }
      print json_encode($results);
    }
    public function addBooking(Request $request){
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
        $InserBuyerDetails->booking_status        = 'Booked';
        $InserBuyerDetails->is_complete           = 0;
        $InserBuyerDetails->save();

      }

        $data = $request->all();
        $item_code = $data['item_code'];
        $sku = $data['sku'];
        $erp = (isset($data['erp'])) ? $data['erp'] : 0;
        $item_size = (isset($data['item_size'])) ? $data['item_size'] : 0;
        $item_gmts_color = (isset($data['item_gmts_color'])) ? $data['item_gmts_color'] : 0;
        $others_color = (isset($data['others_color'])) ? $data['others_color'] : 0;
        $item_description = (isset($data['item_description'])) ? $data['item_description'] : '';
        $item_qty = $data['item_qty'];
        $item_price = $data['item_price'];
      
      for ($i=0; $i < count($item_code); $i++) {
        $insertBooking = new MxpBooking();
        $insertBooking->user_id           = Auth::user()->user_id;
        $insertBooking->booking_order_id  = $customid ;//'booking-abc-001';
        $insertBooking->erp_code          = $erp[$i];
        $insertBooking->item_code         = $item_code[$i];
        $insertBooking->sku         = $sku[$i];
        $insertBooking->gmts_color        = $item_gmts_color[$i];//(!empty($item_gmts_color[$i]) ? $item_gmts_color[$i] : '');
        $insertBooking->others_color        = (!empty($others_color[$i]) ? $others_color[$i] : 0);

        $insertBooking->item_description        = (!empty($item_description[$i]) ? $item_description[$i] : 0);

        $insertBooking->item_size         = (!empty($item_size[$i]) ? $item_size[$i] : 0);
        $insertBooking->item_quantity     = (!empty($item_qty[$i]) ? $item_qty[$i] : 0 );
        $insertBooking->item_price        = (!empty($item_price[$i]) ? $item_price[$i] : 0 );
        $insertBooking->orderDate         = $request->orderDate;
        $insertBooking->orderNo           = $request->orderNo;
        $insertBooking->shipmentDate      = $request->shipmentDate;
        $insertBooking->poCatNo           = $request->poCatNo;
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
        $insertBookingChallan->sku         = $bookingValues->sku;
        $insertBookingChallan->gmts_color        = $bookingValues->gmts_color;
        $insertBookingChallan->others_color      = $bookingValues->others_color;
        $insertBookingChallan->item_description  = $bookingValues->item_description;
        $insertBookingChallan->item_size         = $bookingValues->item_size;
        $insertBookingChallan->item_quantity     = $bookingValues->item_quantity;
        $insertBookingChallan->item_price        = $bookingValues->item_price;
        $insertBookingChallan->orderDate         = $bookingValues->orderDate;
        $insertBookingChallan->orderNo           = $bookingValues->orderNo;
        $insertBookingChallan->shipmentDate      = $bookingValues->shipmentDate;
        $insertBookingChallan->poCatNo           = $bookingValues->poCatNo;
        $insertBookingChallan->save();
      }

      $companyInfo = DB::table('mxp_header')->where('header_type',11)->get();

      $bookingReport = DB::select('call getBookinAndBuyerDeatils("'.$customid.'")');

      $gmtsOrSizeGroup = DB::select("SELECT gmts_color,GROUP_CONCAT(item_size) as itemSize,GROUP_CONCAT(item_quantity) as quantity from mxp_booking WHERE booking_order_id = '".$customid."' GROUP BY gmts_color");

      return view('maxim.orderInput.reportFile',compact('bookingReport','companyInfo','gmtsOrSizeGroup'));
    }
}
