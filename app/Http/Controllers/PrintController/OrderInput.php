<?php

namespace App\Http\Controllers\PrintController;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use App\Model\MxpMultipleChallan;
use App\Model\MxpInputOrder;
use Carbon\Carbon;
use Response;
use Validator;
use Auth;
use DB;

class OrderInput extends Controller
{
    public function orderInputView(){
    	return view('print_file.orderInput.orderInput');
    }

    public function orderInputDetails(Request $request){

   	return json_encode(DB::select('Call getProductSizeQuantityWithConcat("'.$request->item.'")'));
   }

    public function orderInputAction(Request $request){
    	$roleManage = new RoleManagement();

   		$data = $request->all();
   		$erp = (isset($data['erp'])) ? $data['erp'] : [];
   		$item_code = $data['item_code'];
   		$item_size = (isset($data['item_size'])) ? $data['item_size'] : 0;
   		$item_qty = $data['item_qty'];
   		$item_price = $data['item_price'];

   		$inputValues = array();
   		for ($i=0; $i < (sizeof($erp) == 0) ? 0 : count($erp); $i++) {
   			$inputValues[$i]['erp'] = $erp[$i];
   			$inputValues[$i]['itemCode'] = $item_code[$i];
   			$inputValues[$i]['itemSize'] = $item_size[$i];
   			$inputValues[$i]['itemQty'] = (!empty($item_qty[$i]) ? $item_qty[$i] : 0 );
   			$inputValues[$i]['itemPrice'] = (!empty($item_price[$i]) ? $item_price[$i] : 0 );
   		
   		}
   		// self::print_me($inputValues);

   		$OrderInputUniqid = uniqid();

   		foreach ($inputValues as $inputData) {
   			$insertData = new MxpInputOrder();
        	$insertData->user_id = Auth::user()->user_id;
        	$insertData->order_id = $OrderInputUniqid;
        	$insertData->erp_code = $inputData['erp'];
        	$insertData->item_code = (isset($inputData['itemCode'])? $inputData['itemCode'] : '');
        	$insertData->oss = (isset($inputData['oss'])? $inputData['oss']: '');
        	$insertData->style = (isset($inputData['style'])? $inputData['style']:'');
        	$insertData->item_size = isset($inputData['itemSize']) ? $inputData['itemSize'] : 0;
          $insertData->quantity = (isset($inputData['itemQty'])?$inputData['itemQty']:0);
          $insertData->unit_price = (isset($inputData['itemPrice']) ? $inputData['itemPrice'] : 0);
        	// $insertData->incrementValue = $incrementValue;
        	$insertData->save();
   		}

   		$orderValue = DB::select("select erp_code,item_code,GROUP_CONCAT(item_size) as itemSize, GROUP_CONCAT(quantity) as quantity,GROUP_CONCAT(unit_price) as unitPrice from mxp_order_input where order_id= '".$OrderInputUniqid."' group by item_code");


      $headerValue = DB::select("select * from mxp_header");
      $sentBillId = array();
      // self::print_me($sentBillId);

      return view('print_file.orderInput.orderInputViewPage', compact('headerValue','sentBillId','orderValue'));
   }

   
}
