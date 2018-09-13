@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_order_list") )
@section('section')

@section('section')
	<div class="row">
		<div class="col-md-12 col-md-offset-0">
			<table class="table table-bordered table-striped ">
				<tr>
					<thead>
						<th>Serial no</th>
						<th>Buyer Name</th>
						<th>Company Name</th>
						<th>Attention</th>
						<th>Mobile</th>
						<th>Invo No</th>
						<th>Create Time</th>
					</thead>
				</tr>
				@php($j=1)
				@foreach($orderList as $value)
				<tr>
					<td>{{$j++}}</td>
					<td>{{$value->name_buyer}}</td>
					<td>{{$value->name}}</td>
					<td>{{$value->attention_invoice}}</td>
					<td>{{$value->mobile_invoice}}</td>
					<td>{{$value->bill_id}}</td>
					<td>{{Carbon\Carbon::parse($value->created_at)}}</td>
				</tr>
				@endforeach
			</table>

			{{$orderList->links()}}
		</div>
	</div>
@endsection