<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePageHeaderTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_header', function (Blueprint $table) {
            $table->increments('header_id');
            $table->integer('user_id');
            $table->string('header_type');
            $table->string('header_title');
            $table->string('header_fontsize')->nullable(true);
            $table->string('header_fontstyle')->nullable(true);
            $table->string('header_colour')->nullable(true);
            $table->string('logo')->nullable(true);
            $table->string('logo_allignment')->nullable(true);
            $table->string('address1')->nullable(true);
            $table->string('address2')->nullable(true);
            $table->string('address3')->nullable(true);
            $table->string('cell_number')->nullable(true);
            $table->string('attention')->nullable(true);
            $table->string('status');
            $table->string('action');
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
        Schema::drop('mxp_header');
    }
}