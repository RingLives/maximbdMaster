<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateMxpPiTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_pi', function (Blueprint $table) {
            $table->increments('id');
            $table->string('job_no')->nullable();
            $table->integer('user_id')->nullable();
            $table->string('booking_order_id')->nullable();
            $table->string('erp_code')->nullable();
            $table->string('item_code')->nullable()->nullable();
            $table->string('oss')->nullable();
            $table->string('item_description')->nullable();
            $table->string('item_quantity')->nullable();
            $table->string('item_size')->nullable();
            $table->string('item_price')->nullable();
            $table->string('matarial')->nullable();
            $table->string('gmts_color')->nullable();
            $table->string('others_color')->nullable();
            $table->datetime('orderDate')->nullable();
            $table->string('orderNo')->nullable();
            $table->datetime('shipmentDate')->nullable();
            $table->string('poCatNo')->nullable();
            $table->string('sku')->nullable();
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
        Schema::dropIfExists('mxp_pi');
    }
}
