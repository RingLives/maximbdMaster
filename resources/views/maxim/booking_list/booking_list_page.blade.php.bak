@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_booking_list") )
@section('section')

@section('section')
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
					Order date from
					<input type="date" name="from_oder_date_search" class="form-control" id="from_oder_date_search">
				</div>
				<div class="col-sm-3">
					Order date to
					<input type="date" name="to_oder_date_search" class="form-control" id="to_oder_date_search">
				</div>
				<div class="col-sm-3">
					Shipment date from
					<input type="date" name="from_shipment_date_search" class="form-control" id="from_shipment_date_search">
				</div>
				<div class="col-sm-3">
					Shipment date to
					<input type="date" name="to_shipment_date_search" class="form-control" id="to_shipment_date_search">
				</div>
			</div>
			<div class="col-sm-12">
				<div class="col-sm-3">
					Buyer name
					<input type="text" name="buyer_name_search" class="form-control" placeholder="Buyer name search" id="buyer_name_search">
				</div>
				<div class="col-sm-3">
					Company name
					<input type="text" name="company_name_search" class="form-control" placeholder="Company name search" id="company_name_search">
				</div>
				<div class="col-sm-3">
					Attention
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
				<tr>
					<thead>
					<th>Serial no</th>
					<th>Buyer Name</th>
					<th>Company Name</th>
					<th>Attention</th>
					<th>booking id</th>
					<th>Order Date</th>
					<th>Shipment Date</th>
					<th>Status</th>
					<th>Action</th>
					</thead>
				</tr>
				@php($j=1)
				<tbody id="booking_list_tbody">
				@foreach($bookingList as $value)
					<tr id="booking_list_table">
						<td>{{$j++}}</td>
						<td>{{$value->buyer_name}}</td>
						<td>{{$value->Company_name}}</td>
						<td>{{$value->attention_invoice}}</td>
						<td>{{$value->booking_order_id}}</td>
						<td>{{Carbon\Carbon::parse($value->created_at)}}</td>
						<td></td>
						<td>{{$value->booking_status}}</td>
						<td>
							<form action="{{ Route('booking_list_action_task') }}" target="_blank">
								<input type="hidden" name="bid" value="{{$value->booking_order_id}}">
								<button class="btn btn-success">View</button>
							</form>
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


