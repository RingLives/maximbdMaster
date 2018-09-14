<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateExcelEmportTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_order', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('user_id');
            $table->string('order_id')->nullable(true);
            $table->string('erp_code')->nullable(true);
            $table->string('item_code')->nullable(true);
            $table->string('oss')->nullable(true);
            $table->string('style')->nullable(true);
            $table->string('item_size')->nullable(true);
            $table->string('quantity')->nullable(true);
            $table->string('incrementValue')->nullable(true);
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
         Schema::dropIfExists('mxp_order');
    }
}
