<?php $__env->startSection('page_heading',trans('others.heading_role_assign_label')); ?>
<?php $__env->startSection('section'); ?>
<div class="col-sm-12">
    <div class="row">

    <?php if(count($errors) > 0): ?>
                    <div class="alert alert-danger" role="alert">
                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                          <li><span><?php echo e($error); ?></span></li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </div>
            <?php endif; ?>
        
        <?php if(Session::has('com_user_role_assign')): ?>
            <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('com_user_role_assign') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        <?php endif; ?>
            <form action="<?php echo e(Route('role_permission_action')); ?>" method="post" role="form">
                <input name="_token" type="hidden" value="<?php echo e(csrf_token()); ?>">
                    <div class="col-sm-12">
                        <div class="col-sm-5">
                            
                            <div class="form-group">
                                <select class="form-control input_required" name="companyId" id="companyId" >
                                   <option value=""><?php echo e(trans('others.select_company_option_label')); ?></option>    
                                    
                                    <?php $__currentLoopData = $companyList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $company): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                            
                                            <option value="<?php echo e($company->id); ?>">
                                                <?php echo e($company->name); ?>

                                            </option>

                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </select>
                            </div>

                            <div class="form-group">
                                <select class="form-control input_required" name="roleId" id="roleId" onchange="getPermission(this)"  disabled>
                                    <option value=""><?php echo e(trans('others.select_role_option_label')); ?></option>
                                </select>
                            </div>

                           
                        </div>
                        <br><br>
                        <div class="all_checkbox col-sm-12" id="all_checkbox">
                            <div style="float: left; width: 100%; margin-bottom: 20px; ">
                                <a style="cursor: pointer;" id="selectAllcheckBox"><?php echo e(trans('others.select_all_label')); ?></a><br>
                                <a style="cursor: pointer;" id="unselectAllcheckBox"><?php echo e(trans('others.unselect_all_label')); ?></a>
                            </div>

                            <?php $__currentLoopData = $menuList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $menu): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                    <?php if(
                                        
                                        
                                        $menu->route_name != 'company_user_update_view' &&
                                        $menu->route_name != 'add_role_action' &&
                                        $menu->route_name != 'add_role_view' &&
                                        $menu->route_name != 'add_role_action' &&
                                        $menu->route_name != 'role_delete_action' &&
                                        $menu->route_name != 'role_update_view' &&
                                        $menu->route_name != 'role_update_action' &&
                                        $menu->route_name != 'create_company_acc_view' &&
                                        $menu->route_name != 'create_company_acc_action' &&
                                        $menu->route_name != 'company_list_view' &&
                                        $menu->route_name != 'company_user_update_action' &&
                                        $menu->route_name != 'company_user_delete_action' &&
                                        $menu->route_name != 'role_permission_view' &&
                                        $menu->route_name != 'role_permission_action' &&
                                        $menu->route_name != 'role_permission_update_view'): ?>
                                        
                                        <div class="col-sm-4">
                                            <label>
                                                <input disabled class="single_check_box" id="<?php echo e($menu->menu_id); ?>" name="menu_list[]" type="checkbox" value="<?php echo e($menu->menu_id); ?>" 
                                                <?php $__currentLoopData = $roleMenuList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $checkmenu): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                        <?php if($checkmenu->menu_id == $menu->menu_id): ?>
                                                        <?php echo e('checked'); ?>

                                                        <?php endif; ?>
                                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                                >
                                                    <?php echo e($menu->name); ?>

                                                </input>
                                            </label>
                                        </div>

                                    <?php endif; ?>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </div>
                        <br><br><br>
                        <div class="form-group col-sm-2">
                            <input class="form-control btn btn-primary btn-outline" type="submit" value="<?php echo e(trans('others.set_button')); ?>">
                            </input>
                        </div>
                    </div>
                </input>
            </form>
            
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>