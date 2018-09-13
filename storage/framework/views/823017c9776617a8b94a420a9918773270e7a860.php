<!-- Add Brand Modal -->
<div class="modal fade" id="addBrandModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading"><?php echo e(trans('others.add_brand_label')); ?>

                        <button type="button" class="close" data-dismiss="addBrandModal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="panel-body">

                        
                        <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

                        <?php if($errors->any()): ?>
                        <div class="alert alert-danger">
                            <ul>
                                <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <li><?php echo e($error); ?></li>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            </ul>
                        </div>
                        <?php endif; ?>

                        <div class="form-group">
                            <label class="col-md-4 control-label"><?php echo e(trans('others.brand_name_label')); ?></label>
                            <div class="col-md-6">
                                <input type="text" class="form-control  input_required" name="brand_name" value="<?php echo e(old('brand_name')); ?>">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3 col-md-offset-4">
                                <div class="select">
                                    <select class="form-control" type="select" name="isActive" >
                                        <option  value="1" name="isActive" ><?php echo e(trans("others.action_active_label")); ?></option>
                                        <option value="0" name="isActive" ><?php echo e(trans("others.action_inactive_label")); ?></option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button class="btn btn-primary add-product-brand" style="margin-right: 15px;">
                                    <?php echo e(trans('others.save_button')); ?>

                                </button>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<!-- Add Color Modal -->
<div class="modal fade" id="addColorModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading">Add Color
                        <button type="button" class="close" data-dismiss="addColorModal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="panel-body">

                        
                        <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

                        <?php if($errors->any()): ?>
                            <div class="alert alert-danger">
                                <ul>
                                    <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                        <li><?php echo e($error); ?></li>
                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </ul>
                            </div>
                        <?php endif; ?>

                        <div class="form-group">
                            <label class="col-md-4 control-label">Color Name</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control  input_required" name="color_name" value="<?php echo e(old('color_name')); ?>">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3 col-md-offset-4">
                                <div class="select">
                                    <select class="form-control" type="select" name="isActive" >
                                        <option  value="1" name="isActive" ><?php echo e(trans("others.action_active_label")); ?></option>
                                        <option value="0" name="isActive" ><?php echo e(trans("others.action_inactive_label")); ?></option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button class="btn btn-primary add-color-brand" style="margin-right: 15px;">
                                    <?php echo e(trans('others.save_button')); ?>

                                </button>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>





<!-- Add Size Modal -->
<div class="modal fade" id="addSizeModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="panel panel-default">
                    <div class="panel-heading">Add Size
                        <button type="button" class="close" data-dismiss="addSizeModal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>

                    <div class="panel-body">

                        
                        <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

                        <?php if($errors->any()): ?>
                            <div class="alert alert-danger">
                                <ul>
                                    <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                        <li><?php echo e($error); ?></li>
                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </ul>
                            </div>
                        <?php endif; ?>

                        <div class="form-group">
                            <label class="col-md-4 control-label">Size Name</label>
                            <div class="col-md-6">
                                <input type="text" class="form-control  input_required" name="size_name" value="<?php echo e(old('size_name')); ?>">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3 col-md-offset-4">
                                <div class="select">
                                    <select class="form-control" type="select" name="isActive" >
                                        <option  value="1" name="isActive" ><?php echo e(trans("others.action_active_label")); ?></option>
                                        <option value="0" name="isActive" ><?php echo e(trans("others.action_inactive_label")); ?></option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-6 col-md-offset-4">
                                <button class="btn btn-primary add-size-brand" style="margin-right: 15px;">
                                    <?php echo e(trans('others.save_button')); ?>

                                </button>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>








    
        
            
                
                    
                        
                            
                        
                    

                    


                        



                            
                                
                                    
                                        
                                            
                                        
                                    
                                
                            

                            
                                

                                
                                    
                                    
                                

                                
                                    
                                    
                                

                                
                                    
                                    
                                
                            

                                

                            
                                
                                    
                                        
                                    
                                
                            
                        
                    
                
            
        
    
