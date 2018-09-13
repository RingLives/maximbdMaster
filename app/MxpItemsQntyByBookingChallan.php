<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpItemsQntyByBookingChallan extends Model
{
    protected $table = 'mxp_items_details_by_booking_challan';
    protected $primaryKey = 'items_details_id';
    protected $fillable = ['booking_challan_id', 'booking_order_id', 'item_code', 'erp_code', 'item_size', 'item_quantity', 'gmts_color'];
}
