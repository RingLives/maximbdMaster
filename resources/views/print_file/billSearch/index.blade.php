@extends('layouts.dashboard')
@section('page_heading', trans("others.add_searchbill_label") )
@section('section')

@section('section')
    <div class="container-fluid">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="panel panel-default">
					<div class="panel-heading">{{trans('others.add_searchbill_label')}}</div>
					<div class="panel-body">
			            
						<form class="form-horizontal" role="form" method="POST" action="{{ Route('search_bill_action') }}">
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
									<input type="text" class="form-control  input_required" name="bill_invo_no" value="{{ old('bill_invo_no')  }}">
								</div>
							</div>
							
							<div class="form-group ">
								<div class="col-md-6 col-md-offset-7">
									<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
										{{trans('others.search_button')}}
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