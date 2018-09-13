<?php $__env->startSection('page_heading', trans("others.update_gmts_color_label") ); ?>
<?php $__env->startSection('section'); ?>

<?php $__env->startSection('section'); ?>
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

		<div class="row">
			<div class="col-md-10 col-md-offset-1">
				<div class="panel panel-default">
					<div class="panel-heading"><?php echo e(trans('others.update_color_label')); ?></div>
					<?php $__currentLoopData = $MxpGmtsColor; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $GmtsColor): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
					<div class="panel-body">

						<form class="form-horizontal" role="form" method="POST" action="<?php echo e(Route('update_gmtscolor_action')); ?>/<?php echo e($GmtsColor->id); ?>">
							<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">							

						<div class="col-md-12">
							

							<!-- <div class="form-group col-md-6">
								<label class="col-md-4 control-label"><?php echo e(trans('others.product_code_label')); ?></label>
								<div class="col-md-8">
									<select class="form-control" type="select" name="p_code" >
										<option value="<?php echo e($GmtsColor->item_code); ?>"><?php echo e($GmtsColor->item_code); ?></option>

										<?php $__currentLoopData = $itemCodes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $itemCode): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>		
										<option value="<?php echo e($itemCode->product_code); ?>"><?php echo e($itemCode->product_code); ?></option>
										<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

									</select>
								</div>
							</div>	 -->

							<div class="form-group col-md-6">
								<label class="col-md-4 control-label"><?php echo e(trans('others.gmts_color_label')); ?></label>
								<div class="col-md-8">
									<input type="hidden" class="form-control" name="color_id" value="<?php echo e($GmtsColor->id); ?>">
									<input type="text" class="form-control" name="gmts_color" value="<?php echo e($GmtsColor->color_name); ?>">
								</div>
							</div>
								<div class="col-md-3">
									<div class="select">
										<select class="form-control" type="select" name="isActive" >
											<option value="<?php echo e($GmtsColor->status); ?>">
                                                <?php echo e(($GmtsColor->status == 1) ? "Active" : "Inactive"); ?>

                                            </option>
											<option  value="1" name="isActive" ><?php echo e(trans("others.action_active_label")); ?></option>
											<option value="0" name="isActive" ><?php echo e(trans("others.action_inactive_label")); ?></option>
									    </select>
									</div>
								</div>
							
								<div class="col-md-3">
									<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
										<?php echo e(trans('others.update_button')); ?>

									</button>
								</div>
						</div>
						
	

						</form>
					</div>
					<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
				</div>
			</div>
		</div>
	</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>