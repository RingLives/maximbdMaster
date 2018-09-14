<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePiFormatDataTableInfo extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_piFormat_data_info', function (Blueprint $table) {
            $table->increments('id');
            $table->string('code')->nullable(true);
            $table->string('orginal_buyer_name')->nullable(true);
            $table->string('buyer_name')->nullable(true);
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
        Schema::dropIfExists('mxp_piFormat_data_info');
    }
}
