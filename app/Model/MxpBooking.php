<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;
use  App\Model\MxpBookingBuyerDetails;
use App\MxpIpo;
use App\Model\MxpMrf;
class MxpBooking extends Model
{
    protected $table = "mxp_booking";

    protected $fillable = [
    			'user_id',
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
    			'sku',
    			'poCatNo'];

    function buyer_details(){
        return $this->hasOne(MxpBookingBuyerDetails::class, 'booking_order_id','booking_order_id');
    }

    function ipo(){
        return $this->hasMany(MxpIpo::class, 'booking_order_id','booking_order_id');
    }

    function mrf(){
        return $this->hasMany(MxpMrf::class, 'booking_order_id','booking_order_id');
    }
}
