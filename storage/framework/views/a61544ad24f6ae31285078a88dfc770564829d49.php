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
            

            <form role="form" action="<?php echo e(Route('create_company_acc_action')); ?>" method="post">

                <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">


                <div class="form-group">
                    <input class="form-control input_required" type="text" name="name" value="<?php echo e(old('name')); ?>" placeholder="<?php echo e(trans('others.company_name_label')); ?>"  >
                </div>
                <div class="form-group">
                    <input class="form-control input_required" type="text" name="phone" value="<?php echo e(old('phone')); ?>" placeholder="<?php echo e(trans('others.company_phone_number_label')); ?>"  >
                </div>
                <div class="form-group">
                    <input class="form-control input_required" type="text" name="address" value="<?php echo e(old('address')); ?>" placeholder="<?php echo e(trans('others.company_address_label')); ?>"  >
                </div>
                <div class="form-group">
                    <input class="form-control " type="text" name="description" value="<?php echo e(old('description')); ?>" placeholder="<?php echo e(trans('others.company_description_label')); ?>"  >
                </div>
               
                <div class="form-group">
                    <select class="form-control input_required" name="is_active" >
                        <option value="1"><?php echo e(trans('others.action_active_label')); ?></option>   
                        <option value="0"><?php echo e(trans('others.action_inactive_label')); ?></option>
                    </select>
                </div>

                


                <div class="form-group">
                    <input class="form-control btn btn-primary btn-outline" type="submit" value="<?php echo e(trans('others.save_button')); ?>" >
                </div>
            </form>
        </div>
    </div>
</div>
            
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>