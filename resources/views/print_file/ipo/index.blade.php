@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_ipo_view") )
@section('section')

@section('section')
    <div class="container-fluid">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="panel panel-default">
					<div class="panel-heading">{{trans('others.mxp_menu_ipo_view')}}</div>
					<div class="panel-body">
			            
						<form class="form-horizontal" role="form" method="POST" action="{{ Route('ipo_bill_action') }}">
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
								<label class="col-md-4 control-label">{{trans('others.bill_invo_no_label')}}</label>
								<div class="col-md-6">
									<input type="text" placeholder="Enter Invoice No" class="form-control  input_required" name="bill_invo_no" value="{{ old('challan_invo_no')  }}">
								</div>
							</div>

							<div class="form-group">
								<label class="col-md-4 control-label">{{trans('others.initial_increase_label')}}</label>
								<div class="col-md-6">
									<input type="text" placeholder="Enter initial % increase" class="form-control" name="initial_increase" value="{{ old('challan_invo_no')  }}">
								</div>
							</div>
							
							<div class="form-group ">
								<div class="col-md-6 col-md-offset-7">
									<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
										{{trans('others.genarate_bill_button')}}
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