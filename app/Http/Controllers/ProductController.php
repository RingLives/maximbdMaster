<?php

namespace App\Http\Controllers;

use App\Http\Controllers\dataget\ListGetController;
use App\Http\Controllers\Message\StatusMessage;
use App\Http\Controllers\RoleManagement;
use App\MaxParty;
use App\MxpProduct;
use App\MxpBrand;
use App\MxpProductsColors;
use App\MxpSupplierPrice;
use App\Supplier;
use App\VendorPrice;
use Auth;
use Illuminate\Http\Request;
use Validator;
use App\Model\MxpGmtsColor;
use App\MxpProductSize;
use App\MxpProductsSizes;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Supplier\SupplierController;

class ProductController extends Controller
{
    const CREATE_PRODUCT = "create";
    const UPDATE_PRODUCT = "update";
	const ACTIVE_BRAND = 1;

    Public function productList(){


        $products = $this->allProducts();
    	return view('product_management.product_list',compact('products'));
    }

    public function allProducts($productId = null){

        if($productId == null ){
            $proWithSizeColors = MxpProduct::with('colors', 'sizes')->where('user_id',Auth::user()->user_id)->paginate(20);
        }else{
            $proWithSizeColors = MxpProduct::with('colors', 'sizes')->where('product_id', $productId)->where('user_id',Auth::user()->user_id)->paginate(20);
        }



        $i=0;
        foreach ($proWithSizeColors as $proWithSizeColor) {
            $j = 0;
            foreach ($proWithSizeColor->colors as $colorids) {
                $proWithSizeColors[$i]->colors[$j]->setAttribute('color_name', MxpGmtsColor::select('color_name')->where('id', '=', $colorids->color_id)->get()[0]->color_name);
                $j++;
            }

            $j = 0;
            foreach ($proWithSizeColor->sizes as $sizeids) {
                $proWithSizeColors[$i]->sizes[$j]->setAttribute('product_size', MxpProductSize::select('product_size')->where('proSize_id', '=', $sizeids->size_id)->get()[0]->product_size);
                $j++;
            }

            $i++;
        }

        return  $proWithSizeColors;
    }

    Public function addProductListView(){

        $brands = MxpBrand::where([['user_id',Auth::user()->user_id],['status', self::ACTIVE_BRAND]])->get();
    	$colors = MxpGmtsColor::where('user_id',Auth::user()->user_id)->where('item_code', NULL)->where('status', '=', 1)->get();
        $sizes = MxpProductSize::where('user_id',Auth::user()->user_id)->where('product_code', '')->where('status', '=', 1)->get();

        $vendorCompanyList = MaxParty::select('id', 'name', 'name_buyer')->get()->sortBy('name_buyer');

        $supplierList = Supplier::where('status', 1)
                        ->where('is_delete', 0)
                        ->get();

       return view('product_management.add_product',compact('brands', 'colors', 'sizes', 'vendorCompanyList', 'supplierList'));
    }

    Public function updateProductView(Request $request){
        $brands = MxpBrand::where('status', self::ACTIVE_BRAND)->get();
    	//     $product = MxpProduct::where('product_id', $request->product_id)->get();

        $product = $this->allProducts($request->product_id);
        $colors = MxpGmtsColor::where('item_code', NULL)->get();
        $sizes = MxpProductSize::where('product_code', '')->get();


        $colorsJs=[];
        $sizesJs=[];

        foreach ($product as $color){
            foreach ($color->colors as $data){

                array_push($colorsJs, $data->color_id.','.$data->color_name);
            }
        }

        foreach ($product as $size){
            foreach ($size->sizes as $data){
                array_push($sizesJs, $data->size_id.','.$data->product_size);
            }
        }





        $vendorCompanyListPrice = VendorPrice::with('party')->where('product_id', $request->product_id)->get();
        $supplierPrices = MxpSupplierPrice::with('supplier')->where('product_id', $request->product_id)->get();

        $vendorCompanyList = MaxParty::select('mxp_party.id', 'mxp_party.name', 'mxp_party.name_buyer')
                            ->leftJoin('mxp_vendor_prices', 'mxp_vendor_prices.party_table_id', '=', 'mxp_party.id')
                            ->where('mxp_party.status', '=', 1)
                            ->where('mxp_vendor_prices.party_table_id', null)
                            ->get();
//        return count($vendorCompanyList);

        if(count($vendorCompanyListPrice)==0){
            $vendorCompanyList = MaxParty::select('id', 'name', 'name_buyer')->get()->sortBy('name_buyer');
        }

//        return $vendorCompanyList;



        $supplierList = Supplier::select('suppliers.supplier_id', 'suppliers.name', 'suppliers.phone', 'suppliers.address', 'suppliers.status')
                        ->leftJoin('mxp_supplier_prices', 'mxp_supplier_prices.supplier_id', '=', 'suppliers.supplier_id')
                        ->where('suppliers.status', '=', 1)
                        ->where('suppliers.is_delete', '=', 0)
                        ->where('mxp_supplier_prices.supplier_id', null)
                        ->get();
        if(count($supplierPrices) == 0){
            $supplierList = Supplier::get()->sortBy('name');
        }

//        return $product;
       return view('product_management.update_product', compact('product', 'vendorCompanyListPrice', 'supplierPrices', 'supplierList', 'vendorCompanyList',  'colors', 'sizes', 'colorsJs', 'sizesJs'))->with('brands',$brands);
    }

    Public function addProduct(Request $request){


    	$roleManage = new RoleManagement();

        $validMessages = [
            'p_code.required' => 'Item Code field is required.',
            'product_type.required' => 'Product Type is required.',
            'p_code.unique' => 'Item Code has been entered before.',
            'p_erp_code.required' => 'ERP Code field is required.',
            'p_unit_price.required' => 'Unit Price field is required.',
            'p_weight_qty.required' => 'Weight Qty field is required.',
            'p_weight_qty.integer' => 'Weight Qty field is required.',
            'p_weight_amt.required' => 'Weight Amt field is required.',
            'p_weight_amt.integer' => 'Weight Amt field is required.',
            // 'p_brand.required' => 'Brand field is required.'
            ];
        $datas = $request->all();
    	$validator = Validator::make($datas,
            [
    			'p_code' => 'required|unique:mxp_product,product_code',
    			'p_erp_code' => 'required',
    			// 'p_brand' => 'required'
		    ],
            $validMessages
        );

		// self::print_me($validator);

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();



    	$createProduct = new MxpProduct();
    	$createProduct->product_code = $request->p_code;
    	$createProduct->product_name = $request->p_name;
        $createProduct->product_type = $request->product_type;
    	$createProduct->product_description = $request->p_description;
    	$createProduct->brand = $request->p_brand;
    	$createProduct->erp_code = $request->p_erp_code;
    	$createProduct->item_inc_percentage = $request->item_inc_percentage;
    	$createProduct->unit_price = $request->p_unit_price;
    	$createProduct->weight_qty = $request->p_weight_qty;
    	$createProduct->weight_amt = $request->p_weight_amt;
        $createProduct->user_id = Auth::user()->user_id;
        $createProduct->status = $request->is_active;
        $createProduct->others_color = $request->others_color;
    	$createProduct->action = self::CREATE_PRODUCT;
    	$createProduct->save();

        $lastProId = $createProduct->product_id;



        $this->addVendorPrice($request, $lastProId);

        SupplierController::saveSupplierProductPrice($request, $lastProId);


       for ($i=0; $i<count($request->colors); $i++){

           $colorData = explode(',', $request->colors[$i]);

           $storeColor = new MxpProductsColors();
            $storeColor->product_id = $lastProId;
            $storeColor->color_id = $colorData[0];
            $storeColor->status = 1;
            $storeColor->save();

            $this->saveColor($colorData[1], $request->p_code);
        }


        for ($i=0; $i<count($request->sizes); $i++){

           $sizeData = explode(',', $request->sizes[$i]);

            $storeSize = new MxpProductsSizes();
            $storeSize->product_id = $lastProId;
            $storeSize->size_id = $sizeData[0];
            $storeSize->status = 1;
            $storeSize->save();

            $this->saveSize($sizeData[1], $request->p_code);
        }

		StatusMessage::create('new_product_create', 'New product Created Successfully');

		return \Redirect()->Route('product_list_view');    	
    }
    public function updateProduct(Request $request){


//        VendorPrice::where('product_id', $request->product_id)->delete();
        $this->addVendorPrice($request, $request->product_id);

        SupplierController::updateProductPrice($request);


    	$roleManage = new RoleManagement();

        $validMessages = [
            'p_code.required' => 'The Product Code field is required.',
            'p_erp_code.required' => 'ERP Code field is required.',
            'p_brand.required' => 'Brand field is required.'
            ];
    	$validator = Validator::make($request->all(), 
            [
			'p_code' => 'required',
			'p_erp_code' => 'required',
            'p_brand' => 'required'
		   ],
           $validMessages
        );

		if ($validator->fails()) {
			return redirect()->back()->withInput($request->input())->withErrors($validator->messages());
		}

		$validationError = $validator->messages();

    	$updateProduct = MxpProduct::find($request->product_id);
    	$updateProduct->product_code = $request->p_code;
    	$updateProduct->product_name = $request->p_name;
        $updateProduct->product_type = $request->product_type;
    	$updateProduct->product_description = $request->p_description;
    	$updateProduct->brand = $request->p_brand;
    	$updateProduct->erp_code = $request->p_erp_code;
        $updateProduct->item_inc_percentage = $request->item_inc_percentage;
    	$updateProduct->unit_price = $request->p_unit_price;
    	$updateProduct->weight_qty = $request->p_weight_qty;
    	$updateProduct->weight_amt = $request->p_weight_amt;
    	// $updateProduct->description_1 = $request->p_description1;
    	// $updateProduct->description_2 = $request->p_description2;
    	// $updateProduct->description_3 = $request->p_description3;
        // $updateProduct->description_4 = $request->p_description4;
        $updateProduct->user_id = Auth::user()->user_id;
        $updateProduct->status = $request->is_active;
    	$updateProduct->others_color = $request->others_color;
        $updateProduct->action = self::CREATE_PRODUCT;
    	$updateProduct->save();
        $lastProductID = $updateProduct->product_id;

        MxpProductsColors::where('product_id', $lastProductID)->delete();
        MxpGmtsColor::where('item_code', $request->p_code)->delete();

        if(isset($request->colors)) {
            for ($i = 0; $i < count($request->colors); $i++) {
                $id = explode(',', $request->colors[$i])[0];
                $color_name = explode(',', $request->colors[$i])[1];
                $color = new MxpProductsColors();
                $color->product_id = $lastProductID;
                $color->color_id = $id;
                $color->status = 1;
                $color->save();

                $this->saveColor($color_name, $request->p_code);
            }
        }


        MxpProductsSizes::where('product_id', $lastProductID)->delete();
        MxpProductSize::where('product_code', $request->p_code)->delete();

        if (isset($request->sizes)) {
            for ($i = 0; $i < count($request->sizes); $i++) {

                $id = explode(',', $request->sizes[$i])[0];
                $size_name = explode(',', $request->sizes[$i])[1];

                $size = new MxpProductsSizes();
                $size ->product_id = $lastProductID;
                $size ->size_id = $id;
                $size ->status = 1;
                $size->save();

                $this->saveSize($size_name , $request->p_code);
            }
        }





		StatusMessage::create('update_product_create', $request->p_name .' update Successfully');

		return \Redirect()->Route('product_list_view');
    }

    public function deleteProduct(Request $request) {
		$product = MxpProduct::find($request->product_id);
		$product->delete();
		StatusMessage::create('new_product_delete',$product->product_name .' delete Successfully');
		return redirect()->Route('product_list_view');
	}


    public function saveColor($color, $productCode){
        $insertGmtsColor = new MxpGmtsColor();
        $insertGmtsColor->user_id = Auth::user()->user_id;
       $insertGmtsColor->item_code = $productCode;
        $insertGmtsColor->color_name = $color;
        $insertGmtsColor->action = 'create';
        $insertGmtsColor->status = 1;
        $insertGmtsColor->save();
        return 0;
    }
    public function saveSize($size, $productCode){
        $createSize = new MxpProductSize();
        $createSize->user_id = Auth::user()->user_id;
       $createSize->product_code = $productCode;
        $createSize->product_size = $size;
        $createSize->status = 1;
        $createSize->action = 'create';
        $createSize->save();
        return 0;
    }

    public function addVendorPrice(Request $request, $productId){

        for($i=0; $i<count($request->party_table_id); $i++){

            if(count(VendorPrice::find($request->price_id[$i])) > 0){
                $sPrice = VendorPrice::find($request->price_id[$i]);
            }else{
                $sPrice = new VendorPrice();
            }

            $sPrice->party_table_id = $request->party_table_id[$i];
            $sPrice->product_id = $productId;
            $sPrice->vendor_com_price = $request->v_com_price[$i];
            $sPrice->save();

        }


        return true;
    }

}
