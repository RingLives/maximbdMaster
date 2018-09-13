<?php $__env->startSection('page_heading',
trans('others.footer_title_label')); ?>
<?php $__env->startSection('section'); ?>
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                <?php if(Session::has('add_footer_title')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('add_footer_title') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?> 
                <?php if(Session::has('delete_footer')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('delete_footer') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?>
                <?php if(Session::has('update_footer')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_footer') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?>   

<?php if(empty($footers)): ?>
<div class="col-sm-1"></div>
 <div class="col-sm-2 top-btn-pro">
    <a href="<?php echo e(Route('add_footer_title_view')); ?>" class="btn btn-success form-control">Add Footer </a>
 </div>
 <?php endif; ?>

<div class="col-sm-12">
    <!-- <div class="row"> -->

                         
            <!-- <div class="input-group add-on">
              <input class="form-control" placeholder="Search<?php echo e(trans('others.search_placeholder')); ?>" name="srch-term" id="user_search" type="text">
              <div class="input-group-btn">
                <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
              </div>
            </div>
            <br> -->
            <div class="row">
            	<div class="col-md-1"></div>
            	<div class="col-md-10">
            		<table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                    	<th>Serial no</th>
                        <th class="">Footer Title</th>
                        <th class="">Status</th>
                        <th class="">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <?php ($i = 1); ?>
                    <?php $__currentLoopData = $footers; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $title): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <tr>
                        	<td width="10%">
                               <?php echo e($i++); ?>   
                            </td>
                          <td width="40%"><?php echo e($title->title); ?></td>
                        	<td width="20%">                            
                            <?php echo e(($title->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")); ?>

                          </td>
                        	<td width="30%">
                        		<center>
                        		<table>
                                      <tr>
                                          <td class="">
                                              <a href="<?php echo e(Route('update_title_view')); ?>/<?php echo e($title->footer_id); ?>" class="btn btn-success">edit</a>
                                          </td>
                                          <td class="td-pad">
                                              <a href="<?php echo e(Route('delete_footer_action')); ?>/<?php echo e($title->footer_id); ?>" class="btn btn-danger">delete</a>
                                          </td>
                                      </tr>
                                  </table>
                                  </center>
                        	</td>
                         </tr>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    
                          
                </tbody>
            </table>
            	</div>
            	<div class="col-md-1"></div>
            </div>
                
           
       
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>