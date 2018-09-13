<?php $__env->startSection('page_heading',trans('others.mxp_menu_company_list')); ?>
<?php $__env->startSection('section'); ?>

<style type="text/css">
    .panel-heading{
        display: none;
    }
    .panel-body{
        padding: 0px;
    }
</style>

<?php if(Session::has('client_company_added')): ?>
    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('client_company_added') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
<?php elseif(Session::has('client_company_status')): ?>
    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('client_company_status') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
<?php endif; ?>


<div class="create_form_btn" style="margin-bottom: 20px;">
    <a href="<?php echo e(Route('client_com_add_view')); ?>">
        <button class="btn btn-success"><?php echo e(trans('others.add_company_label')); ?></button>
    </a>
</div>


<div class="col-sm-12">
    <div class="row">
        

        <?php $__env->startSection('cotable_panel_body'); ?>

            <?php if(Session::has('role_delete_msg')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('role_delete_msg') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>
            <?php if(Session::has('role_update_msg')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('role_update_msg') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>
            <?php if(Session::has('company_delete')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('company_delete') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>

            
            <div class="input-group add-on">
              <input class="form-control" placeholder="<?php echo e(trans('others.search_placeholder')); ?>" name="srch-term" id="user_search" type="text">
              <div class="input-group-btn">
                <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
              </div>
            </div>
            <br>
    
            

            
            <table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                        <th class=""><?php echo e(trans('others.serial_no_label')); ?></th>
                        <th class=""><?php echo e(trans('others.company_name_label')); ?></th>
                        <th class=""><?php echo e(trans('others.enter_email_address')); ?></th>
                        <th class=""><?php echo e(trans('others.company_phone_number_label')); ?></th>
                        <th class=""><?php echo e(trans('others.company_label')); ?></th>
                        <th class=""><?php echo e(trans('others.status_label')); ?></th>
                        <th class=""><?php echo e(trans('others.action_label')); ?></th>
                    </tr>
                </thead>
                <tbody>
                    
                    <?php $i=1;  ?>
                    <?php $__currentLoopData = $clients; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $client): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($i++); ?></td>
                                <td><?php echo e($client->first_name); ?></td>
                                <td><?php echo e($client->email); ?></td>
                                <td><?php echo e($client->phone_no); ?></td>
                                <td>
                                    <?php $__currentLoopData = $mxpCompanies; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $company): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                            <?php if($company->id == $client->company_id): ?>
                                                <?php echo e($company->name); ?>

                                            <?php endif; ?>
                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </td>
                                
                                <td>
                                    <?php if($client->is_active == '1'): ?>
                                        <?php echo e(trans('others.action_active_label')); ?>

                                    <?php else: ?>
                                        <?php echo e(trans('others.action_inactive_label')); ?>

                                    <?php endif; ?>
                                </td>
                                <td>
                                    <a href="<?php echo e(Route('client_com_update_view')); ?>/<?php echo e($client->user_id); ?>"> <?php echo $__env->make('widgets.button', array('class'=>'success', 'value'=>trans('others.edit_button')), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?> </a>
                                    <a class="delete_id" href="<?php echo e(Route('client_com_delete_action')); ?>/<?php echo e($client->user_id); ?>" > <?php echo $__env->make('widgets.button', array('class'=>'danger', 'value'=>trans('others.delete_button')), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?> </a>
                                </td>
                            </tr>    
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?> 
                </tbody>
            </table>    
            <?php $__env->stopSection(); ?>
            <?php echo $__env->make('widgets.panel', array('header'=>true, 'as'=>'cotable'), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
    </div>
</div>
            
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>