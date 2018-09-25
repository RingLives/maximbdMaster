<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Model\MxpItemDescription;
use App\Http\Controllers\Message\StatusMessage;
use DB;
use Validator;

class itemDescriptionController extends Controller
{
    public function descriptionView(){
        $items = DB::table('mxp_item_description')->orderBy('id', 'DESC')->paginate(20);
        return view('item.item_list',compact('items'));
    }

    public function addDescriptionView(){
        return view('item.add_item');
    }

    public function addDescription(Request $request){

        $validMessages = [
            'description_name.required' => 'Description Name field is required.'
        ];

        $datas = $request->all();

        $validator = Validator::make($datas,
            [
                'description_name' => 'required'
            ],
            $validMessages
        );

        if ($validator->fails()) {
            return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
        }

        $validationError = $validator->messages();
        $createdescription = new MxpItemDescription();
        $createdescription->name = $request->description_name;
        $createdescription->is_active = '1';
        $createdescription->save();
        $lastId = $createdescription->id;
        StatusMessage::create('add_description', 'New Description Created Successfully');

        if(isset($request->request_type) && $request->request_type == 'ajax'){
            return [
                'id' => $lastId,
                'name' => $request->description_name,
                'is_active' => $request->isActive
            ];
        }

        return \Redirect()->Route('description_list_view');

    }

    public function updateDescriptionView(Request $request){
        $item = MxpItemDescription::where('id', $request->id_mxp_desc)->get();
        return view('item.update_item', compact('item'));
    }


    public function updateDescription(Request $request){

        $validMessages = [
            'description_name.required' => 'Description Name field is required.'
        ];

        $datas = $request->all();

        $validator = Validator::make($datas,
            [
                'description_name' => 'required'
            ],
            $validMessages
        );

        if ($validator->fails()) {
            return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
        }

        $validationError = $validator->messages();
        $updatebuyer = MxpItemDescription::find($request->id_mxp_desc);
        $updatebuyer->name = $request->description_name;
        $updatebuyer->is_active = $request->isActive;
        $updatebuyer->save();

        StatusMessage::create('update_description', ' Description buyer Successfully');

        return \Redirect()->Route('description_list_view');
    }

    public function deleteDescription(Request $request){
        $buyer = MxpItemDescription::find($request->id_mxp_desc);
        $buyer->delete();
        StatusMessage::create('description_delete', $buyer->name .' delete Successfully');
        return redirect()->Route('description_list_view');
    }
}
