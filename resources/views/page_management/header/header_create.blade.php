@extends('layouts.dashboard')
@section('page_heading',
trans('others.add_header_label'))
@section('section')
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
                    <div class="panel-heading">{{ trans('others.add_header_label') }}</div>
                    <div class="panel-body">

                   
                        <form class="form-horizontal" action="{{ Route('page_header_save') }}" enctype="multipart/form-data" role="form" method="POST" >
                            <input type="hidden" name="_token" value="{{ csrf_token() }}">

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="col-md-4 control-label">{{ trans('others.header_type_label') }}</label>
                                    <div class="col-md-6">
                                        <select class="form-control" name="header_type" >
                                            <option value="{{ old('header_type') }}">{{ (11 == old('header_type'))?'Company Info':(12 == old('header_type'))?'Booking':'' }}</option>
                                            <option value="11">Company Info </option>
                                            <option value="12"> Booking </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label">{{ trans('others.header_title_label') }}</label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control  input_required" name="header_title" value="{{ old('header_title') }}">
                                    </div>
                                </div>


                                <div class="form-group">
                                  <label class="col-md-4 control-label">{{ trans('others.header_font_size_label') }}</label>
                                  <div class="col-md-6">
                                      <select class="form-control" id="sel1" name="header_fontsize">
                                        <option value="{{ old('header_fontsize') }}">{{ old('header_fontsize') }}</option>
                                        <option value="x-small">Extra Small</option>
                                        <option value="small">Small</option>
                                        <option value="medium">Medium</option>
                                        <option value="large">Large</option>
                                        <option value="x-large">Extra Large</option>
                                      </select>
                                  </div>
                                </div>

                                <div class="form-group">
                                  <label class="col-md-4 control-label">{{ trans('others.header_font_style_label') }}</label>
                                  <div class="col-md-6">
                                      <select class="form-control" id="sel1" name="header_fontstyle">
                                        <option value="{{ old('header_fontstyle') }}">{{ old('header_fontstyle') }}</option>
                                        <option value="normal">Normal</option>
                                        <option value="italic">Italic</option>
                                        <option value="oblique">Oblique</option>
                                      </select>
                                  </div>
                                </div>

                                <div class="form-group">
                                  <label class="col-md-4 control-label">{{ trans('others.header_colour_label') }}</label>
                                  <div class="col-md-6">
                                      <select class="form-control" id="sel1" name="header_colour">
                                        <option value="{{ old('header_colour') }}">{{ old('header_colour') }}</option>
                                        <option value="black">Black</option>
                                        <option value="blue">Blue</option>
                                        <option value="green">Green</option>
                                      </select>
                                  </div>
                                </div>

                                
                                <div class="form-group">
                                    <label class="control-label col-md-4">{{ trans('others.header_logo_label') }}</label>
                                    <div class="col-md-6">
                                        <input data-preview="#preview" name="logo" type="file" id="imageInput">
                                        <img class="col-sm-6" id="preview"  src="" ></img>
                                    </div>
                                </div>
                                
                            </div>

                            <div class="col-md-6">

                                <div class="form-group">
                                  <label class="col-md-4 control-label">{{ trans('others.logo_allignment_label') }}</label>
                                  <div class="col-md-6">
                                      <select class="form-control" id="sel1" name="logo_allignment">
                                        <option value="{{old('logo_allignment')}}">{{ old('logo_allignment') }}</option>
                                        <!-- <option value="top" >Top</option> -->
                                        <option value="right">Right</option>
                                        <option value="left">Left</option>
                                        <!-- <option value="middle">Middle</option> -->
                                      </select>
                                  </div>
                                </div>
                                

                                <div class="form-group">
                                    <label class="col-md-4 control-label">{{ trans('others.header_address1_label') }}</label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="address1" value="{{ old('address1') }}">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label">{{ trans('others.header_address2_label') }}</label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="address2" value="{{ old('address2') }}">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label">{{ trans('others.header_address3_label') }}</label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="address3" value="{{ old('address3') }}">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label">{{ trans('others.header_cell_number_label') }}</label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="cell_number" value="{{ old('cell_number') }}">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label">{{ trans('others.header_attention_label') }}</label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="attention" value="{{ old('attention') }}">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-4">
                                        
                                    </div>
                                    <div class="col-md-6">
                                        <button type="submit" class="btn btn-primary" style="margin-right: 15px;">
                                            {{ trans('others.save_button') }}
                                        </button>
                                    </div>
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