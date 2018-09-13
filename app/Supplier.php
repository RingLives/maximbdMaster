<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Supplier extends Model
{
    protected $primaryKey = 'supplier_id';
    protected $fillable = ['supplier_id', 'name', 'phone', 'address', 'status'];
}
