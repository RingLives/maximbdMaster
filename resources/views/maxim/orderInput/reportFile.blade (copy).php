@extends('maxim.layouts.layouts')
@section('title','Booking Maxim')
@section('print-body')
<?php
	$mn = 1;
	$getBuyerName = '';
	$TotalBookingQty = 0;
	$checkSameItem = [];
	foreach($bookingReport as $details){
		$getBuyerName = $details->buyer_name;
	}
// 
	// print_r("<pre>");
	// print_r($bookingReport);
	// print_r("</pre>");

	
?>
	<center>
		<div class="topPreviews">
			<a href="#" onclick="myFunction()"  class="print" id="print">Print & Preview</a>
		</div>
	</center>
@foreach($companyInfo as $value)
	<div class="row">
		<div class="col-md-2 col-sm-12 col-xs-12">
			@if($value->logo_allignment == "left")
				@if(!empty($value->logo))
					<div class="pull-left">
						<img src="/upload/{{$value->logo}}" height="100px" width="150px" />
					</div>
				@endif
			@endif
		</div>
		<div class="col-md-8 col-sm-12 col-xs-12" style="padding-left: 40px;">
			<h2 align="center">{{ $value->header_title}}</h2>
			<div align="center">
				<p>OFFICE ADDRESS :  {{$value->address1}} {{$value->address2}} {{$value->address3}}</p>
			</div>
		</div>
		<div class="col-md-2 col-sm-12 col-xs-12">
			@if($value->logo_allignment == "right")
				@if(!empty($value->logo))
					<div class="pull-right">
						<img src="/upload/{{$value->logo}}" height="100px" width="150px" />
					</div>
				@endif
			@endif
		</div>
	</div>
@endforeach
<div class="row">
	<div style="background-color: #000;">
		<h3 align="center" style="color:#fff; padding:8px; font-weight: bold;">BOOKING FORM</h3>
	</div>

	<div style="padding-top: 10px;">
		@php ($k =0)
		@foreach ($bookingReport as $details)
			@for ($k;$k <= 0; $k++)
			<div class="col-xs-6 col-md-6" style="padding-left: -40px">
				<!-- <div class="pull-left"> -->
					<span >Booking Date: {{Carbon\Carbon::parse($details->created_at)->format('d-m-Y')}}</span>
				<!-- </div> -->
			</div>
			<div class="col-xs-6 col-md-6">
				<div class="pull-right">
					<ul>
						<li>Booking No: {{$details->booking_order_id}}</li>
						<li>Delivery Date: {{Carbon\Carbon::parse($details->shipmentDate)->format('d-m-Y')}}</li>
					</ul>
				</div>
			</div>
			@endfor
		@endforeach
	</div>
</div>

<div class="row body-top">
	<div class="col-md-8 col-sm-8 col-xs-7 body-list">
		<ul>
			<li style="font-weight: bold;">Buyer : {{$getBuyerName}}</li>
		</ul>
	</div>
	<div class="col-md-4 col-sm-4 col-xs-5">
	</div>
</div>

@foreach ($bookingReport as $key => $details)
   {{-- @if($key != 0) --}}

	<table class="table table-bordered">
	    <thead>
	        <tr>
	        	<th>Job No.</th>
	        	<th>ERP Code</th>
	        	<th>Item / Code No.</th>
	        	<th>PO/Cat No.</th>
	        	<th>GMTS Color</th>
	        	<th>Size</th>
	        	<th>Sku</th>
	        	<th>Order Qty</th>
	        	<th>Unit</th>
	        </tr>
	    </thead>


	    <tbody>
	    	<td>1000000{{$mn++}}</td>
	    	<td>{{$details->erp_code}}</td>
	    	<td>{{$details->item_code}}</td>
	    	<td>{{$details->poCatNo}}</td>
	    	<td>{{$details->gmts_color}}</td>
	    	<td>{{$details->item_size}}</td>
	        <td>{{$details->sku}}</td>
	        <td>{{$details->item_quantity}}</td>
	        <td>PCS</td>
	    </tbody>
	</table>

	<?php
      	$gmtsItemSize = explode(',', $gmtsValue->itemSize);
    ?>
@endforeach
<table class="table table-bordered">
	<tr>
		<td>
			<span class="pull-right" style="font-weight: bold;">Total Qty : {{$TotalBookingQty}}
			</span>
		</td>
	</tr>	
</table>
@foreach ($footerData as $value)
	@if(!empty($value->siginingPerson_2))
		<div class="row">
			<div class="col-md-12 col-xs-12" style="padding-bottom: 20px;">
				<div class="col-md-8 col-xs-8" style="padding: 5px; padding-left: 50px;">
					@if(!empty($value->siginingPersonSeal_2))
						<img src="/upload/{{$value->siginingPersonSeal_2}}" height="100px" width="150px" />
					@endif

					@if(!empty($value->siginingPerson_1))
						<div class="col-md-7 col-xs-7"  style="">
							<div align="center" style="margin:auto;
						    	border: 2px solid black;
						    	padding: 5px;margin-top:30px;">
								{{$value->siginingPerson_1}}
							</div>
						</div>
					@endif
				</div>
				
				<div class="col-md-4 col-xs-4"  style="">
					<div align="center">
						@if(!empty($value->siginingSignature_2))
							<img src="/upload/{{$value->siginingSignature_2}}" height="100px" width="150px" />
						@endif
					</div>

					@if(!empty($value->siginingPerson_2))
						<div align="center" style="margin:auto;
					    	border: 2px solid black;
					    	padding: 5px;margin-top:30px;">
							{{$value->siginingPerson_2}}
						</div>
					@endif
				</div>
			</div>
		</div>
	@endif
@endforeach

	<script type="text/javascript">
		function myFunction() {
			$(".print").addClass("hidden");
		    window.print();
		}
	</script>
@endsection
