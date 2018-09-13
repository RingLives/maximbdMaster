<?php $__env->startSection('section'); ?>
	<div class=" row">
		<div class="col-md-6 col-md-offset-3">
			<?php if(Session::has('lan_upload_success')): ?>
		        <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('lan_upload_success') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
		    <?php endif; ?>
			<div class="alert alert-danger">
				<?php echo e(trans('others.mxp_upload_file_rechecking_label')); ?><br><br>
				<a href="<?php echo e(Route('sure_upload')); ?>" > <?php echo $__env->make('widgets.button', array('class'=>'danger', 'value'=> trans('others.upload_button')), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?> </a>
			</div>
		</div>
	</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>