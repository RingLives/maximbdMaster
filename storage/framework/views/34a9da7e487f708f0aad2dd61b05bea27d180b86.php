<?php $__env->startSection('page_heading', 'Proforma Invoice'); ?>
<?php $__env->startSection('section'); ?>

<?php $__env->startSection('section'); ?>
<?php
	// print_r("<pre>");
	// print_r($bookingDetails);
	// print_r("</pre>");
	$TotalBookingQty =0;
?>
<div class="container-fluid">
	<?php if(Session::has('erro_challan')): ?>
        <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
	<?php endif; ?>
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
				<?php $__currentLoopData = $bookingDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $detailsValue): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
					<?php
						$gmtsColor = explode(',', $detailsValue->gmtsColor);
						$itemSize = explode(',', $detailsValue->itemSize);
						$quantity = explode(',', $detailsValue->quantity);
						$id = explode(',', $detailsValue->abc);

					?>
					<?php $rowspanValue = 0; ?>

					<?php $__currentLoopData = $quantity; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $qtyValue): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
						
						<?php 
							$TotalBookingQty += $qtyValue; 
							$rowspanValue += $rowspanValue +1; 
							$idstrcount = (8 - strlen($id[$key]));

						?>
						<tr>
							<td width="3%"><input type="checkbox" name="" class="form-control" checked></td>
							<td><?php echo e(str_repeat('0',$idstrcount)); ?><?php echo e($id[$key]); ?></td>
							<td><?php echo e($detailsValue->poCatNo); ?></td>
							<td><?php echo e($detailsValue->oos_number); ?></td>
							<?php if($itemcodestatus != $detailsValue->item_code): ?>
						    	<td rowspan="<?php echo e(count($quantity)); ?>">
						    		<div><?php echo e($detailsValue->item_code); ?></div>
						    	</td>
					    	<?php endif; ?>

					    	<?php if($itemcodestatus != $detailsValue->item_code): ?>
						    	<td rowspan="<?php echo e(count($quantity)); ?>">
						    		<div><?php echo e($detailsValue->erp_code); ?></div>
						    	</td>
					    	<?php endif; ?>

							<td><?php echo e($detailsValue->item_description); ?></td>
							<td><?php echo e($gmtsColor[$key]); ?></td>
							<td><?php echo e($itemSize[$key]); ?></td>
							<td><?php echo e($detailsValue->style); ?></td>
							<td><?php echo e($detailsValue->sku); ?></td>
							<td><?php echo e($qtyValue); ?></td>
						</tr>
					<?php $itemcodestatus = $detailsValue->item_code; ?>
					<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
				<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
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
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>