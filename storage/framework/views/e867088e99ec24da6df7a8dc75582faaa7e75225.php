<?php $__env->startSection('page_heading',
trans('others.mxp_menu_bill_copy')); ?>
<?php $__env->startSection('section'); ?>
<div class="col-md-12">
	<?php if($errors->any()): ?>
	    <div class="alert alert-danger">
	        <ul>
	            <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
	               <li><?php echo e($error); ?></li>
	            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
	        </ul>
	    </div>
	<?php endif; ?>
	<?php if(Session::has('error_code')): ?>
    	<?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('error_code') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
	<?php endif; ?>

		<form class="" action="<?php echo e(Route('input_order_action')); ?>" role="form" method="POST" >
            <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

			<table class="table-striped" id="filed_increment">
				<thead>
					<tr>
						<th width="20%">ERP Code</th>
						<th>Item Code</th>
						<th>Item Size</th>
						<th>Item Qty</th>
						<th>Item price</th>
						<th></th>
					</tr>
				</thead>
				<tbody class="idclone" >
					<tr class="tr_clone">
						<td width="20%">
							<div class="form-group">
								<!-- <input type="text" name="erp[]" class="form-control"> -->

								<select name="erp[]" class="form-control erpNo" style="width: 100%" id="erpNo" disabled = "true">
								</select>
							</div>
						</td>
						<td>
							<div class="form-group abcde">
								<input type="text" name="item_code[]" class="form-control item_code">
							</div>
						</td>
						<td width="20%">
							<div class="form-group">
								<!-- <input type="text" name="item_size[]" class="form-control"> -->

								<select name="item_size[]" class="form-control itemSize" id="itemSize" disabled = "true" >
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="item_qty[]" class="form-control">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="item_price[]" class="form-control item_price">
							</div>
						</td>
						<td></td>
					</tr>
				</tbody>		
			</table>
			<div class="form-group button_add">
				<button type="submit" class="btn btn-success" id="add"><i class="fa fa-plus" style="padding-right: 5px;"></i>Add Filed</button>
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-primary">Submit</button>
			</div>
		</form>

</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>