
<div class="progress">
  <div class="progress-bar progress-bar-<?php echo e(isset($class) ? $class : 'default'); ?> <?php echo e(isset($striped) ? 'progress-bar-striped' : ''); ?> <?php echo e(isset($animated) ? 'progress-bar-striped active' : ''); ?>" role="progressbar" aria-valuenow="<?php echo e($value); ?>" aria-valuemin="0" aria-valuemax="100" style="width: <?php echo e($value); ?>%;"><?php echo e(isset($badge) ? $value: ''); ?>

   
  </div>
</div>