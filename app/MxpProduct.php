<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

use App\MxpProductsColors;
use App\MxpProductsSizes;
use App\Model\MxpGmtsColor;

class MxpProduct extends Model {

	protected $table = 'mxp_product';
	protected $primaryKey = 'product_id';

	protected $fillable = ['product_code','product_name', 'product_description', 'brand', 'erp_code','unit_price','weight_qty','weight_amt','description_1','description_2','description_3','description_4','user_id','status','action','id_buyer'];


	public function colors(){
	    return $this->hasMany(MxpProductsColors::class, 'product_id', 'product_id')->where('status', '1')->select('product_id', 'color_id');
    }

    public function sizes(){
            return $this->hasMany(\App\MxpProductsSizes::class, 'product_id', 'product_id')->where('status', '1')->select('product_id', 'size_id');
    }


//    public function getColor(){
//	    return MxpGmtsColor::get()->where('id', '=', $this->colorsIds());
//    }
}
