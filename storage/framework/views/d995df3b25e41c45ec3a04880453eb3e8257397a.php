<?php $__env->startSection('page_heading',
trans('others.add_party_label')); ?>
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

                   
                        <form class="form-horizontal" action="<?php echo e(Route('party_save_action')); ?>" role="form" method="POST" >
                            <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
                            
                            <div class="row">
                                <div style="" class="col-md-12 col-sm-12 ">
                                    <div class="form-group">
                                        <label class="col-md-5 col-sm-5 control-label"><?php echo e(trans('others.party_id_label')); ?></label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control input_required" name="party_id" value="<?php echo e(old('party_id')); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-5 col-sm-5 control-label"><?php echo e(trans('others.party_name_label')); ?></label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="name" value="<?php echo e(old('name')); ?>">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-md-5 col-sm-5 control-label"><?php echo e(trans('others.sort_name_label')); ?></label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="sort_name" value="<?php echo e(old('name')); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-5 col-sm-5 control-label"><?php echo e(trans('others.name_buyer_label')); ?></label>
                                        <div class="col-md-6 col-sm-6">
                                            <input type="text" class="form-control  input_required" name="name_buyer" value="<?php echo e(old('name_buyer')); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                      <label class="col-md-5 col-sm-5 control-label"><?php echo e(trans('others.header_status_label')); ?></label>
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

                            <div class="row">
                                <div class="col-md-12">
                                    <div class="col-md-6">
                                        <div class=" panel panel-default">
                                            <div class="panel-heading">
                                                <?php echo e(trans('others.invoice_label')); ?>

                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.address_part_1_invoice_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="address_part_1_invoice" value="<?php echo e(old('address_part_1_invoice')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.address_part_2_invoice_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="address_part_2_invoice" value="<?php echo e(old('address_part_2_invoice')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.attention_invoice_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="attention_invoice" value="<?php echo e(old('attention_invoice')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.mobile_invoice_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="mobile_invoice" value="<?php echo e(old('mobile_invoice')); ?>">
                                                    </div>
                                                </div>

                                                 <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.telephone_invoice_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="telephone_invoice" value="<?php echo e(old('telephone_invoice')); ?>">
                                                    </div>
                                                </div>

                                                 <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.fax_invoice_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="fax_invoice" value="<?php echo e(old('fax_invoice')); ?>">
                                                    </div>
                                                </div> 
                                            </div>
                                        </div>                                       
                                    </div>

                                    <div class="col-md-6">

                                        <div class="panel panel-default">
                                            <div class="panel-heading">
                                                <?php echo e(trans('others.delivery_label')); ?>

                                            </div>
                                            <div class="panel-body">
                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.address_part1_delivery_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="address_part_1_delivery" value="<?php echo e(old('address_part_1_delivery')); ?>">
                                                    </div>
                                                </div> 

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.address_part2_delivery_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="address_part_2_delivery" value="<?php echo e(old('address_part_2_delivery')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.attention_delivery_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="attention_delivery" value="<?php echo e(old('attention_delivery')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.mobile_delivery_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="mobile_delivery" value="<?php echo e(old('mobile_delivery')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.telephone_delivery_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="telephone_delivery" value="<?php echo e(old('telephone_delivery')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.fax_delivery_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="fax_delivery" value="<?php echo e(old('fax_delivery')); ?>">
                                                    </div>
                                                </div>

                                                <!-- <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.description1_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="description_1" value="<?php echo e(old('description_1')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.description2_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="description_2" value="<?php echo e(old('description_2')); ?>">
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <label class="col-md-5 control-label"><?php echo e(trans('others.description3_label')); ?></label>
                                                    <div class="col-md-6">
                                                        <input type="text" class="form-control" name="description_3" value="<?php echo e(old('description_3')); ?>">
                                                    </div>
                                                </div> -->
                                            </div>
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                    <div class="col-sm-6 col-sm-offset-10 col-xs-offset-8">
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