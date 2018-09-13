<?php 
namespace App\Http\Controllers\PrintController;

use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use Carbon\Carbon;
use App\MaxParty;
use App\MxpIpo;
use Validator;
use Excel;
use DB;
use Auth;

class IPOController extends Controller
{	
	CONST CREATE_IPO = "create";
	CONST UPDATE_IPO = "update";

	public function ipo_view(){
		return view('print_file.ipo.index');
	}

	public function ipo_Action(Request $request){
		$roleManage = new RoleManagement();

		$data = $request->input('initial_increase');

		if($data == ''){
			$data = 2;
		}
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
    $validationError = $validator->messages();
    $IpoUniqueID = "RGA".Carbon::now()->format('dmY')."-ACL-02-".mt_rand(10000,99999);

    $headerValue = DB::select("select * from mxp_header");
    $sentBillIds = DB::select("select * from mxp_maximBill where bill_id= '".$request->bill_invo_no."'");

    if (empty($sentBillIds)) {
      return \Redirect()->Route('ipo_view');
    }
    // self::print_me($sentBillIds);

    foreach ($sentBillIds as$value) {
    	$saveIpo = new MxpIpo();
    	$saveIpo->initial_increase = $data;
    	$saveIpo->checking_no = $IpoUniqueID;
    	$saveIpo->customer_id = $value->party_id;
    	$saveIpo->company_name = $value->name;
    	$saveIpo->user_id = Auth::user()->user_id;
    	$saveIpo->order_id = $value->order_id;
    	$saveIpo->bill_id = $value->bill_id;
    	$saveIpo->erp_code = $value->erp_code;
    	$saveIpo->item_code = $value->item_code;
    	$saveIpo->oss = $value->oss;
    	$saveIpo->style = $value->style;
    	$saveIpo->item_size = $value->item_size;
    	$saveIpo->quantity = $value->quantity;
    	$saveIpo->unit_price = $value->unit_price;
    	$saveIpo->total_price = $value->total_price;
    	$saveIpo->name_buyer = $value->name_buyer;
    	$saveIpo->name = $value->name;
    	$saveIpo->address = $value->address;
    	$saveIpo->attention_invoice = $value->attention_invoice;
    	$saveIpo->mobile_invoice = $value->mobile_invoice;
    	$saveIpo->status = self::CREATE_IPO;
    	$saveIpo->save();
    }
       // self::print_me($sentBillId);
      $sentBillId = DB::select("select * from mxp_ipo where checking_no= '".$IpoUniqueID."'");
      // self::print_me($sentBillIds);

    return view('print_file.ipo.ipoBillPage',[
    	'headerValue' => $headerValue,
      'initIncrease' => $request->initial_increase,
      'sentBillId' => $sentBillId,
    ]);
	}	
}