<?php

namespace App\Http\Controllers\Supplier;

use App\MxpSupplierPrice;
use App\Supplier;
use Validator;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class SupplierController extends Controller
{
    public function supplierList(){

        $suppliers = Supplier::where('is_delete', 0)->get();

        return view('supplier.supplier_list', compact('suppliers'));
    }



    public function supplierAdd(){
        return view('supplier.supplier_add');
    }

    public function supplierAddAction(Request $req){

        $inputErrorMsg = [
            'name.required' => 'Name is required',
            'phone.required' => 'Contact is required',
            'address.required' => 'Address is required',
            'status.required' => 'Please select status'
        ];

        $validate = Validator::make(
            $req->all(),
            [
                'name' => 'required',
                'phone' => 'required',
                'address' => 'required',
                'status' => 'required'
            ],
            $inputErrorMsg
        );

        if($validate->fails()){
            return redirect()->back()->withInput($req->input())->withErrors($validate->messages());
        }


        $supplierId = Supplier::create($req->all())->supplier_id;

        return redirect()->route('supplier_list_view');
    }


    public function supplierUpdate(Request $req){

        $supplier = Supplier::where('is_delete', 0)->where('supplier_id', $req->supplier_id)->get()->first();
        return view('supplier.supplier_update', compact('supplier'));
    }
    public function supplierUpdateAction(Request $req){

//        return $req->all();

        Supplier::where('supplier_id', $req->supplier_id)
            ->update([
                'name' => $req->name,
                'phone'=> $req->phone,
                'address'=>$req->address,
                'status' =>$req->status
            ]);
        return redirect()->route('supplier_list_view');
    }
    public function supplierDeleteAction(Request $req){

        Supplier::where('supplier_id', $req->supplier_id)
            ->update([
                'is_delete' => 1
            ]);

        return redirect()->route('supplier_list_view');
    }

    public static function saveSupplierProductPrice(Request $req, $productId){

        for($i=0; $i<count($req->supplier_id); $i++){
            $sPrice = new MxpSupplierPrice;
            $sPrice->supplier_id = $req->supplier_id[$i];
            $sPrice->product_id = $productId;
            $sPrice->supplier_price = $req->supplier_price[$i];
            $sPrice->save();
        }

        return $req->all();
    }

    public static function updateProductPrice(Request $request){


        for($i=0; $i<count($request->supplier_id); $i++){

            if(count(MxpSupplierPrice::find($request->supplie_price_id[$i])) > 0){
                $sPrice = MxpSupplierPrice::find($request->supplie_price_id[$i]);
            }else{
                $sPrice = new MxpSupplierPrice();
            }

            $sPrice->supplier_id = $request->supplier_id[$i];
            $sPrice->product_id = $request->product_id;
            $sPrice->supplier_price = $request->supplier_price[$i];
            $sPrice->save();

        }

        return true;
    }
}
