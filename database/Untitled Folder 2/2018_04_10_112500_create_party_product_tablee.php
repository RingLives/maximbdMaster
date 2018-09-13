<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePartyProductTablee extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_product', function (Blueprint $table) {
            $table->increments('product_id');
            $table->integer('user_id');
            $table->string('product_code')->nullable(true);
            $table->string('product_name')->nullable(true);
            $table->string('product_description')->nullable(true);
            $table->string('brand')->nullable(true);
            $table->string('erp_code')->nullable(true);
            $table->string('unit_price')->nullable(true);
            $table->string('weight_qty')->nullable(true);
            $table->string('weight_amt')->nullable(true);
            $table->string('others_color')->nullable(true);
            $table->string('description_1')->nullable(true);
            $table->string('description_2')->nullable(true);
            $table->string('description_3')->nullable(true);
            $table->string('description_4')->nullable(true);
            $table->string('status')->nullable(true);
            $table->string('action')->nullable(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
       Schema::drop('mxp_product');
    }
}
