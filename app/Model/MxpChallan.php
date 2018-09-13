<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class MxpChallan extends Model
{
    protected $table = "mxp_challan";
    // protected $primaryKey = "user_id";    

	protected $fillable = ['user_id','order_id','bill_id','erp_code','item_code','oss','style','item_size','quantity','unit_price','total_price','status','name_buyer','name','address','attention_invoice','mobile_invoice','count_challan','sort_name'];
}
