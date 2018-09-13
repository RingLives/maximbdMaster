@extends('layouts.dashboard')
@section('page_heading',trans('others.translation_list_label'))
@section('section')

@section('section')
	<div >
		<div class="col-md-3">
			<a href="{{ Route('create_translation_action') }}"> @include('widgets.button', array('class'=>'success', 'value'=>trans('others.add_new_key_label')))</a>
		</div>

        <div class="input-group custom-search-form col-md-7 col-md-offset-4">
            <input type="text" class="form-control" placeholder="{{ trans('others.search_the_translation_key_placeholder') }}" name="searchFld" id="searchFld">
            <button class="btn btn-default" type="button">
                <i class="fa fa-search"></i>
            </button>
            <p id="search"></p>
        </span>
        </div>

		<div id="hide_me">
	        <div class="col-md-8 col-md-offset-1">
	        	<nav aria-label="Page navigation example">
					<ul class="pagination">
						@if($currentPage > 1)
							<li class="page-item">
								<a class="page-link" href="{{ Route('manage_translation') }}/{{ $currentPage-1 }}" aria-label="Previous">
								<span aria-hidden="true">&laquo;</span>
								<span class="sr-only">Previous</span>
								</a>
							</li>
				        @endif
				        @for($i = 1; (($i-1)*$limitPerPage)<$totalTrans; $i++)
			        		@if($currentPage == $i)
								<li class="active page-item"><a class="page-link" href="#" onclick='return false'><strong> {{$i}}</strong></a></li>
			        		@else
								<li class="page-item"><a class="page-link" href="{{ Route('manage_translation') }}/{{$i}}"> {{$i}}</a></li>
			        		@endif
			        	@endfor
			        	@if($currentPage*$limitPerPage < $totalTrans)
				        	<li class="page-item">
								<a class="page-link" href="{{ Route('manage_translation') }}/{{ $currentPage+1 }}" aria-label="Next">
								<span aria-hidden="true">&raquo;</span>
								<span class="sr-only">Next</span>
								</a>
							</li>
			        	@endif
					</ul>
				</nav>
	        	
	        </div><br><br>
			<table class="table table-bordered">
	            <thead>
	                <tr>
						<th>{{ trans('others.translation_key_label') }}</th>
						<th>{{ trans('others.language_label') }}</th>
						<th>{{ trans('others.language_label') }}</th>
						<th>{{ trans('others.status_label') }}</th>
						<th>{{ trans('others.action_label') }}</th>
	                </tr>
	            </thead>
	            <tbody>
		            @foreach($translations as $translation)
						@php
							$explode_lan_name = explode(',', $translation['lan_name']);
							$explode_trans_value = explode(',', $translation['trans_value']);
							$total_rowspan = count($explode_trans_value);

							reset($explode_lan_name);
							$first_key = key($explode_lan_name);
						@endphp
						<tr>
							<td rowspan="{{ $total_rowspan}}" style="vertical-align: middle;" > {{ $translation['trans_key'] }}</td>
							<td> {{ $explode_trans_value[0] }} </td>
							<td> {{ $explode_lan_name[0] }} </td>
							<td rowspan="{{ $total_rowspan}}" style="vertical-align: middle;" >{{ ($translation['status'] == 1)? trans('others.action_active_label'):trans('others.action_inactive_label') }}</td>
							<td rowspan="{{ $total_rowspan}}" style="vertical-align: middle;" > <a href="{{ Route('update_translation_action') }}/{{ $translation['key_id'] }}"> @include('widgets.button', array('class'=>'success', 'value'=>trans('others.edit_button'))) </a>
							<a class="delete_id" href="{{ Route('delete_translation_action') }}/{{ $translation['key_id'] }}"> @include('widgets.button', array('class'=>'danger', 'value'=>trans('others.delete_button'))) </a>
							</td>
						</tr>
						@for($i=1 ; $i<$total_rowspan ; $i++)
							<tr>
								<td> {{ $explode_trans_value[$i] }} </td>
								<td> {{ $explode_lan_name[$i] }} </td>
							</tr>
						@endfor
					@endforeach
	            </tbody>
	        </table>
		</div>

		<div id="result">
			
		</div>
	</div>
@endsection


{{--  --}}
{{-- trans('others.add_new_key_label') --}}

{{-- trans('others.Search_the_translation_key_placeholder') --}}
{{-- trans('others.translation_key_label') --}}

{{-- trans('others.translation_label') --}}
{{-- trans('others.language_label') --}}
{{-- trans('others.delete_button') --}}

{{-- trans('others.translation_list_label') --}}
{{-- trans('others.add_new_key_label') --}}

{{-- trans('others.translation_list_label') --}}
{{-- trans('others.add_new_key_label') --}}
