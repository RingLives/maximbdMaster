@extends('layouts.dashboard')
@section('page_heading','')
@section('section')
<?php $increase = $ipoIncrease;?>

@if ($errors->any())
    <div class="alert alert-danger">
        <ul>
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif
@if(Session::has('erro_challan'))
    @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ))
@endif
@if(sizeof($ipoListValue) >= 1)
	<div class="panel showMrfList">
		<div class="panel-heading">IPO list</div>
		<div class="panel-body">
			<table class="table table-striped table-bordered">
				<thead>
					<tr>
						<th>#</th>
						<th>Booking Id</th>
						<th>IPO Id</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					@php($i=1)
					@foreach($ipoListValue as $details)
					<tr>
						<td>{{$i++}}</td>
						<td>{{$details->booking_order_id}}</td>
						<td>{{$details->ipo_id}}</td>
						<td>
							<form action="{{Route('ipo_list_action_task') }}" role="form" target="_blank">
								<input type="hidden" name="ipoid" value="{{$details->ipo_id}}">
								<input type="hidden" name="bid" value="{{$details->booking_order_id}}">
								<button class="btn btn-success" >View</button>
							</form>
						</td>
					</tr>
					@endforeach
				</tbody>
			</table>
		</div>
	</div>
@endif

<!-- <form action="{{ Route('task_action') }}" method="POST"> -->
<form action="{{ Route('task_ipo_action') }}" method="POST">
	<input type="hidden" name="_token" value="{{ csrf_token() }}">
	<table class="table table-bordered mainBody">
	    <thead>
	    	<tr>
	        	<th width="5%">SI</th>
	        	<th width="10%">PO/CAT</th>
	        	<th width="10%">Item code</th>
	        	<th width="15%">Description</th>
	        	<th width="10%">Size</th>
	        	<th width="10%">TOTAL PCS/MTR</th>
	        	<th width="10%">Initial Incrise(%)</th>
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
				$ipoIdInc = 0;
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

					$totalQty = 0;
					$totalIncrQty = 0;
					$itemsize = explode(',', $item->item_size);
					$qty = explode(',', $item->left_mrf_ipo_quantity);
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
			    			<td colspan="2" class="colspan-td">
			    				<table >
			    					@foreach ($itemQtyValue as $size => $Qty)
			    					<?php
										$i++;
										$totalQty += $Qty;
									?>
			    					<tr>
			    						<td width="50%">{{$size}}</td>
			    						<input type="hidden" name="product_qty[]" value="{{$Qty}}">
						    			<td width="50%">{{$Qty}}</td>
			    					</tr>
			    					@endforeach

			    					@if( $i > 1 )
			    					<tr>
			    						<td></td>
			    						<td width="100%">{{$totalQty}}</td>
			    					</tr>
			    					@endif
			    				</table>
			    			</td>
			    			<td class="colspan-td">
			    			<div class="middel-table">
			    				<table>
			    					@foreach ($itemQtyValue as $size => $Qty)
										<?php
											$k++;
											$totalIncrQty += ceil(($Qty * $increase) / 100 + $Qty);
										?>

										<tr>
											<!-- <input type="hidden" name="taskType" value="IPO"> -->
											<!-- <input type="hidden" name="ipo_increase" value="YES"> -->
											<input type="hidden" name="ipo_id[]" value="{{$item->id}}" >
											<td width="100%">

												<input type="text" name="ipo_increase_percentage[]" value="{{$increase}}" placeholder="Percentage" class="form-control">

											</td>

										</tr>
			    					@endforeach
									<?php $ipoIdInc = $ipoIdInc + 1;?>

			    					@if( $k > 1 )
			    					<tr>
										{{--<td width="100%">{{$totalIncrQty}}</td>--}}
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
		</tbody>
	</table>
	<div class="form-group">
		<div class="col-md-4"></div>
		<div class="col-md-4">
			<button type="submit" class="btn btn-primary form-control" style="margin-right: 15px;">Save
			</button>
		</div>
		<div class="col-md-5"></div>
	</div>
</form>
@stop
