@extends('layouts.dashboard')
@section('page_heading',
trans('others.mxp_menu_bill_copy'))
@section('section')
@if ($errors->any())
    <div class="alert alert-danger">
        <ul>
        	<li style="list-style-type: none;">
        		@if(Session::has('error_code'))
                	@include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('error_code') ))
        		@endif
    		</li>
            @foreach ($errors->all() as $error)
               <div style="padding-left: 15px;"><li>{{ $error }}</li></div>
            @endforeach
        </ul>
    </div>
@endif

<div class="col-md-8 col-md-offset-2">
	<div class="panel panel-default">
		<div class="panel-heading">
		{{trans('others.mxp_menu_bill_copy')}}
		</div>
		<div class="panel-body">
			<form class="" role="form" method="POST" action="{{route('bill_genarate_action')}}"  enctype="multipart/form-data" 
					>
				<input type="hidden" name="_token" value="{{ csrf_token() }}">

				<div class="row">
					<div class="form-group col-md-6">
						<div class="">
							<div class="select">
								<select class="form-control" type="select" name="buyer_name" >
									<option  value="" name="isActive" ></option>
									@foreach($buyer as $value)
									<option value="{{$value->name_buyer}}" name="isActive" >{{$value->name_buyer}}</option>
									@endforeach
							    </select>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<input type="file" name="import_file" class="">
						</div>
					</div>

					</div>
					<div class="col-md-4 col-md-offset-8">
						<div class="form-group">
				            <div class="form-group">
				                <button type="submit" class="btn btn-primary print" style="margin-right: 15px;" id="">
				                    {{ trans('others.genarate_bill_button') }}
				            	</button>
				            </div>
				        </div>
					</div>
				
				
				
			</form>
		</div>
	</div>
</div><!-- 
    <script type="text/javascript">
		$(document).ready(function(){
			$('.print').printPage();
		});
	</script> -->

@endsection