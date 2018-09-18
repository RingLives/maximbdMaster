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

class IpoListController extends Controller
{

	public function getIpoValue(){
		$ipoDetails = MxpIpo::orderBy('ipo_id','DESC')
			->paginate(20);
		return view('maxim.ipo.list.ipo_list',compact('ipoDetails'));
	}

	public function getIpoReport(Request $request){
		$headerValue  = DB::table("mxp_header")
			->where('header_type',11)
			->get();
			
		$buyerDetails = DB::table("mxp_bookingbuyer_details")
			->where('booking_order_id',$request->bid)
			->get();
		$footerData   = [];
		$ipoDetails   = DB::table("mxp_ipo")
			->where([
				['ipo_id',$request->ipoid],
				['booking_order_id',$request->bid],
			])
			->get();

		// $this->print_me($request->bid);

		$ipoIncrease = $ipoDetails[0]->initial_increase;

		return view('maxim.ipo.ipoBillPage', [
		    'headerValue'  => $headerValue,
		    'initIncrease' => $ipoIncrease,
		    'buyerDetails' => $buyerDetails,
		    'sentBillId'   => $ipoDetails,
		    'footerData'   => $footerData
		  ]
		);
	}
}