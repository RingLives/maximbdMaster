<?php $__env->startSection('page_heading','Generate IPO'); ?>
<?php $__env->startSection('section'); ?>
<?php $increase = $ipoIncrease;?>

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
<?php if(sizeof($ipoListValue) >= 1): ?>
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
					<?php ($i=1); ?>
					<?php $__currentLoopData = $ipoListValue; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $details): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
					<tr>
						<td><?php echo e($i++); ?></td>
						<td><?php echo e($details->booking_order_id); ?></td>
						<td><?php echo e($details->ipo_id); ?></td>
						<td>
							<form action="<?php echo e(Route('ipo_list_action_task')); ?>" role="form" target="_blank">
								<input type="hidden" name="ipoid" value="<?php echo e($details->ipo_id); ?>">
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

<!-- <form action="<?php echo e(Route('task_action')); ?>" method="POST"> -->
<form action="<?php echo e(Route('task_ipo_action')); ?>" method="POST">
	<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
	<table class="table table-bordered mainBody">
	    <thead>
	    	<tr>
	        	<th width="5%">SI</th>
	        	<th width="10%">PO/CAT</th>
	        	<th width="10%">Item code</th>
	        	<th width="15%">Description</th>
	        	<th width="15%">Color</th>
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
    	 	<?php $__currentLoopData = $sentBillId; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $counts): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
    	 		<?php
					$count = 1;
					$rowspanValue += $count;
				?>
    	 	<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    		<?php $__currentLoopData = $sentBillId; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
				<?php
					$i = 0;
					$k = 0;

					$totalQty = 0;
					$totalIncrQty = 0;
					$itemsize = explode(',', $item->item_size);
					$gmts_color = explode(',', $item->gmts_color);
					$qty = explode(',', $item->left_mrf_ipo_quantity);
					$itemlength = 0;

					foreach ($itemsize as $itemlengths) {
						$itemlength = sizeof($itemlengths);
					}
					$itemQtyValue = array_combine($itemsize, $qty);

				?>
    			<tr>
    				<td><?php echo e($j++); ?></td>
    				<td rowspan="<?php echo e($itemlength); ?>"><?php echo e($item->poCatNo); ?></td>
    				<td rowspan="<?php echo e($itemlength); ?>"><?php echo e($item->item_code); ?></td>
    				<td rowspan="<?php echo e($itemlength); ?>"><?php echo e($item->erp_code); ?></td>
		    			<?php if($itemlength >= 1 ): ?>
			    			<td colspan="4" class="colspan-td">
			    				<table>
			    					<?php $__currentLoopData = $qty; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $leftQuantity): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
			    						<tr>
			    							<td style="width: 25%;"><?php echo e($gmts_color[$key]); ?></td>
			    							<td style="width: 25%;"><?php echo e($itemsize[$key]); ?></td>
			    							<td style="width: 25%;">
			    								<input type="hidden" name="ipo_id[]" value="<?php echo e($item->id); ?>">
			    								<input style="" type="text" class="form-control item_quantity" name="product_qty[]" value="<?php echo e($leftQuantity); ?>" >
			    							</td>
			    							<td style="width: 25%;">
			    								<input type="text" name="ipo_increase_percentage[]" value="<?php echo e($increase); ?>" placeholder="Percentage" class="form-control">
			    							</td>
			    						</tr>
			    					<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
			    				</table>
			    				</div>
			    			</td>
			    		<?php endif; ?>
			    		<?php
							$totalAllQty += $totalQty;
							$totalAllIncrQty += $totalIncrQty;
						?>
					<td></td>
					<td style="padding-top: 20px;">
						<?php echo e(Carbon\Carbon::parse($billdata->created_at)->format('d-m-Y')); ?>

					</td>
					<td></td>
    			</tr>
	    	<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
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
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>