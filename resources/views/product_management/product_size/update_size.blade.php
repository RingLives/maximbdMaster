@extends('layouts.dashboard')
@section('page_heading', trans("others.add_product_size_label") )
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
					<div class="panel-heading">{{trans('others.add_size_label')}}</div>
					<div class="panel-body">
			            
			            @foreach($sizes as $values)
						<form class="form-horizontal" role="form" method="POST" action="{{ Route('update_size_action') }}\{{$values->proSize_id}}">
							<input type="hidden" name="_token" value="{{ csrf_token() }}">							

						
						<div class="col-md-12">

							<div class="form-group col-md-6">
								<label class="col-md-4 control-label">{{trans('others.product_size_label')}}</label>
								<div class="col-md-8">
									<input type="text" class="form-control" name="p_size" value="{{$values->product_size}}">
								</div>
							</div>

							<div class="col-md-3">
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
						
							<div class="col-md-3">
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

