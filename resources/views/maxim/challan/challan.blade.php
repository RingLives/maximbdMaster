@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_challan_boxing_list") )
@section('section')

@section('section')
<?php
	// print_r("<pre>");
	// print_r($challanHistory);
	// print_r("</pre>");
?>
    <div class="container-fluid">
    	@if(Session::has('erro_challan'))
            @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ))
		@endif
		<div class="row">
			<div class="col-md-12 col-md-offset-0">
				{{--@if(!empty($challanHistory))
					<div class="panel showMrfList">
						<div class="panel-heading">This Booking Challan list</div>
						<div class="panel-body">
							<table class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>#</th>
										<th>Booking Id</th>
										<th>MRF Id</th>
										<th>Action</th>
									</tr>
								</thead>
								<tbody>
									@php($i=1)
									@foreach($challanHistory as $details)
									<tr>
										<td>{{$i++}}</td>
										<td>{{$details->checking_id}}</td>
										<td>{{$details->challan_id}}</td>
										<td>
											<form action="{{Route('challan_report_view') }}" role="form" target="_blank">
												<input type="hidden" name="mid" value="{{$details->id}}">
												<input type="hidden" name="bid" value="{{$details->checking_id}}">
												<button class="btn btn-success" >View</button>
											</form>
										</td>
									</tr>
									@endforeach
								</tbody>
							</table>
						</div>
					</div>
				@endif --}}
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
												<th width="">Item Color</th>
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
{{--										@foreach ($items as $item)--}}
											<?php
							    				$itemsize = explode(',', $item->item_size);
							    				$qty = explode(',', $item->item_quantity);
							    				$colors  =explode(',', $item->gmts_color);
//							    				$itemQtyValue = array_combine($itemsize, $qty);
//                                                $bookingIds = explode(',',$item->booking_order_id);
                                            $bookingIdList = explode(',',$item->booking_order_id);
//                                                $bookingIdList = array_unique($bookingIds);

//                                                print_r("<pre>");
//												print_r($qty);
//                                            	print_r($itemsize);
//                                            print_r($itemsize);
//                                            print_r("<pre>");

                                                $challanIdList = explode('_',$item->booking_challan_id);
//                                                $challanIdList = array_unique($booking_challan_ids);

//                                                var_dump($challanIdList);
							    			?>
										<tbody>
{{--                                            {{ var_dump($bookingIdList) }}--}}
											<?php $it = 0; ?>
											@foreach ($itemsize as $key=>$value/* $size => $Qty*/)
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

								    					@if(empty($value))
								    					{{-- <tr> --}}
								    						<td {{--width="50%"--}}></td>
															<td {{--width="50%"--}}>
																{{$colors[$key]}}
															</td>
											    			<td width="50%" class="aaa">
											    				<input type="hidden" name="allId[]" value="{{ $challanIdList[$it] }}">
																<input type="text" class="form-control item_quantity" name="product_qty[]" meta:index="{{$qty[$key]}}" value="{{$qty[$key]}}">
																<input type="hidden" name="itemDetails[]" value="{{ $item->erp_code.'~'.$item->item_code.'~'.$value.'~'.$colors[$key] }}">
											    			</td>
		    			    								<?php
                                                                $orderItemQuantity = 0;
                                                                foreach ($bookingIdList as $bookingId){

                                                                    $orderItemQuantity += App\Http\Controllers\taskController\TaskController::getOrderQuantity($bookingId,$item->item_code, null, $colors[$key]);
                                                                }
//                                                                echo $orderItemQuantity;
//		    				    								$orderItemQuantity = App\Http\Controllers\taskController\TaskController::getOrderQuantity($item->booking_order_id,$item->item_code);
		    				    								$deliverredQuantity = ($orderItemQuantity - $qty[$key]);
		    			    								?>
		    			    								<td width=""><?php echo $orderItemQuantity; ?></td>
		    			    								<td width=""><?php echo $deliverredQuantity; ?></td>
		    			    								<td width="">{{$qty[$key]}}</td>
											    		{{-- </tr> --}}
								    					@else
								    					{{-- <tr> --}}
								    						<td{{-- width="50%"--}}>
								    							{{$value}}
								    						</td>
								    						<td{{-- width="50%"--}}>
								    							{{$colors[$key]}}
								    						</td>
											    			<td width="50%" class="aaa">
								    							<input type="hidden" name="allId[]" value="{{ $challanIdList[$it] }}">
								    							<input type="hidden" name="itemDetails[]" value="{{ $item->erp_code.'~'.$item->item_code.'~'.$value.'~'.$colors[$key] }}">
								    							<div class="question_div">
																<input type="text" class="form-control item_quantity" name="product_qty[]" meta:index="{{$qty[$key]}}" value="{{$qty[$key]}}">
											    				</div>
											    			</td>
							    								<?php
                                                                    $orderItemQuantity = 0;
                                                                    foreach ($bookingIdList as $bookingId){

                                                                        $orderItemQuantity += App\Http\Controllers\taskController\TaskController::getOrderQuantity($bookingId,$item->item_code,$value, $colors[$key]);

//                                                                        echo $bookingId." qnty ".$orderItemQuantity." code ".$item->item_code." // ";
                                                                    }
//								    								$orderItemQuantity = App\Http\Controllers\taskController\TaskController::getOrderQuantity($item->booking_order_id,$item->item_code,$value);
								    								$deliverredQuantity = ($orderItemQuantity - $qty[$key]);
							    								?>
							    			    			<td width=""><?php echo $orderItemQuantity; ?></td>
							    			    			<td width=""><?php echo $deliverredQuantity; ?></td>
							    			    			<td width="">{{ $qty[$key] }}</td>
								    					{{-- </tr> --}}
								    					@endif
												<?php $it++; ?>

								    				{{-- </table> --}}
								    			{{-- </td> --}}
											</tr>
											<?php
												$itemcodestatus = $item->item_code;
											?>
											@endforeach
										</tbody>
										@endforeach
										{{--@endforeach--}}
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