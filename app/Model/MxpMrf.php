<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;


class MxpMrf extends Model
{
    protected $table = "mxp_MRF_table";

    protected $fillable = [
    			'user_id',
    			'mrf_id',
    			'booking_order_id',
    			'erp_code',
    			'supplier_id',
    			'item_code',
    			'item_size',
                'item_quantity',
    			'mrf_quantity',
    			'item_price',
    			'matarial',
    			'gmts_color',
    			'orderDate',
    			'orderNo',
    			'shipmentDate',
    			'poCatNo',
    			'status',
    			'action'
    			];

//    protected function getSupplier($key)
//    {
//        return $this->hasOne('App\Supplier', 'supplier_id', 'supplier_id');
//    }
}
