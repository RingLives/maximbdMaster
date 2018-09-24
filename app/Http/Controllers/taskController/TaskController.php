<?php

namespace App\Http\Controllers\taskController;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\RoleManagement;
use App\Model\MxpBookingBuyerDetails;
use App\MxpIpo;
use App\Supplier;
use Auth;
use Carbon\Carbon;
use DB;
use Illuminate\Http\Request;
use Validator;

class TaskController extends Controller {
	CONST CREATE_IPO = "create";
	CONST UPDATE_IPO = "update";

	public function getBuyerCompany(Request $request) {
		return json_encode(DB::table('mxp_party')->where('name_buyer', $request->buyerName)->get());
	}

	public function getItemCode() {
		$results = array();
		$productDetails = DB::select("SELECT mp.product_code FROM mxp_product mp
        LEFT JOIN mxp_productsize mps ON (mps.product_code = mp.product_code)
        LEFT JOIN mxp_gmts_color mgs ON (mgs.item_code = mps.product_code) GROUP BY mps.product_code, mgs.item_code");
		if (isset($productDetails) && !empty($productDetails)) {
			foreach ($productDetails as $itemKey => $itemValue) {

				$results[]['name'] = $itemValue->product_code;
			}
		}
		print json_encode($results);
	}
	public function gettaskActionOrsubmited() {
		return \Redirect()->Route('dashboard_view');
	}
	public function taskActionOrsubmited(Request $request) {
		$roleManage = new RoleManagement();
		$datas = $request->all();

		$taskType = isset($request->taskType) ? $request->taskType : '';
		if ($taskType === 'booking' || $taskType === 'FSC Booking') {
			if($taskType == 'booking'){
				$taskType = 'Create Booking';
			}else{
				$taskType = 'Create FSC Booking';
			}

			$buyerDetails = DB::table('mxp_party')
				->where([
					['name_buyer', $request->buyerName],
					['name', $request->companyName],
				])
				->get();
			return view('maxim.orderInput.orderInputIndex', compact('buyerDetails'))->with(['taskType' => $taskType]);

		} elseif ($taskType === 'PI' || $taskType === 'FSC PI') {

			// $formatTypes = '1002';
			// // $formatTypes = $request->piFormat;
			// $companyInfo = DB::table('mxp_header')->where('header_type', 11)->get();
			// $bookingDetails = DB::select('call getBookinAndBuyerDeatils("' . $request->bookingId . '")');
			// if (empty($bookingDetails)) {
			// 	StatusMessage::create('empty_booking_data', 'This booking Id doesnot show any result . Please check booking Id !');

			// 	return \Redirect()->Route('dashboard_view');
			// }

			// $footerData = DB::select("select * from mxp_reportfooter");

			// return view('maxim.pi_format.piReportPage', compact('companyInfo', 'bookingDetails', 'footerData', 'formatTypes'));



			// $bookingDetails = DB::select('call getBookinAndBuyerDeatils("' . $request->bookingId . '")');

			if($taskType == 'PI'){
				$is_type = 'non_fsc';
				$bookingDetails = $this->getNonfscBookingValue($request->bookingId);
			}else if($taskType == 'FSC PI'){
				$is_type = 'fsc';
				$bookingDetails = $this->getFscBookingValue($request->bookingId);
			}


			// $this->print_me($is_Type);

			return view('maxim.pi_format.pi_generate_page',compact('bookingDetails','is_type'));

		} elseif ($taskType === 'IPO') {

				$validMessages = [
					'bookingId.required' => 'Booking Id is required.',
				];
				$datas = $request->all();
				$validator = Validator::make($datas,
					[
						'bookingId' => 'required',
					], $validMessages);

				if ($validator->fails()) {
					return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
				}
				$validationError = $validator->messages();	

				$ipoValue = DB::table("mxp_booking_challan")->where('booking_order_id', $request->bookingId)->get();

				if (empty($ipoValue)) {
					return \Redirect()->Route('dashboard_view');
				}
				$buyerDetails = DB::table("mxp_bookingbuyer_details")
									->where('booking_order_id', $request->bookingId)
									->get();

				$headerValue = DB::table("mxp_header")
									->where('header_type', 11)
									->get();

				$ipoListValue = DB::table("mxp_ipo")
									->select('id','booking_order_id','ipo_id')
									->where('booking_order_id', $request->bookingId)
									->get();

				return view('maxim.ipo.ipo_price_manage', [
					'headerValue' => $headerValue,
					'buyerDetails' => $buyerDetails,
					'sentBillId' => $ipoValue,
					'ipoIds' => '0',
					'ipoIncrease' => $request->ipoIncrease,
					'ipoListValue' => $ipoListValue,
				]);

		} elseif ($taskType === 'MRF') {
			$data = $request->all();

			$suppliers = Supplier::where('status', 1)
				->where('is_delete', 0)
				->get();

			$booking_order_id = $request->bookingId;
			$validMessages = [
				'bookingId.required' => 'Booking Id field is required.',
			];
			$validator = Validator::make($datas,
				[
					'bookingId' => 'required',
				],
				$validMessages
			);

			if ($validator->fails()) {
				return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
			}

			$validationError = $validator->messages();

			$bookingDetails = DB::select("SELECT * FROM mxp_booking_challan WHERE booking_order_id = '" . $request->bookingId . "' GROUP BY item_code");
			// self::print_me($bookingDetails);

			$buyerDetails = DB::select("SELECT * FROM mxp_bookingbuyer_details WHERE booking_order_id = '" . $request->bookingId . "'");

			if (empty($bookingDetails)) {
				StatusMessage::create('empty_booking_data', 'This booking Id does not show any result . Please check booking Id !');

				return \Redirect()->Route('dashboard_view');
			}

			$MrfDetails = DB::select("select * from mxp_mrf_table where booking_order_id = '" . $request->bookingId . "' GROUP BY mrf_id");
//            return $bookingDetails;
			return view('maxim.mrf.mrf', compact('bookingDetails', 'MrfDetails', 'booking_order_id', 'suppliers'));

		} elseif ($taskType === 'challan') {

			$validMessages = [
				'bookingIdList.required' => 'Booking Id field is required.',
			];
			$validator = Validator::make($datas,
				[
					'bookingIdList' => 'required',
				],
				$validMessages
			);

			if ($validator->fails()) {
				return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
			}

			$validationError = $validator->messages();
			$bookedId = rtrim($request->bookingIdList, ", ");

			$bookingIds = explode(",", $bookedId);
			$bookingIdList = [];
			$companyName = '';
			$iteration = 0;

			foreach ($bookingIds as $bookingId) {
				$tempbookingId = $bookingId;
				$tempbookingId = str_replace(' ', '', $tempbookingId);
				$tempbookingId = str_replace(',', '', $tempbookingId);
				$companyDetails = MxpBookingBuyerDetails::where('booking_order_id', $tempbookingId)->first();
				if ($iteration > 0) {
					if ($companyDetails->Company_name != $companyName) {
						return redirect()->back()->withInput($request->input())->withErrors("Booking order ids are not in same company");
					}
				}
				$companyName = $companyDetails->Company_name;
				$iteration++;
				$bookingDetails = DB::select("SELECT * FROM mxp_items_details_by_booking_challan WHERE booking_order_id = '" . $tempbookingId . "'");
				foreach ($bookingDetails as $currentBooking) {
					$checkMatch = true;
					foreach ($bookingIdList as $bookingList) {
						if (($bookingList->item_code == $currentBooking->item_code) && ($bookingList->item_size == $currentBooking->item_size) && ($bookingList->gmts_color == $currentBooking->gmts_color)) {
//                            echo "item size is ".$currentBooking->item_size." has qnty ".$currentBooking->item_quantity." and pre total is ".$bookingList->item_quantity." and after add ";
							$bookingList->item_quantity += $currentBooking->item_quantity;
							$bookingList->booking_order_id = $bookingList->booking_order_id . ',' . $currentBooking->booking_order_id;
							$bookingList->booking_challan_id = $bookingList->booking_challan_id . ',' . $currentBooking->booking_challan_id;
							$checkMatch = false;
//                            echo $bookingList->item_quantity."<br>";
						}
					}
					if ($checkMatch) {
						array_push($bookingIdList, $currentBooking);
					}

				}
			}
//            $this->print_me($bookingIdList);

//            for ($i = 1; $i < count($bookingIdList); $i++){
			//         	    for( $j = 0; $j < $i; $j++){
			//                    if ($bookingIdList[$i]->item_code == $bookingIdList[$j]->item_code){
			//                        $bookingIdList[$j]->item_size = $bookingIdList[$j]->item_size.','.$bookingIdList[$i]->item_size;
			//                        $bookingIdList[$j]->item_quantity = $bookingIdList[$j]->item_quantity.','.$bookingIdList[$i]->item_quantity;
			//                        $bookingIdList[$j]->gmts_color = $bookingIdList[$j]->gmts_color.','.$bookingIdList[$i]->gmts_color;
			////                        $bookingIdList[$j]->booking_order_id = $bookingIdList[$j]->booking_order_id.','.$bookingIdList[$i]->booking_order_id;
			//                        $bookingIdList[$j]->booking_challan_id = $bookingIdList[$j]->booking_challan_id.'_'.$bookingIdList[$i]->booking_challan_id;
			//                        unset($bookingIdList[$i]);
			//                    }
			//                }
			//            }
			foreach ($bookingIdList as $booking) {
				if (!$booking->items_details_id) {
					unset($booking);
				}

			}
			$bookingDetails = $bookingIdList;
//            $this->print_me($bookingIdList);

			$buyerDetails = DB::select("SELECT * FROM mxp_bookingbuyer_details WHERE booking_order_id = '" . $bookedId . "'");

			if (empty($bookingDetails)) {
				StatusMessage::create('empty_booking_data', 'This booking Id does not show any result . Please check booking Id !');

				return \Redirect()->Route('dashboard_view');
			}

			$challanHistory = DB::table('mxp_multiplechallan')
				->where('checking_id',$bookedId)
				->get();

				// $this->print_me($challanHistory);

			return view('maxim.challan.challan', compact('bookingDetails','challanHistory'));
		} else if($taskType === 'bill'){

			$conversion_rate = $request->conversion_rate;
			$companyInfo = DB::table('mxp_header')->where('header_type', 11)->get();
			$bookingDetails = DB::select('call getBookinAndBuyerDeatils("' . $request->bookingId . '")');
			if (empty($bookingDetails)) {
				StatusMessage::create('empty_booking_data', 'This booking Id doesnot show any result . Please check booking Id !');

				return \Redirect()->Route('dashboard_view');
			}

			$footerData = DB::select("select * from mxp_reportfooter");

			return view('maxim.bill_copy.bill_report', compact('companyInfo', 'bookingDetails', 'footerData', 'conversion_rate'));

		} else {
			$validMessages = [
				'taskType.required' => 'TaskType field is required.',
			];
			$validator = Validator::make($datas,
				[
					'taskType' => 'required',
				],
				$validMessages
			);

			if ($validator->fails()) {
				return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
			}

			$validationError = $validator->messages();
		}
	}
	public static function getOrderQuantity($booking_order_id, $item_code, $item_size = null, $color = null) {

		if ($item_size == null) {
			if ($color == null) {
				$bookingQuantityDetails = DB::select("SELECT item_quantity FROM mxp_booking WHERE booking_order_id = '" . $booking_order_id . "' AND item_code = '" . $item_code . "'");
			} else {
				$bookingQuantityDetails = DB::select("SELECT item_quantity FROM mxp_booking WHERE booking_order_id = '" . $booking_order_id . "' AND item_code = '" . $item_code . "' AND gmts_color = '" . $color . "'");
			}

		} else {
			if ($color == null) {
				$bookingQuantityDetails = DB::select("SELECT item_quantity FROM mxp_booking WHERE booking_order_id = '" . $booking_order_id . "' AND item_code = '" . $item_code . "' AND item_size = '" . $item_size . "'");
			} else {
				$bookingQuantityDetails = DB::select("SELECT item_quantity FROM mxp_booking WHERE booking_order_id = '" . $booking_order_id . "' AND item_code = '" . $item_code . "' AND item_size = '" . $item_size . "' AND gmts_color = '" . $color . "'");
			}

		}
		return isset($bookingQuantityDetails[0]->item_quantity) ? $bookingQuantityDetails[0]->item_quantity : 0;

	}


	public function getNonfscBookingValue($booking_order_id){
		$bookingDetails = DB::select('SELECT mb.oos_number,mb.season_code,mb.style,mb.is_type,GROUP_CONCAT(mb.id) as abc,mb.sku,mb.erp_code,mb.item_code,mb.item_price,mb.item_description, mb.orderDate,mb.orderNo,mb.shipmentDate,mb.poCatNo,mb.others_color ,GROUP_CONCAT(mb.item_size) as itemSize,GROUP_CONCAT(mb.gmts_color) as gmtsColor,GROUP_CONCAT(mb.item_quantity) as quantity,mbd.buyer_name,mbd.Company_name,mbd.C_sort_name,mbd.address_part1_invoice,mbd.address_part2_invoice,mbd.attention_invoice,mbd.mobile_invoice,mbd.telephone_invoice,mbd.fax_invoice,mbd.address_part1_delivery,mbd.address_part2_delivery,mbd.attention_delivery,mbd.mobile_delivery,mbd.telephone_delivery,mbd.fax_delivery,mbd.is_complete,mbd.booking_status,mbd.shipmentDate,mbd.booking_order_id from mxp_booking mb INNER JOIN mxp_bookingbuyer_details mbd on(mbd.booking_order_id = mb.booking_order_id) WHERE  mb.is_pi_type = "unstage" and mb.booking_order_id = "' . $booking_order_id . '"  GROUP BY mb.item_code ORDER BY mb.id ASC');

		return $bookingDetails;
	}
	public function getFscBookingValue($booking_order_id){
		$bookingDetails = DB::select('SELECT mb.oos_number,mb.season_code,mb.style,mb.is_type,GROUP_CONCAT(mb.id) as abc,mb.sku,mb.erp_code,mb.item_code,mb.item_price,mb.item_description, mb.orderDate,mb.orderNo,mb.shipmentDate,mb.poCatNo,mb.others_color ,GROUP_CONCAT(mb.item_size) as itemSize,GROUP_CONCAT(mb.gmts_color) as gmtsColor,GROUP_CONCAT(mb.item_quantity) as quantity,mbd.buyer_name,mbd.Company_name,mbd.C_sort_name,mbd.address_part1_invoice,mbd.address_part2_invoice,mbd.attention_invoice,mbd.mobile_invoice,mbd.telephone_invoice,mbd.fax_invoice,mbd.address_part1_delivery,mbd.address_part2_delivery,mbd.attention_delivery,mbd.mobile_delivery,mbd.telephone_delivery,mbd.fax_delivery,mbd.is_complete,mbd.booking_status,mbd.shipmentDate,mbd.booking_order_id from mxp_booking mb INNER JOIN mxp_bookingbuyer_details mbd on(mbd.booking_order_id = mb.booking_order_id) WHERE  mb.is_pi_type = "unstage" and mb.booking_order_id = "' . $booking_order_id . '" GROUP BY mb.item_code ORDER BY mb.id ASC');

		return $bookingDetails;
	}


}
