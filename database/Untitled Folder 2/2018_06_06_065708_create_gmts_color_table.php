<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateGmtsColorTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_gmts_color', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('user_id');
            $table->string('item_code')->nullable(true);
            $table->string('color_name')->nullable(true);
            $table->string('status')->nullable(true);
            $table->string('action')->nullable(true);
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
        Schema::dropIfExists('mxp_gmts_color');
    }
}
