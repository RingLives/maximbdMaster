<?php

namespace App\Http\Controllers;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\Controller;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use App\MxpProduct;
use App\Model\MxpBooking;
use App\Model\MxpGmtsColor;
use Validator;
use Auth;
use DB;

class ColorController extends Controller
{
	CONST CREATE_GMTS_COLOR = "create";
	CONST UPDATE_GMTS_COLOR = "update";

    public function listView(){
    	$roleManage = new RoleManagement();
    	$gmtsColor = MxpGmtsColor::where('user_id',Auth::user()->user_id)->where('item_code', NULL)->paginate(10);
        return view('color_management.color_list',compact('gmtsColor'));
    }

    public function addColorView(){
    	$roleManage = new RoleManagement();
    	$itemCodes = MxpProduct::select('product_code')->where('user_id',Auth::user()->user_id)->get();
    	return view('color_management.addcolor_view', compact('itemCodes'));
    }

    public function updateColorView(Request $request){
    	$itemCodes = MxpProduct::select('product_code')->where('user_id',Auth::user()->user_id)->get();
    	$MxpGmtsColor = MxpGmtsColor::where('id', $request->color_id)->get();
    	return view('color_management.updateColor', compact('MxpGmtsColor','itemCodes'));
    }

    public function addColorAction(Request $request){
    	$datas = $request->all();
    	$roleManage = new RoleManagement();

        $validMessages = [
            //            'p_code.required' => 'Product code field is required.',
            'gmts_color.required' => 'Color field is required.',
            ];
    	$validator = Validator::make($datas, 
            [
    			//               'p_code' => 'required',
    			'gmts_color' => 'required',
		    ],
            $validMessages
        );

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
		$insertGmtsColor = new MxpGmtsColor();
		$insertGmtsColor->user_id = Auth::user()->user_id;
//      $insertGmtsColor->item_code = $request->p_code;
		$insertGmtsColor->color_name = $request->gmts_color;
		$insertGmtsColor->action = self::CREATE_GMTS_COLOR;
		$insertGmtsColor->status = $request->isActive;
		$insertGmtsColor->save();
        $lastId = $insertGmtsColor->id;

    	StatusMessage::create('add_gmtscolor', $request->p_code .' ' .$request->gmts_color.' Created Successfully');

        if(isset($request->request_type) && $request->request_type == 'ajax'){
            return [
                'color_id' => $lastId,
                'color_name' => $request->gmts_color
            ];
        }
		return \Redirect()->Route('gmts_color_view');
    }

    public function updateColorAction(Request $request){
    	$datas = $request->all();
    	$roleManage = new RoleManagement();

        $validMessages = [
            'p_code.required' => 'Product code field is required.',
            //            'p_code.required' => 'Product code field is required.',
            ];
    	$validator = Validator::make($datas, 
            [
    			//               'p_code' => 'required',
    			'gmts_color' => 'required',
		    ],
            $validMessages
        );

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
		$updateGmtsColor = MxpGmtsColor::find($request->color_id);
		$updateGmtsColor->user_id = Auth::user()->user_id;
		$updateGmtsColor->item_code = $request->p_code;
		$updateGmtsColor->color_name = $request->gmts_color;
		$updateGmtsColor->action = self::UPDATE_GMTS_COLOR;
		$updateGmtsColor->status = $request->isActive;
		$updateGmtsColor->save();

    	StatusMessage::create('update_gmtscolor', $request->p_code .' ' .$request->gmts_color.' Update Successfully');

		return \Redirect()->Route('gmts_color_view');
    }

    

    public function deleteColorAction(Request $request){
    	$deleteGmtsColor = MxpGmtsColor::find($request->color_id);
		$deleteGmtsColor->delete();
		StatusMessage::create('delete_gmts_color', $deleteGmtsColor->item_code .' '.$deleteGmtsColor->color_name .' delete Successfully');
		return redirect()->Route('gmts_color_view');
    }
}
