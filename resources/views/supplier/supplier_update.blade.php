@extends('layouts.dashboard')
{{--@section('page_heading', trans('others.add_party_label'))--}}
@section('page_heading', 'Add Supplier')
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
                    <div class="panel-heading">{{ trans('others.add_party_label') }}</div>
                    <div class="panel-body">

                   
                        <form class="form-horizontal" action="{{ Route('supplier_update_action') }}/{{$supplier->supplier_id}}" role="form" method="POST" >
                            <input type="hidden" name="_token" value="{{ csrf_token() }}">
                            
                            <div class="row">
                                <div style="" class="col-md-12 col-sm-12 ">

                                    <div class="form-group">
                                        <label class="col-md-4 col-sm-4 control-label">Supplier Name</label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="name" value="{{ $supplier->name }}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 col-sm-4 control-label">Contact</label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="phone" value="{{ $supplier->phone }}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 col-sm-4 control-label">Address</label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="address" value="{{ $supplier->address }}">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                      <label class="col-md-4 col-sm-4 control-label">{{ trans('others.header_status_label') }}</label>
                                      <div class="col-md-6 col-sm-6">
                                          <select class="form-control" id="sel1" name="status">
                                              @if($supplier->status == 1)
                                                <option value="1">Active</option>
                                                  <option value="0">Inactive</option>
                                              @else
                                                <option value="0">Inactive</option>
                                                  <option value="1">Active</option>
                                              @endif
                                          </select>
                                      </div>
                                    </div>
                                </div>
                            </div>




                            <div class="form-group">
                                    <div class="col-sm-6 col-sm-offset-5 col-xs-offset-8">
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
    </script>
@endsection