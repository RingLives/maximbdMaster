<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateCreateMxpItemsQntyByBookingChallansTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_items_details_by_booking_challan', function (Blueprint $table) {
            $table->increments('items_details_id');
            $table->integer('booking_challan_id');
            $table->string('booking_order_id')->nullable();
            $table->string('item_code')->nullable();
            $table->string('erp_code')->nullable();
            $table->string('item_size')->nullable();
            $table->string('item_quantity')->nullable();
            $table->string('gmts_color')->nullable();
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
        Schema::dropIfExists('mxp_items_details_by_booking_challan');
    }
}
