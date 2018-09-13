<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpOrder extends Model
{
    protected $table = 'mxp_order';
    // protected $primaryKey = 'header_id';

    protected $fillable = ['user_id','order_id','erp_code','item_code','oss','style','item_size','quantity'];
}
