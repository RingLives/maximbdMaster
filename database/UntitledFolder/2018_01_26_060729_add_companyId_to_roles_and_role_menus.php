<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddCompanyIdToRolesAndRoleMenus extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('mxp_role', function($table) {
            $table->integer('company_id')->after('name');
        });

        Schema::table('mxp_user_role_menu', function($table) {
            $table->integer('company_id')->after('menu_id');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('mxp_role', function($table) {
            $table->dropColumn('company_id');
        });

        Schema::table('mxp_user_role_menu', function($table) {
            $table->dropColumn('company_id');
        });
    }
}
