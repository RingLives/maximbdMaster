<?php

namespace App\Http\Controllers;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\RoleManagement;
use App\MxpFooter;
use Auth;
use Illuminate\Http\Request;
use Validator;
use DB;

class PageFooterController extends Controller
{

	const CREATE_TITLE = "create";
	const UPDATE_TITLE = "update";


    public function pageFooterView(){
    	$footers = DB::select("SELECT * FROM mxp_pageFooter");
    	return view('page_management.footer.page_footer_list',compact('footers'));
    }
    public function addFooterView(){
    	
    	return view('page_management.footer.page_aadFooter');
    }

    public function updateFooterView(Request $request){
    	
    	$titles = MxpFooter::where('footer_id', $request->footer_id)->get();
    	return view('page_management.footer.page_updateFooter', compact('titles'));
    }

    public function addFooter(Request $request) {
    	$roleManage = new RoleManagement();

        $validMessages = [
            'footer_title.required' => 'Footer field is required.'
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas, 
            [
    			'footer_title' => 'required'
		    ],
            $validMessages
    );
		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
    	$createFooter = new MxpFooter();
    	$createFooter->user_id = Auth::user()->user_id;
    	$createFooter->title = $request->footer_title;
        $createFooter->status = $request->isActive;
    	$createFooter->action = self::CREATE_TITLE;
    	$createFooter->save();

		StatusMessage::create('add_footer_title', 'New Footer title Created Successfully');

		return \Redirect()->Route('page_footer_view');
    }

    public function updateFooter(Request $request) {
    	$roleManage = new RoleManagement();

        $validMessages = [
            'footer_title.required' => 'Footer field is required.'
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas, 
            [
    			'footer_title' => 'required'
		    ],
            $validMessages
    );
		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();
    	$updateFooter =MxpFooter::find($request->footer_id);
    	$updateFooter->user_id = Auth::user()->user_id;
    	$updateFooter->title = $request->footer_title;
    	$updateFooter->status = $request->isActive;
        $updateFooter->action = self::CREATE_TITLE;
    	$updateFooter->save();

		StatusMessage::create('update_footer', 'Update footer title Successfully');

		return \Redirect()->Route('page_footer_view');
    }

    public function deleteFooter(Request $request){
    	$deleteFooter =MxpFooter::find($request->footer_id);
    	$deleteFooter->delete();
    	StatusMessage::create('delete_footer', 'Delete footer title Successfully');
		return \Redirect()->Route('page_footer_view');
    }


}
