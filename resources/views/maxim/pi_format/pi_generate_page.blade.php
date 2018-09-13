@extends('layouts.dashboard')
@section('page_heading', 'Proforma Invoice')
@section('section')
<?php
	// print_r("<pre>");
	// print_r($bookingDetails);
	// print_r("</pre>");
	$TotalBookingQty =0;
?>
<div class="container-fluid">
	@if(Session::has('erro_challan'))
        @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ))
	@endif
	<div class="row">
		<table class="table table-bordered">
			<thead>
				<th>#</th>
				<th>Job No</th>
				<th>PO/Cat No</th>
				<th>Item OOS</th>
				<th>Item Code</th>
				<th>ERP Code</th>
				<th>Item Description</th>
				<th>GMTS / item Color</th>
				<th>Item Size</th>
				<th>Style</th>
				<th>SKU</th>
				<th>Item Qty</th>
			</thead>
			<tbody>
				<?php $itemcodestatus = ''; ?>
				@foreach($bookingDetails as $detailsValue)
					<?php
						$gmtsColor = explode(',', $detailsValue->gmtsColor);
						$itemSize = explode(',', $detailsValue->itemSize);
						$quantity = explode(',', $detailsValue->quantity);
						$id = explode(',', $detailsValue->abc);

					?>
					<?php $rowspanValue = 0; ?>

					@foreach($quantity as $key => $qtyValue)
						
						<?php 
							$TotalBookingQty += $qtyValue; 
							$rowspanValue += $rowspanValue +1; 
							$idstrcount = (8 - strlen($id[$key]));

						?>
						<tr>
							<td width="3%"><input type="checkbox" name="" class="form-control" checked></td>
							<td>{{ str_repeat('0',$idstrcount) }}{{ $id[$key] }}</td>
							<td>{{$detailsValue->poCatNo}}</td>
							<td>{{$detailsValue->oos_number}}</td>
							@if($itemcodestatus != $detailsValue->item_code)
						    	<td rowspan="{{count($quantity)}}">
						    		<div>{{$detailsValue->item_code}}</div>
						    	</td>
					    	@endif

					    	@if($itemcodestatus != $detailsValue->item_code)
						    	<td rowspan="{{count($quantity)}}">
						    		<div>{{$detailsValue->erp_code}}</div>
						    	</td>
					    	@endif

							<td>{{$detailsValue->item_description}}</td>
							<td>{{$gmtsColor[$key]}}</td>
							<td>{{$itemSize[$key]}}</td>
							<td>{{$detailsValue->style}}</td>
							<td>{{$detailsValue->sku}}</td>
							<td>{{$qtyValue}}</td>
						</tr>
					<?php $itemcodestatus = $detailsValue->item_code; ?>
					@endforeach
				@endforeach
			</tbody>
		</table>

		<div class="form-group ">
			<div class="col-md-6 col-md-offset-10">
				<button type="submit" class="btn btn-primary" id="rbutton">
					Generate
				</button>
			</div>
		</div>
	</div>
</div>
@endsection