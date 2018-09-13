<?php

namespace App\Http\Controllers\Trans;

use Illuminate\Http\Request;
use App\Http\Requests;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Session;
use Illuminate\Validation\Rule;
use App\Language;
use App\MxpTranslationKey;
use App\MxpTranslation;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Trans\TranslationController;

use Validator;
use Exception;
use App;
use Lang;
use DB;

class TransKeyController extends Controller
{

    public function createTrans(Request $request)
    {   
        if($request->isMethod('post'))
        {
            $validator = Validator::make($request->all(), [
                'Translation_key' => 'required|unique:mxp_translation_keys,translation_key',
            ]);

            $notSuccess = $this->checkValidation($validator, $request);

            if ($notSuccess)
                return redirect()->back()->withInput($request->input())->withErrors($notSuccess);

            else
                return redirect()->route('manage_translation');
        }

        else
            return view('trans.manageTranslation.addNewKey');
    }

    public function checkValidation($validator,Request $request)
    {
        if ($validator->fails())
            return $validator->messages();

        else
        {
            $this->setTranslations($request);
            return '';
        }
    }
    
    private function setTranslations(Request $request)
    {
        $translateKey                   =   $this->getTransKey($request);
        $translateKey->translation_key  =   strtolower($request->Translation_key);
        $translateKey->is_active        =   $request->isActive;

        $isSaved                        =   $translateKey->save();

        if($isSaved)
        {
            $languages = $this->LanguageListProvider();
            foreach ($languages as $language) {
                $this->setSingleTransKey($request, $language->lan_code, $translateKey->translation_key_id);
            }
        }
    }

    private function setSingleTransKey(Request $request,$lan_code,$translation_key_id)
    {
        $translate                      =   $this->getTranslation($request);
        $translate->translation_key_id  =   $translation_key_id;
        $translate->is_active           =   $request->isActive;
        $translate->lan_code            =   $lan_code;
        $translate->save();
    }

    private function getTranslation(Request $request)
    {
        if($request->id)
            $translation = MxpTranslation::find($request->id);

        else
            $translation = new MxpTranslation();

        return $translation;
    }

    private function getTransKey(Request $request)
    {
        if($request->id)
            $transKey = MxpTranslationKey::find($request->id);

        else
            $transKey = new MxpTranslationKey();

        return $transKey;
    }

    public function updateTrans(Request $request)
    {
        $languages = $this->LanguageListProvider();

        foreach ($languages as $language)
        {
            $lan = $language->lan_code;
            $obj = MxpTranslation::where('translation_key_id', $request->id)
              ->where('lan_code', $lan)->get();

            if(!$obj->count())
            {
                $update_key = new MxpTranslation();
                $update_key->lan_code=$lan;
                $update_key->translation_key_id=$request->id;
                $update_key->save();
            }
        }

        $trans_view = DB::select('call get_translation_by_key_id('.$request->id.')');

        return view('trans.manageTranslation.updateTrans', ['trans' => $trans_view ]);
    }

    public function updatedTransAdd(Request $request)
    {
        $temp       =   0;
        $languages  =   $this->LanguageListProvider();

        foreach ($languages as $language)
        {
            $lan_name = $language->lan_name;
            if($request->$lan_name)
                $temp++;
        }

        $messsages = array(
            'English.required'=> trans('validation.mxp_trans_required'),
        );

        $validator = Validator::make(
            $request->all(), 
            [ 'Translation_key' => [
                    'required',
                    Rule::unique('mxp_translation_keys')->ignore($request->translation_key_id, 'translation_key_id'),
                ],
            'English' => ($temp == 0)? 'required': '',
            ], 
            $messsages );

        if ($validator->fails())
            return redirect()->back()->withInput($request->input())->withErrors($validator->messages());

        else
        {
            $this->saveUpdatedTrans($request);
            return redirect()->route('manage_translation');
        }
    }

    public function saveUpdatedTrans(Request $request)
    {
        $languages = $this->LanguageListProvider();

        DB::table('mxp_translation_keys')
            ->where('translation_key_id', $request->translation_key_id)
            ->update(['is_active' => $request->isActive, 'translation_key' => $request->Translation_key]);

        foreach ($languages as $language)
        {
            $lan_name   =   $language->lan_name;
            $lan_code   =   $language->lan_code;
    
            $obj        =   DB::select('select translation from mxp_translations where translation_key_id = ? and lan_code = ?',[$request->translation_key_id, $lan_code]);

            MxpTranslation::where('translation_key_id', $request->translation_key_id)
                    ->where('lan_code', $lan_code)
                    ->update(['translation' => $request->$lan_name, 'is_active' => $request->isActive]);
        }
    }

    private function LanguageListProvider()
    {
        $language   =   new TranslationController();
        $languages  =   $language->getLanguageList();

        return $languages;
    }   

    public function deleteTrans(Request $request)
    {
        $trans_key  =   MxpTranslationKey::find($request->id);
        $trans_key->delete();

        MxpTranslation::where('translation_key_id', $request->id)->delete();

        return redirect()->route('manage_translation');
    }

    /**
     * @desc To change the current language
     * @request Ajax
     */
    public function searchTransKey(Request $request)
    {
        try 
        {
            $result = DB::select('call get_searched_trans_key("'.$request->value.'")');

            $length = count($result);

            if($length > 0)
            {
                $output = '
                    <div>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Sl no.</th>
                                    <th>Translation Key</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                ';
                for ($i=0; $i<$length ; $i++) {
                $output .= '
                                <tr>
                                <td>'.($i+1).'</td>
                                <td>'.$result[$i]->translation_key.'</td>
                                <td>'.(($result[$i]->is_active == 1)? 'Active':'Inactive').'</td>
                                <td> <a href = "/_translation/manage/update/'.$result[$i]->translation_key_id.'" class="btn btn-success">edit</a>
                                <a href = "/_translation/manage/delete/'.$result[$i]->translation_key_id.'" class="btn btn-danger">delete</a></td>

                                </tr>';
                }
                $output .= '
                            </tbody>
                        </table>
                    </div>';

                echo $output;
            }
        }

        catch (Exception $e)
        {
            echo $e;
        }
    }
}
