<?php

namespace App\Http\Controllers\Trans;

use Illuminate\Http\Request;
use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Session;
use App\Language;
use App\MxpTranslation;
use App\Http\Controllers\Controller;
use Illuminate\Support\Collection;

use Exception;
use App;
use Lang;
use DB;

class TranslationController extends Controller
{
    /**
     * @desc To change the current language
     * @request Ajax
     */
    public function changeLanguage(Request $request)
    {
        if($request->ajax()){
            $request->session()->put('locale', $request->locale);
            $request->session()->flash('alert-success','app.Locale_Change_Successs');   
        }
    }

    public static function getLanguageList()
    {
        $languages = DB::select('select * from mxp_languages');

        return $languages;
    }

    public function languagesProvider()
    {
        $languageList = self::getLanguageList();

        return view('trans.language.index', ['languages' => $languageList]);
    }

    public function index()
    {
        return view('trans.index');
    }

    public function manageTranslationKey($page = 1)
    {
        $limitPerPage       =   20;
        $start              =   ($page-1)*$limitPerPage;

        $totalTrans         =   DB::table('mxp_translations')->count();
        $get_translations   =   DB::select('call get_all_translation_with_limit('.$start.','.$limitPerPage.')');

        $translations       =   $this->getTranslationArray($get_translations);

        return view('trans.manageTranslation.index', ['translations' => $translations, 'currentPage' => $page, 'totalTrans' => $totalTrans, 'limitPerPage' => $limitPerPage]);
    }

    private function getTranslationArray($get_translations)
    {
        $translations       =   array();
        $trans_value_array  =   [];
        $lan_code_arrary    =   [];
        $temp               =   -1;
        $i                  =   -1;

        foreach ($get_translations as $trans)
        {
            if($temp == $trans->translation_key_id)
            {
                $translations[$i]['trans_value']    .=   ",".$trans->translation;
                $translations[$i]['lan_name']       .=   ",".$trans->lan_name;
            }
            else
            {
                $i++;
                $translations[$i]['trans_key']      =   $trans->translation_key;
                $translations[$i]['key_id']         =   $trans->translation_key_id;
                $translations[$i]['trans_value']    =   $trans->translation;
                $translations[$i]['lan_name']       =   $trans->lan_name;
                $translations[$i]['status']         =   $trans->is_active;
                $temp                               =   $trans->translation_key_id;
            }
        }

        return $translations;
    }
}
