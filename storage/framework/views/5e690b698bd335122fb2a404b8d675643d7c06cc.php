<?php $__env->startSection('page_heading','Set Task Access'); ?>
<?php $__env->startSection('section'); ?>

<div class="col-sm-12">
    <div class="row">
        <div class="col-sm-5 col-sm-offset-3">
        
            <?php if(count($errors) > 0): ?>
                <div class="alert alert-danger" role="alert">
                    <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                      <li><span><?php echo e($error); ?></span></li><br>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </div>
            <?php endif; ?>

            <?php if(Session::has('new_taskrole_create')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('new_taskrole_create') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>

            <form role="form" action="<?php echo e(Route('permission_task_assign_action')); ?>" method="post">

                <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>" required>

                <?php $__currentLoopData = $rolesList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $role): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>

					<div class="row">
						<div class="form-group">
							<label for="role_<?php echo e($role->id); ?>">Select Task For <?php echo e($role->name); ?></label>
							<div class="form-group">
							    <select class="form-control selections" name="task_<?php echo e($role->id); ?>[]" multiple="true">
							    	<?php $__currentLoopData = $tasksList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $task): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
							        	<option value="<?php echo e($task->id_mxp_task); ?>" <?php 
                                    if(isset($taskRoleData[$role->id]) && !empty($taskRoleData[$role->id])){
                                        if(in_array($task->id_mxp_task, $taskRoleData[$role->id])){
                                            print 'selected="selected"';
                                        }
                                    }
                                    ?>><?php echo e($task->name); ?></option>
							        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
							    </select>
							</div>
						</div>
					</div>

                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                <div class="form-group">
                    <input class="task_role_btn form-control btn btn-primary btn-outline" type="submit" value="<?php echo e(trans('others.save_button')); ?>" >
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(".selections").select2();
</script>
<style type="text/css">
    .task_role_btn{
        margin-top: 15px;
        margin-bottom: 80px;
    }
    .task_role_btn.btn-primary.btn-outline{
        color:#fff;
    }
</style>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>