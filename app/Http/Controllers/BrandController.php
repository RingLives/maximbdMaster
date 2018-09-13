<?php

namespace App\Http\Controllers;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\RoleManagement;
use App\MxpBrand;
use Auth;
use Illuminate\Http\Request;
use Validator;

class BrandController extends Controller
{
	const CREATE_BRAND = "create";
	const UPDATE_BRAND = "update";

    public function brandView(){
    	$brands = MxpBrand::where('user_id',Auth::user()->user_id)->paginate(20);
    	return view('brand.brand_list',compact('brands'));
    }

    public function addBrandView(){
    	return view('brand.add_brand');
    }

    public function updateBrandView(Request $request){
    	$brand = MxpBrand::where('brand_id', $request->brand_id)->get();
    	return view('brand.update_brand', compact('brand'));
    }

    public function addBrand(Request $request){
    	$roleManage = new RoleManagement();

        $validMessages = [
            'brand_name.required' => 'Brand Name field is required.'
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas, 
            [
    			'brand_name' => 'required'
		    ],
            $validMessages
        );

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
    	$createBrand = new MxpBrand();
    	$createBrand->user_id = Auth::user()->user_id;
    	$createBrand->brand_name = $request->brand_name;
    	$createBrand->status = $request->isActive;
    	$createBrand->action = self::CREATE_BRAND;
    	$createBrand->save();
        $lastId = $createBrand->brand_id;
		StatusMessage::create('add_brand', 'New Title Created Successfully');

		if(isset($request->request_type) && $request->request_type == 'ajax'){
            return [
                'brand_id' => $lastId,
                'brand_name' => $request->brand_name
            ];
        }
		return \Redirect()->Route('brand_list_view');
    }


    public function updateBrand(Request $request){
    	$roleManage = new RoleManagement();

        $validMessages = [
            'brand_name.required' => 'Brand Name field is required.'
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas, 
            [
    			'brand_name' => 'required'
		    ],
            $validMessages
        );

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
    	$updateBrand = MxpBrand::find($request->brand_id);
    	$updateBrand->user_id = Auth::user()->user_id;
    	$updateBrand->brand_name = $request->brand_name;
    	$updateBrand->status = $request->isActive;
    	$updateBrand->action = self::UPDATE_BRAND;
    	$updateBrand->save();

		StatusMessage::create('update_brand', ' Update Brand Successfully');

		return \Redirect()->Route('brand_list_view');
    }


    public function deleteBrand(Request $request){
    	$brand = MxpBrand::find($request->brand_id);
		$brand->delete();
		StatusMessage::create('brand_delete', $brand->brand_name .' delete Successfully');
		return redirect()->Route('brand_list_view');
    }
}
