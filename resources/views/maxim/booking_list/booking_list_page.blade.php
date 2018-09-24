@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_booking_list") )
@section('section')
<style type="text/css">
	.b1{
		border-bottom-left-radius: 4px;
		border-top-right-radius: 0px;
	}
	.b2{
		border-bottom-left-radius: 0px;
		border-top-right-radius: 4px;
	}
	.btn-group .btn + .btn,
	 .btn-group .btn + .btn-group,
	  .btn-group .btn-group + .btn,
	   .btn-group .btn-group + .btn-group {
    margin-left: -5px;
}
</style>
	@if(Session::has('empty_booking_data'))
        @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('empty_booking_data') ))
    @endif
    
	<button class="btn btn-warning" type="button" id="booking_reset_btn">Reset</button>
	<div id="booking_simple_search_form">
		<div class="form-group custom-search-form col-sm-9 col-sm-offset-2">
			<input type="text" name="bookIdSearchFld" class="form-control" placeholder="Booking Id search" id="booking_id_search">
			<button class="btn btn-info" type="button" id="booking_simple_search">
				Search{{--<i class="fa fa-search"></i>--}}
			</button>
		</div>
		{{--<div class="col-sm-2">--}}
		{{--<input class="btn btn-primary" type="submit" value="Advanced Search" name="booking_advanc_search" id="booking_advanc_search">--}}
		{{--</div>--}}
		<button class="btn btn-primary " type="button" id="booking_advanc_search">Advance Search</button>
	</div>
	<div>
		<form id="advance_search_form"  style="display: none" method="post">
			<input type="hidden" name="_token" value="{{ csrf_token() }}">
			<div class="col-sm-12">
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Order date from</label>
					<input type="date" name="from_oder_date_search" class="form-control" id="from_oder_date_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Order date to</label>
					<input type="date" name="to_oder_date_search" class="form-control" id="to_oder_date_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Shipment date from</label>
					<input type="date" name="from_shipment_date_search" class="form-control" id="from_shipment_date_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Shipment date to</label>
					<input type="date" name="to_shipment_date_search" class="form-control" id="to_shipment_date_search">
				</div>
			</div>
			<div class="col-sm-12">
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Buyer name</label>
					<input type="text" name="buyer_name_search" class="form-control" placeholder="Buyer name search" id="buyer_name_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Company name</label>
					<input type="text" name="company_name_search" class="form-control" placeholder="Company name search" id="company_name_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Attention</label>
					<input type="text" name="attention_search" class="form-control" placeholder="Attention search" id="attention_search">
				</div>
				<br>
				<div class="col-sm-3">
					<input class="btn btn-info" type="submit" value="Search" name="booking_advanceSearch_btn" id="booking_advanceSearch_btn">
				</div>
			</div>

			{{--<div class="col-sm-2">
				<input type="text" name="searchFld" class="form-control" placeholder="Booking Id search" id="booking_id_search">
			</div>
			<div class="col-sm-2">
				<input type="text" name="searchFld" class="form-control" placeholder="Booking Id search" id="booking_id_search">
			</div>
			<div class="col-sm-2">
				<input type="text" name="searchFld" class="form-control" placeholder="Booking Id search" id="booking_id_search">
			</div>--}}
			<button class="btn btn-primary" type="button" id="booking_simple_search_btn">Simple Search</button>
		</form>
	</div>
	<br>

	<div class="row">
		<div class="col-md-12 col-md-offset-0">
			<table class="table table-bordered">
				<thead>
					<tr>
						<th>Serial no</th>
						<th>Buyer Name</th>
						<th>Company Name</th>
						<th>Attention</th>
						<th>booking No.</th>
						<th width="10%">Order Date</th>
						<th width="10%">Requested Date</th>
						<th>Status</th>
						<th width="">Action</th>
					</tr>
				</thead>
				
				@php($j=1)
				<tbody id="booking_list_tbody">
				@foreach($bookingList as $value)
					<tr id="booking_list_table">
						<td>{{$j++}}</td>
						<td>{{$value->buyer_name}}</td>
						<td>{{$value->Company_name}}</td>
						<td>{{$value->attention_invoice}}</td>
						<td>{{$value->booking_order_id}}</td>
						<td>{{Carbon\Carbon::parse($value->created_at)->format('d-m-Y')}}</td>
						<td>{{Carbon\Carbon::parse($value->shipmentDate)->format('d-m-Y')}}</td>
						<td>{{$value->booking_status}}</td>
						<td width="12%">
							<div class="btn-group">

								<form action="{{ Route('booking_list_action_task') }}" target="_blank">
									<input type="hidden" name="bid" value="{{$value->booking_order_id}}">
									<button class="btn btn-success b1">Report</button>

									<button type="button" class="btn btn-success dropdown-toggle b2" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
									    <span class="caret"></span>
									    <span class="sr-only">Toggle Dropdown</span>
									</button>

									<ul class="dropdown-menu">
									    <li>
									    	<a href="{{ Route('booking_list_details_view', $value->booking_order_id) }}">Views</a>
									    </li>
									    <!-- <li>
									    	<a href="{{ Route('booking_list_create_ipo', $value->booking_order_id) }}">IPO</a>
									    </li>
									    <li>
									    	<a href="{{ Route('booking_list_create_mrf', $value->booking_order_id) }}">MRF</a>
									    </li> -->
										<li>
											<a href="{{ Route('booking_files_download', $value->id) }}" class="btn btn-info">Download Files</a>
										</li>
									</ul>
							  	</form>
							</div>
						</td>
					</tr>
				@endforeach
				</tbody>
			</table>

			<div id="booking_list_pagination">{{$bookingList->links()}}</div>
			<div class="pagination-container">
				<nav>
					<ul class="pagination"></ul>
				</nav>
			</div>
		</div>
	</div>
@endsection
