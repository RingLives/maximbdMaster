<?php

Route::group(['middleware' => 'auth'], function () {
    Route::group(['middleware' => 'routeAccess'], function () {

    Route::get('pi/generate/report',
        [
            'as'=>'pi_generate_action',
            'uses'=>'taskController\pi\PiController@piGenerate'
        ]);
    });
});