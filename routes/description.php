<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
 */

Route::get('/description/list',
    [
        'as'=>'description_list_view',
        'uses'=>'itemDescriptionController@descriptionView'
    ]);
Route::get('/add/description',
    [
        'as'=>'addDescription_view',
        'uses'=>'itemDescriptionController@addDescriptionView'
    ]);
Route::post('/add/description/action',
    [
        'as'=>'create_description_action',
        'uses'=>'itemDescriptionController@addDescription'
    ]);

Route::get('/update/description/{id_mxp_desc?}',
    [
        'as'=>'update_description_view',
        'uses'=>'itemDescriptionController@updateDescriptionView'
    ]);

Route::post('/update/description/{id_mxp_desc?}',
    [
        'as'=>'update_description_action',
        'uses'=>'itemDescriptionController@updateDescription'
    ]);

Route::get('/delete/description/{id_mxp_desc?}',
    [
        'as'=>'delete_description_action',
        'uses'=>'itemDescriptionController@deleteDescription'
    ]);