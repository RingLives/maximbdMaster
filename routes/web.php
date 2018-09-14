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

Route::group(
    [
        // 'prefix' => LaravelLocalization::setLocale(),
        //'middleware' => ['localeSessionRedirect', 'localizationRedirect']
    ], function () {
    /** ADD ALL LOCALIZED ROUTES INSIDE THIS GROUP **/

    // Multi Language
    Route::get('/language/', array(
        'before' => 'csrf',
        'as' => 'language-chooser',
        'uses' => 'Trans\TranslationController@changeLanguage',

    ));

    Route::get('/search_trans_key/', array(
        'as' => 'search_trans',
        'uses' => 'Trans\TransKeyController@searchTransKey',
    ));

    Route::get('/comapny_search/', array(
        'as' => 'search_company',
        'uses' => 'RoleManagement@searchCompanyAction',
    ));

    Route::get('/booking_list_by_booking_id/', array(
        'as'=>'booking_list_view_by_booking_id',
        'uses'=>'taskController\BookingListController@getBookingListByBookingId'
    ));

    Route::get('/booking_report_list_by_book_id/', array(
        'as'=>'booking_list_view_by_booking_id',
        'uses'=>'taskController\BookingListController@getBookingReportListByBookingId'
    ));

    Route::post('/booking_list_by_search/', array(
        'as'=>'booking_list_view_by_search',
        'uses'=>'taskController\BookingListController@getBookingListBySearch'
    ));
    Route::post('/booking_list_book_search/', array(
        'as'=>'booking_list_view_book_search',
        'uses'=>'taskController\BookingListController@getBookingListbookSearch'
    ));

    Route::get('/challan_list_by_challan_id/', array(
        'as'=>'challan_list_view_by_challan_id',
        'uses'=>'taskController\ChallanListController@getChallanListByChallanId'
    ));

    Route::post('/challan_list_by_search/', array(
        'as'=>'challan_list_view_by_search',
        'uses'=>'taskController\ChallanListController@getChallanListBySearch'
    ));

    Route::get('/mrf_list_by_mrf_id/', array(
        'as'=>'mrf_list_view_by_mrf_id',
        'uses'=>'taskController\MrfListController@getMrfListByMrfId'
    ));

    Route::post('/mrf_list_by_search/', array(
        'as'=>'mrf_list_view_by_search',
        'uses'=>'taskController\MrfListController@getMrfListBySearch'
    ));

    Route::post('/po_list_by_search/', array(
        'as'=>'po_list_by_search',
        'uses'=>'Production\PurchaseOrderController@getPOListBySearch'
    ));

    Route::get('/save_purcahse_order/', array(
        'as'=>'save_purcahse_order',
        'uses'=>'Production\PurchaseOrderController@savePurchaseOrder'
    ));

    // Route::get('/create_urgent_client', array(
    // 	'as' => 'add_urgent_client',
    // 	'uses' => 'ClientController@addUrgentClient',
    // ));

    Route::any('/create_urgent_client_action', array(
        'as' => 'add_urgent_client_action',
        'uses' => 'ClientController@addUrgentClientAction',
    ));

    Route::get('/search_purchased_client/{n?}', array(
        'as' => 'search_client',
        'uses' => 'product\PurchasedSearchController@search_client',
    ));

    Route::get('/search_purchased_invoice/', array(
        'as' => 'search_invoice',
        'uses' => 'product\PurchasedSearchController@search_invoice',
    ));

    Route::get('/search_purchased_date/', array(
        'as' => 'search_date',
        'uses' => 'product\PurchasedSearchController@search_date',
    ));

    // Super Admin Login/

    Route::get('/registration', function () {
        return view('auth.register');
    });
    Route::get('/logout', 'Auth\LoginController@logout');

    Auth::routes();

    Route::get('unauthorized', function () {
        return view('notify.unauthorized');
    });

    // Super Admin Access Route
    Route::group(['middleware' => 'auth'], function () {

        Route::get('/', 'HomeController@index');

        Route::get('/dashboard', [
            'as' => 'dashboard_view',
            'uses' => 'HomeController@dashboard',
        ]);
        Route::get('/profile', [
            'as' => 'user_profile_view',
            'uses' => 'UserProfileController@profile',
        ]);
        Route::post('/profile', [
            'as' => 'user_profile_action',
            'uses' => 'UserProfileController@profileUpdate',
        ]);

        Route::group(['middleware' => 'routeAccess'], function () {
            Route::group(['prefix' => 'super-admin'], function () {

                Route::group(['middleware' => 'onlySuperAdmin'], function () {
                    //Company Account Management
                    Route::get('/opencompanyacc', [
                        'as' => 'create_company_acc_view',
                        'uses' => 'CompanyManagement@companyAccOpeningForm',
                    ]);
                    Route::post('/opencompanyacc', [
                        'as' => 'create_company_acc_action',
                        'uses' => 'CompanyManagement@openCompanyAcc',
                    ]);
                    Route::get('companylist', [
                        'as' => 'company_list_view',
                        'uses' => 'CompanyManagement@companyList',
                    ]);
                    Route::get('/updatecompanyacc/{com_id?}', [
                        'as' => 'update_company_acc_view',
                        'uses' => 'CompanyManagement@updateCompanyAccForm',
                    ]);
                    Route::post('/updatecompanyacc', [
                        'as' => 'update_company_acc_action',
                        'uses' => 'CompanyManagement@updateCompanyAcc',
                    ]);
                    Route::get('/deletecompanyacc/{com_id?}', [
                        'as' => 'delete_company_acc_action',
                        'uses' => 'CompanyManagement@deleteCompanyAcc',
                    ]);
                });
                // End of onlySuperAdmin Middleware

                // Role Management
                Route::get('/addrole',
                    [
                        'as' => 'add_role_view',
                        'uses' => 'RoleManagement@addRoleForm',
                    ]);

                Route::post('/addrole',
                    [
                        'as' => 'add_role_action',
                        'uses' => 'RoleManagement@addRole',
                    ]);
                Route::get('/rolelist',
                    [
                        'as' => 'role_list_view',
                        'uses' => 'RoleManagement@roleList',
                    ]);
                Route::get('/role/delete/{id?}',
                    [
                        'as' => 'role_delete_action',
                        'uses' => 'RoleManagement@deleteRole',
                    ]);

                Route::get('/role/update/{id?}',
                    [
                        'as' => 'role_update_view',
                        'uses' => 'RoleManagement@updateForm',
                    ]);
                Route::post('/role/update/{id?}',
                    [
                        'as' => 'role_update_action',
                        'uses' => 'RoleManagement@updateRole',
                    ]);

                Route::get('role/permission',
                    [
                        'as' => 'role_permission_view',
                        'uses' => 'RoleManagement@rolePermissionForm',
                    ]);
                Route::post('role/permission',
                    [
                        'as' => 'role_permission_action',
                        'uses' => 'RoleManagement@rolePermission',
                    ]);
                Route::any('permissions',
                    [
                        'as' => 'get_role_permission_view',
                        'uses' => 'RoleManagement@getPermissions',
                    ]);

                Route::post('role/permission/update',
                    [
                        'as' => 'role_permission_update_view',
                        'uses' => 'RoleManagement@rolePermissionForm',
                    ]);

                Route::get('role/permission/list',
                    [
                        'as' => 'role_permission_list_view',
                        'uses' => 'RoleManagement@rolePermissionList',
                    ]);
                // End of Role Management

                // User Management
                Route::get('user/add',
                    [
                        'as' => 'create_user_view',
                        'uses' => 'UserController@createUserForm',
                    ]);
                Route::post('user/add',
                    [
                        'as' => 'create_user_action',
                        'uses' => 'UserController@createUser',
                    ]);

                Route::get('user/list',
                    [
                        'as' => 'user_list_view',
                        'uses' => 'UserController@userList',
                    ]);
                Route::get('user/update/{id?}',
                    [
                        'as' => 'company_user_update_view',
                        'uses' => 'UserController@updateUserForm',
                    ]);
                Route::post('user/update',
                    [
                        'as' => 'company_user_update_action',
                        'uses' => 'UserController@updateUser',
                    ]);
                Route::get('user/delete/{id?}',
                    [
                        'as' => 'company_user_delete_action',
                        'uses' => 'UserController@deleteUser',
                    ]);

                Route::any('getrolelist', [
                    // 'as' => 'get_role_list_view',
                    'uses' => 'RoleManagement@getRoleList',
                ]);
                // End of user management

            });
            // End of super-admin prefix

            // --------- translation language **********
            Route::group(['prefix' => '_translation'], function () {
                Route::get('/uploadTranslationFile',
                    [
                        'as' => 'update_language',
                        'uses' => 'Trans\UploadFileController@updateFileView',
                    ]);

                Route::get('/successfullyUploaded',
                    [
                        'as' => 'sure_upload',
                        'uses' => 'Trans\UploadFileController@updateLangFiles',
                    ]);

                Route::group(['prefix' => 'language'], function () {
                    Route::get('/',
                        [
                            'as' => 'manage_language',
                            'uses' => 'Trans\TranslationController@languagesProvider',
                        ]);

                    Route::match(['get', 'post'], '/create',
                        [
                            'as' => 'create_locale_action',
                            'uses' => 'Trans\ManageLocaleController@createLocale',
                        ]);

                    Route::match(['get', 'post'], '/update/{id?}',
                        [
                            'as' => 'update_locale_action',
                            'uses' => 'Trans\ManageLocaleController@updateLocale',
                        ]);

                });

                Route::group(['prefix' => 'manage'], function () {
                    Route::match(['get', 'post'], '/create',
                        [
                            'as' => 'create_translation_action',
                            'uses' => 'Trans\TransKeyController@createTrans',
                        ]);

                    Route::get('/{p?}',
                        [
                            'as' => 'manage_translation',
                            'uses' => 'Trans\TranslationController@manageTranslationKey',
                        ]);

                    Route::get('/update/{id?}',
                        [
                            'as' => 'update_translation_action',
                            'uses' => 'Trans\TransKeyController@updateTrans',
                        ]);

                    Route::post('/updatePost/{id?}',
                        [
                            'as' => 'update_translation_key_action',
                            'uses' => 'Trans\TransKeyController@updatedTransAdd',
                        ]);

                    Route::get('/delete/{id?}',
                        [
                            'as' => 'delete_translation_action',
                            'uses' => 'Trans\TransKeyController@deleteTrans',
                        ]);
                });
            });
            // --------- end translation language **********

            // --------- start product prefix **********


            // End of product Prefix

            // Client/Company Information
            Route::get('client_com/list',
                [
                    'as' => 'client_com_list_view',
                    'uses' => 'ClientController@clientComList',
                ]);
            Route::get('client_com/add',
                [
                    'as' => 'client_com_add_view',
                    'uses' => 'ClientController@createClientComForm',
                ]);
            Route::post('client_com/add',
                [
                    'as' => 'client_com_add_action',
                    'uses' => 'ClientController@createClientCom',
                ]);
            Route::get('client_com/update/{id?}',
                [
                    'as' => 'client_com_update_view',
                    'uses' => 'ClientController@updateClientComForm',
                ]);
            Route::post('client_com/update/{id?}',
                [
                    'as' => 'client_com_update_action',
                    'uses' => 'ClientController@updateClientCom',
                ]);
            Route::get('client_com/delete/{id?}',
                [
                    'as' => 'client_com_delete_action',
                    'uses' => 'ClientController@deleteClientCom',
                ]);

            //End of Client/Company Information

            // Stock_Management.............



            // End Store----------------------------------------
            // Stock Start----------------------------------------


        });
    });
    // End of RouteAccess Middleware

});
// End of Auth Middleware

//  ******** These are so important for Nabodip.... Please don't remove these... ********//
/*
INSERT INTO `mxp_menu` (`menu_id`, `name`, `route_name`, `description`, `parent_id`, `is_active`, `order_id`, `created_at`, `updated_at`) VALUES
(77, 'Store', 'store_list_view', 'Store entry delete', 83, 1, 0, NULL, NULL),
(78, 'Store Add View', 'add_store_view', 'Store entry update form', 0, 1, 0, NULL, NULL),
(79, 'STORE ADD ACTION', 'add_store_action', 'Store entry update action', 0, 1, 0 , NULL, NULL),
(80, 'Store Edit View', 'edit_store_view', 'Store entry delete', 0, 1, 0, NULL, NULL),
(81, 'STORE EDIT ACTION', 'edit_store_action', 'Store entry update form', 0, 1, 0, NULL, NULL),
(82, 'STORE DELETE ACTION', 'delete_store_action', 'Store entry update action', 0, 1, 0 , NULL, NULL),
'83', 'STOCK_MANAGEMENT', '', 'Stock_Management', '0', '1', '0', NULL, NULL),
(84, 'Stock', 'stock_view', 'Stocks', 83, 1, 1, NULL, NULL);

INSERT INTO `mxp_user_role_menu` (`role_menu_id`, `role_id`, `menu_id`, `company_id`, `is_active`, `created_at`, `updated_at`) VALUES
(486, 1, 77, 0, 1, NULL, NULL),
(487, 1, 78, 0, 1, NULL, NULL),
(488, 1, 79, 0, 1, NULL, NULL),
(489, 1, 80, 0, 1, NULL, NULL),
(490, 1, 81, 0, 1, NULL, NULL),
(491, 1, 82, 0, 1, NULL, NULL),
(492, 1, 83, 0, 1, NULL, NULL),
(493, 1, 84, 0, 1, NULL, NULL);

<option value="" {{ ($stock_status === '')? "selected":"" }} name="stock_status">select</option>

<option value="1" {{ ($stock_status === '1')? "selected":"" }} name="stock_status">Stocked</option>

<option value="0" {{ ($stock_status === '0')? "selected":"" }} name="stock_status">Not yet stocked</option>
</select>
 */


Route::group(['middleware' => 'auth'], function () {
    Route::post('/add/brand/action',
            [
                'as'=>'create_brand_action',
                'uses'=>'BrandController@addBrand'
            ]);
    Route::post('add/product_size',
            [
                'as'=>'create_size_action',
                'uses'=>'ProductSizeController@addSize'
            ]);
    Route::group(['middleware' => 'routeAccess'], function () {

        // party routes

        Route::get('list/party',
            [
                'as'=>'party_list_view',
                'uses'=>'PartyController@index'
            ]);

        Route::get('party/create',
            [
                'as'=>'party_create',
                'uses'=>'PartyController@create'
            ]);
        Route::post('party/create/hh',
            [
                'as'=>'party_save_action',
                'uses'=>'PartyController@store'
            ]);
        Route::get('party/edit/{id?}',
            [
                'as'=>'party_edit_view',
                'uses'=>'PartyController@updateView'
            ]);

        Route::post('party/id/edit/{id?}',
            [
                'as'=>'party_edit_action',
                'uses'=>'PartyController@update'
            ]);

        Route::get('party/id/delete/{id?}',
            [
                'as'=>'party_delete_action',
                'uses'=>'PartyController@deleteParty'
            ]);

        // product routes

        Route::get('product/list',
            [
                'as'=>'product_list_view',
                'uses'=>'ProductController@productList'
            ]);
        Route::get('add/product',
            [
                'as'=>'add_product_view',
                'uses'=>'ProductController@addProductListView'
            ]);
        Route::post('add/product/action',
            [
                'as'=>'add_product_action',
                'uses'=>'ProductController@addProduct'
            ]);

//        Route::post('add/vendor/price',
//            [
//                'as'=>'add_product_price_action',
//                'uses'=>'ProductController@addVendorPrice'
//            ]);


        Route::get('/deleteProduct/{product_id?}',
            [
                'as'=>'delete_product_action',
                'uses'=>'ProductController@deleteProduct'
            ]);
        Route::get('/updateProduct/{product_id?}',
            [
                'as'=>'update_product_view',
                'uses'=>'ProductController@updateProductView'
            ]);
        Route::post('/updateProduct/{product_id?}',
            [
                'as'=>'update_product_action',
                'uses'=>'ProductController@updateProduct'
            ]);

        /* Brand Routes */

        Route::get('/brand/list',
            [
                'as'=>'brand_list_view',
                'uses'=>'BrandController@brandView'
            ]);
        Route::get('/add/brand',
            [
                'as'=>'addbrand_view',
                'uses'=>'BrandController@addBrandView'
            ]);

        Route::get('/update/brand/{brand_id?}',
            [
                'as'=>'update_brand_view',
                'uses'=>'BrandController@updateBrandView'
            ]);

        Route::post('/update/{brand_id?}',
            [
                'as'=>'update_brand_action',
                'uses'=>'BrandController@updateBrand'
            ]);

        Route::get('/delete/{brand_id?}',
            [
                'as'=>'delete_brand_action',
                'uses'=>'BrandController@deleteBrand'
            ]);

        /* product size routes*/

        Route::get('view/product/list',
            [
                'as'=>'product_size_view',
                'uses'=>'ProductSizeController@sizeView'
            ]);

        Route::get('add/product/size',
            [
                'as'=>'add_size_view',
                'uses'=>'ProductSizeController@addSizeView'
            ]);
        

        Route::post('update/size/{size_id?}',
            [
                'as'=>'update_size_action',
                'uses'=>'ProductSizeController@updateSize'
            ]);

        Route::get('delete/product_size/{size_id?}',
            [
                'as'=>'delete_size_action',
                'uses'=>'ProductSizeController@deleteSize'
            ]);
        Route::get('update/product_size/{size_id?}',
            [
                'as'=>'update_size_view',
                'uses'=>'ProductSizeController@updateSizeView'
            ]);




        /*page header routes*/

        Route::get('list/header',
            [
                'as'=>'page_header_view',
                'uses'=>'HeaderController@index'
            ]);

        Route::get('page/header/create',
            [
                'as'=>'page_header_create',
                'uses'=>'HeaderController@create'
            ]);
        Route::post('party/create/header',
            [
                'as'=>'page_header_save',
                'uses'=>'HeaderController@store'
            ]);
        Route::get('page/edit/{id?}',
            [
                'as'=>'page_edit_view',
                'uses'=>'HeaderController@updateView'
            ]);

        Route::post('page/edit/{id?}',
            [
                'as'=>'page_edit_action',
                'uses'=>'HeaderController@updateHeader'
            ]);

        Route::get('page/delete/{id?}',
            [
                'as'=>'page_delete_action',
                'uses'=>'HeaderController@deletePage'
            ]);

        // page footer route

        Route::get('Pagefooter',
            [
                'as'=>'page_footer_view',
                'uses'=>'PageFooterController@pageFooterView'
            ]);
        Route::get('addPagefooter',
            [
                'as'=>'add_footer_title_view',
                'uses'=>'PageFooterController@addFooterView'
            ]);

        Route::post('addPagefooteraction',
            [
                'as'=>'footer_action',
                'uses'=>'PageFooterController@addFooter'
            ]);

        Route::get('update/footer/{footer_id?}',
            [
                'as'=>'update_title_view',
                'uses'=>'PageFooterController@updateFooterView'
            ]);
        Route::post('update/footer/title/{footer_id?}',
            [
                'as'=>'updatefooter_action',
                'uses'=>'PageFooterController@updateFooter'
            ]);

        Route::get('deletefooteraction/{footer_id?}',
            [
                'as'=>'delete_footer_action',
                'uses'=>'PageFooterController@deleteFooter'
            ]);


        // report footer

        Route::get('report/footer',
            [
                'as'=>'report_footer_view',
                'uses'=>'ReportFooterController@reportView'
            ]);
        Route::get('add/report/footer',
            [
                'as'=>'addreport_footer_view',
                'uses'=>'ReportFooterController@addReportView'
            ]);
        Route::post('add/report',
            [
                'as'=>'reportfooter_action',
                'uses'=>'ReportFooterController@addReport'
            ]);
        Route::get('update/report/footer/view/{report_id?}',
            [
                'as'=>'update_report_view',
                'uses'=>'ReportFooterController@updateReportView'
            ]);
        Route::post('update/report/footer/{report_id?}',
            [
                'as'=>'update_report_action',
                'uses'=>'ReportFooterController@updateReport'
            ]);
        Route::get('delete/report/footer/{report_id?}',
            [
                'as'=>'delete_report_action',
                'uses'=>'ReportFooterController@deleteReport'
            ]);

        /* Gmts color routes */

        Route::get('color/list/view',
            [
                'as'=>'gmts_color_view',
                'uses'=>'ColorController@listView'
            ]);
        Route::get('add/color/view',
            [
                'as'=>'add_color_view',
                'uses'=>'ColorController@addColorView'
            ]);
        Route::get('update/gmts/color/view/{color_id?}',
            [
                'as'=>'update_gmtscolor_view',
                'uses'=>'ColorController@updateColorView'
            ]);
        Route::post('add/gmts/color/action',
            [
                'as'=>'add_gmtscolor_action',
                'uses'=>'ColorController@addColorAction'
            ]);
        Route::post('update/gmts/color/action/{color_id?}',
            [
                'as'=>'update_gmtscolor_action',
                'uses'=>'ColorController@updateColorAction'
            ]);
        Route::any('delete/gmts/color/action/{color_id?}',
            [
                'as'=>'delete_gmtscolor_action',
                'uses'=>'ColorController@deleteColorAction'
            ]);

    } );
});

/* all bill copy order genarates routes */


Route::group(['middleware' => 'auth'], function () {

    Route::group(['middleware' => 'routeAccess'], function () {

        Route::get('bill/copy',
            [
                'as'=>'bill_copy_view',
                'uses'=>'PrintController\TestController@billView'
            ]);
        Route::get('bill/copy/print',
            [
                'as'=>'bill_print_view',
                'uses'=>'PrintController\TestController@billViewPrint'
            ]);

        Route::post('bill/genarate',
            [
                'as'=>'bill_genarate_action',
                'uses'=>'PrintController\TestController@billbillGenarate'
            ]);
        Route::get('all/bill/view/all',
            [
                'as'=>'all_bill_view',
                'uses'=>'PrintController\BillController@searchBill'
            ]);

        Route::post('search/bill/action/bill/bill',
            [
                'as'=>'search_bill_action',
                'uses'=>'PrintController\BillController@searchBillPage'
            ]);

        Route::get('challan/boxing/list',
            [
                'as'=>'challan_boxing_list_view',
                'uses'=>'PrintController\ChallanController@challanView'
            ]);


        Route::any('challan/boxing/list/action',
            [
                'as'=>'challan_boxing_action',
                'uses'=>'PrintController\ChallanController@challanAction'
            ]);

        Route::post('multiple/challan',
            [
                'as'=>'multiple_challan_action',
                'uses'=>'PrintController\ChallanController@multipleChallanAction'
            ]);

        Route::post('multiple/challan/search',
            [
                'as'=>'multiple_challan_search',
                'uses'=>'PrintController\ChallanController@multipleChallanSearch'
            ]);

        Route::get('order/list/view',
            [
                'as'=>'order_list_view',
                'uses'=>'PrintController\OrderList@orderView'
            ]);

        Route::get('create/Ipo',
            [
                'as'=>'ipo_view',
                'uses'=>'PrintController\IPOController@ipo_view'
            ]);
        Route::post('action/create/ipo',
            [
                'as'=>'ipo_bill_action',
                'uses'=>'PrintController\IPOController@ipo_Action'
            ]);
        Route::get('order/input/view',
            [
                'as'=>'order_input_view',
                'uses'=>'PrintController\OrderInput@orderInputView'
            ]);
        Route::post('order/input/view/action',
            [
                'as'=>'input_order_action',
                'uses'=>'PrintController\OrderInput@orderInputAction'
            ]);
    });

    Route::any('/get/product/details/booking',
        [
            'as'=>'get_product_details',
            'uses'=>'taskController\BookingController@orderInputDetails'
        ]);
    Route::any('submited/get/product/details/vedorPrice',
        [
            'as'=>'get_product_details',
            'uses'=>'taskController\BookingController@getVendorPrice'
        ]);
    Route::any('/get/product/details',
        [
            'as'=>'get_product_details',
            'uses'=>'PrintController\OrderInput@orderInputDetails'
        ]);
});

/*there are all Task Routes*/

Route::group(['middleware' => 'auth'], function () {

    Route::any('get/itemcode',
            [
                'as'=>'get_item_details',
                'uses'=>'taskController\TaskController@getItemCode'
            ]);
    Route::any('get/ordercode',
            [
                'as'=>'get_order_details',
                'uses'=>'taskController\BookingController@getordercode'
            ]);

    Route::group(['middleware' => 'routeAccess'], function () {
        Route::post('submited/task',
            [
                'as'=>'task_action',
                'uses'=>'taskController\TaskController@taskActionOrsubmited'
            ]);

        Route::get('submited/task',
            [
                'as'=>'task_action',
                'uses'=>'taskController\TaskController@gettaskActionOrsubmited'
            ]);

        

        

        /** there are all booking routes here **/

        Route::any('booking/order/action',
            [
                'as'=>'booking_order_action',
                'uses'=>'taskController\BookingController@addBooking'
            ]);

        // Route::get('booking/list/list',
        //     [
        //         'as'=>'booking_list_view',
        //         'uses'=>'taskController\BookingController@addBooking'
        //     ]);

        /** there are all booking list routes here **/

        Route::get('booking/list/view',
            [
                'as'=>'booking_list_action_task',
                'uses'=>'taskController\BookingListController@showBookingReport'
            ]);

        /** there are all challan routes here **/

        Route::post('task/multiple/challanaction',
            [
                'as'=>'multiple_challan_action_task',
                'uses'=>'taskController\ChallanController@addChallan'
            ]);

        Route::get('view/challan/list',
            [
                'as'=>'challan_list_view',
                'uses'=>'taskController\ChallanListController@challanListView'
            ]);
        Route::get('challan/list/action/task',
            [
                'as'=>'challan_list_action_task',
                'uses'=>'taskController\ChallanListController@showChallanReport'
            ]);


        /** there are all MRF routes here **/

        Route::post('task/mrf/task',
            [
                'as'=>'mrf_action_task',
                'uses'=>'taskController\MrfController@addMrf'
            ]);

        Route::get('task/mrf/task/list',
            [
                'as'=>'mrf_list_action_task',
                'uses'=>'taskController\MrfListController@showMrfReport'
            ]);

        /** there are all IPO routes here **/

        Route::post('task/ipo/action',
            [
                'as'=>'task_ipo_action',
                'uses'=>'taskController\Ipo\IpoController@storeIpo'
            ]);
        Route::get('ipo/report/view',
            [
                'as'=>'ipo_list_action_task',
                'uses'=>'taskController\Ipo\IpoController@ipoReportView'
            ]);
        });
        /** there are all task routes here **/
        Route::any('/get/buyer/company',
            [
                'as'=>'get_buyer_company',
                'uses'=>'taskController\TaskController@getBuyerCompany'
            ]);
    
});

/*there are all Production Routes*/

Route::group(['middleware' => 'auth'], function () {

    Route::group(['middleware' => 'routeAccess'], function () {

            Route::get('booking/list/list',
            [
                'as'=>'booking_list_view',
                'uses'=>'taskController\BookingListController@bookingListView'
            ]);

//added in maxim-office
            Route::get('booking/list/report',
            [
                'as'=>'booking_list_report',
                'uses'=>'taskController\BookingListController@bookingListReport'
            ]);

            Route::get('mrf/list/list',
            [
                'as'=>'mrf_list_view',
                'uses'=>'taskController\MrfListController@mrfListView'
            ]);
            Route::get('permission/task/assign',
            [
                'as'=>'permission_task_assign',
                'uses'=>'taskAssignController@taskassign'
            ]);


            Route::post('permission/task/assign',
            [
                'as'=>'permission_task_assign_action',
                'uses'=>'taskAssignController@taskassignaction'
            ]);

    });
});

Route::group(['middleware' => 'auth'], function () {

    Route::group(['middleware' => 'routeAccess'], function () {

        Route::get('booking/list/detailsView/{booking_id?}',
            [
                'as'=>'booking_list_details_view',
                'uses'=>'taskController\BookingListController@detailsViewForm'
            ]);

        Route::get('booking/list/createIpo/{booking_id?}',
            [
                'as'=>'booking_list_create_ipo',
                'uses'=>'taskController\BookingListController@createIpoView'
            ]);

        Route::get('booking/list/createMrf/{booking_id?}',
            [
                'as'=>'booking_list_create_mrf',
                'uses'=>'taskController\BookingListController@createMrfView'
            ]);

        Route::get('purchase/order/list',
            [
                'as'=>'generate_purchase_order',
                'uses'=>'Production\PurchaseOrderController@index'
            ]);

        // Route::get('purchase/booking/report',
        //     [
        //         'as'=>'generate_purchase_order',
        //         'uses'=>'Production\PurchaseOrderController@index'
        //     ]);

        Route::get('purchase/order/report/{data?}',
            [
                'as'=>'generate_purchase_order_report',
                'uses'=>'Production\PurchaseOrderController@getReport'
            ]);
    });
});

include('pi_route.php');
//INSERT INTO `maxpronewerp`.`mxp_menu` (`name`, `route_name`, `description`, `parent_id`, `is_active`, `order_id`) VALUES ('Purchase Order', 'generate_purchase_order', 'purchase order list', '97', '1', '3');
//INSERT INTO `maxpronewerp`.`mxp_user_role_menu` (`role_id`, `menu_id`, `company_id`, `is_active`) VALUES ('1', '108', '0', '1');


