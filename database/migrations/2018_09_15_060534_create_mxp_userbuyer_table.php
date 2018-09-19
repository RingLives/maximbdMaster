<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateMxpUserbuyerTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_userbuyer', function (Blueprint $table) {
            $table->increments('id_userbuyer');
            $table->integer('id_buyer')->nullable(true);
            $table->integer('id_user')->nullable(true);
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
         Schema::dropIfExists('mxp_userbuyer');
    }
}
