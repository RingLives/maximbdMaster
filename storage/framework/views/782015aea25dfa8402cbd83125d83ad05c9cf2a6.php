<?php $__env->startSection('page_heading', trans("others.language_list_label")); ?>
<?php $__env->startSection('section'); ?>

<?php $__env->startSection('section'); ?>
	<div class="col-md-10 col-md-offset-1">
		<div>
			<a href="<?php echo e(Route('create_locale_action')); ?>"> <?php echo $__env->make('widgets.button', array('class'=>'success', 'value'=>trans("others.add_locale_button")), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?></a><br><br>
		</div>
		<div>
			<table class="table table-bordered">
	            <thead>
	                <tr>
						<th><?php echo e(trans('others.serial_no_label')); ?></th>
						<th><?php echo e(trans('others.language_title_label')); ?></th>
						<th><?php echo e(trans('others.language_code_label')); ?></th>
						<th><?php echo e(trans('others.status_label')); ?></th>
						<th><?php echo e(trans('others.action_label')); ?></th>
	                </tr>
	            </thead>
	            <tbody>
	            <?php ($i = 1); ?> 
		            <?php $__currentLoopData = $languages; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $language): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
						<tr>
							<td><?php echo e($i++); ?></td>
							<td><?php echo e($language->lan_name); ?></td>
							<td><?php echo e($language->lan_code); ?></td>
							<td><?php echo e(($language->is_active == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")); ?></td>
							<td> <a href="<?php echo e(Route('update_locale_action')); ?>/<?php echo e($language->id); ?>"> <?php echo $__env->make('widgets.button', array('class'=>'success', 'value'=>trans("others.edit_button")), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?> </a></td>
						</tr>
					<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
	            </tbody>
	        </table>
		</div>
	</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>