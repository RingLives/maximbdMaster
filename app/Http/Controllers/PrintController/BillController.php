<?php

namespace App\Http\Controllers\PrintController;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use App\MaxParty;
use Validator;
use Excel;
use DB;


class BillController extends Controller
{

    public function searchBill(){
      return view('print_file.billSearch.index');
    }

    public function challanView(){
      return view('print_file.challan.index');
    }

    public function searchBillPage(Request $request){
      $roleManage = new RoleManagement();

        $validMessages = [
            'bill_invo_no.required' => 'Invo no  is required.'
            ];
        $datas = $request->all();
      $validator = Validator::make($datas, 
            [
                'bill_invo_no' => 'required'
        ],
            $validMessages
        );

    if ($validator->fails()) {
      return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
    }

      $headerValue = DB::select("select * from mxp_header");

      $sentBillId = DB::select("select * from mxp_maximBill where bill_id= '".$request->bill_invo_no."'");

      if (empty($sentBillId)) {

        return \Redirect()->Route('all_bill_view');
        
      }

      return view('print_file.billSearch.billSearchPage',[
        'headerValue' => $headerValue,
        'sentBillId' => $sentBillId,
      ]);
    }

    public function challanAction(Request $request){
      $roleManage = new RoleManagement();

        $validMessages = [
            'challan_invo_no.required' => 'Invo no  is required.'
            ];
        $datas = $request->all();
      $validator = Validator::make($datas, 
            [
                'challan_invo_no' => 'required'
        ],
            $validMessages
        );

    if ($validator->fails()) {
      return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
    }
      $headerValue = DB::select("select * from mxp_header");
      $sentBillId = DB::select("select * from mxp_maximBill where bill_id= '".$request->challan_invo_no."' group by item_code");
      // self::print_me($sentBillId);
      return view('print_file.challan.challanBoxingPage',[
        'headerValue' => $headerValue,
        'sentBillId' => $sentBillId,
      ]);
    }
}
