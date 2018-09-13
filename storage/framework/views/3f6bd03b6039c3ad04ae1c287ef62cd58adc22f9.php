<?php $__env->startSection('content'); ?>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-8 col-md-offset-2">
			<div class="panel panel-default" style="margin-top: 80px;">
				<div class="panel-heading"><?php echo e(trans('others.login_label')); ?></div>
				<div class="panel-body">
					<?php if(count($errors) > 0): ?>
						<div class="alert alert-danger">
							<strong><?php echo e(trans('others.validationerror_there_were_some_problems_with_your_input')); ?><br><br>
							<ul>
								<?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
									<li><?php echo e($error); ?></li>
								<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
								<li><?php echo e(trans('others.validationerror_or_you_are_not_active_yet')); ?></li>
							</ul>
						</div>
					<?php endif; ?>

					<form class="form-horizontal" role="form" method="POST" action="<?php echo e(Route('login')); ?>">
						<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

						<div class="form-group">
							<label class="col-md-4 control-label">User Name</label>
							<div class="col-md-6">
								<input type="email" class="form-control" name="email" value="<?php echo e(old('email')); ?>" placeholder="<?php echo e(trans('others.enter_email_address')); ?>">
							</div>
						</div>

						<div class="form-group">
							<label class="col-md-4 control-label"><?php echo e(trans('others.enter_password')); ?></label>
							<div class="col-md-6">
								<input type="password" class="form-control" name="password" placeholder="Enter Password">
							</div>
						</div>

						<div class="form-group">
							<div class="col-md-6 col-md-offset-4">
								<div class="checkbox">
									<label>
										<input type="checkbox" name="remember">
										<?php echo e(trans('others.login_rememberme_label')); ?>

									</label>
								</div>
							</div>
						</div>
						
						<div class="form-group">
							<div class="col-md-6 col-md-offset-4">
								<button type="submit" class="btn btn-primary" style="margin-right: 15px;background-color: #e0007c;
    border-color: #e0007c;">
									<?php echo e(trans('others.login_label')); ?>

								</button>

								<a href=""><?php echo e(trans('others.forgot_your_password')); ?></a>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.app', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>