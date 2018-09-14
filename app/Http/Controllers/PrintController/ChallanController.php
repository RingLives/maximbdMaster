<?php

namespace App\Http\Controllers\PrintController;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use App\Model\MxpMultipleChallan;
use App\Model\MxpChallan;
use Carbon\Carbon;
use Response;
use Validator;
use Auth;
use DB;

class ChallanController extends Controller
{
    const CREATE_MULTIPLE_CHALLAN = "create";
    const UPDATE_MULTIPLE_CHALLAN = "update";

     public function challanView(){
       $sentBillId = [];
      return view('print_file.challan.index',compact('sentBillId'));
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
        StatusMessage::create('vaildate_error_mess', ' Invo no  is required. ');

        return \Redirect()->Route('challan_boxing_list_view');
      }
      $headerValue = DB::select("select * from mxp_header");
      $sentBillId = DB::select("select * from mxp_challan where bill_id= '".$request->challan_invo_no."' group by item_code");


      $multipleChallanList = DB::select("select * from mxp_multiplechallan where bill_id= '".$request->challan_invo_no."' group by challan_id");

      return view('print_file.challan.index',
        [
        'sentBillId' => $sentBillId,
        'multipleChallanList' => $multipleChallanList,
      ]);
    }

    public function multipleChallanSearch(Request $request){
      $roleManage = new RoleManagement();
      $validMessages = [
            'challan_invo_nos.required' => 'Invo no  is required.'
            ];
      $datas = $request->all();
      $validator = Validator::make($datas, 
            [
                'challan_invo_nos' => 'required'
        ],
            $validMessages
        );

      if ($validator->fails()) {

        return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
      }
      $multipleChallan = DB::select("select * from mxp_multiplechallan where bill_id= '".$request->challan_invo_nos."' and challan_id= '".$request->challan_id."'");

      if (empty($multipleChallan)) {

        return \Redirect()->Route('challan_boxing_list_view');
      }
      $footerData = DB::select("select * from mxp_reportfooter");
      $headerValue = DB::select("select * from mxp_header");

      return view('print_file.challan.challanBoxingPage',
        [
        'headerValue' => $headerValue,
        'multipleChallan' => $multipleChallan,
        'footerData' => $footerData,
      ]);
    }    

  public function autoInrement($value){

        return str_pad($value + 1, 3, "0", STR_PAD_LEFT);
    }

  public function array_combine_($keys, $values)
  {
      $result = array();
      foreach ($keys as $i => $k) {
          $result[$k][] = isset($values[$i]) ? $values[$i] : 0;
      }
      array_walk($result, create_function('&$v', '$v = (count($v) == 1)? array_pop($v): $v;'));
      return    $result;
  }

    public function multipleChallanAction(Request $request){

      $table = $request->all();
      $oneArray = $table['allId'];
      $twoArray = $table['product_qty'];
      $length = sizeof($twoArray);
      $count = 0;
      foreach ($twoArray as $value) {
        if($value == 0){
          $count++;
        }
      }

      if($count == $length){
        StatusMessage::create('erro_challan', 'All item quantity is empty, cannot generate challan ! ');

        return \Redirect()->Route('challan_boxing_list_view');
      }

      $temp = self::array_combine_($oneArray, $twoArray);
      foreach ($temp as $key => $value) {
          if(sizeof($value) > 1){
            $tempValue[] = implode(',', $value);
          }else{
            $tempValue[] = $value;
          }
      }
      // this code only for Challan increment id genarate

      $maxIncrement = DB::select("select max(incrementValue) from mxp_multiplechallan group by incrementValue");
        if(sizeof($maxIncrement) == 0){
            $number = 0;
        }else{
          foreach ($maxIncrement as $value) {
            foreach ($value as $key => $aa) {
                $number = intval($aa);
            }
        }  
        }
      $incrementValue = self::autoInrement($number);
      $one_uniq = array_unique($oneArray);
      $mainData = array_combine($one_uniq, $tempValue);

      $findSortNames = "";
      foreach ($mainData as $keys => $sortNames) {
        $findSortName = DB::select(" select sort_name from mxp_challan where id ='".$keys."'");
        foreach ($findSortName as $value) {
          $findSortNames = $value;
        }
      }
      // var_dump($findSortNames);die();
      // self::print_me($findSortNames);
      $MultipleChallanUniqueID = "CHA-".Carbon::now()->format('Ymd')."-".$findSortNames->sort_name."-".$incrementValue;
      $MultipleCheckingUniqueID = "CHK-".Carbon::now()->format('Ymd')."-".$findSortNames->sort_name."-".$incrementValue;

      

      foreach($mainData as $key => $value){
        $findChallanUpdate = DB::select(" select quantity from mxp_challan where id ='".$key."'");
        foreach ($findChallanUpdate as $challanValues) {
          $quantity[] = explode(',', $challanValues->quantity);
        }
      }

      foreach ($quantity as $key => $value) {
        foreach ($value as $item) {
          $dbValue[] = $item;
        }
      }

      $combineUpdateData = array_combine($dbValue, $twoArray);

      foreach ($combineUpdateData as $keys => $datas) {
        $finalData[] = $keys - $datas;  //finalData[] is same as twoArray[]
      }

      $tempp = self::array_combine_($oneArray, $finalData);

      foreach ($tempp as $key => $value) {
          if(sizeof($value) > 1){
            $tempValues[] = implode(',', $value);
          }else{
            $tempValues[] = $value;
          }
      }

      $challanTableUpdate = array_combine($one_uniq, $tempValues);
      $count_challan = 1;
      foreach ($challanTableUpdate as $key => $value) {
        $count = DB::select(" select * from mxp_challan where id ='".$key."'");
        foreach ($count as $countvalue) {
          $findChallanUpdateData = MxpChallan::find($key);
          $findChallanUpdateData->quantity = $value;
          $findChallanUpdateData->count_challan = $count_challan + $countvalue->count_challan;
          $findChallanUpdateData->save();
        } 

      }

      foreach ($mainData as $key => $value) {
        $findChallan = DB::select(" select * from mxp_challan where id ='".$key."'");
        foreach ($findChallan as $challanValue) {

          $insertMultipleChallan = new MxpMultipleChallan();
          $insertMultipleChallan->user_id = Auth::user()->user_id;

          $insertMultipleChallan->challan_id = $MultipleChallanUniqueID;
          $insertMultipleChallan->checking_id = $MultipleCheckingUniqueID;

          $insertMultipleChallan->bill_id = $challanValue->bill_id;
          $insertMultipleChallan->erp_code = $challanValue->erp_code;
          $insertMultipleChallan->item_code = $challanValue->item_code;
          $insertMultipleChallan->oss = $challanValue->oss;
          $insertMultipleChallan->style = $challanValue->style;
          $insertMultipleChallan->item_size = $challanValue->item_size;
          $insertMultipleChallan->quantity = $value;
          $insertMultipleChallan->unit_price = $challanValue->unit_price;
          $insertMultipleChallan->total_price = $challanValue->total_price;
          $insertMultipleChallan->party_id = $challanValue->party_id;
          $insertMultipleChallan->name_buyer = $challanValue->name_buyer;
          $insertMultipleChallan->name = $challanValue->name;
          $insertMultipleChallan->address = $challanValue->address;
          $insertMultipleChallan->attention_invoice = $challanValue->attention_invoice;
          $insertMultipleChallan->mobile_invoice = $challanValue->mobile_invoice;
          $insertMultipleChallan->incrementValue = $incrementValue;
          $insertMultipleChallan->status = self::CREATE_MULTIPLE_CHALLAN;
          $insertMultipleChallan->save();
        }        
      }

      $headerValue = DB::select("select * from mxp_header");
      $multipleChallan = DB::select(" select * from mxp_multiplechallan where challan_id ='".$MultipleChallanUniqueID."'");

      $footerData = DB::select("select * from mxp_reportfooter");

      return view('print_file.challan.challanBoxingPage',
        [
        'footerData' => $footerData,
        'headerValue' => $headerValue,
        'multipleChallan' => $multipleChallan,
      ]);
    }
}
