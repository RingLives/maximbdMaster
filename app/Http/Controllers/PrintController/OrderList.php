<?php

namespace App\Http\Controllers\PrintController;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\mxp_maximBill;
use DB;

class OrderList extends Controller
{
    public function orderView(){
    	$orderList = DB::table('mxp_maximBill')
    				->select('bill_id','name_buyer','name','attention_invoice','mobile_invoice','created_at')
    				->groupBy('bill_id')
    				->orderBy('id','DESC')
    				->paginate(20);
    	// self::print_me($orderList);
    	return view('print_file.orderlist.orderlist',['orderList' => $orderList]);
    }
}
