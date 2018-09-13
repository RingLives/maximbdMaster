<?php $__env->startSection('page_heading',trans('others.update_translation_label')); ?>
<?php $__env->startSection('section'); ?>

<?php $__env->startSection('section'); ?>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-8 col-md-offset-2">
			<div class="panel panel-default">
				<div class="panel-heading"><?php echo e(trans('others.update_translation_label')); ?></div>
				<div class="panel-body">

					<form class="form-horizontal" role="form" method="POST" action="<?php echo e(Route('update_translation_key_action')); ?>">
						<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
						<input type="hidden" name="translation_key_id" value="<?php echo e($trans[0]->translation_key_id); ?>">

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
							<label class="col-md-4 control-label"><?php echo e(trans('others.update_translation_key_label')); ?></label>
							<div class="col-md-6">
								<input type="text" class="form-control input_required" name="Translation_key" value="<?php echo e($trans[0]->translation_key); ?>">
							</div>
						</div>
						<table class="table table-bordered">
				            <thead>
				                <tr>
									<th><?php echo e(trans('others.language_label')); ?></th>
									<th><?php echo e(trans('others.translation_label')); ?></th>
				                </tr>
				            </thead>
				            <tbody>
									<?php $__currentLoopData = $trans; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $transes): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
									<tr>
										<td> <?php echo e($transes->lan_name); ?></td>
										<td>
											<input type="text" class="form-control" name="<?php echo e($transes->lan_name); ?>"  value="<?php echo e($transes->translation); ?>">
										</td>
									</tr>
								<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
				            </tbody>
				        </table>

						<div class="form-group">
							<div class="col-md-3 col-md-offset-4">
								<div class="select">
										<select class="form-control" type="select" name="isActive" >
											<option  value="1" name="isActive" <?php echo e(($trans[0]->is_active == 1)? 'selected' : ''); ?>><?php echo e(trans('others.action_active_label')); ?></option>
											<option value="0" name="isActive" <?php echo e(($trans[0]->is_active == 0) ? 'selected' : ''); ?>><?php echo e(trans('others.action_inactive_label')); ?></option>
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
				</div>
			</div>
		</div>
	</div>
</div>
<?php $__env->stopSection(); ?>









<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>