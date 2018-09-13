<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class UpdateGetProductSizeQuantityWithConcatStorePorceduer extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared("DROP procedure IF EXISTS getProductSizeQuantityWithConcat");
        DB::unprepared("CREATE DEFINER=`root`@`localhost` PROCEDURE `getProductSizeQuantityWithConcat`(IN `product_code` VARCHAR(247))
    NO SQL
SELECT mp.erp_code,mp.product_id,mp.unit_price,mp.product_name,mp.others_color,mp.product_description ,GROUP_CONCAT(mps.product_size order by product_size) as size,GROUP_CONCAT(mgs.color_name) as color   FROM mxp_product mp 
LEFT JOIN mxp_productSize mps ON (mps.product_code = mp.product_code)
LEFT JOIN mxp_gmts_color mgs ON (mgs.item_code = mps.product_code)
WHERE mp.product_code = product_code and mp.status = 1 GROUP BY mps.product_code, mgs.item_code;");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared("DROP procedure IF EXISTS getProductSizeQuantityWithConcat");
    }
}
