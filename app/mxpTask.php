<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class mxpTask extends Model
{
    protected $table = 'mxp_task';
    protected $primaryKey = 'id_mxp_task';

    protected $fillable = [
    			'name',
    			'status'
    		];
}
