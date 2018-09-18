@extends('layouts.dashboard')
@section('page_heading','Ipo List' )
@section('section')

<!-- <button class="btn btn-warning" type="button" id="mrf_reset_btn">Reset</button>
<div id="mrf_simple_search_form">
	<div class="form-group custom-search-form col-sm-9 col-sm-offset-2">
		<input type="text" name="mrfIdSearchFld" class="form-control" placeholder="MRF Id search" id="mrf_id_search">
		<button class="btn btn-info" type="button" id="mrf_simple_search">
			Search {{--<i class="fa fa-search"></i>--}}
		</button>
	</div>
	<button class="btn btn-primary " type="button" id="mrf_advanc_search">Advance Search</button>
</div> -->

<div>
	<form id="mrf_advance_search_form"  style="display: none" method="post">
		<input type="hidden" name="_token" value="{{ csrf_token() }}">
		<div class="row">
			<div class="col-sm-3">
				<label class="col-sm-12 label-control">Create date from</label>
				<input type="date" name="from_create_date_search" class="form-control" id="from_create_date_search">
			</div>
			<div class="col-sm-3">
				<label class="col-sm-12 label-control">Create date to</label>
				<input type="date" name="to_create_date_search" class="form-control" id="to_create_date_search">
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
		<div class="row">
			<div class="col-sm-4">
				<label class="col-sm-12 label-control">Booking Id</label>
				<input type="text" name="booking_id_search" class="form-control" placeholder="Booking Id search" id="booking_id_search">
			</div>
			<div class="col-sm-4">
				<label class="col-sm-12 label-control">Mrf Status</label>
				<select class="form-control selections" name="mrf_status" id="mrf_status">
					<option value="Open">Open</option>
					<option value="Waiting_for_Goods">Waiting for Goods</option>
					<option value="Delivered">Delivered</option>
				</select>
			</div>
			<br>
			<div class="col-sm-4">
				<input class="btn btn-info" type="submit" value="Search" name="mrf_advanceSearch_btn" id="mrf_advanceSearch_btn">
			</div>
		</div>
		<button class="btn btn-primary" type="button" id="mrf_simple_search_btn">Simple Search</button>
	</form>
</div>
<br>
<div class="row">
	<div class="col-md-10 col-md-offset-1">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th>Serial No.</th>
					<th>Booking No.</th>
					<th>Ipo No.</th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
			@php($j=1 + $ipoDetails->perPage() * ($ipoDetails->currentPage() - 1))
			@foreach($ipoDetails as $value)
				<tr id="mrf_list_table">
					<td>{{$j++}}</td>
					<td>{{$value->booking_order_id}}</td>
					<td>{{$value->ipo_id}}</td>
					<td>
						<form action="{{ Route('ipo_list_report_view') }}" role="form" target="_blank">
							{{ csrf_field() }}
							<input type="hidden" name="ipoid" value="{{$value->ipo_id}}">
							<input type="hidden" name="bid" value="{{$value->booking_order_id}}">
							<button class="btn btn-success">Report</button>
						</form>
					</td>
				</tr>
			@endforeach
			</tbody>
		</table>
		<div id="">{{$ipoDetails->links()}}</div>
		<div class="pagination-container">
			<nav>
				<ul class="pagination"></ul>
			</nav>
		</div>
	</div>
</div>
@endsection