<?php

namespace App\Http\Controllers\Trans;

use Illuminate\Http\Request;
use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Session;
use App\Language;
use App\MxpTranslationKey;
use App\MxpTranslation;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Trans\TranslationController;
use App\Http\Controllers\Message\StatusMessage;
use Exception;
use App;
use Lang;
use DB;
use File;

class UploadFileController extends Controller
{
	public $view_path = '_translation.';
    public $app_template_pagewise_css = array(
            //'auth',
    );

    public function updateFileView()
    {
        return view('trans.uploadFile');
    }

    private function _createLangDirectory($lang_directory, $resource_directory) {

        try {
            $create_lang_directory_status = File::makeDirectory($lang_directory, 0777, true, true);
            if ($create_lang_directory_status) {

                $locales = DB::select('select * from mxp_languages where is_active = 1');
                $total_locales = count($locales);
                //echo $total_locales;exit();
                
                if ($total_locales > 0) {

                    for ($i = 0; $i < $total_locales; $i++) {
                        
                        $contents = '';
                        $locale_lang_directory = $lang_directory . '/' . $locales[$i]->lan_code;
                        $create_locale_lang_directory_status = File::makeDirectory($locale_lang_directory, 0777, true, true);
                        if ($create_locale_lang_directory_status) {

                            $locale_lang_file = $locale_lang_directory . '/others.php';
                            $locale_lang_file_validation = $locale_lang_directory . '/validation.php';
                            $locale_lang_file_pagination = $locale_lang_directory . '/pagination.php';
                            $locale_lang_file_password = $locale_lang_directory . '/password.php';
                            $locale_lang_file_auth      =$locale_lang_directory . '/auth.php';
                            $contents = "<?php\r\n\r\nreturn [\r\n\r\n";
                            $keys_and_values = DB::select('call get_translations_by_locale("' . $locales[$i]->lan_code . '")');
                            foreach ($keys_and_values as $kav) {
                                $contents .= '\'' . addslashes($kav->translation_key) . '\' => \'' . addslashes($kav->translation) . '\',' . "\r\n";
                            }
                            $contents .= "\r\n];";
                            $create_locale_lang_file = File::put($locale_lang_file, $contents);
                            $create_locale_lang_file_validation = File::put($locale_lang_file_validation, $contents);
                            $create_locale_lang_file_pagination = File::put($locale_lang_file_pagination, $contents);
                            $create_locale_lang_file_password = File::put($locale_lang_file_password, $contents);
                            $create_locale_lang_file_auth = File::put($locale_lang_file_auth, $contents);

                            $temp_lang_directory = base_path() . '/resources/lang_01/' . $locales[$i]->lan_code;
                            ///echo $temp_lang_directory;
                            if (File::exists($temp_lang_directory)) {

                                $existing_lang_files = File::files($temp_lang_directory);
                                //echo '<pre>';print_r($existing_lang_files);echo '</pre>';
//exit();
                                $total_existing_lang_files = count($existing_lang_files);
                                if ($total_existing_lang_files > 0) {

                                    for ($j = 0; $j < $total_existing_lang_files; $j++) {

                                        $cut_slashes = explode('/', $existing_lang_files[$j]);
                                        //echo '<pre>';print_r($cut_slash);echo '</pre>';
                                        $lang_file_name = $cut_slashes[count($cut_slashes) - 1];
                                        File::copy($existing_lang_files[$j], $locale_lang_directory . '/' . $lang_file_name);
                                    }
                                }
                            }
                        }
                    }//
                }
            }
        } catch (\Exception $ex) {
            echo $ex->getMessage();
        }
    }

    public function __construct() {

        //$this->data['app_template_pagewise_css'] = $this->app_template_pagewise_css;
    }

    public function index() {

        $data = array();

        return view($this->view_path . 'index');
    }

    public function updateLangFiles() {

        $resource_directory = base_path() . '/resources/';
        $lang_directory = base_path() . '/resources/lang';

        // echo $lang_directory;
        // die();

        if (File::exists($lang_directory)) {
//            $lang_directory = base_path() . '/resources/lang_01/en';
          // echo '<pre>';print_r(File::files($lang_directory));echo '</pre>';
            //$old_lang_file=
             File::deleteDirectory($lang_directory);

            //File::move($lang_directory, $resource_directory . '/lang');
        }
        $this->_createLangDirectory($lang_directory, $resource_directory);
        
        // return redirect()->route('dashboard_view');
        StatusMessage::create('lan_upload_success', "Successfully Uploaded");
        return redirect()->back();
    }

    public function generateKeysFromPreviousVersion() {

        $previous_version_dir = base_path() . '/resources/bookhint_v1_langs/';
        $files = File::glob($previous_version_dir . '*_lang.php');
        //echo '<pre>';print_r($files);echo '</pre>';
        $data = array();
        foreach ($files as $key => $value) {

            $cut_slashes = explode('/', $value);
//            $contents = File::get($previous_version_dir . $cut_slashes[count($cut_slashes) - 1]);
//            echo '<pre>';print_r($contents);echo '</pre>';
            $cut_php_ext = explode('.php', $cut_slashes[count($cut_slashes) - 1]);

            $file = fopen($previous_version_dir . $cut_php_ext[0] . ".csv", "r");
            //$key_arr = fgetcsv($file);
            //echo '<pre>';print_r(fgetcsv($file));echo '</pre>';
            //echo '<pre>';print_r($key_arr);echo '</pre>';
            while (($line = fgetcsv($file)) !== FALSE) {
                //$line is an array of the csv elements
                //echo '<pre>';print_r($line);echo '</pre>';
                $total_line = count($line);
                for($i = 0; $i < $total_line; $i++){
                    if(!empty($line[$i])){
                        $data[] = $line[$i];
                    }
                }
            }
            
            fclose($file);
//            echo count($key_arr);
//            $csv = array_map('str_getcsv', file($previous_version_dir . $cut_php_ext[0] . ".csv"));
            //echo '<pre>';print_r($data);echo '</pre>';
            //echo count($data) . '<br>';
        }
        $data2 = array();
        $total_data = count($data);
        for($i = 0; $i < $total_data; $i++){
            
            if(!empty(trim($data[$i]))){
                $data2[] = $data[$i];
            }
        }
        //echo '<pre>';print_r($data2);echo '</pre>';
        foreach($data2 as $key => $value){
            $str = trim($value);
            $translation_key = new TranslationKey;
            $translation_key->translation_key = strtolower(trim($str, '_'));
            $translation_key->is_active = 1;
            $translation_key->save();
        }
    }
}
