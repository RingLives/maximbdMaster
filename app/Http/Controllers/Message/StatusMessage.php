<?php

namespace App\Http\Controllers\Message;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Session;

class StatusMessage extends Controller
{
    public static function create($key, $message){
    	
    	Session::flash($key, $message);
    }
}
