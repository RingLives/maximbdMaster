<?php

namespace App\Http\Controllers;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\RoleManagement;
use Illuminate\Http\Request;
use Validator;
use App\MxpHeader;
use Auth;
use DB;

class HeaderController extends Controller
{   
    public $logo;
    
  	const HEADER_CREATE = "create";
  	const HEADER_UPDATE = "update";

    public function index()
    {
        $page_list = DB::select("SELECT * FROM mxp_header");
        return view('page_management.header.header_list', compact('page_list'));
    }

    public function create()
    {
        return view('page_management.header.header_create');
    }

    public function updateView(Request $request)
    {
        $page_edits = MxpHeader::Where('header_id',$request->id )->get();

        return view('page_management.header.header_edit', compact('page_edits'));
    }

    public function store(Request $request)
    {
        $roleManage = new RoleManagement();

        $validMassage = [
            'header_title.required' => 'Header title required.'
        ];

        $validator = Validator::make($request->all(), [
            'header_title' => 'required'
        ],$validMassage);

        if ($validator->fails()) {
            return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
        }

        if ($request->hasFile('logo')) {
         if($request->file('logo')->isValid()) {
             try {
                 $file = $request->file('logo');
                 $this->logo = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

                 $request->file('logo')->move("upload", $this->logo);
             } catch (Illuminate\Filesystem\FileNotFoundException $e) {

             }
         }
        }
        $this->print_me($this->logo);
        $page = new MxpHeader();
        $page->header_type  = $request->header_type;
        $page->header_title  = $request->header_title;
        $page->header_fontsize = $request->header_fontsize;
        $page->header_fontstyle = $request->header_fontstyle;
        $page->header_colour = $request->header_colour;
        $page->logo = $this->logo;
        $page->logo_allignment = $request->logo_allignment;
        $page->address1 = $request->address1;
        $page->address2 = $request->address2;
        $page->address3 = $request->address3;
        $page->cell_number = $request->cell_number;
        $page->attention = $request->attention;
        $page->action = self::HEADER_CREATE;
        $page->user_id = Auth::user()->user_id;
        $page->save();

        StatusMessage::create('page_header_added', 'New Header Added Successfully');
        return Redirect()->Route('page_header_view');
    }
    
    public function updateHeader(Request $request)
    {   
        $roleManage = new RoleManagement();
        $validMassage = [
            'header_title.required' => 'header_title.required',
        ];

        $validator = Validator::make($request->all(), 
            [
                'header_title' => 'required',
            ],
            $validMassage
        );

        if ($validator->fails()) {
            return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
        }

        if ($request->hasFile('logo')) {
         if($request->file('logo')->isValid()) {
             try {
                 $file = $request->file('logo');
                 $this->logo = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

                 $request->file('logo')->move("upload", $this->logo);
             } catch (Illuminate\Filesystem\FileNotFoundException $e) {

             }
         }
        }
        // $this->print_me($this->logo);
        $update_page = MxpHeader::find($request->id);
        $update_page->header_type  = $request->header_type;
        $update_page->header_title = $request->header_title;
        $update_page->header_fontsize = $request->header_fontsize;
        $update_page->header_fontstyle = $request->header_fontstyle;
        $update_page->header_colour = $request->header_colour;
        $update_page->logo  = $this->logo;
        $update_page->logo_allignment = $request->logo_allignment;
        $update_page->address1 = $request->address1;
        $update_page->address2 = $request->address2;
        $update_page->address3 = $request->address3;
        $update_page->cell_number = $request->cell_number;
        $update_page->attention = $request->attention;
        $update_page->action = self::HEADER_UPDATE;
        $update_page->save();
        StatusMessage::create('header_updated', 'Page Header updated Successfully');
        return Redirect()->Route('page_header_view');
    }

    public function deletePage(Request $request) {
      $pageDelete = MxpHeader::find($request->id);
      $pageDelete->delete();
      StatusMessage::create('header_delete', ''. $pageDelete->header_title .' is deleted Successfully');
      return redirect()->Route('page_header_view');
     }

}
