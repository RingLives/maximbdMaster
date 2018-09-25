<!-- Add Brand Modal -->
<div class="modal fade" id="addBrandModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading">{{trans('others.add_brand_label')}}
                        <button type="button" class="close" data-dismiss="addBrandModal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="panel-body">

                        {{--<form class="form-horizontal" role="form" method="POST" action="{{ Route('create_brand_action') }}">--}}
                        <input type="hidden" name="_token" value="{{ csrf_token() }}">

                        @if ($errors->any())
                        <div class="alert alert-danger">
                            <ul>
                                @foreach ($errors->all() as $error)
                                <li>{{ $error }}</li>
                                @endforeach
                            </ul>
                        </div>
                        @endif

                        <div class="form-group">
                            <label class="col-md-4 control-label">{{trans('others.brand_name_label')}}</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control  input_required" name="brand_name" value="{{ old('brand_name')  }}">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3 col-md-offset-4">
                                <div class="select">
                                    <select class="form-control" type="select" name="isActive" >
                                        <option  value="1" name="isActive" >{{ trans("others.action_active_label") }}</option>
                                        <option value="0" name="isActive" >{{ trans("others.action_inactive_label") }}</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button class="btn btn-primary add-product-brand" style="margin-right: 15px;">
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



<!-- Add Color Modal -->
<div class="modal fade" id="addColorModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading">Add Color
                        <button type="button" class="close" data-dismiss="addColorModal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="panel-body">

                        {{--<form class="form-horizontal" role="form" method="POST" action="{{ Route('create_brand_action') }}">--}}
                        <input type="hidden" name="_token" value="{{ csrf_token() }}">

                        @if ($errors->any())
                            <div class="alert alert-danger">
                                <ul>
                                    @foreach ($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <div class="form-group">
                            <label class="col-md-4 control-label">Color Name</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control  input_required" name="color_name" value="{{ old('color_name')  }}">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3 col-md-offset-4">
                                <div class="select">
                                    <select class="form-control" type="select" name="isActive" >
                                        <option  value="1" name="isActive" >{{ trans("others.action_active_label") }}</option>
                                        <option value="0" name="isActive" >{{ trans("others.action_inactive_label") }}</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button class="btn btn-primary add-color-brand" style="margin-right: 15px;">
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





<!-- Add Size Modal -->
<div class="modal fade" id="addSizeModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading">Add Size
                        <button type="button" class="close" data-dismiss="addSizeModal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="panel-body">

                        {{--<form class="form-horizontal" role="form" method="POST" action="{{ Route('create_brand_action') }}">--}}
                        <input type="hidden" name="_token" value="{{ csrf_token() }}">

                        @if ($errors->any())
                            <div class="alert alert-danger">
                                <ul>
                                    @foreach ($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <div class="form-group">
                            <label class="col-md-4 control-label">Size Name</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control  input_required" name="size_name" value="{{ old('size_name')  }}">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3 col-md-offset-4">
                                <div class="select">
                                    <select class="form-control" type="select" name="isActive" >
                                        <option  value="1" name="isActive" >{{ trans("others.action_active_label") }}</option>
                                        <option value="0" name="isActive" >{{ trans("others.action_inactive_label") }}</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button class="btn btn-primary add-size-brand" style="margin-right: 15px;">
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

<!-- Add Buyer Modal -->
<div class="modal fade" id="addBuyerModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading"> {{--{{trans('others.add_brand_label')}}--}} Add Buyer
                        <button type="button" class="close" data-dismiss="addBuyerModal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="panel-body">

                        {{--<form class="form-horizontal" role="form" method="POST" action="{{ Route('create_brand_action') }}">--}}
                        <input type="hidden" name="_token" value="{{ csrf_token() }}">

                        @if ($errors->any())
                            <div class="alert alert-danger">
                                <ul>
                                    @foreach ($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <div class="form-group">
                            <label class="col-md-4 control-label">{{--{{trans('others.brand_name_label')}}--}}Buyer Name</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control  input_required" name="buyer_name" value="{{ old('buyer_name')  }}">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3 col-md-offset-4">
                                <div class="select">
                                    <select class="form-control" type="select" name="isActive" >
                                        <option  value="1" name="isActive" >{{ trans("others.action_active_label") }}</option>
                                        <option value="0" name="isActive" >{{ trans("others.action_inactive_label") }}</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button class="btn btn-primary add-product-buyer" style="margin-right: 15px;">
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

<!-- Add Description Modal -->
<div class="modal fade" id="addDescriptionModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading"> {{--{{trans('others.add_brand_label')}}--}} Add Description
                        <button type="button" class="close" data-dismiss="addDescriptionModal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="panel-body">

                        {{--<form class="form-horizontal" role="form" method="POST" action="{{ Route('create_brand_action') }}">--}}
                        <input type="hidden" name="_token" value="{{ csrf_token() }}">

                        @if ($errors->any())
                            <div class="alert alert-danger">
                                <ul>
                                    @foreach ($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <div class="form-group">
                            <label class="col-md-4 control-label">{{--{{trans('others.brand_name_label')}}--}}Description</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control  input_required" name="description_name" value="{{ old('description_name')  }}">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3 col-md-offset-4">
                                <div class="select">
                                    <select class="form-control" type="select" name="isActive" >
                                        <option  value="1" name="isActive" >{{ trans("others.action_active_label") }}</option>
                                        <option value="0" name="isActive" >{{ trans("others.action_inactive_label") }}</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button class="btn btn-primary add-product-description" style="margin-right: 15px;">
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





{{--<!-- Add Vendor Company Price-->--}}
{{--<div class="modal fade" id="addVendorComPrice" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">--}}
    {{--<div class="modal-dialog" role="document">--}}
        {{--<div class="modal-content">--}}
            {{--<div class="modal-body">--}}
                {{--<div class="panel panel-default">--}}
                    {{--<div class="panel-heading">Vendor Company Price--}}
                        {{--<button type="button" class="close" data-dismiss="addVendorComPrice" aria-label="Close">--}}
                            {{--<span aria-hidden="true">&times;</span>--}}
                        {{--</button>--}}
                    {{--</div>--}}

                    {{--<div class="panel-body">--}}


                        {{--<form class="form-horizontal vendor-price" role="form" method="POST" action="{{ Route('create_brand_action') }}">--}}



                            {{--@if ($errors->any())--}}
                                {{--<div class="alert alert-danger">--}}
                                    {{--<ul>--}}
                                        {{--@foreach ($errors->all() as $error)--}}
                                            {{--<li>{{ $error }}</li>--}}
                                        {{--@endforeach--}}
                                    {{--</ul>--}}
                                {{--</div>--}}
                            {{--@endif--}}

                            {{--@foreach($vendorCompanyList as $vCom)--}}
                                {{--<input type="hidden" name="party_table_id[]" value="{{ $vCom->id  }}" >--}}

                                {{--<div class="col-md-4">--}}
                                    {{--<label class="control-label">Size Name</label>--}}
                                    {{--<input type="text" class="form-control" value="{{ $vCom->name_buyer  }}" disabled>--}}
                                {{--</div>--}}

                                {{--<div class="col-md-5">--}}
                                    {{--<label class="control-label col-md-12">Size Name</label>--}}
                                    {{--<input type="text" class="form-control" value="{{ $vCom->name  }}" disabled>--}}
                                {{--</div>--}}

                                {{--<div class="col-md-3">--}}
                                    {{--<label class="control-label">Size Name</label>--}}
                                    {{--<input type="text" class="form-control" name="v_com_price[]" value="" placeholder="Enter Price">--}}
                                {{--</div>--}}
                            {{--@endforeach--}}

                                {{--<input type="hidden" name="_token" value="{{ csrf_token() }}">--}}

                            {{--<div class="form-group">--}}
                                {{--<div class="col-md-2 col-md-offset-10">--}}
                                    {{--<button class="btn btn-primary vendor-price-btn" style="margin-right: 15px;">--}}
                                        {{--{{trans('others.save_button')}}--}}
                                    {{--</button>--}}
                                {{--</div>--}}
                            {{--</div>--}}
                        {{--</form>--}}
                    {{--</div>--}}
                {{--</div>--}}
            {{--</div>--}}
        {{--</div>--}}
    {{--</div>--}}
{{--</div>--}}