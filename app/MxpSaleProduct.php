<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpSaleProduct extends Model
{
    protected $table = "mxp_sale_products";

	protected $fillable = [
	'product_id','invoice_id','client_id','com_group_id','company_id','user_id','quantity','price','bonus','commission','sale_date','is_deleted','is_active'
    ];
}
