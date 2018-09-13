<?php $__env->startSection('section'); ?>
<div class="col-sm-12">
    <div class="row">
        <div class="col-sm-5 col-sm-offset-3">
            <?php if(count($errors) > 0): ?>
                    <div class="alert alert-danger" role="alert">
                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                          <li><span><?php echo e($error); ?></span></li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </div>
            <?php endif; ?>

            <?php if(Session::has('company_creation')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('company_creation') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>
            

            <form role="form" action="<?php echo e(Route('client_com_add_action')); ?>" method="post">

                <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

                <div class="form-group">
                    <input class="form-control input_required" type="text" name="name" value="<?php echo e(old('name')); ?>" placeholder="<?php echo e(trans('others.company_name_label')); ?>"  >
                </div>
                <div class="form-group">
                    <input class="form-control input_required" type="email" name="email" value="<?php echo e(old('email')); ?>" placeholder="<?php echo e(trans('others.enter_email_address')); ?>"  >
                </div>
                <div class="form-group">
                    <input class="form-control input_required" type="text" name="phone" value="<?php echo e(old('phone')); ?>" placeholder="<?php echo e(trans('others.company_phone_number_label')); ?>"  >
                </div>
                <div class="form-group">
                    <input class="form-control input_required" type="text" name="address" value="<?php echo e(old('address')); ?>" placeholder="<?php echo e(trans('others.company_address_label')); ?>"  >
                </div>
               
                <div class="form-group">
                    <select class="form-control input_required" name="is_active" >
                        <option value="1"><?php echo e(trans('others.action_active_label')); ?></option>   
                        <option value="0"><?php echo e(trans('others.action_inactive_label')); ?></option>
                    </select>
                </div>
                <input type="hidden" name="group_id" value="<?php echo e($request->session()->get('group_id')); ?>">
                

                <?php if(count($companies)>1): ?>
                    <div class="form-group">
                        <select class="form-control input_required" name="company_id" >
                            <option value=""><?php echo e(trans('others.select_company_option_label')); ?></option>
                            <?php $__currentLoopData = $companies; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $company): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <option value="<?php echo e($company->id); ?>"><?php echo e($company->name); ?></option>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </select>
                    </div> 
                <?php else: ?>

                    <?php $__currentLoopData = $companies; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $company): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                
                                <div class="form-group">
                                    <select class="form-control input_required" name="company_id" disabled>
                                        
                                        <?php $__currentLoopData = $companies; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $company): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                            <option selected value="<?php echo e($company->id); ?>"><?php echo e($company->name); ?></option>
                                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                    </select>
                                </div> 
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    
                <?php endif; ?>

                


                <div class="form-group">
                    <input class="form-control btn btn-primary btn-outline" type="submit" value="<?php echo e(trans('others.add_company_label')); ?>" >
                </div>
            </form>
        </div>
    </div>
</div>
            
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>