<?php

namespace App\Http\Controllers\PrintController;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\RoleManagement;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Model\MxpChallan;
use App\Mxp_maximBill;
use Carbon\Carbon;
use App\MxpOrder;
use App\MaxParty;
use Validator;
use Auth;
use Excel;
use DB;

class TestController extends Controller
{
	const CREATE_BILL = "create";
	const UPDATE_BILL = "update";
    
    public function billView(){
        $wrongValues = [];
    	$buyer = DB::select('select * from mxp_party');
    	return view('print_file.bill_copy',['buyer'=>$buyer,'wrongValues'=>$wrongValues]);
    }

    // public function billGenarateView(){
    //     $wrongValues = [];
    // 	return view('print_file.bill.index',compact("wrongValues"));
    // }

    public function searchProductsize($product_code, $size , $sizes){
        foreach ($sizes as $key => $value) {
            if($value[0] == $product_code && $value[1] == $size){
                $results2[] = true;
            }else{
                $results2[] = false;
            }
        }
        $final_check[$size] = array_search(1, $results2);
        foreach ($final_check as $key => $value) {
            if(empty($value)){
                $GLOBALS['wrongSized'][] = $key;
            }
        }


    }

    public function autoInrement($value){

        return str_pad($value + 1, 3, "0", STR_PAD_LEFT);
    }


	 Public function billbillGenarate(Request $request){
	 	$roleManage = new RoleManagement();
        $GLOBALS['wrongSized'] = array();
        $validMessages = [
            'import_file.required' => 'Excel field is required.',
            'buyer_name.required' => 'Buyer Name is required.'
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas, 
            [
                'import_file' => 'required',
    			'buyer_name' => 'required'
		    ],
            $validMessages
        );

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}
        $validationError = $validator->messages();
        $maxIncrement = DB::select("select max(incrementValue) from mxp_order group by incrementValue");
        
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
 		$uniqid = uniqid();

        $file = $request->file('import_file');

        // checking if product exists in product table 

         $sizes = DB::select("select product_code, product_size as size from mxp_productSize");
        foreach ($sizes as $key => $value) {
                $sizes2[$key][0]=$value->product_code;
                $sizes2[$key][1]=$value->size;
        }

        $allProductCodeDB = DB::select("select product_code from mxp_product");
        foreach ($allProductCodeDB as $value) 
            $allProductCode[$value->product_code] = $value->product_code;

        if($file){
            $path = $file->getRealPath();
            $data = Excel::load($path, function($reader) {
            })->get();
            if(!empty($data) && $data->count()){
                foreach ($data as $key => $value) {

                    $result[$value->item_code] = array_search($value->item_code, $allProductCode);

                    // if(!empty($result[$value->item_code]) && !empty($value->size)){
                    //     self::searchProductsize($value->item_code, $value->size, $sizes2);
                    // }
                }
            }
        }
        // self::print_me($GLOBALS['wrongSized']);
        
        foreach ($result as $key => $value) {
            if(empty($value)){
                $wrongValues[] = $key;
            }
        }
        if(!empty($wrongValues)){
            
            StatusMessage::create('error_code', 'This product code is not available in product list.');
            return redirect()->route('bill_copy_view')->withErrors($wrongValues)->withInput();
        }

        // $sizeErrors = $GLOBALS['wrongSized'];
        // self::print_me($sizeErrors);
        // if(!empty($sizeErrors))
        // {
        //     return redirect()->route('bill_copy_view')->withErrors($sizeErrors)->withInput();
        // }
        // end

        if($file){
            $path = $file->getRealPath();
            $data = Excel::load($path, function($reader) {
            })->get();
            if(!empty($data) && $data->count()){
                foreach ($data as $key => $value) {
                	$ExportData = new MxpOrder();
                	$ExportData->user_id = Auth::user()->user_id;
                	$ExportData->order_id = $uniqid;
                	$ExportData->erp_code = $value->item_no_erp;
                	$ExportData->item_code = $value->item_code;
                	$ExportData->oss = $value->oss;
                	$ExportData->style = $value->style;
                	$ExportData->item_size = $value->size;
                    $ExportData->quantity = $value->qty_pcs;
                	$ExportData->incrementValue = $incrementValue;
                	$ExportData->save();
		    	}
            }
        } 

        /* there are all input data view page bill */
        $buyerDatils = MaxParty::where('name_buyer',$request->buyer_name)->get();
	    $headerValue = DB::select("select * from mxp_header");
        $orderValue = DB::select("select * from mxp_order where order_id= '".$uniqid."' group by item_code");

        // self::print_me($buyerDatils);
        $mainData = [];
	    foreach ($orderValue as $value) {
	    	$mainData[] =DB::select('Call getProductSizeQuantity("'.$value->item_code.'","'.$value->order_id.'")');
	    };

	    /* there are all input data entery database  maximbill */

        $buyername_buyer = "";
        $buyername = "";
        $buyerattention_invoice = "";
        $buyeraddress1 = "";
        $buyeraddress2 = "";
        $buyeraddress3 = "";
        $buyermobile = "";
        $buyersortName = "";
        foreach ($buyerDatils as $key => $value) {
            $buyerparty_id = $value->party_id;
            $buyername_buyer = $value->name_buyer;
            $buyername = $value->name;
            $buyerattention_invoice = $value->attention_invoice;
            $buyeraddress1 = $value->address_part1_invoice;
            $buyeraddress2 = $value->address_part2_invoice;
            $buyermobile = $value->mobile_invoice;
            $buyersortName = $value->sort_name;
        }

        // $sortName = $buyerDatils->sort_name;
        $orderAllValues = DB::select("select * from mxp_order where order_id= '".$uniqid."'");

        $billUniqueID = "INV-".Carbon::now()->format('Ymd')."-".$buyersortName."-".$incrementValue;
	     foreach ($mainData as  $valuedata) {
	    	foreach ($valuedata as $key => $billDatas) {
			    	$billData = new Mxp_maximBill();
                    $billData->user_id = Auth::user()->user_id;
                    $billData->order_id = $billDatas->order_id;
                    $billData->bill_id = $billUniqueID;
                    $billData->erp_code = $billDatas->erp_code;
                    $billData->item_code = $billDatas->item_code;
                    $billData->oss = $billDatas->oss;
                    $billData->style = $billDatas->style;
                    $billData->item_size = $billDatas->item_size;
                    $billData->quantity = $billDatas->quantity;
                    $billData->unit_price = $billDatas->unit_price;
                    $billData->total_price = $billDatas->unit_price*$billDatas->unit_price;
                    $billData->party_id = $buyerparty_id;
                    $billData->name_buyer = $buyername_buyer;
                    $billData->name = $buyername;
                    $billData->sort_name = $buyersortName;
                    $billData->attention_invoice = $buyerattention_invoice;
                    $billData->address = $buyeraddress1. $buyeraddress2;
                    $billData->mobile_invoice = $buyermobile;
                    $billData->status = self::CREATE_BILL;
                    $billData->save();

                    $challanData = new MxpChallan();
		        	$challanData->user_id = Auth::user()->user_id;
		        	$challanData->order_id = $billDatas->order_id;
		        	$challanData->bill_id = $billUniqueID;
		        	$challanData->erp_code = $billDatas->erp_code;
		        	$challanData->item_code = $billDatas->item_code;
		        	$challanData->oss = $billDatas->oss;
		        	$challanData->style = $billDatas->style;
		        	$challanData->item_size = $billDatas->item_size;
		        	$challanData->quantity = $billDatas->quantity;
		        	$challanData->unit_price = $billDatas->unit_price;
		        	$challanData->total_price = $billDatas->unit_price*$billDatas->unit_price;
                    $challanData->party_id = $buyerparty_id;
		        	$challanData->name_buyer = $buyername_buyer;
                    $challanData->name = $buyername;
		        	$challanData->sort_name = $buyersortName;
		        	$challanData->attention_invoice = $buyerattention_invoice;
                    $challanData->address = $buyeraddress1. $buyeraddress2;
		        	$challanData->mobile_invoice = $buyermobile;
		        	$challanData->status = self::CREATE_BILL;
		        	$challanData->save();
	       }
	    }

	    $sentBillId = DB::select("select * from mxp_maximBill where bill_id= '".$billUniqueID."' group by item_code");

    	return view('print_file.bill.printIndex',[
    		'mainData' => $mainData,
    		'buyerDatils' => $buyerDatils,
    		'headerValue' => $headerValue,
    		'sentBillId' => $sentBillId
    	]);
	    
	    }
}
