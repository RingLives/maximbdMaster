<?php

namespace App\Http\Controllers\Source\User;

use App\userbuyer;
use Auth;

trait UserAccessBuyerList
{
	public function getUserByerList(){
		$userbuyer = userbuyer::where("id_user",Auth::user()->user_id)->get();
		$buyerList = [];
		if(isset($userbuyer) && !empty($userbuyer)){
			foreach ($userbuyer as $buyerusr) {
				$buyerList[] = $buyerusr->id_buyer;
			}
		}
		return $buyerList;
	}
}