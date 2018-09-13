<?php $__env->startSection('page_heading', trans("others.add_gmts_color_label") ); ?>
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
					<div class="panel-heading"><?php echo e(trans('others.add_color_label')); ?></div>
					<div class="panel-body">

						<form class="form-horizontal" role="form" method="POST" action="<?php echo e(Route('add_gmtscolor_action')); ?>">
							<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">


							<div class="col-md-12">

								
								
								
								
								
								

								
								
								
								
								

								<div class="form-group col-md-6">
									<label class="col-md-4 control-label"><?php echo e(trans('others.gmts_color_label')); ?></label>
									<div class="col-md-8">
										<input type="text" class="form-control" name="gmts_color" value="<?php echo e(old('gmts_color')); ?>">
									</div>
								</div>
								<div class="form-group col-md-3">
									<div class="select">
										<select class="form-control" type="select" name="isActive" >
											<option  value="1" name="isActive" ><?php echo e(trans("others.action_active_label")); ?></option>
											<option value="0" name="isActive" ><?php echo e(trans("others.action_inactive_label")); ?></option>
										</select>
									</div>
								</div>

								<div class="form-group col-md-3">
										<button type="submit" class="btn btn-primary" style="margin-right: 15px;">
											<?php echo e(trans('others.save_button')); ?>

										</button>
								</div>
							</div>

						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>