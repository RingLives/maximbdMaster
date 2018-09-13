<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class MxpPurchaseOrder extends Model
{
    protected $primaryKey = 'po_id';

    protected $fillable = [
        'po_no',
        'booking_order_id',
        'shipment_date',
        'item_code',
        'erp_code',
        'item_size',
        'item_quantity',
        'gmts_color',
        'material',
        'unit',
        'unit_price',
        'total_amount'
    ];
}
