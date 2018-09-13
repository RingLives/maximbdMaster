<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePageReportFooterTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_reportFooter', function (Blueprint $table) {
            $table->increments('re_footer_id');
            $table->integer('user_id');
            $table->string('reportName');
            $table->string('description_1');
            $table->string('description_2');
            $table->string('description_3');
            $table->string('description_4');
            $table->string('description_5');
            $table->string('siginingPerson_1');
            $table->string('siginingPersonSeal_1')->nullable(true);
            $table->string('siginingSignature_1')->nullable(true);         
            $table->string('siginingPerson_2');
            $table->string('siginingSignature_2')->nullable(true);
            $table->string('siginingPersonSeal_2')->nullable(true);
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
        Schema::dropIfExists('mxp_reportFooter');
    }
}
