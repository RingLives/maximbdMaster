@extends('maxim.layouts.layouts')
@section('title','IPO Maxim')
@section('print-body')
<center>
	<a href="#" onclick="myFunction()" class="print">Print & Preview</a>
</center>

{{--@foreach($buyerDetails as $details)
	<div class="row header-top-a">
		<div class="col-md-2 col-sm-2">

		</div>
		<div class="col-md-8 col-sm-8 buyerName">
			<h2 align="center">{{$details->buyer_name}}</h2>
		</div>
		<div class="col-md-2 col-sm-2"></div>
	</div>
@endforeach --}}

@foreach($headerValue as $value)
	<div class="row">
		<div class="col-md-2 col-sm-12 col-xs-12">
			@if($value->logo_allignment === "left")
				@if(!empty($value->logo))
					<div class="pull-left">
						<img src="/upload/{{$value->logo}}" height="40px" width="150px" style="margin-top:  15px;" />
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
			@if($value->logo_allignment === "right")
				@if(!empty($value->logo))
					<div class="pull-right">
						<img src="/upload/{{$value->logo}}" height="40px" width="150px" style="margin-top:  15px;" />
					</div>
				@endif
			@endif
		</div>
	</div>
@endforeach

<div class="row header-bottom">
	<div class="col-md-12 col-sm-12 header-bottom-b">
		<span>Internal Purchase Order</span>
	</div>
	<hr>
</div>

<div class="row body-top" style="margin-top: 10px;">
	<div class="col-md-6 col-sm-6 col-xs-7 body-list">
		{{--@foreach($buyerDetails as $details)--}}
			<ul>
				<li><strong>Booking ID: {{$details[0]->booking_order_id}}</strong></li>
				<li><strong>Company Name: {{$details[0]->buyer_name}}</strong></li>
				<li><h5>Date : {{Carbon\Carbon::now()->format('Y-m-d')}}</h5></li>
			</ul>
		{{--@endforeach--}}
	</div>

	<div class="col-md-6 col-sm-6 col-xs-5 valueGenarate">
		<table class="tables table-bordered">
			<tr>
				<td colspan="2">
					<div>
						<p>MAY PORTION</p>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div>
						<p>Ipo No : {{$sentBillId[0]->ipo_id}}</p>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>
<?php 
	foreach ($sentBillId as $key => $item){
		$increaseValue = explode(',', $item->initial_increase);
	}
?>

<table class="table table-bordered mainBody" style="margin-top: 20px;">
    <thead>
    	<tr>
        	<th width="5%">SI</th>
        	<th width="10%">PO/CAT</th>
        	<th width="10%">Item code</th>
        	<th width="15%">Description</th>
        	<th width="15%">Color</th>
        	<th width="10%">Size</th>
        	<th width="10%">TOTAL PCS/MTR</th>
        	<th width="10%">{{$increaseValue[0]}}%</th>
        	<th width="10%">1ST DELIVERY</th>
            <th width="10%">Request Date</th>
            <th width="10%">Confirmation Date</th>
        </tr>
    </thead>
    <tbody>
    	<?php
    		$j = 1;
    		$totalAllQty = 0;
    		$totalAllIncrQty = 0;
    		$totalUsdAmount = 0;
    		$BDTandUSDavarage = 80;
    		$rowspanValue = 0;
    	 ?>
    	 	@foreach($sentBillId as $counts)
    	 		<?php
    	 			$count = 1;
    	 			$rowspanValue += $count;
    	 		 ?>
    	 	@endforeach

    		@foreach ($sentBillId as $key => $item)

    			<?php
    				$i = 0;
    				$k = 0;
    				$totalQty =0;
    				$totalIncrQty = 0;
    				$itemsize = explode(',', $item->item_size);
    				$qty = explode(',', $item->item_quantity);
    				$gmts_color = explode(',', $item->gmts_color);
                    $itemQuaInc = explode(',', $item->initial_increase);

    				$itemlength = 0;
    				foreach ($itemsize as $itemlengths) {
    					$itemlength = sizeof($itemlengths);
    				}
    				$itemQtyValue = array_combine($itemsize, $qty);
    			?>


	    			<tr>
	    				<td>{{$j++}}</td>
	    				<td rowspan="{{$itemlength}}">{{$item->poCatNo}}</td>
	    				<td rowspan="{{$itemlength}}">{{$item->item_code}}</td>
	    				<td rowspan="{{$itemlength}}">{{$item->erp_code}}</td>
			    			@if ($itemlength >= 1 )
				    			<td colspan="3" class="colspan-td">
				    				<table >
				    					
				    					@foreach ($qty as $key => $qtyValue)
				    					<?php
				    						$i++;
				    						$totalQty += $qtyValue;
				    					?>
				    					<tr>
				    						<td width="50%">{{$gmts_color[$key]}}</td>
				    						<td width="50%">{{$itemsize[$key]}}</td>
							    			<td width="50%">{{$qtyValue}}</td>
				    					</tr>
				    					@endforeach

				    					@if( $i > 1 )
				    					<tr>
				    						<td colspan="3">
				    							<span class="pull-right">
					    							{{$totalQty}}
				    							</span>
				    						</td>
				    					</tr>
				    					@endif
				    				</table>
				    			</td>
				    			<td class="colspan-td" width="15%">
				    				<div class="middel-table">
					    				<table>
					    					@foreach ($qty as $size => $Qty)
					    					<?php
					    						$k++;
					    						$totalIncrQty += ceil(($Qty*$itemQuaInc[$k-1])/100 + $Qty);
					    					?>
					    					<tr>
								    			<td style="padding:5px;" width="100%">{{ceil(($Qty*$itemQuaInc[$k-1])/100 + $Qty)}} ({{ $itemQuaInc[$k-1] }}%)
								    			</td>
					    					</tr>
					    					@endforeach

					    					@if( $k > 1 )
					    					<tr>
					    						<td width="100%">{{$totalIncrQty}}</td>
					    					</tr>
					    					@endif
					    				</table>
				    				</div>
				    			</td>
				    		@endif
			    		<?php
    						$totalAllQty += $totalQty;
    						$totalAllIncrQty += $totalIncrQty;
    					?>
    					<td></td>
    					<td style="padding-top: 20px;">
    						{{Carbon\Carbon::parse($billdata->created_at)->format('d-m-Y')}}
    					</td>
    					<td></td>
	    			</tr>
    		@endforeach

    	<tr>
			<td colspan="5">
				<div class="grandTotal" style="">
					<span>GRAND TOTAL</span>
				</div>
			</td>
			<td>{{$totalAllQty}}</td>
			<td>{{$totalAllIncrQty}}</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="11">
				<p><strong>Remarks: TAKE GOODS FROM STOCK WITH {{$increase}}%</strong></p>
			</td>
		</tr>

		<tr>
			<td colspan="11">
				<h6>1. Quality confirm to sample card</h6>
			</td>
		</tr>

		 <tr>
		 	<td colspan="11">
		 		<h6>2. Please pack as the enclosed background and mark the styleNo. on the parcel or carton.</h6>
		 	</td>
		 </tr>

    	<tr>
			<td colspan="4"><strong>PrintShop: </strong></td>
			<td colspan="2"><strong>QC: </strong></td>
			<td colspan="2"><strong>CS Superviser: </strong></td>
			<td colspan="3"><strong>CS: </strong></td>
		</tr>
	</tbody>
</table>

<script type="text/javascript">
	function myFunction() {
		$('.colspan-td table').css('font-family','arial, sans-serif');
		$('.colspan-td table').css('border-collapse','collapse');
		$('.colspan-td table').css('width','100%');
		$('.colspan-td table td').css('border','1px solid #DBDBDB');
		$('.colspan-td table td').css('padding','5px');
		$('.colspan-td table tr:first-child td').css('border-top', '0');
		$('.colspan-td table tr td:first-child').css('border-left', '0');
		$('.colspan-td table tr:last-child td').css('border-bottom', '0');
		$('.colspan-td table tr td:last-child').css('border-right', '0');
	    window.print();
	}
</script>
@endsection
