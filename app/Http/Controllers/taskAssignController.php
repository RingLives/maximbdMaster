<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\MxpMenu;
use App\mxpTask;
use App\MxpTaskRole;

class taskAssignController extends Controller
{
    public function taskassign(Request $request)
    {
        $taskRoleData = array();
        $selectedTaskRole = MxpTaskRole::all();
        if(isset($selectedTaskRole) && !empty($selectedTaskRole)){
            foreach ($selectedTaskRole as $srk => $srvalue) {
                if(isset($srvalue->task) && !empty($srvalue->task)){
                    $taskRoleData[$srvalue->role_id] = explode(",", $srvalue->task);
                }else{
                    $taskRoleData[$srvalue->role_id] = array();
                }
            }
        }
    	$company_id = $request->session()->get('company_id');

    	if(!empty($company_id) && ($company_id != 0)){
    		$rolesList = DB::select('SELECT * FROM `mxp_role` WHERE `company_id` = '.$company_id.' AND `is_active` =1');
    	}else{
    		$rolesList = DB::select('SELECT * FROM `mxp_role` WHERE `is_active` =1');
    	}

    	$tasksList = DB::select("SELECT * FROM `mxp_task` WHERE `status` = 1");
    	
    	return view('role_management.taskassign', compact('rolesList', 'tasksList', 'taskRoleData'));

    }
    public function taskassignaction(Request $request)
    {

        $data = array();
    	$company_id = $request->session()->get('company_id');

    	if(!empty($company_id) && ($company_id != 0)){
    		$rolesList = DB::select('SELECT * FROM `mxp_role` WHERE `company_id` = '.$company_id.' AND `is_active` =1');
    	}else{
    		$rolesList = DB::select('SELECT * FROM `mxp_role` WHERE `is_active` =1');
    	}


    	$tasksList = DB::select("SELECT * FROM `mxp_task` WHERE `status` = 1");
    	
    	$tasksList = mxpTask::where('status', 1);
    	
    	// self::print_me($tasksList);


        if(isset($rolesList) && !empty($rolesList)){
            foreach ($rolesList as $roleKey => $roleValue) {
                $task = @implode(',',$request->get("task_".$roleValue->id));
                $data[] = array('role_id' => $roleValue->id,'task' => $task);
                $task = '';
            }
        }
        if(!empty($data)){
            MxpTaskRole::truncate();
            MxpTaskRole::insert($data);
            return redirect()->back()->with('new_taskrole_create', 'Successfully Saved.');
        }
        return Redirect()->Route('permission_task_assign');
        

    }

}
