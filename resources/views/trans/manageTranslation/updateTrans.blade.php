@extends('layouts.dashboard')
@section('page_heading',trans('others.update_translation_label'))
@section('section')

@section('section')
<div class="container-fluid">
	<div class="row">
		<div class="col-md-8 col-md-offset-2">
			<div class="panel panel-default">
				<div class="panel-heading">{{ trans('others.update_translation_label') }}</div>
				<div class="panel-body">

					<form class="form-horizontal" role="form" method="POST" action="{{ Route('update_translation_key_action')}}">
						<input type="hidden" name="_token" value="{{ csrf_token() }}">
						<input type="hidden" name="translation_key_id" value="{{$trans[0]->translation_key_id}}">

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
							<label class="col-md-4 control-label">{{ trans('others.update_translation_key_label') }}</label>
							<div class="col-md-6">
								<input type="text" class="form-control input_required" name="Translation_key" value="{{$trans[0]->translation_key}}">
							</div>
						</div>
						<table class="table table-bordered">
				            <thead>
				                <tr>
									<th>{{ trans('others.language_label') }}</th>
									<th>{{ trans('others.translation_label') }}</th>
				                </tr>
				            </thead>
				            <tbody>
									@foreach($trans as $transes)
									<tr>
										<td> {{ $transes->lan_name }}</td>
										<td>
											<input type="text" class="form-control" name="{{ $transes->lan_name }}"  value="{{ $transes->translation}}">
										</td>
									</tr>
								@endforeach
				            </tbody>
				        </table>

						<div class="form-group">
							<div class="col-md-3 col-md-offset-4">
								<div class="select">
										<select class="form-control" type="select" name="isActive" >
											<option  value="1" name="isActive" {{($trans[0]->is_active == 1)? 'selected' : '' }}>{{ trans('others.action_active_label') }}</option>
											<option value="0" name="isActive" {{($trans[0]->is_active == 0) ? 'selected' : '' }}>{{ trans('others.action_inactive_label') }}</option>
									   </select>
								</div>
							</div>
						</div>
						
						<div class="form-group">
							<div class="col-md-6 col-md-offset-4">
								<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
									{{ trans('others.update_button') }}
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



{{-- trans('others.update_translation_label') --}}
{{-- trans('others.update_translation_key_label') --}}

{{-- trans('others.language_label') --}}
{{-- trans('others.translation_label') --}}
