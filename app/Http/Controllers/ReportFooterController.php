<?php

namespace App\Http\Controllers;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\RoleManagement;
use Illuminate\Support\Facades\Input;
use App\MxpReportFooter;
use Auth;
use Illuminate\Http\Request;
use Validator;

class ReportFooterController extends Controller
{   
    /* images variables */
    public $fristSignature;
    public $fristSeal;
    public $secondSignature;
    public $secondSeal;
    
	CONST CREATE_REPORT = "create";
	CONST UPDATE_REPORT = "update";

    public function reportView(){

    	$reports = MxpReportFooter::get();
    	return view('page_management.report_footer.report_footer_list',compact('reports'));
    }

    public function addReportView(){
    	return view('page_management.report_footer.addreport_footer');
    }

    public function updateReportView(Request $request){
    	$datas = MxpReportFooter::where('re_footer_id', $request->report_id)->get();
    	return view('page_management.report_footer.updatereport_footer', compact('datas'));
    }

    public function addReport(Request $request){
    	$roleManage = new RoleManagement();

        $validMessages = [
            'report_name.required' => 'Report name field is required.',
            // 'per1_name.required' => 'Frist Person name field is required.',
            // 'per2_name.required' => 'Second Report name field is required.',
                        
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas, 
            [
    			'report_name' => 'required',
    			// 'per1_name' => 'required',
    			// 'per2_name' => 'required',
    						
		    ],
            $validMessages
    );
		
		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}
		$validationError = $validator->messages();

		if ($request->hasFile('signature_1')) {
	        if($request->file('signature_1')->isValid()) {
	            try {
	                $file = $request->file('signature_1');
	                $this->fristSignature = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

	                $request->file('signature_1')->move("upload", $this->fristSignature);
	            } catch (Illuminate\Filesystem\FileNotFoundException $e) {

	            }
	        }
        }
        if ($request->hasFile('signature_2')) {
	        if($request->file('signature_2')->isValid()) {
	            try {
	                $file = $request->file('signature_2');
	                $this->secondSignature = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

	                $request->file('signature_2')->move("upload", $this->secondSignature);
	            } catch (Illuminate\Filesystem\FileNotFoundException $e) {

	            }
	        }
        }

        if ($request->hasFile('seal_1')) {
	        if($request->file('seal_1')->isValid()) {
	            try {
	                $file = $request->file('seal_1');
	                $this->fristSeal = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

	                $request->file('seal_1')->move("upload", $this->fristSeal);
	            } catch (Illuminate\Filesystem\FileNotFoundException $e) {

	            }
	        }
        }

        if ($request->hasFile('seal_2')) {
	        if($request->file('seal_2')->isValid()) {
	            try {
	                $file = $request->file('seal_2');
	                $this->secondSeal = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

	                $request->file('seal_2')->move("upload", $this->secondSeal);
	            } catch (Illuminate\Filesystem\FileNotFoundException $e) {

	            }
	        }
        }

    	$createReport = new MxpReportFooter();
    	$createReport->reportName = $request->report_name;
    	$createReport->siginingPerson_1 = $request->per1_name;
    	$createReport->siginingSignature_1 = $this->fristSignature;
    	$createReport->siginingPersonSeal_1 = $this->fristSeal;
    	$createReport->siginingPerson_2 = $request->per2_name;
    	$createReport->siginingSignature_2 = $this->secondSignature;    	
    	$createReport->siginingPersonSeal_2 = $this->secondSeal;      	
        $createReport->user_id = Auth::user()->user_id;
        $createReport->status = $request->isActive;
    	$createReport->action = self::CREATE_REPORT;
    	$createReport->save();

		StatusMessage::create('new_report_create', 'New report footer Created Successfully');

		return \Redirect()->Route('report_footer_view');    	
    }



    public function updateReport(Request $request){
    	$roleManage = new RoleManagement();

        $validMessages = [
            'report_name.required' => 'Report name field is required.',
            // 'per1_name.required' => 'Frist Person name field is required.',
            // 'per2_name.required' => 'Second Report name field is required.',
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas, 
            [
    			'report_name' => 'required',
    			// 'per1_name' => 'required',
    			// 'per2_name' => 'required',
		    ],
            $validMessages
    );
		
		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();

		if ($request->hasFile('signature_1')) {
	        if($request->file('signature_1')->isValid()) {
	            try {
	                $file = $request->file('signature_1');
	                $this->fristSignature = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

	                $request->file('signature_1')->move("upload", $this->fristSignature);
	            } catch (Illuminate\Filesystem\FileNotFoundException $e) {

	            }
	        }
        }
        if ($request->hasFile('signature_2')) {
	        if($request->file('signature_2')->isValid()) {
	            try {
	                $file = $request->file('signature_2');
	                $this->secondSignature = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

	                $request->file('signature_2')->move("upload", $this->secondSignature);
	            } catch (Illuminate\Filesystem\FileNotFoundException $e) {

	            }
	        }
        }

        if ($request->hasFile('seal_1')) {
	        if($request->file('seal_1')->isValid()) {
	            try {
	                $file = $request->file('seal_1');
	                $this->fristSeal = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

	                $request->file('seal_1')->move("upload", $this->fristSeal);
	            } catch (Illuminate\Filesystem\FileNotFoundException $e) {

	            }
	        }
        }

        if ($request->hasFile('seal_2')) {
	        if($request->file('seal_2')->isValid()) {
	            try {
	                $file = $request->file('seal_2');
	                $this->secondSeal = rand(11111, 99999) . '.' . $file->getClientOriginalExtension();

	                $request->file('seal_2')->move("upload", $this->secondSeal);
	            } catch (Illuminate\Filesystem\FileNotFoundException $e) {

	            }
	        }
        }

    	$updateReport = MxpReportFooter::find($request->report_id);
    	$updateReport->reportName = $request->report_name;
    	$updateReport->siginingPerson_1 = $request->per1_name;
    	$updateReport->siginingSignature_1 = $this->fristSignature;
    	$updateReport->siginingPersonSeal_1 = $this->fristSeal;
    	$updateReport->siginingPerson_2 = $request->per2_name;
    	$updateReport->siginingSignature_2 = $this->secondSignature;    	
    	$updateReport->siginingPersonSeal_2 = $this->secondSeal;
        $updateReport->user_id = Auth::user()->user_id;
    	$updateReport->status = $request->isActive;
        $updateReport->action = self::CREATE_REPORT;
    	$updateReport->save();

		StatusMessage::create('update_report_footer', 'Update report footer Successfully');

		return \Redirect()->Route('report_footer_view');    	
    }

    public function deleteReport(Request $request){
    	$deleteReport = MxpReportFooter::find($request->report_id);
    	$deleteReport->delete();

    	StatusMessage::create('delete_report_footer', 'Delete report footer Successfully');

		return \Redirect()->Route('report_footer_view');
    }
}
