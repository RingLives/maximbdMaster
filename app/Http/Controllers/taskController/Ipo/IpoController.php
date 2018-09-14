<?php

namespace App\Http\Controllers\taskController\Ipo;

use App\Http\Controllers\Message\ActionMessage;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Model\MxpBookingChallan;
use Illuminate\Http\Request;
use Carbon\Carbon;
use App\MxpIpo;
use Validator;
use Auth;
use DB;

class IpoController extends Controller
{
  public function ipoReportView(Request $request){
    $headerValue = DB::table("mxp_header")->where('header_type',11)->get();
    $buyerDetails = DB::table("mxp_bookingbuyer_details")->where('booking_order_id',$request->bid)->get();
    $footerData =[];
    $ipoDetails = DB::table("mxp_ipo")->where([['ipo_id', $request->ipoid],['booking_order_id',$request->bid]])->get();
    return view('maxim.ipo.ipoBillPage', [
        'headerValue'  => $headerValue,
        'initIncrease' => $request->ipoIncrease,
        'buyerDetails' => $buyerDetails,
        'sentBillId'   => $ipoDetails,
        'footerData'   => $footerData
      ]
    );
  }

	function array_combine_($keys, $values){
	    $result = array();
	    foreach ($keys as $i => $k) {
	        $result[$k][] = isset($values[$i]) ? $values[$i] : 0;
	    }
	    array_walk($result, create_function('&$v', '$v = (count($v) == 1)? array_pop($v): $v;'));
	    return  $result;
	}

    public function storeIpo(Request $request){

		$datas = $request->all();
    $booking_order_id = $request->booking_order_id;
    $allId = $datas['ipo_id'];
    $product_qty = $datas['product_qty'];
    $ipoIncrease = $datas['ipo_increase_percentage'];

       /**
      - This Array most important to create challan
      - and update BookingChallan table
      **/
        $combineMrfInputAndDb= '';
        $tempValue = [];
        $tempMrfValue = [];
        $quantity = [];
        $dbValue = [];
        $finalData = [];
        $tempValues = [];

      /**
      - This section check to one booking Challan value
      - empty or not empty ( this mean challan complte).
      - If empty all value then redirect create challan page.
      **/

        $length = sizeof($product_qty);
        $count = 0;
        foreach ($product_qty as $value) {
			if($value == 0 || $value < 0 ){
				$count++;
			}
        }

      if($count == $length){
        StatusMessage::create('erro_challan', 'Ops! Challan has been complte ');

        return \Redirect()->Route('dashboard_view');
      }

      /**
      - This Section create to concat all Get input
      - value by item id and store $tempValue Array.
      **/
		
		$temp = $this->array_combine_ ($allId ,$product_qty);


      /**
      - This Section add new MRF qty + DB MRF qty.
      **/

        $mrfQuantityDb = [];
        foreach ($temp as $key => $value) {
        	$getMrfDbvalue = DB::select(" select ipo_quantity from mxp_booking_challan where id ='".$key."'");
        	foreach ($getMrfDbvalue as $Mrfvalue) {
          		$mrfQuantityDb[$key] = explode(',', $Mrfvalue->ipo_quantity);
        	}
        }
      // self::print_me($mrfQuantityDb);
       $mrfInputValues = [];
        foreach ($temp as $key => $tempsValue) {
          if(sizeof($tempsValue) >1){
            foreach ($tempsValue as $tempItem) {
              $mrfInputValues[] = $tempItem;
            }
          }else{
            $mrfInputValues[] = $tempsValue;
          }
        }

        $mrfDbQty = [];
        foreach ($mrfQuantityDb as $key => $mrfDb) {

          if(sizeof($mrfDb) > 1){
            foreach ($mrfDb as $mrfDbItems) {
              $mrfDbQty[] = $mrfDbItems;
            }
          }else{
            foreach ($mrfDb as $valuess) {
            $mrfDbQty[] = $valuess;
            }
          }
        }

      foreach ($mrfQuantityDb as $mrfQuantity) {
        foreach ($mrfQuantity as $mrf) {

            if(empty($mrf)){
              foreach ($temp as $key => $value) {
                if(sizeof($value) > 1){
                  $tempValue[$key]= implode(',', $value);
                }else{
                  $tempValue[$key] = $value;
                }
              }
            }else{
               $combineMrfInputAndDb = $this->array_combine_($mrfInputValues,$mrfDbQty);
            }
        }
      }
      // self::print_me($combineMrfInputAndDb);
      if(!empty($combineMrfInputAndDb)){

          foreach ($combineMrfInputAndDb as $mrfInputValuesKeys => $mrfDbQtys) {
            if(sizeof($mrfDbQtys) > 1){
              foreach ($mrfDbQtys as $mrfQtys) {
               $tempMrfValue[] = $mrfQtys + $mrfInputValuesKeys;
              }
            }else{
            $tempMrfValue[] = $mrfDbQtys + $mrfInputValuesKeys;  //finalMrfData[] is same as twoArray[]
          }
        }

        $InputMrfAndDbMrfValue = $this->array_combine_($allId,$tempMrfValue);

          foreach ($InputMrfAndDbMrfValue as $key => $value) {
              if(sizeof($value) > 1){
                $tempValue[$key]= implode(',', $value);
              }else{
                $tempValue[$key] = $value;
              }
            }
      }


      /**
        - End Section.
      **/

      /**
        - This section most importent to update all array
        - value. Becouse this section create to array_combine
        - database primary id.
        - @param $maindata
      **/

      $inputMrfValue = $this->array_combine_($allId,$product_qty);
      foreach ($inputMrfValue as $key => $value) {
          if(sizeof($value) > 1){
            $mainData[$key]= implode(',', $value);
          }else{
            $mainData[$key] = $value;
          }
        }



      /** This code only for mxp_booking_Challan Table update **/

      foreach($tempValue as $key => $value){
        $findChallanUpdate = DB::select(" select left_mrf_ipo_quantity from mxp_booking_challan where id ='".$key."'");
        
        foreach ($findChallanUpdate as $challanValues) {
          $quantity[] = explode(',', $challanValues->left_mrf_ipo_quantity);
        }
      }

      foreach ($quantity as $key => $value) {
        foreach ($value as $item) {
          $dbValue[] = $item;
        }
      }

      $combineUpdateDatas = $this->array_combine_($product_qty,$dbValue);

      foreach ($combineUpdateDatas as $keys => $datas) {
        if(sizeof($datas) > 1){
          foreach ($datas as $value) {
           $finalData[] = $value - $keys;
          }
        }else{
        $finalData[] = $datas - $keys;  //finalData[] is same as twoArray[]
      }
    }
      $tempp = $this->array_combine_($allId, $finalData);
      foreach ($tempp as $key => $value) {
          if(sizeof($value) > 1){
            $tempValues[$key] = implode(',', $value);
          }else{
            $tempValues[$key] = $value;
          }
      }

      // self::print_me($tempValue);

      $makeOneArray = [];
      foreach ($tempValue as $key => $value) {
        $makeOneArray[$key]['ipo_quantity'] = $value;
      }
      foreach ($tempValues as $key => $value) {
        $makeOneArray[$key]['left_mrf_ipo_quantity'] = $value;
      }

      /** Quantity and Mrf value Insert **/
      foreach ($makeOneArray as $key => $minusValues) {
        $challanMinusValueInsert = MxpBookingChallan::find($key);
        $challanMinusValueInsert->left_mrf_ipo_quantity = $minusValues['left_mrf_ipo_quantity'];
        $challanMinusValueInsert->ipo_quantity = $minusValues['ipo_quantity'];
        $challanMinusValueInsert->update();
      }

      $cc = MxpIpo::count();
      $count = str_pad($cc + 1, 4, 0, STR_PAD_LEFT);
      $id = "IPO"."-";
      $date = date('dmY') ;
      $ipo_id = $id.$date."-".$count;

      $mainData = $this->increaseIpoValue($allId, $ipoIncrease,$mainData);

      foreach ($mainData as $key => $value) {
      // $this->print_me($value);
        $getBookingChallanValue = DB::table("mxp_booking_challan")->where('id',$key)->get();
        foreach ($getBookingChallanValue as $bookingChallanValue) {
            $createIpo                   = new MxpIpo();
            $createIpo->user_id          = Auth::user()->user_id;
      			$createIpo->ipo_id           = $ipo_id;
            $createIpo->booking_order_id = $bookingChallanValue->booking_order_id;
            $createIpo->erp_code         = $bookingChallanValue->erp_code;
            $createIpo->item_code        = $bookingChallanValue->item_code;
            $createIpo->item_size        = $bookingChallanValue->item_size;
            $createIpo->item_description = $bookingChallanValue->item_description;
            $createIpo->item_quantity    = $value['item_quantity'];
            $createIpo->initial_increase = $value['increaseValue'];
      			$createIpo->item_price       = $bookingChallanValue->item_price;
      			$createIpo->matarial         = $bookingChallanValue->matarial;
      			$createIpo->gmts_color       = $bookingChallanValue->gmts_color;
      			$createIpo->others_color     = $bookingChallanValue->others_color;
      			$createIpo->orderDate        = $bookingChallanValue->orderDate;
      			$createIpo->orderNo          = $bookingChallanValue->orderNo;
      			$createIpo->shipmentDate     = $bookingChallanValue->shipmentDate;
            $createIpo->poCatNo          = $bookingChallanValue->poCatNo;
            $createIpo->ipo_quantity     = $value['item_quantity'];
      			$createIpo->sku              = $bookingChallanValue->sku;
      			$createIpo->status           = ActionMessage::CREATE;
      			$createIpo->save();
        }
      }

      $headerValue = DB::table("mxp_header")->where('header_type',11)->get();
      $buyerDetails = DB::table("mxp_bookingbuyer_details")->where('booking_order_id',$booking_order_id)->get();
      $footerData =[];
      $ipoDetails = DB::table("mxp_ipo")->where('ipo_id', $ipo_id)->get();

      return view('maxim.ipo.ipoBillPage', [
          'headerValue'  => $headerValue,
          'initIncrease' => $request->ipoIncrease,
          'buyerDetails' => $buyerDetails,
          'sentBillId'   => $ipoDetails,
          'footerData'   => $footerData
        ]
      );
    }


    public function increaseIpoValue(array $ipo_id = [], array $increase = [], array $maindata = null){
      $ipoAndIncreaseValue = [];
      $temp = $this->array_combine_ ($ipo_id ,$increase);
      foreach ($temp as $key => $values) {
        $ipoAndIncreaseValue[$key]['increaseValue']= implode(',', $values);
      }
      foreach ($maindata as $keys => $valuess) {
        $ipoAndIncreaseValue[$keys]['item_quantity']= $valuess;
      }
      return $ipoAndIncreaseValue;
    }

}