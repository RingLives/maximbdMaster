@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_challan_boxing_list") )
@section('section')

@section('section')
    <div class="container-fluid">
    	@if(Session::has('erro_challan'))
            @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ))
		@endif
		<div class="row">
			<div class="col-md-12 col-md-offset-0">
				<div class="panel panel-default">
					<div class="panel-heading">{{trans('others.mxp_menu_challan_boxing_list')}}</div>
					<div class="panel-body">
							@if(!empty($bookingDetails))							
							<!-- <div class="col-md-12"> -->
								<!-- <span style="font-size:15px;padding-bottom: 15px;">Challan data for edit</span> -->
								<form class="form-horizontal" role="form" method="POST" action="{{ Route('multiple_challan_action_task') }}">
									<input type="hidden" name="_token" value="{{ csrf_token() }}">

									<table class="table table-bordered table-striped" >
										<thead>
											<tr>
												<th>SerialNo</th>
												<th width="">ERP Code</th>
												<th width="">Item Code</th>
												<th width="">Item Size</th>
												<th width="">Challan Quantity</th>
												<th width="">Booking Quantity</th>
												<th width="">Delivery Quantity</th>
												<th width="">Balance Quantity</th>
											</tr>
										</thead>
										<?php
										   $i=1;
										   
										 ?>
										<?php $itemcodestatus = ''; ?>
										@foreach ($bookingDetails as $item)
											<?php
							    				$itemsize = explode(',', $item->itemSize);  				
							    				$qty = explode(',', $item->quantity);
							    				$itemQtyValue = array_combine($itemsize, $qty);

							    			?>
										<tbody>
											@foreach ($itemQtyValue as $size => $Qty)
											<tr>
												<td>
													@if($itemcodestatus != $item->item_code)
														{{$i++}}
													@endif
												</td>
												<td>
													@if($itemcodestatus != $item->item_code)
														{{$item->erp_code}}
													@endif
												</td>
												<td>
													@if($itemcodestatus != $item->item_code)
														{{$item->item_code}}
													@endif
												</td>
												{{-- <td colspan="2" class="colspan-td"> --}}
								    				{{-- <table width="100%" id="sampleTbl"> --}}
								    					
								    					@if(empty($size))
								    					{{-- <tr> --}}
								    						<td width="50%"></td>
											    			<td width="50%" class="aaa">
											    				<input type="hidden" name="allId[]" value="{{$item->id}}">
																<input type="text" class="form-control item_quantity" name="product_qty[]" value="{{$Qty}}">
											    			</td>
		    			    								<?php 
		    				    								$orderItemQuantity = App\Http\Controllers\taskController\TaskController::getOrderQuantity($item->booking_order_id,$item->item_code); 
		    				    								$deliverredQuantity = ($orderItemQuantity - $Qty);
		    			    								?>
		    			    								<td width=""><?php echo $orderItemQuantity; ?></td>
		    			    								<td width=""><?php echo $deliverredQuantity; ?></td>
		    			    								<td width="">{{$Qty}}</td>
											    		{{-- </tr> --}}
								    					@else
								    					{{-- <tr> --}}
								    						<td width="50%">
								    							{{$size}}
								    						</td>
											    			<td width="50%" class="aaa">
								    							<input type="hidden" name="allId[]" value="{{$item->id}}">
								    							<div class="question_div">
																<input type="text" class="form-control item_quantity" name="product_qty[]" value="{{$Qty}}">
											    				</div>
											    			</td>
							    								<?php 
								    								$orderItemQuantity = App\Http\Controllers\taskController\TaskController::getOrderQuantity($item->booking_order_id,$item->item_code,$size); 
								    								$deliverredQuantity = ($orderItemQuantity - $Qty);
							    								?>
							    			    			<td width=""><?php echo $orderItemQuantity; ?></td>
							    			    			<td width=""><?php echo $deliverredQuantity; ?></td>
							    			    			<td width="">{{$Qty}}</td>
								    					{{-- </tr> --}}
								    					@endif
								    					
								    				{{-- </table> --}}
								    			{{-- </td> --}}
											</tr>
											<?php 
												$itemcodestatus = $item->item_code;
											?>
											@endforeach
										</tbody>
										@endforeach
									</table>
								

									<div class="form-group ">
										<div class="col-md-6 col-md-offset-10">
											<button type="submit" class="btn btn-primary" id="rbutton">
												{{trans('others.genarate_bill_button')}}
											</button>
										</div>
									</div>
								</form>
							<!-- </div> -->

							@if(!empty($multipleChallanList))
								<span style="font-size:15px;">Multiple Challan list</span>
								<table class="table table-bordered">
									<thead>
										<th>Serial No</th>
										<th>Invo no</th>
										<th>Challan no</th>
									</thead>
									@php($k = 1)
									@foreach($multipleChallanList as $ChallanList)
										<tr>
											<td>{{$k++}}</td>
											<td>{{$ChallanList->bill_id}}</td>
											<td>{{$ChallanList->challan_id}}</td>	
										</tr>
									@endforeach
								</table>
							@endif
						@endif
					</div>
				</div>
			</div>
		</div>
	</div>
@endsection