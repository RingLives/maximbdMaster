@extends('layouts.dashboard')
@section('page_heading',trans('others.add_product_label'))
@section('section')
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
		  rel="stylesheet">

@include('product_management.product_modal')

<?php 
	// print_r("<pre>");
	// print_r($brands);
	// print_r("</pre>");
?>

{{-- <div class="col-sm-2">
		<div class="form-group ">
			<a href="{{URL::previews}}" class="btn btn-primary ">
				<i class="fa fa-arrow-left"></i> Back</a>
		</div>
	</div>
<div class="col-sm-10"></div> --}}

<div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
            	@if(count($errors) > 0)
                    <div class="alert alert-danger" role="alert">
                        @foreach($errors->all() as $error)
                          <li><span>{{ $error }}</span></li>
                        @endforeach
                    </div>
                @endif

                <div class="panel panel-default">
                    <div class="panel-heading">{{ trans('others.add_product_label') }}</div>
                    <div class="panel-body">                  
                        <form class="form-horizontal" action="{{ Route('add_product_action') }}" method="POST" autocomplete="off">
                            <input type="hidden" name="_token" value="{{ csrf_token() }}">

                            <div class="row">
                            	<div class="col-sm-12 col-md-6">

									{{--Add Product Brand Select Box--}}

									<div class="form-group">
										<label class="col-md-4 control-label">{{ trans('others.product_brand_label') }}</label>
										<div class="col-md-6">

											<div class="product-brand-list" style="width:80%; float: left;">
												<select class="form-control brand-list" name="p_brand" value="" style="width: 95% !important;">
													<option value="{{old('p_brand')}}">{{(!empty(old('p_brand'))) ? old('p_brand') :"Choose Brand"}}</option>

													@foreach($brands as $brand)
														<option value="{{$brand->brand_name}}">{{$brand->brand_name}}</option>
													@endforeach
												</select>
											</div>

											<div class="add-brand-btn" style="width:20%; float: left; padding-top: 5px;">
												<a class="hand-cursor"  data-toggle="modal" data-target="#addBrandModal">
													<i class="material-icons">
														add_circle_outline
													</i>
												</a>

											</div>
										</div>
									</div>

									{{--End Add Product Brand Select Box--}}

                            		<div class="form-group">
		                                <label class="col-md-4 control-label">{{ trans('others.product_code_label') }}</label>
		                                <div class="col-md-6">
		                                    <input type="text" class="form-control  input_required" name="p_code" value="{{old('p_code')}}" placeholder="Item code">
		                                </div>
		                            </div>

		                            {{--<div class="form-group">--}}
		                                {{--<label class="col-md-4 control-label">{{ trans('others.product_name_label') }}</label>--}}
		                                {{--<div class="col-md-6">--}}
		                                    {{--<input type="text" class="form-control" name="p_name" value="{{old('p_name')}}" placeholder="Item Name">--}}
		                                {{--</div>--}}
		                            {{--</div>--}}



									<div class="form-group">
										<label class="col-md-4 control-label">{{ trans('others.product_description_label') }}</label>

										<div class="col-md-6">
										<!--  <input type="text" class="form-control" name="p_description" value="{{old('p_description')}}" placeholder="Description"> -->
											<select name="p_description" class="form-control" id="p_description">
												<option value="">Item Description</option>
                                                <?php
                                                if (isset($itemList) && !empty($itemList)) {
                                                    foreach ($itemList as $item) {
                                                        print '<option value="' . $item->name . '">' . ucwords($item->name) . '</option>';
                                                    }
                                                }
                                                ?>
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
														<option value="{{$color->id}},{{$color->color_name}}">{{$color->color_name}}</option>
													@endforeach
												</select>

											</div>
											<div class="add-color-btn" style="width:20%; float: left; padding-top: 5px;">
												<a class="hand-cursor" data-toggle="modal" data-target="#addColorModal">
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
										<label class="col-md-4 control-label">Size</label>
										<div class="col-md-6">
											<div class="product-size-list" style="width:80%; float: left;">

												<select class="select-size-list" name="sizes[]" multiple="multiple">
													<option value="">Choose Size</option>
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

		                            <!-- <div class="form-group">
		                                <label class="col-md-4 control-label">{{ trans('others.others_color_label') }}</label>
		                                <div class="col-md-6">
		                                    <input type="text" class="form-control" name="others_color" value="{{old('others_color')}}" placeholder="Others Color">
		                                </div>
		                            </div> -->
		                            
                            	</div>

                            	<div class="col-sm-12 col-md-6">

                            		<div class="form-group">
		                                <label class="col-md-4 control-label">{{ trans('others.product_erp_code_label') }}</label>
		                                <div class="col-md-6">
		                                    <input type="text" class="form-control input_required" name="p_erp_code" value="{{old('p_erp_code')}}" placeholder="ERP code">
		                                </div>
		                            </div>

		                            <div class="form-group">
		                                <label class="col-md-4 control-label">{{ trans('others.product_unit_price_label') }}</label>
		                                <div class="col-md-6">
											<div style="width:100%; float: left;">
		                                    	<input type="text" class="form-control" name="p_unit_price" value="{{old('p_unit_price')}}" placeholder="Unit Price">
											</div>
											<div class="add-vendor-com-price-btn" style="width:100%; float: left; padding-top: 5px;">

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
													Supplier Price
												</small>
											</div>
		                                </div>
		                            </div>

                            		<div class="form-group">
		                                <label class="col-md-4 control-label">{{ trans('others.product_weight_qty_label') }}</label>
		                                <div class="col-md-6">
		                                    <input type="text" class="form-control" name="p_weight_qty" value="{{old('p_weight_qty')}}" placeholder="{{ trans('others.product_weight_qty_label') }}">
		                                </div>
		                            </div>

		                            <div class="form-group">
		                                <label class="col-md-4 control-label">{{ trans('others.product_weight_amt_label') }}</label>
		                                <div class="col-md-6">
		                                    <input type="text" class="form-control" name="p_weight_amt" value="{{old('p_weight_amt')}}" placeholder="Weight AMT">
		                                </div>
		                            </div>

									{{--<div class="form-group">--}}
										{{--<label class="col-md-4 control-label">{{ trans('others.product_type_label') }}</label>--}}
										{{--<div class="col-sm-6">--}}
											{{--<div class="select">--}}
												{{--<select class="form-control" type="select" name="product_type" >--}}
													{{--<option  value="MRF" >MRF</option>--}}
													{{--<option value="IPO" >IPO</option>--}}
												{{--</select>--}}
											{{--</div>--}}
										{{--</div>--}}
									{{--</div>--}}

									<div class="form-group ipo_increase_percentage" style="display: none;">
										<label class="col-md-4 control-label">{{ trans('others.ipo_increase_percentage') }}</label>
										<div class="col-md-6">
											<input type="text" class="form-control" name="item_inc_percentage" value="{{old('item_inc_percentage')}}" placeholder="Increase Percentage">
										</div>
									</div>

		                            <div class="form-group">
		                            	<label class="col-md-4 control-label">{{ trans('others.add_product_status') }}</label>
		                                <div class="col-sm-6">
		                                    <div class="select">
		                                        <select class="form-control" type="select" name="is_active" >
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
													<button type="button" class="close" data-dismiss="addSupplierComPrice" aria-label="Close">
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
	                            <div class="col-sm-offset-10 col-xs-offset-8">
                                    <button type="submit" class="btn btn-primary" style="margin-right: 15px;">
                                        {{ trans('others.save_button') }}
                                	</button>
                                </div>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(".selections").select2();
        $(".select-color-list").select2();
        $(".select-size-list").select2();
    </script>
@endsection