@extends('maxim.layouts.layouts')
@section('title','Booking Maxim')
@section('print-body')
<?php
	$mn = 1;
	$getBuyerName = '';
	$TotalBookingQty = 0;
	foreach($bookingReport as $details){
		$getBuyerName = $details->buyer_name;
	}
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
						<img src="/upload/58906.png" height="40px" width="150px" style="margin-top:  15px;" />
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
						<img src="/upload/{{$value->logo}}" height="40px" width="150px" style="margin-top:  15px;" />
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
						<li>Requested Delivery Date: {{Carbon\Carbon::parse($details->shipmentDate)->format('d-m-Y')}}</li>
					</ul>
				@if($details->is_type == 'fsc')
					<ul style="border: 1px solid #ddd;padding: 5px; width:90%;float: right;">
						<li>
							<span style="padding-left: 5px; font-weight: bold;">FSC-MIX</span>
						</li>
						<li>
							<span style="padding-left: 5px; font-weight: bold;">License Code: FSC-C121666</span>
						</li>
					</ul>
				@endif
				</div>
			</div>
			@endfor
		@endforeach
	</div>
</div>

<div class="row body-top">
	<div class="col-md-8 col-sm-8 col-xs-7 body-list">
		<ul>
			<li style="font-weight: bold;">Buyer: {{$getBuyerName}}</li>
		</ul>
	</div>
	<div class="col-md-4 col-sm-4 col-xs-5">
	</div>
</div>
<?php $itemcodestatus = ''; ?>
@foreach ($bookingReport as $key => $details)
   	<?php
        $gmtsColor = explode(',', $details->gmtsColor);
        $itemSize = explode(',', $details->itemSize);
        $quantity = explode(',', $details->quantity);
        $idstrcount = (8 - strlen($details->id));
    ?>
	<table class="table table-bordered">
	    <thead>
	        <tr>
	        	<th>Job No.</th>
	        	<th width="15%">ERP Code</th>
	        	<th width="15%">Item / Code No.</th>
	        	<th>Season Code</th>
	        	<th>OOS No.</th>
	        	<th>Style</th>
	        	<th>PO/Cat No.</th>
	        	<th>GMTS Color</th>
	        	<th>Size</th>
	        	<th>Sku</th>
	        	<th>Order Qty</th>
	        	<th>Unit</th>
	        </tr>
	    </thead>
	    <tbody>
	    	<?php $rowspanValue = 0; ?>

		    @foreach($quantity as $key => $qtyValue)

		    	<?php $TotalBookingQty += $qtyValue; $rowspanValue += $rowspanValue +1; ?>

		    	<tr>
			    	<td>{{ str_repeat('0',$idstrcount) }}{{ $details->id }}</td>
			    	<!-- <td width="15%">{{$details->erp_code}}</td> -->
			    	@if($itemcodestatus != $details->item_code)
				    	<td width="15%" rowspan="{{count($quantity)}}">
				    		<div>{{$details->erp_code}}</div>
				    	</td>
			    	@endif

                    @if($itemcodestatus != $details->item_code)
                        <td width="15%" rowspan="{{count($quantity)}}">
                            <div>{{$details->item_code}}</div>
                        </td>
                    @endif


                <!-- <td width="15%">{{$details->item_code}}</td> -->
			    	{{--<td width="15%">{{$details->item_code}}</td>--}}
			    	<td width="15%">{{$details->season_code}}</td>
			    	<td width="15%">{{$details->oos_number}}</td>
			    	<td width="15%">{{$details->style}}</td>
			    	{{--@if($itemcodestatus != $details->item_code)--}}
				    	{{--<td width="15%" rowspan="{{count($quantity)}}">--}}
				    		{{--<div>{{$details->style}}</div>--}}
				    	{{--</td>--}}
			    	{{--@endif--}}

			    	<!-- <td>{{$details->poCatNo}}</td> -->
			    	@if($itemcodestatus != $details->item_code)
				    	<td rowspan="{{count($quantity)}}">
				    		<div>{{$details->poCatNo}}</div>
				    	</td>
			    	@endif
			    	<td>{{$gmtsColor[$key]}}</td>
			    	<td>{{$itemSize[$key]}}</td>
			        <td>{{$details->sku}}</td>
			        <td>{{$qtyValue}}</td>
			        <td>PCS</td> 
			        {{--@if($itemcodestatus != $details->item_code)--}}
				    	{{--<td rowspan="{{count($quantity)}}">--}}
				    		{{--<div>PCS</div>--}}
				    	{{--</td>--}}
			    	{{--@endif--}}
		        </tr>

		        <?php $itemcodestatus = $details->item_code; ?>

		    @endforeach

	    </tbody>
	</table>

	
@endforeach
<table class="table table-bordered">
	<tr>
		<td>
			<span class="pull-right" style="font-weight: bold; font-size:18px;">Booking Total Qty: {{$TotalBookingQty}}
			</span>
		</td>
		<td style="width: 4%;"></td>
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
