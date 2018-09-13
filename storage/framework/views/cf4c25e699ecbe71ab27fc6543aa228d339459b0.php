<?php $__env->startSection('page_heading',
trans('others.brand_list_label')); ?>
<?php $__env->startSection('section'); ?>
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                <?php if(Session::has('add_brand')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('add_brand') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?> 
                <?php if(Session::has('brand_delete')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('brand_delete') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?>
                <?php if(Session::has('update_brand')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_brand') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?>   
 <div class="col-sm-2 top-btn-pro">
    <a href="<?php echo e(Route('addbrand_view')); ?>" class="btn btn-success form-control">
    <?php echo e(trans('others.add_brand_label')); ?></a>
 </div>
 <div class="col-sm-6">
    <div class="form-group custom-search-form">
        <input type="text" name="searchFld" class="form-control" placeholder="search" id="user_search">
        <button class="btn btn-default" type="button">
            <i class="fa fa-search"></i>
        </button>
    </div>
</div>

<div class="col-sm-12">
    <div class="row"> 
    	<div class="col-sm-1"></div>
    		<div class="col-sm-10">
            	<table class="table table-bordered" id="tblSearch">
	                <thead>
	                    <tr>
	                    	<th width="10%">Serial no</th>
	                    	<th width="45%">Brand</th>
	                    	<th width="20%">Status</th>
	                        <th width="25%">Action</th>
	                    </tr>
	                </thead>
                <tbody>  
                    <?php ($i=1); ?>
                    <?php $__currentLoopData = $brands; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $brand): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>                  
                        <tr>                        	
                        	<td><?php echo e($i++); ?></td>
                        	<td><?php echo e($brand->brand_name); ?></td>                	
                        	<td>
                              <?php echo e(($brand->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")); ?>

                          </td>                	
                        	<td>                        		
                        		<table>
                                      <tr>
                                          <td class="">
                                              <a href="<?php echo e(Route('update_brand_view')); ?>/<?php echo e($brand->brand_id); ?>" class="btn btn-success">edit</a>
                                          </td>
                                          <td class="td-pad">
                                              <a href="<?php echo e(Route('delete_brand_action')); ?>/<?php echo e($brand->brand_id); ?>" class="btn btn-danger">delete</a>
                                          </td>
                                      </tr>
                                  </table>                                 
                        	</td>
                         </tr>                    
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>                      
                </tbody>
            </table>
            <?php echo e($brands->links()); ?>

            </div>
            <div class="col-sm-1"></div>
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>