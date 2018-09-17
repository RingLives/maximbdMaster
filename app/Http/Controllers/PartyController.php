<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\MaxParty;
use Validator;
use App\Http\Controllers\Message\StatusMessage;
use DB;
use Auth;

class PartyController extends Controller
{
    public function index()
    {
        $party_list = MaxParty::where('user_id',Auth::user()->user_id)->paginate(10);
        return view('party_management.party_list', compact('party_list'));
    }

    public function create()
    {
        return view('party_management.party_create');
    } 

    public function updateView(Request $request)
    {
        $party_edits = MaxParty::Where('id',$request->id )->get();

        return view('party_management.party_edit', compact('party_edits'));
    }

    public function store(Request $request)
    {   
        $roleManage = new RoleManagement();
        $validMassage = [
            'party_id.required' => 'Vendor id is required',
            'party_id.unique' => 'Vendor id is already entered.',            
            'name.required' => 'Company Name is required',
            'sort_name.required' => 'Company sort name is required',
            'name_buyer.required' => 'Brand name is required',
            'name.unique' => 'Vendor name already entered',
            
        ];
         $validator = Validator::make($request->all(), [
            'party_id'               => 'required|unique:mxp_party,party_id',
            'name'                   => 'required||unique:mxp_party,name',
            'sort_name'              =>'required',
            'name_buyer'             => 'required',
            
        ],
        $validMassage
    );

        if ($validator->fails()) {
            return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
        }

        $party = new MaxParty();
        $party->party_id               = $request->party_id;
        $party->user_id                = Auth::user()->user_id;
        $party->name                   = $request->name;
        $party->sort_name              = $request->sort_name;
        $party->name_buyer             = $request->name_buyer;
        $party->address_part1_invoice  = $request->address_part_1_invoice;
        $party->address_part2_invoice  = $request->address_part_2_invoice;
        $party->attention_invoice      = $request->attention_invoice;
        $party->mobile_invoice         = $request->mobile_invoice;
        $party->telephone_invoice      = $request->telephone_invoice;
        $party->fax_invoice            = $request->fax_invoice;
        $party->address_part1_delivery = $request->address_part_1_delivery;
        $party->address_part2_delivery = $request->address_part_2_delivery;
        $party->attention_delivery     = $request->attention_delivery;
        $party->mobile_delivery        = $request->mobile_delivery;
        $party->telephone_delivery     = $request->telephone_delivery;
        $party->fax_delivery           = $request->fax_delivery;
        $party->description_1          = $request->description_1;
        $party->description_2          = $request->description_2;
        $party->description_3          = $request->description_3;
        $party->status                 = $request->status;
        $party->save();
        StatusMessage::create('party_added', $request->name.' Party Added Successfully');
        return Redirect()->Route('party_list_view');
    }

    public function update(Request $request)
    {   
        $roleManage = new RoleManagement();

        $validMassage = [
            'party_id.required' => 'Vendor id is required',
            'name.required' => 'Company Name is required',
            'sort_name.required' => 'Company sort name is required',
            'name_buyer.required' => 'Buyer name is required',
        ];

        $validator = Validator::make($request->all(), [
            'party_id'               => 'required',
            'name'                   => 'required',
            'sort_name'              => 'required',
            'name_buyer'             => 'required',
        ],
        $validMassage
    );

        if ($validator->fails()) {
            return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
        }


        $update_party = MaxParty::find($request->id);
        $update_party->party_id               = $request->party_id;
        $update_party->user_id                = Auth::user()->user_id;
        $update_party->name                   = $request->name;
        $update_party->sort_name              = $request->sort_name;
        $update_party->name_buyer             = $request->name_buyer;
        $update_party->address_part1_invoice  = $request->address_part_1_invoice;
        $update_party->address_part2_invoice  = $request->address_part_2_invoice;
        $update_party->attention_invoice      = $request->attention_invoice;
        $update_party->mobile_invoice         = $request->mobile_invoice;
        $update_party->telephone_invoice      = $request->telephone_invoice;
        $update_party->fax_invoice            = $request->fax_invoice;
        $update_party->address_part1_delivery = $request->address_part_1_delivery;
        $update_party->address_part2_delivery = $request->address_part_2_delivery;
        $update_party->attention_delivery     = $request->attention_delivery;
        $update_party->mobile_delivery        = $request->mobile_delivery;
        $update_party->telephone_delivery     = $request->telephone_delivery;
        $update_party->fax_delivery           = $request->fax_delivery;
        $update_party->description_1          = $request->description_1;
        $update_party->description_2          = $request->description_2;
        $update_party->description_3          = $request->description_3;
        $update_party->status          = $request->status;
        $update_party->save();

        StatusMessage::create('party_updated', $request->name .' '. $request->name_buyer .'(buyer) updated Successfully');
        return Redirect()->Route('party_list_view');
    }

     public function deleteParty(Request $request) {
      $party = MaxParty::find($request->id);
      $party->delete();
      StatusMessage::create('party_delete',$party->name .' is deleted Successfully');
      return redirect()->Route('party_list_view');
     }
}
