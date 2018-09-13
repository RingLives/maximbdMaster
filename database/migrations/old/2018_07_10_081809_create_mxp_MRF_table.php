<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateMxpMRFTable extends Migration {
	/**
	 * Run the migrations.
	 *
	 * @return void
	 */
	public function up() {
		Schema::create('mxp_MRF_table', function (Blueprint $table) {
			$table->increments('id');
			$table->integer('user_id');
			$table->string('mrf_id');
			$table->string('booking_order_id');
			$table->string('mrf_person_name')->nullable(true);
			$table->string('erp_code')->nullable(true);
			$table->string('item_code')->nullable(true);
			$table->string('item_size')->nullable(true);
			$table->string('item_description')->nullable(true);
			$table->string('item_quantity')->nullable(true);
			$table->string('mrf_quantity')->nullable(true);
			$table->string('item_price')->nullable(true);
			$table->string('matarial')->nullable(true);
			$table->string('gmts_color')->nullable(true);
			$table->string('others_color')->nullable(true);
			$table->string('orderDate')->nullable(true);
			$table->string('orderNo')->nullable(true);
			$table->string('shipmentDate')->nullable(true);
			$table->string('mrf_person_name')->nullable(true);
			$table->string('poCatNo')->nullable(true);
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
	public function down() {
		Schema::dropIfExists('mxp_MRF_table');
	}
}
