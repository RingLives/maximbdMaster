<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class MxpInputOrder extends Model
{
    protected $table = 'mxp_order_input';
    // protected $primaryKey = 'header_id';

    protected $fillable = ['user_id','order_id','erp_code','item_code','oss','style','item_size','quantity','unit_price'];
}
