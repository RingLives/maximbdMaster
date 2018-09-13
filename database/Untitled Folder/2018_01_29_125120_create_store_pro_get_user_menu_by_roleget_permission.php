<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateStoreProGetUserMenuByRolegetPermission extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('CREATE DEFINER=`root`@`localhost` PROCEDURE `get_permission`(IN `role_id` INT(11), IN `route` VARCHAR(120), IN `comp_id` INT(11))
if(comp_id !="")then SELECT COUNT(*) as cnt FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE m.route_name=route AND rm.role_id=role_id AND rm.company_id=comp_id;
else
SELECT COUNT(*) as cnt FROM mxp_user_role_menu rm inner JOIN mxp_menu m ON(m.menu_id=rm.menu_id) WHERE m.route_name=route AND rm.role_id=role_id ;
end if');
    }


    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared("DROP procedure IF EXISTS get_permission");
    }
}
