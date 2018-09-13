@extends('layouts.dashboard')

@section('section')
	<div class=" row">
		<div class="col-md-6 col-md-offset-3">
			@if(Session::has('lan_upload_success'))
		        @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('lan_upload_success') ))
		    @endif
			<div class="alert alert-danger">
				{{ trans('others.mxp_upload_file_rechecking_label')}}<br><br>
				<a href="{{ Route('sure_upload') }}" > @include('widgets.button', array('class'=>'danger', 'value'=> trans('others.upload_button'))) </a>
			</div>
		</div>
	</div>
@endsection
