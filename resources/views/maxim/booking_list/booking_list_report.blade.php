@extends('layouts.dashboard')
@section('page_heading', "Tracking List")
@section('section')
<?php 
	// print_r("<pre>");
	// print_r($bookingList);
	// print_r("</pre>");
?>
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
			<button class="btn btn-info" type="button" id="booking_simple_search_report">
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
					<label class="col-sm-12 label-control">Vendor name</label>
					<input type="text" name="company_name_search" class="form-control" placeholder="Company name search" id="company_name_search">
				</div>
				<!-- <div class="col-sm-3">
					<label class="col-sm-12 label-control">Attention</label>
					<input type="text" name="attention_search" class="form-control" placeholder="Attention search" id="attention_search">
				</div> -->
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
<div class="booking_report_details_view" id="booking_report_details_view">
	

</div>

	<div class="row">
		<div class="col-md-12 col-md-offset-0">
			<div class="table-responsive" style="max-width: 100%;
		max-height: 500px;
		overflow: auto;">
				<table class="table table-bordered" style="min-width: 600px;" >
					<thead>
						<tr>
							<th>Job No.</th>
							<th>Buyer Name</th>
							<th>Vendor Name</th>
							<th>Attention</th>
							<th>Booking No.</th>
							<th>PI No.</th>
							<th width="50%">Order Date</th>
							<th width="10%">Requested Date</th>
							<th>Challan No.</th>
							<th>Item Code</th>
							<th>ERP Code</th>
							<th>Size</th>
							<th>Item Description</th>
							<th>Quantity</th>
							<th>Price/Pcs.</th>
							<th>Value</th>
						</tr>
					</thead>
					<?php
						$fullTotalAmount = 0;
					?>
					@php($j=1)
					@php($ccc=0)
					<tbody id="booking_list_tbody">
					@foreach($bookingList as $value)
						<?php
							$ilc = 1;
							$TotalAmount = 0;
						?>
						@foreach($value->itemLists as $valuelist)
						<?php
						$idstrcount = (8 - strlen($valuelist->id));
						if(count($value->itemLists) == 1){
						?>
						<tr id="booking_list_table">
							<td>{{ str_repeat('0',$idstrcount) }}{{ $valuelist->id }}</td>
							<td>{{$value->buyer_name}}</td>
							<td>{{$value->Company_name}}</td>
							<td>{{$value->attention_invoice}}</td>
							<td>{{$value->booking_order_id}}</td>
							@if($value->pi_ipo_Mrf_challan_list->pi[0]->p_id != '')
							<?php $array_value= []; ?>
								@foreach($value->pi_ipo_Mrf_challan_list->pi as $piValues)
								<?php $array_value[$piValues->job_no] = $piValues->job_no ?>
									@if($piValues->job_no == $valuelist->id)
										<td>{{$piValues->p_id}}</td>
										<?php break; ?>
									@endif
								@endforeach
								@if($valuelist->id == array_search($valuelist->id,$array_value))
								@else
								<td></td>
								@endif
							@else
								<td></td>
							@endif
							<td>
								{{Carbon\Carbon::parse($value->created_at)->format('d-m-Y')}}</td>
							<td>
								{{Carbon\Carbon::parse($value->shipmentDate)->format('d-m-Y')}}
							</td>
							<!-- <td>{{$value->pi_ipo_Mrf_challan_list->challan[$ccc]->challan_id}}</td> 
							-->
							<td></td>
						<?php
						}else if(count($value->itemLists) > 1){
							if($ilc == 1){
								?>
								<tr id="booking_list_table">
									<td>{{ str_repeat('0',$idstrcount) }}{{ $valuelist->id }}</td>
									<td>{{$value->buyer_name}}</td>
									<td>{{$value->Company_name}}</td>
									<td>{{$value->attention_invoice}}</td>
									<td>{{$value->booking_order_id}}</td>
									@if($value->pi_ipo_Mrf_challan_list->pi[0]->p_id !='')
									<?php $array_value= []; ?>
										@foreach($value->pi_ipo_Mrf_challan_list->pi as $piValues)
											<?php $array_value[$piValues->job_no] = $piValues->job_no;?>
											@if($piValues->job_no == $valuelist->id)
												<td>{{$piValues->p_id}}</td>
												<?php break; ?>
											@endif
										@endforeach
										@if($valuelist->id == array_search($valuelist->id,$array_value))
										@else
										<td></td>
										@endif
									@else
									<td></td>
									@endif
									<td>{{Carbon\Carbon::parse($value->created_at)->format('d-m-Y')}}</td>
									<td>
										{{Carbon\Carbon::parse($value->shipmentDate)->format('d-m-Y')}}
									</td>
									<!-- <td>{{$value->pi_ipo_Mrf_challan_list->challan[$ccc]->challan_id}}</td> -->

									<td></td>
								<?php
							}else{
								?>
								</tr>
								<tr id="booking_list_table">

								<?php
							}
						}
						?>

						<?php
						if(count($value->itemLists) == 1){
						?>

						<?php
						}else if(count($value->itemLists) > 1){
							if($ilc == 1){
								?>

								<?php
							}else{
								?>
								<td>{{ str_repeat('0',$idstrcount) }}{{ $valuelist->id }}</td>
								<!-- <td colspan="7"></td> -->
								<td>{{$value->buyer_name}}</td>
								<td>{{$value->Company_name}}</td>
								<td>{{$value->attention_invoice}}</td>
								<td>{{$value->booking_order_id}}</td>
								@if($value->pi_ipo_Mrf_challan_list->pi[0]->p_id !='')
								<?php $array_value= []; ?>
									@foreach($value->pi_ipo_Mrf_challan_list->pi as $piValues)
									<?php $array_value[$piValues->job_no] = $piValues->job_no;?>
										@if($piValues->job_no == $valuelist->id)
											<td>{{$piValues->p_id}}</td>
											<?php break; ?>
										@endif
									@endforeach
									@if($valuelist->id == array_search($valuelist->id,$array_value))
									@else
									<td></td>
									@endif
								@else
								<td></td>
								@endif
								<td>{{Carbon\Carbon::parse($value->created_at)->format('d-m-Y')}}</td>
								<td>
									{{Carbon\Carbon::parse($value->shipmentDate)->format('d-m-Y')}}
								</td>
								<!-- <td>{{$value->pi_ipo_Mrf_challan_list->challan[$ccc]->challan_id}}</td> -->
								<td></td>
								<?php
							}
						}
						?>
								<td>{{$valuelist->item_code}}</td>
								<td>{{$valuelist->erp_code}}</td>
								<td>{{$valuelist->item_size}}</td>
								<td>{{$valuelist->item_description}}</td>
								<td>{{$valuelist->item_quantity}}</td>
								<td>${{$valuelist->item_price}}</td>
								<td>${{ $valuelist->item_quantity*$valuelist->item_price }}</td>
								<?php
									$fullTotalAmount += $valuelist->item_quantity*$valuelist->item_price;
									$TotalAmount += $valuelist->item_quantity*$valuelist->item_price;
								?>
								</tr>
								<?php
								if(count($value->itemLists) == 1){
								?>
								<!-- <tr>
									<td colspan="13"></td>
									<td><strong>Total :</strong></td>
									<td><strong>${{ round($TotalAmount,2) }}</strong></td>
									<td></td>
								</tr> -->
								<?php
								}else if(count($value->itemLists) > 1){
									if($ilc == count($value->itemLists)){
										?>
										<!-- <tr>
											<td colspan="13"></td>
											<td><strong>Total :</strong></td>
											<td><strong>${{ round($TotalAmount,2) }}</strong></td>
											<td></td>
										</tr> -->
										<?php
									}
								}
								?>
							<?php
							$ilc = $ilc+1;
							?>
						@endforeach
							<?php $ccc++; ?>
					@endforeach
						<tr>
							<td colspan="13"></td>
							<td><strong style="font-size: 12px;">All Total :</strong></td>
							<td><strong>${{ round($fullTotalAmount,2) }}</strong></td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div id="booking_list_pagination">{{$bookingList->links()}}</div>
			<div class="pagination-container">
				<nav>
					<ul class="pagination"></ul>
				</nav>
			</div>
		</div>
	</div>
@endsection
