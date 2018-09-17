<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddFieldMxpBookingChallan extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('mxp_booking_challan', function (Blueprint $table) {
            $table->string('left_mrf_ipo_quantity')->after('item_quantity');
            $table->string('ipo_quantity')->after('mrf_quantity');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('mxp_booking_challan', function (Blueprint $table) {
            $table->dropColumn('left_mrf_ipo_quantity');
            $table->dropColumn('ipo_quantity');
        });
    }
}
