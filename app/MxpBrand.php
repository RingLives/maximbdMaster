<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpBrand extends Model
{
     protected $table = 'mxp_brand';
    protected $primaryKey = 'brand_id';

    protected $fillable = ['user_id','brand_name','action','status'];
}
