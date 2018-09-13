<?php

namespace App\Model;

use Illuminate\Database\Eloquent\Model;

class MxpGmtsColor extends Model
{
    protected $table = 'mxp_gmts_color';
    // protected $primaryKey = 'header_id';

    protected $fillable = ['id', 'user_id','color_name','action','status'];
}
