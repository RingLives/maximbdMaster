<?php $__env->startSection('page_heading','User Profile'); ?>
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
            <?php if(Session::has('profile_update')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('profile_update') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
            <?php endif; ?>
            

            <form role="form" action="<?php echo e(Route('user_profile_action')); ?>" method="post">

                <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
                <input type="hidden" name="user_id" value="<?php echo e($selectedUser->user_id); ?>">
                
                <div class="form-group">
                    <input class="form-control" type="text" name="personal_name" value="<?php echo e($selectedUser->first_name); ?>" placeholder="Personal Name">
                </div>
                <div class="form-group">
                    <input class="form-control" type="text" name="personal_phone_number" value="<?php echo e($selectedUser->phone_no); ?>" placeholder="Phone Number">
                </div>

                <div class="form-group">
                    <input class="form-control" type="email" name="email" value="<?php echo e($selectedUser->email); ?>" placeholder="Email" required="email" disabled>
                </div>

                 <div class="form-group">
                    <input class="form-control" type="text"  value="<?php echo e($selectedUser->name); ?>" placeholder="Company Number" disabled>
                </div>

                <div class="form-group">
                        <?php $__currentLoopData = $roleList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $role): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <?php if($selectedUser->user_role_id == $role->id): ?>
                                <input class="form-control" type="text"  value="<?php echo e($role->name); ?>"  disabled>
                            <?php endif; ?>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </div>
                
                <div class="form-group">
                    <input class="form-control" type="text"  value="<?php echo e($selectedUser->phone); ?>" placeholder="Company Phone" disabled>
                </div>
                <div class="form-group">
                    <input class="form-control" type="text"  value="<?php echo e($selectedUser->address); ?>" placeholder="Company Address" disabled>
                </div>
                <div class="form-group">
                    <input class="form-control" type="text"  value="<?php echo e($selectedUser->description); ?>" placeholder="Company Description" disabled>
                </div>
                
                <div class="form-group">
                    <select class="form-control" name="is_active" disabled>                        
                        <option <?php echo e((($selectedUser->active_user == 1)?'selected':'')); ?> value="1">Active</option>
                        <option <?php echo e((($selectedUser->active_user != 1)?'selected':'')); ?>  value="0">Deactive</option>
                    </select>
                </div>


                <button style="margin-bottom: 20px;" type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo">Change Password</button>
                <div id="demo" class="collapse">
                    
                    <div class="form-group">
                        <input type="password" class="form-control" name="current_password" value="" placeholder="Current Password">
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control" name="password" value="" placeholder="New Password">
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control" name="password_confirmation" value="" placeholder="Confirm Password">
                    </div>

                </div>


                <div class="form-group">
                    <input class="form-control btn btn-primary btn-outline" type="submit" value="Update" >
                </div>
            </form>
        </div>
    </div>
</div>
            
<?php $__env->stopSection(); ?>


<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>