<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateBookingFilesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('booking_files', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('booking_buyer_id')->nullable();
            $table->string('file_name_original')->nullable();
            $table->string('file_name_server')->nullable();
            $table->string('file_ext')->nullable();
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
        Schema::dropIfExists('booking_files');
    }
}
