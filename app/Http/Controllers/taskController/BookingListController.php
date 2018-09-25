<?php

namespace App\Http\Controllers\taskController;

use  App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\taskController\BookingController;
use App\Http\Controllers\RoleManagement;
use App\Model\BookingFile;
use App\Model\MxpBooking;
use Illuminate\Http\Request;
use Carbon\Carbon;
use App\Supplier;
use App\MxpIpo;
use Validator;
use Auth;
use DB;
use Illuminate\Support\Facades\Response;
use ZipArchive;
use App\Model\MxpBookingBuyerDetails;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\File;

class BookingListController extends Controller
{   
    CONST CREATE_IPO = "create";
    CONST UPDATE_IPO = "update";

    public function bookingListView(){

        $bookingList = DB::table('mxp_bookingbuyer_details')
            ->where('is_complete', 0)
            ->groupBy('booking_order_id')
            ->orderBy('id','DESC')
            ->paginate(15);

        return view('maxim.booking_list.booking_list_page',compact('bookingList'));
    }

    public function getBookingItemLists($booking_id = null){

        if($booking_id == null)
            return false;
        $bookingList = DB::table('mxp_booking')
            ->where('booking_order_id', $booking_id)
            ->orderBy('id','DESC')
            ->get();
        if(isset($bookingList) && !empty($bookingList)){
            if(isset($bookingList) && !empty($bookingList)){
                foreach ($bookingList as &$booking) {
                    $booking->job_number = $booking->id;
                }
            }
            return $bookingList;
        }else{
            return false;
        }
    }

    public function bookingListReport(){

        $bookingList = DB::table('mxp_bookingbuyer_details')
            ->where('is_complete', 0)
            ->groupBy('booking_order_id')
            ->orderBy('id','DESC')
            ->paginate(150);

        if(isset($bookingList) && !empty($bookingList)){
            foreach ($bookingList as &$booking) {
                $booking->itemLists = $this->getBookingItemLists($booking->booking_order_id);
                $booking->pi_ipo_Mrf_challan_list = MxpBookingBuyerDetails::with('pi','challan','ipo', 'mrf')
                          ->where('booking_order_id', $booking->booking_order_id)
                          ->first();
            }
        }

        // $this->print_me($bookingList);


        return view('maxim.booking_list.booking_list_report',compact('bookingList'));
    }

    public function bookingFilesDownload(Request $request){

        $fileinfo = BookingFile::get()->where('booking_buyer_id', $request->booking_buyer_id);


        $files = [];
        $oriFiles = [];

        foreach ($fileinfo as $info){
            array_push($files, 'booking_files/'.$info->file_name_server.'.'.$info->file_ext);
            array_push($oriFiles, 'booking_files/'.$info->file_name_original.'.'.$info->file_ext);
        }

        $bbInfo = MxpBookingBuyerDetails::where('id', $request->booking_buyer_id)->first();

        $zipname = $bbInfo->booking_order_id.'.zip';
        $zip = new ZipArchive;
        $zip->open($zipname, ZipArchive::CREATE);

        $i=0;
        foreach ($files as $file) {
            $zip->addFile($file);
            $zip->renameName($file, $oriFiles[$i]);
            $i++;
        }
        $zip->close();

        header('Content-Type: application/zip');
        header('Content-disposition: attachment; filename='.$zipname);
        header('Content-Length: ' . filesize($zipname));

        readfile($zipname);

        File::delete($zipname);

        return redirect()->back();
    }

    public function showBookingReport(Request $request){
        // $bookingReport = DB::select("call getBookinAndBuyerDeatils('".$request->bid."')");

        $bookingReport = $this->getBookingDetailsValue($request->bid);
        $bookingBuyer = $this->getBookingBuyerDetails($request->bid);
        $companyInfo = DB::table('mxp_header')->where('header_type',11)->get();
        $user = new BookingController();
        $getBookingUserDetails = $user::getUserDetails( $request->bid );
        // $this->print_me($bookingBuyer);

        return view('maxim.orderInput.reportFile',compact('bookingReport','companyInfo','gmtsOrSizeGroup','getBookingUserDetails','bookingBuyer'));
    }

    public function getBookingReportListByBookingId(Request $request){

        $bookingList = DB::table('mxp_bookingbuyer_details')
            ->where('booking_order_id', 'like', '%'.$request->booking_id.'%')
            ->orderBy('id','DESC')
            ->get();
        if(isset($bookingList) && !empty($bookingList)){
            foreach ($bookingList as &$booking) {
                $booking->itemLists = $this->getBookingItemLists($booking->booking_order_id);
                $booking->pi_ipo_Mrf_challan_list = MxpBookingBuyerDetails::with('pi','challan','ipo', 'mrf')
                          ->where('booking_order_id', $booking->booking_order_id)
                          ->first();
            }
        }
        return $bookingList;
    }

    public function getBookingListByBookingId(Request $request){

        $bookingList = DB::table('mxp_bookingbuyer_details')
            ->where('booking_order_id', 'like', '%'.$request->booking_id.'%')
            ->orderBy('id','DESC')
            ->get();

        return $bookingList;
    }

    public function getBookingListBySearch(Request $request){

        $bookingList = DB::table('mxp_bookingbuyer_details');
        $checkValidation = false;

        if($request->buyer_name_search != '')
        {
            $checkValidation = true;
            $bookingList->where('buyer_name','like','%'.$request->buyer_name_search.'%');
        }
        if($request->company_name_search != '')
        {
            $checkValidation = true;
            $bookingList->where('Company_name','like','%'.$request->company_name_search.'%');
        }
        if($request->attention_search != '')
        {
            $checkValidation = true;
            $bookingList->where('attention_invoice','like','%'.$request->attention_search.'%');
        }
        if($request->from_oder_date_search != '' && $request->to_oder_date_search != '')
        {
            $checkValidation = true;
            if($request->from_oder_date_search == $request->to_oder_date_search)
                $bookingList->whereDate('created_at', $request->from_oder_date_search);
            else
                $bookingList->whereDate('created_at','>=',$request->from_oder_date_search)->whereDate('created_at','<=',$request->to_oder_date_search);
        }
//      if($request->from_shipment_date_search != '' && $request->to_shipment_date_search != '')
//      {
//          $checkValidation = true;
//          if($request->from_shipment_date_search == $request->to_shipment_date_search)
//              $bookingList->whereDate('created_at', $request->from_shipment_date_search);
//          else
//              $bookingList->whereBetween('created_at', [$request->from_shipment_date_search, $request->to_shipment_date_search]);
//      }

        if($checkValidation)
        {
            $bookings = $bookingList->groupBy('booking_order_id')->orderBy('id','DESC')->get();
            return $bookings;
        }
        else
            return null;
    }

    public function getBookingListbookSearch(Request $request){

        $bookingList = DB::table('mxp_bookingbuyer_details');
        $checkValidation = false;

        if($request->buyer_name_search != '')
        {
            $checkValidation = true;
            $bookingList->where('buyer_name','like','%'.$request->buyer_name_search.'%');
        }
        if($request->company_name_search != '')
        {
            $checkValidation = true;
            $bookingList->where('Company_name','like','%'.$request->company_name_search.'%');
        }
        if($request->attention_search != '')
        {
            $checkValidation = true;
            $bookingList->where('attention_invoice','like','%'.$request->attention_search.'%');
        }
        if($request->from_oder_date_search != '' && $request->to_oder_date_search != '')
        {
            $checkValidation = true;
            if($request->from_oder_date_search == $request->to_oder_date_search)
                $bookingList->whereDate('created_at', $request->from_oder_date_search);
            else
                $bookingList->whereDate('created_at','>=',$request->from_oder_date_search)->whereDate('created_at','<=',$request->to_oder_date_search);
        }
//      if($request->from_shipment_date_search != '' && $request->to_shipment_date_search != '')
//      {
//          $checkValidation = true;
//          if($request->from_shipment_date_search == $request->to_shipment_date_search)
//              $bookingList->whereDate('created_at', $request->from_shipment_date_search);
//          else
//              $bookingList->whereBetween('created_at', [$request->from_shipment_date_search, $request->to_shipment_date_search]);
//      }

        if($checkValidation)
        {
            $bookings = $bookingList->groupBy('booking_order_id')->orderBy('id','DESC')->get();
            if(isset($bookings) && !empty($bookings)){
                foreach ($bookings as &$booking) {
                    $booking->itemLists = $this->getBookingItemLists($booking->booking_order_id);
                }
            }
            // print '<pre>';
            // print_r($bookings);
            // print '</pre>';
            // die();
            return $bookings;
        }
        else
            return null;
    }

    public function createIpoView(Request $request){

        $ipoValue = DB::table("mxp_booking_challan")->where('booking_order_id', $request->booking_id)->get();

        if (empty($ipoValue)) {
            return \Redirect()->Route('dashboard_view');
        }
        $buyerDetails = DB::table("mxp_bookingbuyer_details")
            ->where('booking_order_id', $request->booking_id)
            ->get();

        $headerValue = DB::table("mxp_header")
            ->where('header_type', 11)
            ->get();

        $ipoListValue = DB::table("mxp_ipo")
            ->select('id','booking_order_id','ipo_id')
            ->where('booking_order_id', $request->booking_id)
            ->get();

        return view('maxim.ipo.ipo_price_manage', [
            'headerValue' => $headerValue,
            'buyerDetails' => $buyerDetails,
            'sentBillId' => $ipoValue,
            'ipoIds' => '0',
            'ipoIncrease' => $request->ipoIncrease,
            'ipoListValue' => $ipoListValue,
        ]);
    }

    public function createMrfView(Request $request){
        // return 'createMrfView and booking id is '.$request->booking_id;

         // $data = $request->all();

            $suppliers = Supplier::where('status', 1)
                                 ->where('is_delete', 0)
                                 ->get();

            $booking_order_id = $request->booking_id;

            $bookingDetails = DB::select("SELECT * FROM mxp_booking_challan WHERE booking_order_id = '".$request->booking_id."' GROUP BY item_code");

            $buyerDetails = DB::select("SELECT * FROM mxp_bookingbuyer_details WHERE booking_order_id = '".$request->booking_id."'");

            if(empty($bookingDetails)){
                StatusMessage::create('empty_booking_data', 'This booking id empty value !');

                return \Redirect()->Route('booking_list_view');
            }

            $MrfDetails = DB::select("select * from mxp_mrf_table where booking_order_id = '".$request->booking_id."' GROUP BY mrf_id");

            return view('maxim.mrf.mrf',compact('bookingDetails','MrfDetails','booking_order_id', 'suppliers'));
    }

    public function detailsViewForm(Request $request)
    {
        $bookingDetails = MxpBookingBuyerDetails::with('bookings', 'ipo', 'mrf')
                          ->where('booking_order_id', $request->booking_id)
                          ->first();

        return view('maxim.booking_list.booking_View_Details',
                    [
                        'booking_id' => $request->booking_id, 
                        'bookingDetails' => $bookingDetails
                    ]);
    }

    public static function getBookingDetailsValue($booking_order_id){
        // $bookingDetails = DB::select('SELECT mb.oos_number,mb.season_code,mb.style,mb.is_type,GROUP_CONCAT(mb.id) as job_id,mb.sku,mb.erp_code,mb.item_code,mb.item_price,mb.item_description, mb.orderDate,mb.orderNo,mb.shipmentDate,mb.poCatNo,mb.others_color ,GROUP_CONCAT(mb.item_size) as itemSize,GROUP_CONCAT(mb.gmts_color) as gmtsColor,GROUP_CONCAT(mb.item_quantity) as quantity,mbd.buyer_name,mbd.Company_name,mbd.C_sort_name,mbd.address_part1_invoice,mbd.address_part2_invoice,mbd.attention_invoice,mbd.mobile_invoice,mbd.telephone_invoice,mbd.fax_invoice,mbd.address_part1_delivery,mbd.address_part2_delivery,mbd.attention_delivery,mbd.mobile_delivery,mbd.telephone_delivery,mbd.fax_delivery,mbd.is_complete,mbd.booking_status,mbd.shipmentDate,mbd.booking_order_id from mxp_booking mb INNER JOIN mxp_bookingbuyer_details mbd on(mbd.booking_order_id = mb.booking_order_id) WHERE mb.booking_order_id = "' . $booking_order_id . '" GROUP BY mb.item_code ORDER BY mb.id ASC');

        $bookingDetails = MxpBooking::where('booking_order_id',$booking_order_id)
                    ->orderBy('id','ASC')
                    ->get();

        return $bookingDetails;
    }

    public static function getBookingBuyerDetails($booking_order_id){
        $buyerDetails = MxpBookingBuyerDetails::where('booking_order_id',$booking_order_id)
                    ->get();
        return $buyerDetails;
    }
}
