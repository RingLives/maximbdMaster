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

Route::get('/buyer/list',
    [
        'as'=>'buyer_list_view',
        'uses'=>'buyerController@buyerView'
    ]);
Route::get('/add/buyer',
    [
        'as'=>'addbuyer_view',
        'uses'=>'buyerController@addbuyerView'
    ]);
Route::post('/add/buyer/action',
    [
        'as'=>'create_buyer_action',
        'uses'=>'buyerController@addBuyer'
    ]);

Route::get('/update/buyer/{id_mxp_buyer?}',
    [
        'as'=>'update_buyer_view',
        'uses'=>'buyerController@updatebuyerView'
    ]);

Route::post('/update/buyer/{id_mxp_buyer?}',
    [
        'as'=>'update_buyer_action',
        'uses'=>'buyerController@updatebuyer'
    ]);

Route::get('/delete/buyer/{id_mxp_buyer?}',
    [
        'as'=>'delete_buyer_action',
        'uses'=>'buyerController@deletebuyer'
    ]);