<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class MxpBookingMultipleChallan extends Model
{
    protected $table = "mxp_booking_multipleChallan";

    protected $fillable = [
                'user_id',
    			'challan_id',
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
                'status'
    		];
}
