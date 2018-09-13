<button type="button" class="btn btn-<?php echo e(isset($class) ? $class : 'default'); ?> <?php echo e(isset($rounded) ? 'btn-rounded' : ''); ?> <?php echo e(isset($bordered) ? 'btn-bordered' : ''); ?> <?php if(isset($size)): ?> btn-<?php echo e($size); ?> <?php endif; ?>  <?php echo e(isset($disabled) ? 'disabled' : ''); ?>"><?php echo e($value); ?></button> 

	 