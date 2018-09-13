<?php $__env->startSection('page_heading',
trans('others.header_list_label')); ?>
<?php $__env->startSection('section'); ?>
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>


    <!-- <div class="row"> -->
        <?php if(Session::has('page_header_added')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('page_header_added') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        <?php endif; ?>

        <?php if(Session::has('header_delete')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('header_delete') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        <?php endif; ?>

        <?php if(Session::has('header_updated')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('header_updated') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        <?php endif; ?>

    	 <div class="col-sm-3 top-btn-pro">
    	 	<a href="<?php echo e(Route('page_header_create')); ?>" class="btn btn-success form-control">
            <?php echo e(trans('others.add_header_label')); ?>

            </a>
    	 </div>
        
<div class="col-sm-12 col-md-12">
            <div class="table-responsive">
                <table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                        <th>#</th>
                        <th class="">
                            <?php echo e(trans('others.header_title_label')); ?>

                        </th>
                        <th>Header type</th>
                        <!-- <th class="">
                            <?php echo e(trans('others.header_font_size_label')); ?>

                        </th> -->
                        <!-- <th class="">
                            <?php echo e(trans('others.header_font_style_label')); ?>

                        </th> -->
                        <!-- <th class="">
                            <?php echo e(trans('others.header_colour_label')); ?>

                        </th> -->
                        <th class="">
                            <?php echo e(trans('others.header_logo_label')); ?>

                        </th>
                       <!--  <th class="">
                            <?php echo e(trans('others.logo_allignment_label')); ?>

                        </th> -->
                        <th class="">
                            <?php echo e(trans('others.header_address_label')); ?>

                        </th>
                        <th class="">
                            <?php echo e(trans('others.action_label')); ?>

                        </th>
                    </tr>
                </thead>
                <tbody>
                    <?php ($j = 1); ?>
                  <?php $__currentLoopData = $page_list; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $page): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                  <tr>
                    <td><?php echo e($j++); ?></td>
                    <td>
                        <?php if($page->header_type == 11): ?>
                        Company 

                        <?php elseif($page->header_type == 12): ?>
                        Booking 
                        <?php else: ?>

                        <?php endif; ?>
                    </td>  
                    <td><?php echo e($page->header_title); ?></td>
                    <!-- <td><?php echo e($page->header_fontsize); ?></td>
                    <td><?php echo e($page->header_fontstyle); ?></td>
                    <td><?php echo e($page->header_colour); ?></td> -->
                    <td>
                        <?php if(!empty($page->logo)): ?>
                        <img src="/upload/<?php echo e($page->logo); ?>" height="50px" weidth="90px" />
                        <?php endif; ?>
                    </td>
                    <!-- <td><?php echo e($page->logo_allignment); ?></td> -->
                    <td><?php echo e($page->address1); ?> <?php echo e((!empty($details->address2) ? ',' : '')); ?> <?php echo e($page->address2); ?> <?php echo e((!empty($details->address3) ? ',' : '')); ?> <?php echo e($page->address3); ?></td>
                    <td>
                        <table>
                          <tr>
                              <td class="">
                                  <a href="<?php echo e(Route('page_edit_view')); ?>/<?php echo e($page->header_id); ?>" class="btn btn-success">edit</a>
                              </td>   
                              <td class="td-pad">
                                  <a href="<?php echo e(Route('page_delete_action')); ?>/<?php echo e($page->header_id); ?>" class="btn btn-danger">delete</a>
                              </td>
                          </tr>
                        </table>
                    </td>
                </tr>
                  <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?> 
                    
                </tbody>
            </table>
            </div>    
           
        
    </div>
</div>          
            
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>