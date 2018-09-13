<?php $__env->startSection('page_heading', 'Supplier List'); ?>
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
        <?php if(Session::has('party_added')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('party_added') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        <?php endif; ?>

        <?php if(Session::has('party_delete')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('party_delete') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        <?php endif; ?>

        <?php if(Session::has('party_updated')): ?>
                <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('party_updated') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        <?php endif; ?>

 <div class="col-sm-3 top-btn-pro">
 	<a href="<?php echo e(Route('supplier_add_view')); ?>" class="btn btn-success form-control">
        Add Supplier
    </a>
 </div>
<div class="col-sm-6">
    <div class="form-group custom-search-form">
        <input type="text" name="searchFld" class="form-control" placeholder="search" id="user_search">
        <button class="btn btn-default" type="button">
            <i class="fa fa-search"></i>
        </button>
    </div>
</div>
        
           
            <!-- <div class="input-group add-on">
              <input class="form-control" placeholder="Search<?php echo e(trans('others.search_placeholder')); ?>" name="srch-term" id="user_search" type="text">
              <div class="input-group-btn">
                <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
              </div>
            </div>
            <br> -->
<div class="col-sm-12 col-md-12">
            <div class="table-responsive">
                <table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                        <th class="">Sl</th>
                        <th class="">Supplier Name</th>
                        <th class="">Contact</th>
                        <th class="">Address</th>
                        <th class="">Status</th>
                        <th class="">Action</th>
                    </tr>
                </thead>
                <tbody>
                  <?php $__currentLoopData = $suppliers; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $supplier): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                  <tr>
                    <td><?php echo e($key+1); ?></td>
                    <td><?php echo e($supplier->name); ?></td>
                    <td><?php echo e($supplier->phone); ?></td>
                    <td><?php echo e($supplier->address); ?></td>

                    <td>
                        <?php echo e(($supplier->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")); ?>

                    </td>

                    <td>
                        <table>
                          <tr>
                              <td class="">
                                  <a href="<?php echo e(Route('supplier_update')); ?>/<?php echo e($supplier->supplier_id); ?>" class="btn btn-success">edit</a>
                              </td>   
                              <td class="td-pad">
                                  <a href="<?php echo e(Route('supplier_delete_action')); ?>/<?php echo e($supplier->supplier_id); ?>" class="btn btn-danger">delete</a>
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