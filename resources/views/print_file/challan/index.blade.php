@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_challan_boxing_list") )
@section('section')

@section('section')
    <div class="container-fluid">
    	@if(Session::has('erro_challan'))
            @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ))
		@endif
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="panel panel-default">
					<div class="panel-heading">{{trans('others.mxp_menu_challan_boxing_list')}}</div>
					<div class="panel-body">			            
						<form class="form-horizontal" role="form" method="POST" action="{{ Route('challan_boxing_action') }}">
							<input type="hidden" name="_token" value="{{ csrf_token() }}">

							@if(Session::has('vaildate_error_mess'))
					            @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('vaildate_error_mess') ))
							@endif

							<div class="form-group">
								<label class="col-md-4 control-label">{{trans('others.bill_invo_no_label')}}</label>
								<div class="col-md-6">
									<input type="text" class="form-control  input_required" name="challan_invo_no" value="{{ old('challan_invo_no')  }}">
								</div>
							</div>
							
							<div class="form-group ">
								<div class="col-md-6 col-md-offset-7">
									<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
										{{trans('others.search_button')}}
									</button>
								</div>
							</div>
							</form>

							@if(!empty($sentBillId))
							
							<!-- <div class="col-md-12"> -->
								<span style="font-size:15px;">Challan data for edit</span>
								<form class="form-horizontal" role="form" method="POST" action="{{ Route('multiple_challan_action') }}">
									<input type="hidden" name="_token" value="{{ csrf_token() }}">

									<table class="table table-bordered" >
										<thead>
											<tr>
												<th>SerialNo</th>
												<th width="">Itemcode</th>
												<th width="">Size</th>
												<th width="">Quantity</th>
											</tr>
										</thead>
										<?php
										   $i=1;
										 ?>
										@foreach ($sentBillId as $item)
											<?php
							    				$itemsize = explode(',', $item->item_size);  				
							    				$qty = explode(',', $item->quantity);
							    				$itemQtyValue = array_combine($itemsize, $qty);
							    			?>
										<tbody>
											<tr>
												<td>{{$i++}}</td>
												<td>{{$item->item_code}}</td>
												<td colspan="2" class="colspan-td">
								    				<table width="100%" id="sampleTbl">
								    					@foreach ($itemQtyValue as $size => $Qty)
								    					@if(empty($size))
								    					<tr>
								    						<td width="70%"></td>
											    			<td width="30%" class="aaa">
											    				<input type="hidden" name="allId[]" value="{{$item->id}}">
																<input type="text" class="form-control item_quantity" name="product_qty[]" value="{{$Qty}}">
											    			</td>
											    		</tr>
								    					@else
								    					<tr>
								    						<td width="70%">
								    							<input type="text" class="form-control" name="product_size" value="{{$size}}" disabled>
								    						</td>
											    			<td width="30%" class="aaa">
								    							<input type="hidden" name="allId[]" value="{{$item->id}}">
								    							<div class="question_div">
																<input type="text" class="form-control item_quantity" name="product_qty[]" value="{{$Qty}}">
											    				</div>

											    			</td>
								    					</tr>
								    					@endif
								    					@endforeach
								    				</table>
								    			</td>
												
											</tr>
											
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

				<div class="panel panel-default">
					<div class="panel-heading">{{trans('others.mxp_menu_multiple_challan_search')}}
					</div>
					<div class="panel-body">
						<form class="form-horizontal" role="form" method="POST" action="{{ Route('multiple_challan_search') }}">
							<input type="hidden" name="_token" value="{{ csrf_token() }}">

							@if ($errors->any())
							    <div class="alert alert-danger">
							        <ul>
							            @foreach ($errors->all() as $error)
							                <li>{{ $error }}</li>
							            @endforeach
							        </ul>
							    </div>
							@endif

							<div class="form-group">
								<label class="col-md-4 control-label">{{trans('others.bill_invo_no_label')}}</label>
								<div class="col-md-6">
									<input type="text" class="form-control  input_required" name="challan_invo_nos" value="{{ old('challan_invo_no')  }}">
								</div>
							</div>

							<div class="form-group">
								<label class="col-md-4 control-label">{{trans('others.challan_no_label')}}</label>
								<div class="col-md-6">
									<input type="text" class="form-control  input_required" name="challan_id" value="{{ old('challan_invo_no')  }}">
								</div>
							</div>
							
							<div class="form-group ">
								<div class="col-md-6 col-md-offset-7">
									<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
										{{trans('others.search_button')}}
									</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
@endsection