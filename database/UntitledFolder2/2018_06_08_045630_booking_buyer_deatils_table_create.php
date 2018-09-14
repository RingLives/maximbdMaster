<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class BookingBuyerDeatilsTableCreate extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_bookingbuyer_details', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('user_id');
            $table->string('booking_order_id');
            $table->string('Company_name')->nullable(true);
            $table->string('C_sort_name')->nullable(true);
            $table->string('buyer_name')->nullable(true);
            $table->string('address_part1_invoice')->nullable(true);
            $table->string('address_part2_invoice')->nullable(true);
            $table->string('attention_invoice')->nullable(true);
            $table->string('mobile_invoice')->nullable(true);
            $table->string('telephone_invoice')->nullable(true);
            $table->string('fax_invoice')->nullable(true);
            $table->string('address_part1_delivery')->nullable(true);
            $table->string('address_part2_delivery')->nullable(true);
            $table->string('attention_delivery')->nullable(true);
            $table->string('mobile_delivery')->nullable(true);
            $table->string('telephone_delivery')->nullable(true);
            $table->string('fax_delivery')->nullable(true);
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
         Schema::dropIfExists('mxp_bookingbuyer_details');
    }
}
