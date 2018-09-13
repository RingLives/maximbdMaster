<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddNewFieldMxpBookingTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('mxp_booking', function (Blueprint $table) {
            $table->string('season_code')->nullable();
            $table->string('oos_number')->nullable();
            $table->string('style')->nullable();
            $table->string('is_type')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('mxp_booking', function (Blueprint $table) {
            $table->dropColumn(['session_no', 'oos_number', 'style','is_type']);
        });
    }
}
