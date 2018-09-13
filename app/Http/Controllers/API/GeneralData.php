<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class GeneralData extends Controller {
	public function getUserByComId(Request $request) {

		// $user = MxpCompanyUser::get()->where('company_id', $request->comId);
		// echo '<pre>';
		// print_r($user);

		$companyUser = DB::table('mxp_users')
			->select('mxp_users.is_active as active_user', 'mxp_users.*', 'mxp_role.name')
			->leftjoin('mxp_role', 'mxp_role.id', '=', 'mxp_users.user_role_id')
			->get()
			->where('company_id', $request->comId);

		return json_encode($companyUser);
	}
}
