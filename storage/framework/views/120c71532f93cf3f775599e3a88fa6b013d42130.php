<?php $__env->startSection('page_heading', 'Add Supplier'); ?>
<?php $__env->startSection('section'); ?>
<div class="container-fluid">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                <?php if(count($errors) > 0): ?>
                    <div class="alert alert-danger" role="alert">
                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                          <li><span><?php echo e($error); ?></span></li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </div>
                <?php endif; ?>

                <div class="panel panel-default">
                    <div class="panel-heading"><?php echo e(trans('others.add_party_label')); ?></div>
                    <div class="panel-body">

                   
                        <form class="form-horizontal" action="<?php echo e(Route('supplier_add_action')); ?>" role="form" method="POST" >
                            <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
                            
                            <div class="row">
                                <div style="" class="col-md-12 col-sm-12 ">

                                    <div class="form-group">
                                        <label class="col-md-4 col-sm-4 control-label">Supplier Name</label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="name" value="<?php echo e(old('name')); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 col-sm-4 control-label">Contact</label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="phone" value="<?php echo e(old('phone')); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 col-sm-4 control-label">Address</label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="address" value="<?php echo e(old('address')); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                      <label class="col-md-4 col-sm-4 control-label"><?php echo e(trans('others.header_status_label')); ?></label>
                                      <div class="col-md-6 col-sm-6">
                                          <select class="form-control" id="sel1" name="status">
                                            <option value="<?php echo e(old('')); ?>"></option>
                                            <option value="1">Active</option>
                                            <option value="0">Inactive</option>
                                          </select>
                                      </div>
                                    </div>
                                </div>
                            </div>




                            <div class="form-group">
                                    <div class="col-sm-6 col-sm-offset-5 col-xs-offset-8">
                                        <button type="submit" class="btn btn-primary" style="margin-right: 15px;">
                                            <?php echo e(trans('others.save_button')); ?>

                                        </button>
                                    </div>
                            </div>
                            
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(".selections").select2();
    </script>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>