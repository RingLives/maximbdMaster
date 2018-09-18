<?php

Route::group(['middleware' => 'auth'], function () {
    Route::group(['middleware' => 'routeAccess'], function () {

	    Route::get('ipo/list',
	        [
	            'as'=>'ipo_list_view',
	            'uses'=>'taskController\Ipo\IpoListController@getIpoValue'
	        ]);

	    Route::get('ipo/report',
	        [
	            'as'=>'ipo_list_report_view',
	            'uses'=>'taskController\Ipo\IpoListController@getIpoReport'
	        ]);
    });
});