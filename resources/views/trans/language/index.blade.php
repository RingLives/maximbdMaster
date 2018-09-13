@extends('layouts.dashboard')
@section('page_heading', trans("others.language_list_label"))
@section('section')

@section('section')
	<div class="col-md-10 col-md-offset-1">
		<div>
			<a href="{{ Route('create_locale_action') }}"> @include('widgets.button', array('class'=>'success', 'value'=>trans("others.add_locale_button")))</a><br><br>
		</div>
		<div>
			<table class="table table-bordered">
	            <thead>
	                <tr>
						<th>{{trans('others.serial_no_label')}}</th>
						<th>{{trans('others.language_title_label')}}</th>
						<th>{{trans('others.language_code_label')}}</th>
						<th>{{trans('others.status_label')}}</th>
						<th>{{trans('others.action_label')}}</th>
	                </tr>
	            </thead>
	            <tbody>
	            @php ($i = 1) 
		            @foreach($languages as $language)
						<tr>
							<td>{{ $i++ }}</td>
							<td>{{ $language->lan_name }}</td>
							<td>{{ $language->lan_code }}</td>
							<td>{{ ($language->is_active == 1)? trans("others.action_active_label"):trans("others.action_inactive_label") }}</td>
							<td> <a href="{{ Route('update_locale_action') }}/{{ $language->id }}"> @include('widgets.button', array('class'=>'success', 'value'=>trans("others.edit_button"))) </a></td>
						</tr>
					@endforeach
	            </tbody>
	        </table>
		</div>
	</div>
@endsection
