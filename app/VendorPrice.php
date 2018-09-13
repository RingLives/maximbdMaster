<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

use App\MaxParty;

class VendorPrice extends Model
{
    protected $table = 'mxp_vendor_prices';
    protected $primaryKey = 'price_id';

    public function party(){
        return $this->hasOne(MaxParty::class, 'id', 'party_table_id');
    }
}
