<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Mxp_role;
use App\User;
use Auth;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;

class LoginController extends Controller {
	/*
		    |--------------------------------------------------------------------------
		    | Login Controller
		    |--------------------------------------------------------------------------
		    |
		    | This controller handles authenticating users for the application and
		    | redirecting them to your home screen. The controller uses a trait
		    | to conveniently provide its functionality to your applications.
		    |
	*/

	use AuthenticatesUsers;

	/**
	 * Where to redirect users after login.
	 *
	 * @var string
	 */
	protected $redirectTo = '/dashboard';

	/**
	 * Create a new controller instance.
	 *
	 * @return void
	 */
	public function __construct() {
		$this->middleware('guest')->except('logout');
	}

	protected function credentials(Request $request) {
		return array_merge($request->only($this->username(), 'password'), ['is_active' => 1]);
	}

	protected function authenticated(Request $request, $user) {

		$request->session()->put('user_role_id', $user->user_role_id);
		$request->session()->put('user_id', $user->user_id);
		$request->session()->put('user_type', $user->type);
		$request->session()->put('company_id', $user->company_id);

		if ($user->type == 'company_user') {
			$user_role = Mxp_role::get()->where('id', '=', $user->user_role_id)->first();
			$request->session()->put('user_role', $user_role);
		}

		if (Auth::user()->type == "super_admin") {

			$request->session()->put('group_id', Auth::user()->user_id);

		} else {
			$request->session()->put('group_id', Auth::user()->group_id);

		}
	}
}
