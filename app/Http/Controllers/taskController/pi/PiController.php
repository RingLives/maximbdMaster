<?php

namespace App\Http\Controllers\taskController\pi;

use App\Http\Controllers\Message\ActionMessage;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Model\MxpBookingChallan;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Validator;
use Auth;
use DB;
use App\Model\MxpBookingBuyerDetails;
use App\Model\MxpBooking;
use App\Model\MxpPi;

class PiController extends Controller
{
	public function piGenerate(Request $request){
		$data = $request->all();

		if($request->is_type === 'non_fsc'){
			$is_type = 'non_fsc';
		}else if($request->is_type === 'fsc'){
			$is_type = 'fsc';
		}
		// $this->print_me($is_type);

		if (empty($data)) {
			StatusMessage::create('empty_booking_data', 'Have not checked any Item !');
			return \Redirect()->Route('dashboard_view');
		}

		$getDbValue = [];
		foreach ($data as $key => $dataValue) {
			foreach ($dataValue as $values) {
				$getDbValue[] = DB::table('mxp_booking')->where('id',$values)->get();
			}
		}
		$pi_details = [];
		foreach ($getDbValue as $key => $aaavalue) {
			foreach ($aaavalue as $key => $bbbvalue) {
				$pi_details[] =  $bbbvalue;
			}
		}

		foreach ($data as $key => $dataValue) {
			foreach ($dataValue as $values) {
				$updateBookingtable = MxpBooking::find($values);
				$updateBookingtable->is_pi_type = $is_type;
				$updateBookingtable->save();
			}
		}

	    $buyerDetails = DB::table('mxp_bookingbuyer_details')
	    	->where('booking_order_id',$pi_details[0]->booking_order_id)
	    	// ->select('C_sort_name')
	    	->first();

		// $ccc = DB::table('mxp_pi')->orderBy('DESC')->limit(1);
		// $this->print_me($ccc);
		$cc = MxpPI::count();
		$count = str_pad($cc + 1, 4, 0, STR_PAD_LEFT);
		$date = date('dmY') ;
		$customid = $date."-".$buyerDetails->C_sort_name."-".$count;

		// $this->print_me($customid);/
		if(isset($pi_details) && !empty($pi_details)) {
			foreach ($pi_details as $piValues) {

				$piDetails = new MxpPi();
				$piDetails->p_id = $customid;
				$piDetails->job_no = $piValues->id;
				$piDetails->user_id = Auth::user()->user_id;
				$piDetails->booking_order_id = $piValues->booking_order_id;
				$piDetails->erp_code = $piValues->erp_code;
				$piDetails->item_code = $piValues->item_code;
				$piDetails->item_size = $piValues->item_size;
				$piDetails->item_description = $piValues->item_description;
				$piDetails->item_quantity = $piValues->item_quantity;
				$piDetails->item_price = $piValues->item_price;
				$piDetails->matarial = $piValues->matarial;
				$piDetails->gmts_color = $piValues->gmts_color;
				$piDetails->others_color = $piValues->others_color;
				$piDetails->orderDate = $piValues->orderDate;
				$piDetails->orderNo = $piValues->orderNo;
				$piDetails->shipmentDate = $piValues->shipmentDate;
				$piDetails->poCatNo = $piValues->poCatNo;
				$piDetails->oos_number = $piValues->oos_number;
				$piDetails->sku = $piValues->sku;
				$piDetails->style = $piValues->style;
				$piDetails->is_type = $is_type;
				$piDetails->save();
			}
		}

		$bookingDetails = DB::table('mxp_pi')
			->where([
				['p_id',$customid],
				['is_type',$is_type],
			])
			->get();
		$companyInfo = DB::table('mxp_header')->where('header_type', 11)->get();
		$footerData = DB::select("select * from mxp_reportfooter");

		// $this->print_me($bookingDetails);

		return view('maxim.pi_format.piReportPage', compact('companyInfo', 'bookingDetails','footerData','buyerDetails','is_type'));
	}
}