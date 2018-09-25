<?php

namespace App\Http\Controllers;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\RoleManagement;
use App\MxpProduct;
use App\MxpProductSize;
use Auth;
use Illuminate\Http\Request;
use Validator;

class ProductSizeController extends Controller
{
	const CREATE_SIZE = "create";
	const UPDATE_SIZE = "update";
    
    public function sizeView(){
    	$productSize = MxpProductSize::where('product_code', '')->paginate(15);
    	return view('product_management.product_size.product_size_view',compact('productSize'));
    }

    public function addSizeView(){
    	$products = MxpProduct::get();
    	return view('product_management.product_size.add_size', compact('products'));
    }

    public function updateSizeView(Request $request){
    	$sizes = MxpProductSize::where('proSize_id',$request->size_id)->get();
    	$products = MxpProduct::get();
    	return view('product_management.product_size.update_size', compact('sizes'))->with('products',$products);
    }

    public function addSize(Request $request){
    	// $roleManage = new RoleManagement();

        $validMessages = [
        //  'p_code.required' => 'Product code field is required.',
            'p_size.required' => 'Size field is required.'
            ];
        $datas = $request->all();
        $validator = Validator::make($datas, 
                [
    //              'p_code' => 'required',
                    'p_size' => 'required'
                ],
                $validMessages
        );
        if ($validator->fails()) {
            return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
        }

		$validationError = $validator->messages();
    	$createSize = new MxpProductSize();
    	$createSize->user_id = Auth::user()->user_id;
//      $createSize->product_code = $request->p_code;
    	$createSize->product_size = $request->p_size;
    	$createSize->status = $request->isActive;
    	$createSize->action = self::CREATE_SIZE;
    	$createSize->save();
        $lastId = $createSize->proSize_id;
 
        StatusMessage::create('add_size_title', 'New product Size Created Successfully');
 
        if(isset($request->request_type) && $request->request_type == 'ajax'){
            return [
                'size_id' => $lastId,
                'product_size' => $request->p_size
            ];
        }


		StatusMessage::create('add_size_title', 'New product Size Created Successfully');

		return \Redirect()->Route('product_size_view');
    }

    public function updateSize(Request $request){
    	$roleManage = new RoleManagement();

        $validMessages = [
            //'p_code.required' => 'Product code field is required.',
            'p_size.required' => 'Size field is required.'
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas, 
            [
//              'p_code' => 'required',
    			'p_size' => 'required'
		    ],
            $validMessages
    );
		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
    	$updateSize = MxpProductSize::find($request->size_id);
    	$updateSize->user_id = Auth::user()->user_id;
    	$updateSize->product_code = $request->p_code;
    	$updateSize->product_size = $request->p_size;
    	$updateSize->status = $request->isActive;
    	$updateSize->action = self::UPDATE_SIZE;
    	$updateSize->save();

		StatusMessage::create('update_size_title', 'Product Size update Successfully');

		return \Redirect()->Route('product_size_view');
    }

    public function deleteSize(Request $request){
    	$deleteSize =MxpProductSize::find($request->size_id);
    	$deleteSize->delete();
    	StatusMessage::create('delete_size', 'Delete product size Created Successfully');
		return \Redirect()->Route('product_size_view');
    }
}
