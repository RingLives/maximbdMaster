<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class MxpReportFooter extends Model
{
    protected $table = 'mxp_reportFooter';
	protected $primaryKey = 're_footer_id';

	protected $fillable = ['user_id','reportName','description_1','description_2','description_3','description_4','description_5','siginingPerson_1','siginingPerson_2','siginingPersonSeal_1','siginingSignature_1','siginingSignature_2','siginingPersonSeal_2','status','action'];
}
