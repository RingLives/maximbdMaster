<?php $__env->startSection('page_heading',trans('others.mxp_menu_role_list')); ?>
<?php $__env->startSection('section'); ?>
           
<div class="col-sm-12">
    <div class="row">
        <div class="col-sm-12">
            <?php $__env->startSection('cotable_panel_title',trans('others.list_of_responsible_person_label')); ?>
            <?php $__env->startSection('cotable_panel_body'); ?>

            <?php if(Session::has('role_delete_msg')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('role_delete_msg') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>
            <?php if(Session::has('role_update_msg')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('role_update_msg') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>



            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th class="col-sm-1"><?php echo e(trans('others.serial_no_label')); ?></th>
                        <th class="col-sm-4"><?php echo e(trans('others.mxp_menu_role')); ?></th>
                        <th class="col-sm-4"><?php echo e(trans('others.company_name_label')); ?></th>
                        <th class="col-sm-4"><?php echo e(trans('others.status_label')); ?></th>
                        <th class="col-sm-2"><?php echo e(trans('others.action_label')); ?></th> 
                    </tr>
                </thead>
                <tbody>
                    
                    <?php $i=1;  ?>
                    <?php $__currentLoopData = $roleList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $role): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($i++); ?></td>
                                <td><?php echo e($role->name); ?></td>
                                <td><?php echo e($role->c_name); ?></td>
                                <td>
                                    <?php if($role->is_active == '1'): ?>
                                        <?php echo e(trans('others.action_active_label')); ?>

                                    <?php else: ?>
                                        <?php echo e(trans('others.action_inactive_label')); ?>

                                    <?php endif; ?>
                                </td>
                                <td>
                                    <a href="<?php echo e(Route('role_update_action')); ?>/<?php echo e($role->cm_group_id); ?>"> <?php echo $__env->make('widgets.button', array('class'=>'success', 'value'=>trans('others.update_button')), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?> </a>
                                    <a href="<?php echo e(Route('role_delete_action')); ?>/<?php echo e($role->id); ?>"> <?php echo $__env->make('widgets.button', array('class'=>'danger', 'value'=>trans('others.delete_button')), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?> </a>
                                </td>
                            </tr>    
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?> 
                    
                    
                </tbody>
            </table>    
            <?php $__env->stopSection(); ?>
            <?php echo $__env->make('widgets.panel', array('header'=>true, 'as'=>'cotable'), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        </div>
    </div>
</div>
            
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>