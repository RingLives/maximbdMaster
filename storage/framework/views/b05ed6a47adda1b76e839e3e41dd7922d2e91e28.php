<?php $__env->startSection('page_heading', trans("others.update_brand_label") ); ?>
<?php $__env->startSection('section'); ?>

<?php $__env->startSection('section'); ?>
    <div class="container-fluid">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="panel panel-default">
					<div class="panel-heading"><?php echo e(trans('others.update_brand_label')); ?></div>
					<div class="panel-body">

						<?php $__currentLoopData = $brand; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $values): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
			            
						<form class="form-horizontal" role="form" method="POST" action="<?php echo e(Route('update_brand_action')); ?>/<?php echo e($values->brand_id); ?>">
							<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

							<?php if($errors->any()): ?>
							    <div class="alert alert-danger">
							        <ul>
							            <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
							                <li><?php echo e($error); ?></li>
							            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
							        </ul>
							    </div>
							<?php endif; ?>

							<div class="form-group">
								<label class="col-md-4 control-label"><?php echo e(trans('others.brand_name_label')); ?></label>
								<div class="col-md-6">
									<input type="text" class="form-control  input_required" name="brand_name" value="<?php echo e($values->brand_name); ?>">
								</div>
							</div>							

							<div class="form-group">
								<div class="col-md-3 col-md-offset-4">
									<div class="select">
										<select class="form-control" type="select" name="isActive" >
											<option value="<?php echo e($values->status); ?>">
                                                <?php echo e(($values->status == 1) ? "Active" : "Inactive"); ?>

                                            </option>
											<option  value="1" name="isActive" ><?php echo e(trans("others.action_active_label")); ?></option>
											<option value="0" name="isActive" ><?php echo e(trans("others.action_inactive_label")); ?></option>
									    </select>
									</div>
								</div>
							</div>
							
							<div class="form-group">
								<div class="col-md-6 col-md-offset-4">
									<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
										<?php echo e(trans('others.update_button')); ?>

									</button>
								</div>
							</div>
						</form>
						<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
					</div>
				</div>
			</div>
		</div>
	</div>
<?php $__env->stopSection(); ?>


<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>