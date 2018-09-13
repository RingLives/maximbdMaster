<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

use Validator;
use DB;
class AppServiceProvider extends ServiceProvider
{
  /**
  * Bootstrap any application services.
  *
  * @return void
  */
  public function boot()
  {

    error_reporting(0);
    
  Validator::extend('unique_check_more_field_comb', function($attribute, $value,$parameters)
  { 
    $table = $parameters[0];
    $packing_field = $parameters[1];
    $company_id_field=$parameters[2];
    $company_id_field_value=$parameters[3];
    $com_groupyid_field=$parameters[4];
    $com_groupyid_field_value=$parameters[5];
    $user_field=$parameters[6];
    $user_field_value=$parameters[7];
    $name_field=$parameters[8];
    $name_value=$parameters[9];
    $product_group_field=$parameters[10];
    $product_group_value=$parameters[11];
    $group_id_field=$parameters[12];
    $group_id_value=$parameters[13];
    $packing_ids_comb=$parameters[14];
    $packing_ids_comb_value=$parameters[15];
    $isdeleted_field=$parameters[16];
    $isdeleted_value=$parameters[17];

    $result=array();

    foreach ($value as $key => $packing_id)
    {
      $result=DB::select('select count(*) as cnt from '.$table.' where
      packing_id ="'.$packing_id.'" and name="'.$name_value.'" and product_group_id="'.$product_group_value.'"
      and company_id="'.$company_id_field_value.'"
      and com_group_id="'.$com_groupyid_field_value.'"
      and user_id="'.$user_field_value.'" and comb_id ="'.$packing_ids_comb_value.'"
      and is_deleted="0"');
    }
    return $result[0]->cnt==0;

  });

  Validator::extend('arr_key_has_value', function($attribute, $value)
  {
    $tr=0;

    foreach ($value as $key => $values)
    {
      if($key && $values!=="" || $key==0)
        $tr=1;

      else
      $tr=0;
    }
    return $tr==1;
  });
}

  /**
  * Register any application services.
  *
  * @return void
  */
  public function register()
  {
  //
  }
}
