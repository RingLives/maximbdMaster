<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateMxpPurchaseOrdersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('mxp_purchase_orders', function (Blueprint $table) {
            $table->increments('po_id');
            $table->string('po_no');
            $table->string('booking_order_id');
            $table->string('shipment_date');
            $table->string('item_code');
            $table->string('erp_code');
            $table->string('item_size')->nullable();
            $table->string('item_quantity')->nullable();
            $table->string('gmts_color')->nullable();
            $table->string('material')->nullable();
            $table->string('unit')->nullable();
            $table->string('unit_price')->nullable();
            $table->string('total_amount')->nullable();
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
        Schema::dropIfExists('mxp_purchase_orders');
    }
}
