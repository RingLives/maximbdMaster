<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddFieldPiTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('mxp_pi', function (Blueprint $table) {
            $table->dropColumn('oss');
            $table->string('p_id')->nullable()->after('job_no');
            $table->string('oos_number')->nullable()->after('item_description');
            $table->string('is_type')->nullable()->after('sku');
            $table->string('style')->nullable()->after('item_description');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('mxp_pi', function (Blueprint $table) {
            // $table->dropColumn(['oos_number', 'is_type']);
        });
    }
}
