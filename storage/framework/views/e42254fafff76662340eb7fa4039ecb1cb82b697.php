<?php $__env->startSection('page_heading',trans('others.update_ueader')); ?>
<?php $__env->startSection('section'); ?>
<div class="container-fluid">
        <div class="row">
            <div class="col-md-12">
                <?php if(count($errors) > 0): ?>
                    <div class="alert alert-danger" role="alert">
                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                          <li><span><?php echo e($error); ?></span></li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </div>
                <?php endif; ?>

                <div class="panel panel-default">
                    <div class="panel-heading"><?php echo e(trans('others.update_ueader')); ?></div>
                    <div class="panel-body">

                    <?php $__currentLoopData = $page_edits; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $page_edit): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <form class="form-horizontal" action="<?php echo e(Route('page_edit_action')); ?>/<?php echo e($page_edit->header_id); ?>" role="form" method="POST" enctype="multipart/form-data">
                            <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

                            <div class="col-md-6">

                                <div class="form-group">
                                    <label class="col-md-4 control-label"><?php echo e(trans('others.header_type_label')); ?></label>
                                    <div class="col-md-6">
                                        <select class="form-control" name="header_type" >
                                            <option value="<?php echo e($page_edit->header_type); ?>">
                                                <?php if($page_edit->header_type == 11): ?>
                                                    Company Info
                                                <?php elseif($page_edit->header_type == 12): ?>
                                                    Booking Info
                                                <?php else: ?>
                                                <?php endif; ?>
                                            </option>
                                            <option value="11">Company Info </option>
                                            <option value="12"> Booking </option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label"><?php echo e(trans('others.header_title_label')); ?></label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control  input_required" name="header_title" value="<?php echo e($page_edit->header_title); ?>">
                                    </div>
                                </div>


                                <div class="form-group">
                                  <label class="col-md-4 control-label"><?php echo e(trans('others.header_font_size_label')); ?></label>
                                  <div class="col-md-6">
                                      <select class="form-control" id="sel1" name="header_fontsize">
                                        <option value="<?php echo e($page_edit->header_fontsize); ?>"><?php echo e($page_edit->header_fontsize); ?></option>
                                        <option value="x-small">Extra Small</option>
                                        <option value="small">Small</option>
                                        <option value="medium">Medium</option>
                                        <option value="large">Large</option>
                                        <option value="x-large">Extra Large</option>
                                      </select>
                                  </div>
                                </div>

                                <div class="form-group">
                                  <label class="col-md-4 control-label"><?php echo e(trans('others.header_font_style_label')); ?></label>
                                  <div class="col-md-6">
                                      <select class="form-control" id="sel1" name="header_fontstyle">
                                        <option value="<?php echo e($page_edit->header_fontstyle); ?>"><?php echo e($page_edit->header_fontstyle); ?></option>
                                        <option value="normal">Normal</option>
                                        <option value="italic">Italic</option>
                                        <option value="oblique">Oblique</option>
                                      </select>
                                  </div>
                                </div>

                                <div class="form-group">
                                  <label class="col-md-4 control-label"><?php echo e(trans('others.header_colour_label')); ?></label>
                                  <div class="col-md-6">
                                      <select class="form-control" id="sel1" name="header_colour">
                                        <option value="<?php echo e($page_edit->header_colour); ?>"><?php echo e($page_edit->header_colour); ?></option>
                                        <option value="black">Black</option>
                                        <option value="blue">Blue</option>
                                        <option value="green">Green</option>
                                      </select>
                                  </div>
                                </div>

                                
                                <div class="form-group">
                                    <label class="control-label col-md-4"><?php echo e(trans('others.header_logo_label')); ?></label>
                                    <div class="col-md-6">
                                        <input data-preview="#preview" name="logo" type="file" id="imageInput">
                                        <img class="col-sm-6" id="preview"  src="" ></img>
                                    </div>
                                </div>
                                
                            </div>

                            <div class="col-md-6">

                                <div class="form-group">
                                  <label class="col-md-4 control-label"><?php echo e(trans('others.logo_allignment_label')); ?></label>
                                  <div class="col-md-6">
                                      <select class="form-control" id="sel1" name="logo_allignment">
                                        <option value="<?php echo e($page_edit->logo_allignment); ?>"><?php echo e($page_edit->logo_allignment); ?></option>
                                        <!-- <option value="top">Top</option> -->
                                        <option value="right">Right</option>
                                        <option value="left">Left</option>
                                        <!-- <option value="middle">Middle</option> -->
                                      </select>
                                  </div>
                                </div>
                                

                                <div class="form-group">
                                    <label class="col-md-4 control-label"><?php echo e(trans('others.header_address1_label')); ?></label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="address1" value="<?php echo e($page_edit->address1); ?>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label"><?php echo e(trans('others.header_address2_label')); ?></label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="address2" value="<?php echo e($page_edit->address2); ?>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label"><?php echo e(trans('others.header_address3_label')); ?></label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="address3" value="<?php echo e($page_edit->address3); ?>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label"><?php echo e(trans('others.header_cell_number_label')); ?></label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="cell_number" value="<?php echo e($page_edit->cell_number); ?>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-md-4 control-label"><?php echo e(trans('others.header_attention_label')); ?></label>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" name="attention" value="<?php echo e($page_edit->attention); ?>">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="col-md-4">
                                        
                                    </div>
                                    <div class="col-md-6">
                                        <button type="submit" class="btn btn-primary" style="margin-right: 15px;">
                                            <?php echo e(trans('others.update_button')); ?>

                                        </button>
                                    </div>
                                </div>
                                
                            </div>

                            
                            
                        </form>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
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