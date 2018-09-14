<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateMultipleChallanTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_multiplechallan', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('user_id');
            $table->string('challan_id')->nullable(true);
            $table->string('checking_id')->nullable(true);
            $table->string('bill_id')->nullable(true);
            $table->string('erp_code')->nullable(true);
            $table->string('item_code')->nullable(true);
            $table->string('oss')->nullable(true);
            $table->string('style')->nullable(true);
            $table->string('item_size')->nullable(true);
            $table->string('quantity')->nullable(true);
            $table->string('unit_price')->nullable(true);
            $table->string('total_price')->nullable(true);
            $table->string('party_id')->nullable(true);
            $table->string('name_buyer')->nullable(true);
            $table->string('name')->nullable(true);
            $table->string('sort_name')->nullable(true);
            $table->string('address')->nullable(true);
            $table->string('attention_invoice')->nullable(true);
            $table->string('mobile_invoice')->nullable(true);
            $table->string('incrementValue')->nullable(true);
            $table->string('status')->nullable(true);
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
        Schema::dropIfExists('mxp_multiplechallan');
    }
}
