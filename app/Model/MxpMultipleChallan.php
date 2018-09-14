<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class MxpMultipleChallan extends Model
{
   protected $table = "mxp_multiplechallan";
    // protected $primaryKey = "id";    

	protected $fillable = ['user_id','challan_id','checking_id','bill_id','erp_code','item_code','oss','style','item_size','quantity','unit_price','total_price','status','name_buyer','name','address','attention_invoice','mobile_invoice'];
}
