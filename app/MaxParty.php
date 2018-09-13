<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MaxParty extends Model
{
    protected $table = 'mxp_party';
    protected $primaryKey = 'id';

    protected $fillable = ['party_id','name','sort_name','name_buyer','address_part1_invoice','address_part2_invoice','attention_invoice','mobile_invoice','telephone_invoice','fax_invoice','address_part1_delivery','address_part2_delivery','attention_delivery','mobile_delivery','telephone_delivery','fax_delivery','description_1','description_2','description_3'];
}
