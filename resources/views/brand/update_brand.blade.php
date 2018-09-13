@extends('layouts.dashboard')
@section('page_heading', trans("others.update_brand_label") )
@section('section')

@section('section')
    <div class="container-fluid">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="panel panel-default">
					<div class="panel-heading">{{trans('others.update_brand_label')}}</div>
					<div class="panel-body">

						@foreach($brand as $values)
			            
						<form class="form-horizontal" role="form" method="POST" action="{{ Route('update_brand_action') }}/{{$values->brand_id}}">
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
									<input type="text" class="form-control  input_required" name="brand_name" value="{{$values->brand_name}}">
								</div>
							</div>							

							<div class="form-group">
								<div class="col-md-3 col-md-offset-4">
									<div class="select">
										<select class="form-control" type="select" name="isActive" >
											<option value="{{$values->status}}">
                                                {{($values->status == 1) ? "Active" : "Inactive"}}
                                            </option>
											<option  value="1" name="isActive" >{{ trans("others.action_active_label") }}</option>
											<option value="0" name="isActive" >{{ trans("others.action_inactive_label") }}</option>
									    </select>
									</div>
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

