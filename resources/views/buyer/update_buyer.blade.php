@extends('layouts.dashboard')
@section('page_heading', trans("others.update_buyer_label") )
@section('section')

@section('section')
    <div class="container-fluid">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="panel panel-default">
					<div class="panel-heading">{{trans('others.update_buyer_label')}}</div>
					<div class="panel-body">

						@foreach($buyer as $values)
			            
						<form class="form-horizontal" role="form" method="POST" action="{{ Route('update_buyer_action') }}/{{$values->id_mxp_buyer}}">
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
								<label class="col-md-4 control-label">{{trans('others.buyer_name_label')}}</label>
								<div class="col-md-6">
									<input type="text" class="form-control  input_required" name="buyer_name" value="{{$values->buyer_name}}">
								</div>
							</div>							
							
							<div class="form-group">
								<div class="col-md-6 col-md-offset-4">
									<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
										{{trans('others.update_button')}}
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
@endsection

