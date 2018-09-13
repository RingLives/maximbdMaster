<?php

namespace App\Http\Controllers\taskController;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use Validator;
use Auth;
use DB;

class ChallanListController extends Controller
{
    public function challanListView(){
        $challanDetails = DB::table('Mxp_multipleChallan')
            ->groupBy('challan_id')
            ->orderBy('id','DESC')
            ->paginate(15);
        return view('maxim.challan.list.challanList',compact('challanDetails'));
    }


    public function showChallanReport(Request $request){
//        $this->print_me($request->cid);
        $headerValue = DB::table("mxp_header")->where('header_type',11)->get();
        $multipleChallan = DB::select(" select * from Mxp_multipleChallan where challan_id ='".$request->cid."'");
        $buyerDetails = DB::table("mxp_bookingBuyer_details")->where('booking_order_id',$request->bid)->get();
        $footerData = DB::select("select * from mxp_reportFooter");

        return view('maxim.challan.challanBoxingPage',
            [
                'footerData' => $footerData,
                'headerValue' => $headerValue,
                'buyerDetails' => $buyerDetails,
                'multipleChallan' => $multipleChallan
            ]);
    }

    public function getChallanListByChallanId(Request $request){

        $challanList = DB::table('Mxp_multipleChallan')
            ->where('challan_id', 'like', '%'.$request->challan_id.'%')
            ->groupBy('challan_id')
            ->orderBy('id','DESC')
            ->get();

        return $challanList;
    }

    public function getChallanListBySearch(Request $request){

        $challanList = DB::table('Mxp_multipleChallan');
        $checkValidation = false;

        if($request->booking_id_search != '')
        {
            $checkValidation = true;
            $challanList->where('checking_id','like','%'.$request->booking_id_search.'%');
        }
        if($request->from_create_date_search != '' && $request->to_create_date_search != '')
        {
            $checkValidation = true;
            if($request->from_create_date_search == $request->to_create_date_search)
                $challanList->whereDate('created_at', $request->from_create_date_search);
            else
                $challanList->whereDate('created_at','>=',$request->from_create_date_search)->whereDate('created_at','<=',$request->to_create_date_search);
        }

        if($checkValidation)
        {
            $challans = $challanList->groupBy('challan_id')->orderBy('id','DESC')->get();
            return $challans;
        }
        else
            return null;
    }
}
