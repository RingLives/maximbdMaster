<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Mxp_maximBill extends Model
{
    protected $table = 'mxp_maximBill';
    // protected $primaryKey = 'header_id';

    protected $fillable = ['user_id','order_id','bill_id','erp_code','item_code','oss','style','item_size','quantity','unit_price','total_price','status','name_buyer','name','address','attention_invoice','mobile_invoice'];
    protected $dates = ['created_at'];
}
