<?php

namespace App\Http\Controllers\taskController;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use App\Model\MxpBookingChallan;
use App\Model\MxpBookingMultipleChallan;
use App\Model\MxpMultipleChallan;
use App\MxpItemsQntyByBookingChallan;
use App\Model\MxpChallan;
use Carbon\Carbon;
use Validator;
use Auth;
use DB;

class ChallanController extends Controller
{
    const CREATE_MULTIPLE_CHALLAN = "create";
    const UPDATE_MULTIPLE_CHALLAN = "update";

    public function autoInrement($value){

        return str_pad($value + 1, 3, "0", STR_PAD_LEFT);
    }

    public function array_combine_($keys, $values){
        $result = array();
        foreach ($keys as $i => $k) {
            $result[$k][] = isset($values[$i]) ? $values[$i] : 0;
        }
        array_walk($result, create_function('&$v', '$v = (count($v) == 1)? array_pop($v): $v;'));
        return $result;
    }
    public function addChallan(Request $request){

        $table = $request->all();
        $oneArray = $table['allId'];
        $twoArray = $table['product_qty'];
        $itemDetails = $table['itemDetails'];

        $booking_order_id = '';
        $preMainData =[];
        $CurMainData =[];
        $checkingIdList = [];

        foreach ($itemDetails as $key=>$value){
            $challanIds = explode(',', $oneArray[$key]);
            foreach ($challanIds as $challanId){
                $findChallanUpdateData = MxpBookingChallan::find($challanId);
                $challanQnties = $findChallanUpdateData->item_quantity;
                $preMainData[$challanId] = $challanQnties;
                $checkingIdList[] = $findChallanUpdateData->booking_order_id;
            }
        }

        foreach ($itemDetails as $key=>$value)
        {
            $itemDetail = explode('~', $value);
            $itemQnty = $twoArray[$key];
            $challanIds = explode(',', $oneArray[$key]);

            foreach ($challanIds as $challanId)
            {
                $challanBooking = $this->getBookingChallan($challanId, $itemDetail);
                $booking_order_id = $challanBooking->booking_order_id;
                if($challanBooking->item_quantity >= $itemQnty)
                {
                    $qnty = $challanBooking->item_quantity - $itemQnty;
                    $itemQnty -= $itemQnty;
                    $challanBooking->item_quantity = $qnty;
                    $challanBooking->save();
                }
                else
                {
                    $itemQnty -= $challanBooking->item_quantity;
                    $challanBooking->item_quantity = 0;
                    $challanBooking->save();
                }

                $setChallans = $challanBooking = MxpItemsQntyByBookingChallan::where('booking_challan_id', $challanId)
                    ->where('item_code', $itemDetail[1])->get();

                $challanQnty = '';
                foreach ($setChallans as $challan){
                    $challanQnty .= $challan->item_quantity.',';
                }

                $setQnty=rtrim($challanQnty,", ");

                $findChallanUpdateData = MxpBookingChallan::find($challanId);
                $findChallanUpdateData->item_quantity = $setQnty;
                $findChallanUpdateData->save();

                $CurMainData[$challanId] = $setQnty;
            }
        }

        $mainData = [];
        foreach ($preMainData as $key=>$value){
            $preQntys = explode(',', $value);
            $curQntys = explode(',', $CurMainData[$key]);
            $updateQntys = '';

            foreach ($preQntys as $key1=>$value1){
                $updateQntys .= ($value1-$curQntys[$key1]).',';
            }

            $mainData[$key] = rtrim($updateQntys,", ");
        }
        $checkingOrders = implode(', ', array_unique($checkingIdList));

//      die();
//
//      $this->print_me($mainData);
//
//      /**
//      - This Array most important to create challan
//      - and update BookingChallan table
//      **/
//
//      $dbValue = [];
//      $quantity = [];
//      $finalData = [];
//      $tempValue = [];
//      $tempValues = [];
//
//      /**
//      - This section check to one booking Challan value
//      - empty or not empty ( this mean challan complte).
//      - If empty all value then redirect create challan page.
//      **/
//
//      $length = sizeof($twoArray);
//      $count = 0;
//      foreach ($twoArray as $value) {
//        if($value == 0 || $value < 0 ){
//          $count++;
//        }
//      }
//
//      if($count == $length){
//        StatusMessage::create('erro_challan', 'Ops! Challan has been complte ');
//
//        return \Redirect()->Route('dashboard_view');
//      }
//
//      /**
//      - This Section create to concat all Get input
//      - value by item id and store $tempValue Array.
//      **/
//
//      $temp = self::array_combine_($oneArray, $twoArray);
//      foreach ($temp as $key => $value) {
//          if(sizeof($value) > 1){
//            $tempValue[$key]= implode(',', $value);
//          }else{
//            $tempValue[$key] = $value;
//          }
//      }
//      $this->print_me($tempValue);
//      /**
//      - This section most importent to update all array
//      - value. Becouse this section create to array_combine
//      - database primary id.
//      - @param $maindata
//      **/
//
//      $one_uniq = array_unique($oneArray);
////      $mainData = array_combine($one_uniq, $tempValue);
//
////      $this->print_me($mainData);
//
//      /** This code only for mxp_booking_Challan Table update **/
//
//      $findChallanUpdate = [];
//
//      $setChallanQnty = [];
//
//      foreach($tempValue as $key => $value){
//         $challanBookingIds = explode(',', $key);
//         $currentQnties = explode(',',$value);
//
//         foreach ($challanBookingIds as $id){
//             $bookingChallanQnty = DB::select(" select item_quantity from mxp_booking_challan where id ='".$id."'");
//             foreach ($bookingChallanQnty as $val){
//
//                 $itemQnties = explode(',',$val->item_quantity);
//                 $findChallanUpdate[$id] = $val;
//
//                 foreach ($itemQnties as $index=>$itemQnty){
//                    if($itemQnty >= $currentQnties[$index]){
//                        $setChallanQnty[$id][] = $itemQnty-$currentQnties[$index];
//                        $currentQnties[$index] -= $currentQnties[$index];
//                    }
//                    else{
//                        $setChallanQnty[$id][] = 0;
//                        $currentQnties[$index] -= $itemQnty;
//                    }
//                 }
//             }
//         }
//        foreach ($findChallanUpdate as $key=>$challanValues) {
//          $quantity[$key] = explode(',', $challanValues->item_quantity);
//        }
//      }
//
//      $this->print_me($setChallanQnty);
//      $mainData = [];
//      $booking_ids = [];
//
//      foreach ($setChallanQnty as $key=>$values){
//          $qnty = implode(',',$values);
//          $mainData[$key] = $qnty;
//
//          $findChallanUpdateData = MxpBookingChallan::find($key);
//          $findChallanUpdateData->item_quantity = $qnty;
//          $findChallanUpdateData->save();
//
//          $booking_ids[$key] = $findChallanUpdateData->booking_order_id;
//          $booking_order_id = $findChallanUpdateData->booking_order_id;
//
//          $item_qnty = explode(',', $qnty);
//          $item_size = explode(',', $findChallanUpdateData->item_size);
//          $item_color = explode(',', $findChallanUpdateData->gmts_color);
//
//          for ($i = 0; $i < count($item_qnty); $i++){
//              MxpItemsQntyByBookingChallan::where('booking_challan_id', $findChallanUpdateData->id)
//                  ->where('item_size', $item_size[$i])
//                  ->where('gmts_color', $item_color[$i])
//                  ->update(['item_quantity' => $item_qnty[$i]]);
//          }
//      }
//      $booking_order_ids = array_unique($booking_ids);


//      echo $booking_order_id;
//      echo "<br>";
//      echo "<pre>";
//      print_r($findChallanUpdate);
//      echo "<br>";
//      echo "<pre>";
//      print_r($setChallanQnty);
//      echo "<br>";
//      $this->print_me($mainData);
//      $this->print_me($booking_order_id);

//        **End** edited by nabodip

//      $combineUpdateDatas = $this->array_combine_($twoArray,$dbValue);
//
//      foreach ($combineUpdateDatas as $keys => $datas) {
//        if(sizeof($datas) > 1){
//          foreach ($datas as $value) {
//           $finalData[] = $value - $keys;
//          }
//        }else{
//        $finalData[] = $datas - $keys;  //finalData[] is same as twoArray[]
//      }
//      }
//
//      $tempp = self::array_combine_($oneArray, $finalData);
//      foreach ($tempp as $key => $value) {
//          if(sizeof($value) > 1){
//            $tempValues[] = implode(',', $value);
//          }else{
//            $tempValues[] = $value;
//          }
//      }
//
//      $challanTableUpdate = array_combine($one_uniq, $tempValues);
//      $count_challan = 1;
//      $booking_order_id = '';
//      foreach ($challanTableUpdate as $key => $value) {
//        $count = DB::select(" select * from mxp_booking_challan where id ='".$key."'");
//        foreach ($count as $countvalue) {
//          $booking_order_id = $countvalue->booking_order_id;
//          $findChallanUpdateData = MxpBookingChallan::find($key);
//          $findChallanUpdateData->item_quantity = $value;
//          $findChallanUpdateData->save();
//
//            $item_qnty = explode(',', $value);
//            $item_size = explode(',', $findChallanUpdateData->item_size);
//            $item_color = explode(',', $findChallanUpdateData->gmts_color);
//
//            for ($i = 0; $i < count($item_qnty); $i++){
//                $itemQntyByChalan = MxpItemsQntyByBookingChallan::where('booking_challan_id', $findChallanUpdateData->id)
//                    ->where('item_size', $item_size[$i])
//                    ->where('gmts_color', $item_color[$i])
//                    ->update(['item_quantity' => $item_qnty[$i]]);
//            }
//        }
//
//      }

        /** End this code for update mxp_booking_Challan Table  **/

        /** this code only for Challan increment id genarate **/

        $companySortName = '';
        $buyerDetails = DB::table("mxp_bookingbuyer_details")->where('booking_order_id', $booking_order_id)->get();
        foreach ($buyerDetails as $getSortCname) {
            $companySortName = $getSortCname->C_sort_name;
        }

        // $cc = MxpBookingMultipleChallan::count();
        $cc = MxpMultipleChallan::distinct('challan_id')->count('challan_id');
        $count = str_pad($cc + 1, 4, 0, STR_PAD_LEFT);
//          $this->print_me($count);
        $id = "M-CHA" . "-";
        $date = date('dmY');
        $MultipleChallanUniqueID = $date . "-" . $companySortName . "-" . $count;
//        $MultipleCheckingUniqueID = $id . $date . "-" . $companySortName . "-" . $count;

        /** End this code only for Challan increment id genarate **/

        $allBookingId = [];

//        $this->print_me($mainData);

        foreach ($mainData as $key => $value) {
            $findChallan = DB::select(" select * from mxp_booking_challan where id ='".$key."'");
            //		 self::print_me($findChallan);
            foreach ($findChallan as $challanValue) {

                $insertMultipleChallan = new MxpMultipleChallan();
                $insertMultipleChallan->user_id = Auth::user()->user_id;

                $insertMultipleChallan->challan_id = $MultipleChallanUniqueID;
                $insertMultipleChallan->checking_ids_of_challan = $checkingOrders;
                $insertMultipleChallan->checking_id = $challanValue->booking_order_id;

                // $insertMultipleChallan->bill_id = $challanValue->bill_id;
                $insertMultipleChallan->erp_code = $challanValue->erp_code;
                $insertMultipleChallan->item_code = $challanValue->item_code;
                // $insertMultipleChallan->oss = $challanValue->oss;
                // $insertMultipleChallan->style = $challanValue->style;
                $insertMultipleChallan->gmts_color = $challanValue->gmts_color;
                $insertMultipleChallan->item_size = $challanValue->item_size;
                $insertMultipleChallan->quantity = $value;
                // $insertMultipleChallan->unit_price = $challanValue->unit_price;
                // $insertMultipleChallan->total_price = $challanValue->total_price;
                // $insertMultipleChallan->party_id = $challanValue->party_id;
                // $insertMultipleChallan->name_buyer = $challanValue->name_buyer;
                // $insertMultipleChallan->name = $challanValue->name;
                // $insertMultipleChallan->address = $challanValue->address;
                // $insertMultipleChallan->attention_invoice = $challanValue->attention_invoice;
                // $insertMultipleChallan->mobile_invoice = $challanValue->mobile_invoice;
                // $insertMultipleChallan->incrementValue = $incrementValue;
                $insertMultipleChallan->status = self::CREATE_MULTIPLE_CHALLAN;
                $insertMultipleChallan->save();

                $allBookingId[] = $challanValue->booking_order_id;
            }
        }

        $headerValue = DB::table("mxp_header")->where('header_type',11)->get();
        $multipleChallan = DB::select(" select * from mxp_multiplechallan where challan_id ='".$MultipleChallanUniqueID."'");
        $buyerDetails = DB::table("mxp_bookingbuyer_details")->where('booking_order_id',$booking_order_id)->get();
        $footerData = DB::select("select * from mxp_reportfooter");

        return view('maxim.challan.challanBoxingPage',
            [
                'footerData' => $footerData,
                'headerValue' => $headerValue,
                'buyerDetails' => $buyerDetails,
                'multipleChallan' => $multipleChallan
            ]);
    }

    private function getBookingChallan($challanId, $itemDetail){
        if($itemDetail[3] != '' && $itemDetail[2] != '')
        {
            $challanBooking = MxpItemsQntyByBookingChallan::where('booking_challan_id', $challanId)
                ->where('erp_code', $itemDetail[0])
                ->where('item_code', $itemDetail[1])
                ->where('item_size', $itemDetail[2])
                ->where('gmts_color', $itemDetail[3])
                ->first();
        }
        else if($itemDetail[3] == '' && $itemDetail[2] != '')
        {
            $challanBooking = MxpItemsQntyByBookingChallan::where('booking_challan_id', $challanId)
                ->where('erp_code', $itemDetail[0])
                ->where('item_code', $itemDetail[1])
                ->where('item_size', $itemDetail[2])
                ->first();
        }
        else if($itemDetail[3] != '' && $itemDetail[2] == '')
        {
            $challanBooking = MxpItemsQntyByBookingChallan::where('booking_challan_id', $challanId)
                ->where('erp_code', $itemDetail[0])
                ->where('item_code', $itemDetail[1])
                ->where('gmts_color', $itemDetail[3])
                ->first();
        }
        else if($itemDetail[3] == '' && $itemDetail[2] == '')
        {
            $challanBooking = MxpItemsQntyByBookingChallan::where('booking_challan_id', $challanId)
                ->where('erp_code', $itemDetail[0])
                ->where('item_code', $itemDetail[1])
                ->first();
        }
        return $challanBooking;
    }
}