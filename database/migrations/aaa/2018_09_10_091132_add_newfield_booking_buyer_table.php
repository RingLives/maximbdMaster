<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddNewfieldBookingBuyerTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('mxp_bookingbuyer_details', function (Blueprint $table) {
            $table->string('shipmentDate')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('mxp_bookingbuyer_details', function (Blueprint $table) {
            $table->dropColumn('shipmentDate');
        });
    }
}
