<?php $__env->startSection('page_heading','Add Role'); ?>
<?php $__env->startSection('section'); ?>
           
<div class="col-sm-12" id="demo">
    <div class="row">
        <div class="col-sm-5 col-sm-offset-3">
            <?php if(count($errors) > 0): ?>
                    <div class="alert alert-danger" role="alert">
                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                          <li><span><?php echo e($error); ?></span></li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </div>
            <?php endif; ?>

            <?php if(Session::has('new_user_create')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('new_user_create') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>
            

            <form role="form" action="<?php echo e(Route('create_user_action')); ?>" method="post">

                <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">


                <div class="form-group">
                    <select class="form-control input_required" name="company_id" id="companyId" >
                       <option value=""><?php echo e(trans('others.select_company_option_label')); ?></option>
                        <?php $__currentLoopData = $companyList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $company): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                
                                <option value="<?php echo e($company->id); ?>">
                                    <?php echo e($company->name); ?>

                                </option>

                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </select>
                </div>

                <div class="form-group">
                    <select class="form-control input_required" name="role_id" id="roleId" onchange="getPermission(this)"  disabled>
                        <option value=""><?php echo e(trans('others.select_role_option_label')); ?></option>
                    </select>
                </div>


                <div class="form-group">
                    <input class="form-control input_required" type="text" name="personal_name" value="<?php echo e(old('personal_name')); ?>" placeholder="<?php echo e(trans('others.employee_name_label')); ?>"  >
                </div>
                <div class="form-group">
                    <input class="form-control" type="text" name="personal_phone_number" value="<?php echo e(old('personal_phone_number')); ?>" placeholder="<?php echo e(trans('others.personal_phone_number_label')); ?>"  >
                </div>
                <div class="form-group">
                    <input class="form-control input_required" type="text" name="employee_address" value="<?php echo e(old('employee_address')); ?>" placeholder="<?php echo e(trans('others.employee_address_label')); ?>"  >
                </div>                

                <div class="form-group">
                    <input class="form-control input_required" type="email" name="email" value="<?php echo e(old('email')); ?>" placeholder="<?php echo e(trans('others.enter_email_address')); ?>" required="email">
                </div>

                <div class="form-group">
                        <input type="password" class="form-control input_required" name="password" value="" placeholder="<?php echo e(trans('others.enter_password')); ?>">
                </div>

                <div class="form-group">
                        <input type="password" class="form-control input_required" name="password_confirmation" value="" placeholder="<?php echo e(trans('others.password_confirmation_label')); ?>">
                </div>

               
                <div class="form-group">
                    <select class="form-control input_required" name="is_active" >
                        <option value="1"><?php echo e(trans('others.action_active_label')); ?></option>   
                        <option value="0"><?php echo e(trans('others.action_inactive_label')); ?></option>
                    </select>
                </div>

                


                <div class="form-group">
                    <input class="form-control btn btn-primary btn-outline" type="submit" value="<?php echo e(trans('others.mxp_menu_create_user')); ?>" >
                </div>
            </form>
        </div>
    </div>
</div>
            
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>