<?php


Route::group(['middleware' => 'auth'], function(){
   Route::group(['middleware' => 'routeAccess'], function(){

       Route::get('supplier/list', 'Supplier\SupplierController@supplierList')->name('supplier_list_view');
       Route::get('supplier/add', 'Supplier\SupplierController@supplierAdd')->name('supplier_add_view');
       Route::post('supplier/add', 'Supplier\SupplierController@supplierAddAction')->name('supplier_add_action');
       Route::get('supplier/update/{supplier_id?}', 'Supplier\SupplierController@supplierUpdate')->name('supplier_update');
       Route::post('supplier/update/{supplier_id?}', 'Supplier\SupplierController@supplierUpdateAction')->name('supplier_update_action');
       Route::get('supplier/delete/{supplier_id?}', 'Supplier\SupplierController@supplierDeleteAction')->name('supplier_delete_action');

       Route::get('booking/list/download/file/{booking_buyer_id?}/', 'taskController\BookingListController@bookingFilesDownload')->name('booking_files_download');


   });
});

?>