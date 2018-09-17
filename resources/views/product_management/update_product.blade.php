@extends('layouts.dashboard')
@section('page_heading',
trans('others.update_product_label'))
@section('section')
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"rel="stylesheet">

    @extends('product_management.product_modal')

<div class="container-fluid">
        <div class="row">
             <div class="col-md-12 ">   <!--col-md-offset-2 -->
            	@if(count($errors) > 0)
                    <div class="alert alert-danger" role="alert">
                        @foreach($errors->all() as $error)
                          <li><span>{{ $error }}</span></li>
                        @endforeach
                    </div>
                @endif

                <div class="panel panel-default">
                    <div class="panel-heading">{{ trans('others.update_product_label') }}</div>
                    <div class="panel-body">
                        @foreach($product as $data)
                
                        <form class="form-horizontal" action="{{ Route('update_product_action') }}/{{$data->product_id}}" method="POST" autocomplete="off">
                            <input type="hidden" name="_token" value="{{ csrf_token() }}">

                            <div class="row">
                                <div class="col-sm-12 col-md-6">
                                    <div class="form-group">
                                        <label class="col-md-4 control-label">{{ trans('others.product_brand_label') }}</label>
                                        <div class="col-md-6">
                                            <select class="form-control " name="p_brand" required value="">
                                                <option value="{{$data->brand}}">{{$data->brand}}</option>
                                                @foreach($brands as $brand)
                                                    <option value="{{$brand->brand_name}}">{{$brand->brand_name}}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-4 control-label">{{ trans('others.product_code_label') }}</label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control  input_required" name="p_code" value="{{$data->product_code}}">
                                        </div>
                                    </div>


                                    <div class="form-group">
                                        <label class="col-md-4 control-label">{{ trans('others.product_description_label') }}</label>

                                        <div class="col-md-6">
                                            <select class="form-control " name="p_description" required value="">

                                                    @foreach($itemList as $item)

                                                        <option value="{{$item->id}}" {{ ( $item->id == $data->item_description_id) ? 'selected' : '' }}>{{$item->name}}</option>
                                                    @endforeach
                                            </select>

                                            </div>
                                        </div>


{{--Add Color MultiSelect Box--}}
                                    <div class="form-group">
                                        <label class="col-md-4 control-label">Color</label>
                                        <div class="col-md-6">
                                            <div class="product-brand-list" style="width:80%; float: left;">

                                                <select class="select-color-list" name="colors[]" multiple="multiple">
                                                    <option value="">Choose Color</option>
                                                    @foreach($colors as $color)
                                                        <option value="{{$color->id}},{{$color->color_name}}" >{{$color->color_name}}</option>
                                                    @endforeach
                                                </select>

                                            </div>
                                            <div class="add-color-btn" style="width:20%; float: left; padding-top: 5px;">
                                                <a class="hand-cursor"  data-toggle="modal" data-target="#addColorModal">
                                                    <i class="material-icons">
                                                        add_circle_outline
                                                    </i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    {{--End Add Color MultiSelect Box--}}


                                    {{--Add Size MultiSelect Box--}}
                                    <div class="form-group">
                                        <label class="col-md-4 control-label">Size Range</label>
                                        <div class="col-md-6">
                                            <div class="product-size-list" style="width:80%; float: left;">

                                                <select class="select-size-list" name="sizes[]" multiple="multiple">
                                                    <option value="">Choose Size Range</option>
                                                    @foreach($sizes as $size)
                                                        <option value="{{$size->proSize_id}},{{$size->product_size}}">{{$size->product_size}}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                            <div class="add-brand-btn" style="width:20%; float: left; padding-top: 5px;">
                                                <a class="hand-cursor" data-toggle="modal" data-target="#addSizeModal">
                                                    <i class="material-icons">
                                                        add_circle_outline
                                                    </i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    {{--End Add Size MultiSelect Box--}}

                                    {{--Item  Size  Box--}}
                                    <?php 
                                        $valuess = explode('-', $data->item_size_width_height);
                                    ?>
                                    <div class="itemSize">
                                        <label class="col-md-4 control-label">Item Size</label>
                                        
                                            <div class="col-md-3">
                                                <div id="custom-search-input">
                                                    <div class="input-group col-md-3">
                                                        <input type="text" class="form-control input-sm" name="item_size_width" placeholder="width" style="width: 60px !important;" value="{{$valuess[0]}}" />
                                                        <span class="input-group-btn" style=" color: #555;font-size: 18px; padding: 0px 5px; border: 1px solid #ddd; border-left:none ;" >
                                                            mm
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div id="custom-search-input">
                                                    
                                                    <div class="input-group col-md-3">
                                                        <input type="text" class="form-control input-sm" name="item_size_height" placeholder="height" style="width: 60px !important;" value="{{$valuess[1]}}"/>
                                                        <span class="input-group-btn" style="color: #555;font-size: 18px;padding: 0px 5px; border: 1px solid #ddd; border-left:none ;">
                                                            mm
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                    </div>

                                 

                                    <!-- <div class="form-group">
                                        <label class="col-md-4 control-label">{{ trans('others.others_color_label') }}</label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="others_color" value="{{$data->others_color}}">
                                        </div>
                                    </div> -->

                                </div>


                                <div class="col-md-6 col-sm-12">

                                    <div class="form-group">
                                        <label class="col-md-4 control-label">{{ trans('others.product_erp_code_label') }}</label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control  input_required" name="p_erp_code" value="{{$data->erp_code}}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 control-label">{{ trans('others.product_unit_price_label') }}</label>
                                        <div class="col-md-6">
                                            <div style="width:100%; float: left;">
                                                <input type="text" class="form-control " name="p_unit_price" value="{{ $data->unit_price}}">
                                            </div>
                                            <div class="add-vendor-com-price-btn" style=" width:100%; float: left; padding-top: 5px;">
                                                <a style="float:left;" class="hand-cursor" data-toggle="modal" data-target="#addVendorComPrice">
                                                    <i class="material-icons">
                                                        add_circle_outline
                                                    </i>
                                                </a>
                                                <small style="float: left; padding-top: 4px;">
                                                    Vendor Price
                                                </small>


                                                <a style=" padding-left:5px; float: left;" class="hand-cursor" data-toggle="modal" data-target="#addSupplierPrice">
                                                    <i class="material-icons">
                                                        add_circle_outline
                                                    </i>
                                                </a>
                                                <small style="float: left; padding-top: 4px;">
                                                    Vendor Price
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="col-md-4 control-label">{{ trans('others.product_weight_qty_label') }}</label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="p_weight_qty" value="{{$data->weight_qty}}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 control-label">{{ trans('others.product_weight_amt_label') }}</label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="p_weight_amt" value="{{$data->weight_amt}}">
                                        </div>
                                    </div>

                                    {{--<div class="form-group">--}}
                                        {{--<label class="col-md-4 control-label">{{ trans('others.product_type_label') }}</label>--}}
                                        {{--<div class="col-sm-6">--}}
                                            {{--<div class="select">--}}
                                                {{--<select class="form-control" type="select" name="product_type" >--}}
                                                    {{--@if($data->product_type == 'MRF')--}}
                                                        {{--<option  value="MRF" >MRF</option>--}}
                                                        {{--<option value="IPO" >IPO</option>--}}
                                                    {{--@else--}}
                                                        {{--<option value="IPO" >IPO</option>--}}
                                                        {{--<option  value="MRF" >MRF</option>--}}
                                                    {{--@endif--}}

                                                {{--</select>--}}
                                            {{--</div>--}}
                                        {{--</div>--}}
                                    {{--</div>--}}

                                    {{--<div class="form-group">--}}
                                        {{--<label class="col-md-4 control-label">{{ trans('others.product_type_label') }}</label>--}}
                                        {{--<div class="col-sm-6">--}}
                                            {{--<div class="select">--}}
                                                {{--<select class="form-control" type="select" name="product_type" >--}}
                                                    {{--@if($data->product_type == 'MRF')--}}
                                                        {{--<option  value="MRF" >MRF</option>--}}
                                                        {{--<option value="IPO" >IPO</option>--}}
                                                    {{--@else--}}
                                                        {{--<option value="IPO" >IPO</option>--}}
                                                        {{--<option  value="MRF" >MRF</option>--}}
                                                    {{--@endif--}}
                                                {{--</select>--}}
                                            {{--</div>--}}
                                        {{--</div>--}}
                                    {{--</div>--}}

                                    <div class="form-group ipo_increase_percentage" style="display: none;">
                                        <label class="col-md-4 control-label">{{ trans('others.ipo_increase_percentage') }}</label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="item_inc_percentage" value="{{ $data->item_inc_percentage }}">
                                        </div>
                                    </div>



                                    <div class="form-group">
                                        <label class="col-md-4">Product Status</label>
                                        <div class="col-md-6">
                                            <div class="select">
                                                <select class="form-control" type="select" name="is_active" >
                                                    <option value="{{$data->status}}">
                                                        {{($data->status == 1) ? "Active" : "Inactive"}}
                                                    </option>

                                                    <option  value="1" name="is_active" >{{ trans('others.action_active_label') }}</option>
                                                    <option value="0" name="is_active" >{{ trans('others.action_inactive_label') }}</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>



                            <!-- Add Vendor Company Price-->
							<div class="modal fade" id="addVendorComPrice" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
								<div class="modal-dialog" role="document">
									<div class="modal-content">
										<div class="modal-body">
											<div class="panel panel-default">
												<div class="panel-heading">Vendor Company Price
													<button type="button" class="close" data-dismiss="addVendorComPrice" aria-label="Close">
														<span aria-hidden="true">&times;</span>
													</button>
												</div>

												<div class="panel-body">


													{{--<form class="form-horizontal vendor-price" role="form" method="POST" action="{{ Route('create_brand_action') }}">--}}



													@if ($errors->any())
														<div class="alert alert-danger">
															<ul>
																@foreach ($errors->all() as $error)
																	<li>{{ $error }}</li>
																@endforeach
															</ul>
														</div>
													@endif


													@foreach($vendorCompanyListPrice as $vCom)
														<input type="hidden" name="price_id[]" value="{{ $vCom->price_id  }}" >
                                                        <input type="hidden" name="party_table_id[]" value="{{ $vCom->party_table_id  }}" >

														<div class="col-md-4">
															{{--<label class="control-label">Size Name</label>--}}
															<input type="text" class="form-control" value="{{ $vCom->party->name_buyer  }}" disabled>
														</div>

														<div class="col-md-5">
															{{--<label class="control-label col-md-12">Size Name</label>--}}
															<input type="text" class="form-control" value="{{ $vCom->party->name  }}" disabled>
														</div>

														<div class="col-md-3">
															{{--<label class="control-label">Size Name</label>--}}
															<input type="text" class="form-control v_com_price" name="v_com_price[]" value="{{$vCom->vendor_com_price}}" placeholder="Enter Price">
														</div>
													@endforeach

                                                    @foreach($vendorCompanyList as $vCom)
                                                        <input type="hidden" name="party_table_id[]" value="{{ $vCom->id  }}" >

                                                        <div class="col-md-4">
                                                            {{--<label class="control-label">Size Name</label>--}}
                                                            <input type="text" class="form-control" value="{{ $vCom->name_buyer  }}" disabled>
                                                        </div>

                                                        <div class="col-md-5">
                                                            {{--<label class="control-label col-md-12">Size Name</label>--}}
                                                            <input type="text" class="form-control" value="{{ $vCom->name  }}" disabled>
                                                        </div>

                                                        <div class="col-md-3">
                                                            {{--<label class="control-label">Size Name</label>--}}
                                                            <input type="text" class="form-control" name="v_com_price[]" value="" placeholder="Enter Price">
                                                        </div>
                                                    @endforeach

													{{--<input type="hidden" name="_token" value="{{ csrf_token() }}">--}}

														<div class="form-group">
															<div class="col-md-2 col-md-offset-10">
																<button class="btn btn-primary vendor-price-btn" style="margin-right: 15px;">
																	{{trans('others.save_button')}}
																</button>
															</div>
														</div>
													{{--</form>--}}
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>



                            <!-- Add Supplier Price-->
                            <div class="modal fade" id="addSupplierPrice" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="panel panel-default">
                                                <div class="panel-heading">Supplier Price
                                                    <button type="button" class="close" data-dismiss="addSupplierPrice" aria-label="Close">
                                                        <span aria-hidden="true">&times;</span>
                                                    </button>
                                                </div>

                                                <div class="panel-body">

                                                    @if ($errors->any())
                                                        <div class="alert alert-danger">
                                                            <ul>
                                                                @foreach ($errors->all() as $error)
                                                                    <li>{{ $error }}</li>
                                                                @endforeach
                                                            </ul>
                                                        </div>
                                                    @endif

                                                    @foreach($supplierPrices as $supplierPrice)
                                                        <input type="hidden" name="supplie_price_id[]" value="{{ $supplierPrice->supplier_price_id  }}" >
                                                        <input type="hidden" name="supplier_id[]" value="{{ $supplierPrice->supplier_id  }}" >
                                                        <input type="hidden" name="price_id[]" value="{{ $supplierPrice->price_id  }}" >

                                                        <div class="col-md-5 col-md-offset-2">
                                                            <input type="text" class="form-control" value="{{ $supplierPrice->supplier->name  }}" disabled>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <input type="text" class="form-control supplier_price" name="supplier_price[]" value="{{ $supplierPrice->supplier_price}}" placeholder="Enter Price">
                                                        </div>
                                                    @endforeach

                                                    @foreach($supplierList as $supplier)
                                                        <input type="hidden" name="supplier_id[]" value="{{ $supplier->supplier_id  }}" >

                                                        <div class="col-md-5 col-md-offset-2">
                                                            <input type="text" class="form-control" value="{{ $supplier->name  }}" disabled>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <input type="text" class="form-control" name="supplier_price[]" value="" placeholder="Enter Price">
                                                        </div>
                                                    @endforeach

                                                    <div class="form-group">
                                                        <div class="col-md-2 col-md-offset-10">
                                                            <button class="btn btn-primary supplier-price-btn" style="margin-right: 15px;">
                                                                {{trans('others.save_button')}}
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>



                            
                            <div class="form-group">
	                            <div class="col-md-offset-10">
                                    <button type="submit" class="btn btn-primary" style="margin-right: 15px;">
                                        {{ trans('others.update_button') }}
                                	</button>
                                </div>
                            </div>
                        </form>

                        @endforeach
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(".selections").select2();
        // $(".select-color-list").select2();
        // $(".select-size-list").select2();

        var selectedColors = $(".select-color-list").select2();
        var selectedSizes = $(".select-size-list").select2();

       var colors = {!! json_encode($colorsJs) !!};
        var sizes = {!! json_encode($sizesJs) !!};

        selectedColors.val(colors).trigger("change");
        selectedSizes.val(sizes).trigger("change");
    </script>
@endsection