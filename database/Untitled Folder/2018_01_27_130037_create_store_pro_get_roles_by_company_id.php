<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateStoreProGetRolesByCompanyId extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        DB::unprepared('CREATE DEFINER=`root`@`localhost` PROCEDURE `get_roles_by_company_id`(IN `cmpny_id` INT(11), IN `cm_grp_id` INT(11)) SELECT rl.name as roleName, cm.name as companyName, cm.id as company_id, rl.cm_group_id, rl.is_active FROM mxp_role rl INNER JOIN mxp_companies cm ON(rl.company_id=cm.id) where cm.group_id = `cmpny_id` and rl.cm_group_id = `cm_grp_id`');
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        DB::unprepared("DROP procedure IF EXISTS get_roles_by_company_id");
    }
}
