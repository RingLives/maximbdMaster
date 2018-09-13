<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpProductGroup extends Model
{
    protected $table = "mxp_product_group";

	protected $fillable = [
	'name', 'company_id', 'com_group_id', 'user_id', 'is_active', 'is_deleted'
    ];
}
