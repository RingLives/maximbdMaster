<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpProductSize extends Model
{
    protected $table = 'mxp_productsize';
	protected $primaryKey = 'proSize_id';

	protected $fillable = ['proSize_id', 'user_id','product_size','status','action'];
}
