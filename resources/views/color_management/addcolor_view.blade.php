@extends('layouts.dashboard')
@section('page_heading', trans("others.add_gmts_color_label") )
@section('section')

@section('section')
	<div class="container-fluid">
		@if ($errors->any())
			<div class="alert alert-danger">
				<ul>
					@foreach ($errors->all() as $error)
						<li>{{ $error }}</li>
					@endforeach
				</ul>
			</div>
		@endif

		<div class="row">
			<div class="col-md-10 col-md-offset-1">
				<div class="panel panel-default">
					<div class="panel-heading">{{trans('others.add_color_label')}}</div>
					<div class="panel-body">

						<form class="form-horizontal" role="form" method="POST" action="{{ Route('add_gmtscolor_action') }}">
							<input type="hidden" name="_token" value="{{ csrf_token() }}">


							<div class="col-md-12">

								{{--<div class="form-group col-md-6">--}}
								{{--<label class="col-md-4 control-label">{{trans('others.product_code_label')}}</label>--}}
								{{--<div class="col-md-8">--}}
								{{--<select class="form-control" type="select" name="p_code" >--}}
								{{--<option value="{{old('p_code')}}">{{old('p_code')}}</option>--}}
								{{--@foreach($itemCodes as $itemCode)--}}

								{{--<option value="{{$itemCode->product_code}}">{{$itemCode->product_code}}</option>--}}
								{{--@endforeach--}}
								{{--</select>--}}
								{{--</div>--}}
								{{--</div>	--}}

								<div class="form-group col-md-6">
									<label class="col-md-4 control-label">{{trans('others.gmts_color_label')}}</label>
									<div class="col-md-8">
										<input type="text" class="form-control" name="gmts_color" value="{{ old('gmts_color')  }}">
									</div>
								</div>
								<div class="form-group col-md-3">
									<div class="select">
										<select class="form-control" type="select" name="isActive" >
											<option  value="1" name="isActive" >{{ trans("others.action_active_label") }}</option>
											<option value="0" name="isActive" >{{ trans("others.action_inactive_label") }}</option>
										</select>
									</div>
								</div>

								<div class="form-group col-md-3">
										<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
											{{trans('others.save_button')}}
										</button>
								</div>
							</div>

						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
@endsection