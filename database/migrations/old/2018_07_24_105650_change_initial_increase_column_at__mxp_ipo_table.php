<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class ChangeInitialIncreaseColumnAtMxpIpoTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('mxp_ipo', function($table){
           $table->dropColumn('initial_increase')->delete();
        });
        Schema::table('mxp_ipo', function($table){
            $table->string('initial_increase')->after('booking_order_id');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
    }
}
