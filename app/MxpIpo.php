<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpIpo extends Model
{
    protected $table = 'mxp_ipo';
    protected $primaryKey = 'id';

    protected $fillable = [
    			'user_id',
    			'initial_increase',
    			'booking_order_id',
    			'erp_code',
    			'item_code',
    			'item_size',
    			'item_quantity',
    			'item_price',
    			'matarial',
    			'gmts_color',
    			'orderDate',
    			'orderNo',
    			'shipmentDate',
    			'poCatNo',
    			'status'];
}
