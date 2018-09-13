<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePartyTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_party', function (Blueprint $table) {
            $table->increments('id');
            $table->string('party_id')->nullable(true);
            $table->string('user_id')->nullable(true);
            $table->string('name')->nullable(true);
            $table->string('sort_name')->nullable(true);
            $table->string('name_buyer')->nullable(true);
            $table->string('address_part1_invoice')->nullable(true);
            $table->string('address_part2_invoice')->nullable(true);
            $table->string('attention_invoice')->nullable(true);
            $table->string('mobile_invoice')->nullable(true);
            $table->string('telephone_invoice')->nullable(true);
            $table->string('fax_invoice')->nullable(true);
            $table->string('address_part1_delivery')->nullable(true);
            $table->string('address_part2_delivery')->nullable(true);
            $table->string('attention_delivery')->nullable(true);
            $table->string('mobile_delivery')->nullable(true);
            $table->string('telephone_delivery')->nullable(true);
            $table->string('fax_delivery')->nullable(true);
            $table->string('description_1')->nullable(true);
            $table->string('description_2')->nullable(true);
            $table->string('description_3')->nullable(true);
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
        Schema::drop('mxp_party');
    }
}
