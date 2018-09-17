<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Message\StatusMessage;
use App\buyer;
use DB;
use Validator;

class buyerController extends Controller
{
    public function buyerView(){
    	$buyers = DB::table('mxp_buyer')->orderBy('id_mxp_buyer', 'DESC')->paginate(20);
    	return view('buyer.buyer_list',compact('buyers'));
    }

    public function addbuyerView(){
    	return view('buyer.add_buyer');
    }

    public function addbuyer(Request $request){

        $validMessages = [
            'buyer_name.required' => 'buyer Name field is required.'
            ];

        $datas = $request->all();

    	$validator = Validator::make($datas, 
            [
    			'buyer_name' => 'required'
		    ],
            $validMessages
        );

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
    	$createbuyer = new buyer();
    	$createbuyer->buyer_name = $request->buyer_name;
    	$createbuyer->save();
        $lastId = $createbuyer->id_mxp_buyer;
		StatusMessage::create('add_buyer', 'New Buyer Created Successfully');

		if(isset($request->request_type) && $request->request_type == 'ajax'){
            return [
                'id_mxp_buyer' => $lastId,
                'buyer_name' => $request->buyer_name
            ];
        }

		return \Redirect()->Route('buyer_list_view');

    }

    public function updatebuyerView(Request $request){
    	$buyer = buyer::where('id_mxp_buyer', $request->id_mxp_buyer)->get();
    	return view('buyer.update_buyer', compact('buyer'));
    }


    public function updatebuyer(Request $request){

        $validMessages = [
            'buyer_name.required' => 'buyer Name field is required.'
            ];

        $datas = $request->all();

    	$validator = Validator::make($datas, 
            [
    			'buyer_name' => 'required'
		    ],
            $validMessages
        );

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
    	$updatebuyer = buyer::find($request->id_mxp_buyer);
    	$updatebuyer->buyer_name = $request->buyer_name;
    	$updatebuyer->save();

		StatusMessage::create('update_buyer', ' Update buyer Successfully');

		return \Redirect()->Route('buyer_list_view');
    }

    public function deletebuyer(Request $request){
    	$buyer = buyer::find($request->id_mxp_buyer);
		$buyer->delete();
		StatusMessage::create('buyer_delete', $buyer->buyer_name .' delete Successfully');
		return redirect()->Route('buyer_list_view');
    }
}
