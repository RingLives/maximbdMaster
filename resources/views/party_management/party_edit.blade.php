@extends('layouts.dashboard')
@section('page_heading',
trans('others.update_party_label'))
@section('section')
<div class="container-fluid">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                @if(count($errors) > 0)
                    <div class="alert alert-danger" role="alert">
                        @foreach($errors->all() as $error)
                          <li><span>{{ $error }}</span></li>
                        @endforeach
                    </div>
                @endif

                <div class="panel panel-default">
                    <div class="panel-heading">{{ trans('others.update_party_label') }}</div>
                    <div class="panel-body">

                        @foreach($party_edits as $party_edit)
                        <form class="form-horizontal" action="{{ Route('party_edit_action') }}/{{$party_edit->id}}" role="form" method="POST" >
                            <input type="hidden" name="_token" value="{{ csrf_token() }}">

                            <div class="row">
                                <div style="" class="col-md-12 col-sm-12 ">
                                    <div class="form-group">
                                        <label class="col-md-5 col-sm-5 control-label">{{ trans('others.party_id_label') }}</label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control" name="party_id" value="{{ $party_edit->party_id }}" readonly="true">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-5 control-label">{{ trans('others.party_name_label') }}</label>
                                        <div class="col-sm-6">
                                            <input type="text" class="form-control  input_required" name="name" value="{{ $party_edit->name }}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-5 control-label">{{ trans('others.sort_name_label') }}</label>
                                        <div class="col-sm-6">
                                            <input type="text" class="form-control  input_required" name="sort_name" value="{{ $party_edit->sort_name }}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-sm-5 control-label">{{ trans('others.name_buyer_label') }}</label>
                                        <div class="col-sm-6">
                                            {{-- <input type="text" class="form-control  input_required" name="name_buyer" value="{{ $party_edit->name_buyer }}"> --}}
                                            <select class ="form-control" name="name_buyer" id="name_buyer">
                                                <option value="">Choose a Option</option>
                                                @foreach($buyers as $buyer)   
                                                    <option @if($buyer->id_mxp_buyer == $party_edit->id_buyer)
                                                          selected="selected" 
                                                    @endif data-id="{{ $buyer->id_mxp_buyer }}" value="{{ $buyer->buyer_name }}">{{ $buyer->buyer_name }}</option>
                                                @endforeach
                                            </select>
                                            <input type="hidden" id="id_buyer" name="id_buyer" value="{{ $party_edit->id_buyer }}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                      <label class="col-md-5 col-sm-5 control-label">{{ trans('others.header_status_label') }}</label>
                                      <div class="col-md-6 col-sm-6">
                                          <select class="form-control" id="sel1" name="status">
                                            <option value="{{$party_edit->status}}">{{ ($party_edit->status == 1) ? "Active" : "Inactive"}} </option>
                                            <option value="1">Active</option>
                                            <option value="0">Inactive</option>
                                          </select>
                                      </div>
                                    </div>
                            </div>
                        </div>

                            <div class="row">
                                <div class="col-md-12 col-sm-12">
                                    <div class="col-md-6 col-sm-12">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                {{trans('others.invoice_label')}}
                                            </div>

                                            <div class="panel-body">

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.address_part_1_invoice_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="address_part_1_invoice" value="{{ $party_edit->address_part1_invoice }}">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.address_part_2_invoice_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="address_part_2_invoice" value="{{ $party_edit->address_part2_invoice }}">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.attention_invoice_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="attention_invoice" value="{{ $party_edit->attention_invoice }}">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.mobile_invoice_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="mobile_invoice" value="{{ $party_edit->mobile_invoice }}">
                                                    </div>
                                                </div>

                                                 <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.telephone_invoice_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="telephone_invoice" value="{{ $party_edit->telephone_invoice }}">
                                                    </div>
                                                </div>

                                                 <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.fax_invoice_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="fax_invoice" value="{{ $party_edit->fax_invoice }}">
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-md-6 col-sm-12">
                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                {{trans('others.delivery_label')}}
                                            </div>

                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.address_part1_delivery_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="address_part_1_delivery" value="{{ $party_edit->address_part1_delivery }}">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.address_part2_delivery_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="address_part_2_delivery" value="{{ $party_edit->address_part2_delivery }}">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.attention_delivery_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="attention_delivery" value="{{ $party_edit->attention_delivery }}">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.mobile_delivery_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="mobile_delivery" value="{{ $party_edit->mobile_delivery }}">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.telephone_delivery_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="telephone_delivery" value="{{ $party_edit->telephone_delivery }}">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 col-sm-5 control-label">{{ trans('others.fax_delivery_label') }}</label>
                                                    <div class="col-md-6 col-sm-6">
                                                        <input type="text" class="form-control" name="fax_delivery" value="{{ $party_edit->fax_delivery }}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="col-sm-6 col-sm-offset-8 col-xs-offset-8">
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
    </script>
@endsection