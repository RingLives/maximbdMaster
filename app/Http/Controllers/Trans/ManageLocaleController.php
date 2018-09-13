<?php

namespace App\Http\Controllers\Trans;

use Illuminate\Http\Request;
use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Session;
use Illuminate\Validation\Rule;
use App\Trans\TranslationController;
use App\Http\Controllers\Controller;
use App\Language;

use Validator;
use Exception;
use App;
use Lang;
use DB;

class ManageLocaleController extends Controller
{ 
    public function createLocale(Request $request)
    {
        if($request->isMethod('post'))
        {
            $validator = Validator::make($request->all(), [
                'lan_name' => 'required|unique:mxp_languages',
                'lan_code' => 'required|unique:mxp_languages',
            ]);

            $success = $this->setLocale($validator, $request);

            if ($success)
                return redirect()->back()->withInput($request->input())->withErrors($success);

            else
                return redirect()->route('manage_language');
        }
         
        return view('trans.language.addLocale', compact('language'));
    }

    public function updateLocale(Request $request)
    {
        if($request->isMethod('post'))
        {
            $validator  =    Validator::make($request->all(), [
                'lan_name' => [
                    'required',
                    Rule::unique('mxp_languages')->ignore($request->id, 'id'),
                ],
                'lan_code' => [
                    'required',
                    Rule::unique('mxp_languages')->ignore($request->id, 'id'),
                ],
            ]);

            $success    =    $this->setLocale($validator, $request);

            if ($success)
                return redirect()->back()->withInput($request->input())->withErrors($success);
            else
                return redirect()->route('manage_language');
        }

        $language = Language::find($request->id);

        return view('trans.language.updateLocale',['language' => $language]);
    }

    public function setLocale($validator,Request $request)
    {
        if ($validator->fails())
            return $validator->messages();

        else
        {
            $this->saveLocale($request);
            return '';
        }
    }

    public function saveLocale(Request $request)
    {
        $language               =   $this->getLanguageObj($request);
        $language->lan_name     =   $request->lan_name;
        $language->lan_code     =   $request->lan_code;
        $language->is_active    =   $request->isActive;
        
        return $language->save();
    }

    public function getLanguageObj(Request $request)
    {
        if($request->id)
            $language   =   Language::find($request->id);

        else
            $language   =   new Language();

        return $language;
    }
}
