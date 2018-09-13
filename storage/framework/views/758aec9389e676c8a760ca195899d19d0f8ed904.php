<?php $__env->startSection('page_heading', trans("others.new_mrf_create_label")); ?>
<?php $__env->startSection('section'); ?>
<style type="text/css">
	/*.top-div{
		background-color: #f9f9f9;
		padding:5px 0px 5px 10px;
		border-radius: 7px;
		box-sizing: border-box;
		display: block;
	}
	.showMrfList{
		background-color: #f9f9f9;
		border-radius: 10px;
		box-sizing: border-box;
		box-shadow: 0 10px 20px rgba(0,0,0,0.10), 0 6px 6px rgba(0,0,0,0.15);
		z-index: 999;
	}
	.top-div .mrfControl{
		text-align: left;
		width:30%;
		display: inline-block;
	}
	.top-div .mrfControl .all{
		display: inline;
		float: left;
		width: 10%;
	}

	@media (max-width: 300px) {
		.top-div .mrfControl{
		text-align: left;
		width:40%;
		display: inline-block;
	}
	.top-div .mrfControl .all{
		display: inline;
		float: left;
		width: 25%;
	}
	}*/
</style>

    <div class="container-fluid">
    	<?php if($errors->any()): ?>
            <div class="alert alert-danger">
                <ul>
                    <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <li><?php echo e($error); ?></li>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </ul>
            </div>
        <?php endif; ?>


    	<?php if(Session::has('erro_challan')): ?>
            <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
		<?php endif; ?>
		<div class="row">
			<div class="col-md-12 col-md-offset-0">
				<?php if(!empty($MrfDetails)): ?>
					<div class="panel showMrfList">
						<div class="panel-heading">MRP list</div>
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
									<?php ($i=1); ?>
									<?php $__currentLoopData = $MrfDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $details): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
									<tr>
										<td><?php echo e($i++); ?></td>
										<td><?php echo e($details->booking_order_id); ?></td>
										<td><?php echo e($details->mrf_id); ?></td>
										<td>
											<form action="<?php echo e(Route('mrf_list_action_task')); ?>" role="form" target="_blank">
												<input type="hidden" name="mid" value="<?php echo e($details->mrf_id); ?>">
												<input type="hidden" name="bid" value="<?php echo e($details->booking_order_id); ?>">
												<button class="btn btn-success" >View</button>
											</form>
										</td>
									</tr>
									<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
								</tbody>
							</table>
						</div>
					</div>
				<?php endif; ?>
				<div class="panel panel-default">
					<div class="panel-heading"><?php echo e(trans('others.new_mrf_create_label')); ?></div>
					<div class="panel-body aaa">
							<?php if(!empty($bookingDetails)): ?>
								<form class="form-horizontal" role="form" method="POST" action="<?php echo e(Route('mrf_action_task')); ?>">
									<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
									<input type="hidden" name="booking_order_id" value="<?php echo e($booking_order_id); ?>">

									<div class="col-sm-6">
										<div class="form-group">
											<label class="col-sm-12 label-control">Supplier</label>
											<div class="col-sm-12">
												
												<select class="form-control" name="supplier_id">
													<?php $__currentLoopData = $suppliers; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $supplier): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
														<option value="<?php echo e($supplier->supplier_id); ?>"><?php echo e($supplier->name); ?></option>
													<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
												</select>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="form-group">
											<label class="col-sm-12 label-control">Shipment Date</label>
											<div class="col-sm-12">
												<input class="form-control" type="Date" name="mrf_shipment_date" required>
											</div>
										</div>
									</div>
									<table class="table table-bordered table-striped" >
										<thead>
											<tr>
												<th width="4%">#</th>
												<th width="15%">ERP Code</th>
												<th width="15%">Item Code</th>
												<th width="15%">Color</th>
												<th width="15%">Size</th>
												<th width="15%">Quantity Left</th>
												<th>MRF QTY</th>
											</tr>
										</thead>
										<?php
										   $i=1;
										 ?>
										<?php $__currentLoopData = $bookingDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
											<?php
							    				$itemsize = explode(',', $item->item_size);
                                            	$gmts_color = explode(',', $item->gmts_color);
							    				$qty = explode(',', $item->left_mrf_ipo_quantity);
							    				$mrf_quantity = explode(',', $item->mrf_quantity);

							    				$itemQtyValue = array_combine($itemsize, $qty);
							    			?>
										<tbody>
											<tr>
												<td>
													<?php echo e($i++); ?>

												</td>
												<td><span><?php echo e($item->erp_code); ?></span></td>
												<td><span><?php echo e($item->item_code); ?></span></td>
												<td class="colspan-td" colspan="4">

													<table id="sampleTbl">
														<tbody>

																<?php $__currentLoopData = $qty; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $leftQuantity): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
																	<tr>
																		<td style="width: 25%;"><?php echo e($gmts_color[$key]); ?></td>
																		<td style="width: 25%;"><?php echo e($itemsize[$key]); ?></td>
																		<td style="width: 25%;">
																			<input type="hidden" name="allId[]" value="<?php echo e($item->id); ?>">
																			<input style="" type="text" class="form-control item_quantity" name="product_qty[]" value="<?php echo e($leftQuantity); ?>" >
																		</td>
																		<td style="width: 25%;">
																			<input type="text" class="form-control item_mrf" name="item_mrf[]" value="<?php echo e($mrf_quantity[$key]); ?>" disabled="true">
																		</td>
																	</tr>
																<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
														</tbody>
													</table>
												</td>

											</tr>
										</tbody>
										<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
									</table>
									<div class="form-group ">
										<div class="col-md-6 col-md-offset-10">
											<button type="submit" class="btn btn-primary" id="rbutton">
												<?php echo e(trans('others.create_button_lable')); ?>

											</button>
										</div>
									</div>
								</form>
							<?php if(!empty($multipleChallanList)): ?>
								<span style="font-size:15px;">Multiple Challan list</span>
								<table class="table table-bordered">
									<thead>
										<th>Serial No</th>
										<th>Invo no</th>
										<th>Challan no</th>
									</thead>
									<?php ($k = 1); ?>
									<?php $__currentLoopData = $multipleChallanList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $ChallanList): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
										<tr>
											<td><?php echo e($k++); ?></td>
											<td><?php echo e($ChallanList->bill_id); ?></td>
											<td><?php echo e($ChallanList->challan_id); ?></td>
										</tr>
									<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
								</table>
							<?php endif; ?>
						<?php endif; ?>
					</div>
				</div>
			</div>
		</div>
	</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>