<?php $__env->startSection('page_heading',
trans('others.Gmts_color_list_label')); ?>
<?php $__env->startSection('section'); ?>
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
<?php if(Session::has('add_gmtscolor')): ?>
    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('add_gmtscolor') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
<?php endif; ?>
<?php if(Session::has('update_gmtscolor')): ?>
    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_gmtscolor') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
<?php endif; ?>
<?php if(Session::has('delete_gmts_color')): ?>
    <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('delete_gmts_color') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
<?php endif; ?>

<div class="row">
        
    <div class="col-md-12 col-xs-12">
		<div class="col-sm-3 top-btn-pro">
		 	<a href="<?php echo e(Route('add_color_view')); ?>" class="btn btn-success form-control">
		        <?php echo e(trans('others.add_color_label')); ?>

		    </a>
		</div>
		<div class="col-sm-9">
		    <div class="form-group custom-search-form">
		        <input type="text" name="searchFld" class="form-control" placeholder="search" id="user_search">
		        <button class="btn btn-default" type="button">
		            <i class="fa fa-search"></i>
		        </button>
		    </div>
		</div>
	</div>
	<div class="col-xs-12 col-md-12 ">
        <table class="table table-bordered" id="tblSearch">
            <thead>
                <tr>
                	<th>Serial No</th>
                	
                	<th>GMTS Color</th>
                	<th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
              <?php ($i=1); ?>
                    <?php $__currentLoopData = $gmtsColor; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $color): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>                  
                        <tr>                        	
                        	<td><?php echo e($i++); ?></td>
                        	        	
                        	<td><?php echo e($color->color_name); ?></td>                	
                        	<td>
                            <?php echo e(($color->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")); ?>

                          </td>                	
                        	<td>                        		
                        		<table>
                                <tr>
                                    <td class="">
                                        <a href="<?php echo e(Route('update_gmtscolor_view')); ?>/<?php echo e($color->id); ?>" class="btn btn-success">edit</a>
                                    </td>
                                    <td class="td-pad">
                                        <a href="<?php echo e(Route('delete_gmtscolor_action')); ?>/<?php echo e($color->id); ?>" class="btn btn-danger">delete</a>
                                    </td>
                                </tr>
                            </table>                                 
                        	</td>
                         </tr>                    
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?> 
            </tbody>
        </table>
         	<?php echo e($gmtsColor->links()); ?>

    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>