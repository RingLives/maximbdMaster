<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpHeader extends Model
{
    protected $table = 'mxp_header';
    protected $primaryKey = 'header_id';

    protected $fillable = ['user_id','header_title','header_fontsize','header_fontstyle','header_colour','logo','logo_allignment','address1','address2','address3','status','action'];
}