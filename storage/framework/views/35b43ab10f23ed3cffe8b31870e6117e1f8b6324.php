<?php $__env->startSection('page_heading',
trans('others.party_list_label')); ?>
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
 	<a href="<?php echo e(Route('party_create')); ?>" class="btn btn-success form-control">
        <?php echo e(trans('others.add_party_label')); ?>

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
                        <th class="">Vendor ID</th>
                        <th class="">Company Name</th>
                        <th class="">Buyer</th>
                        <th class="">Address -1 (Invoice)</th>
                        <th class="">Address -2 (Invoice)</th>
                        <th class="">Attention (Invoice)</th>
                        <th class="">Mobile (Invoice)</th>
                        <!-- <th class="">Fax(Invoice)</th>
                        <th class="">Address(Delivery)</th>
                        <th class="">Mobile(Delivery)</th>
                        <th class="">Fax(Delivery)</th>
                        <th class="">Description</th> -->
                        <th class="">Status</th>
                        <th class="">Action</th>
                    </tr>
                </thead>
                <tbody>
                  <?php $__currentLoopData = $party_list; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $party): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                  <tr>  
                    <td><?php echo e($party->party_id); ?></td>
                    <td><?php echo e($party->name); ?></td>
                    <td><?php echo e($party->name_buyer); ?></td>
                    <td><?php echo e($party->address_part1_invoice); ?></td>
                    <td><?php echo e($party->address_part2_invoice); ?></td>
                    <td><?php echo e($party->attention_invoice); ?></td>
                    <td><?php echo e($party->mobile_invoice); ?></td>

                    <!-- <td><?php echo e($party->fax_invoice); ?></td>
                    <td><?php echo e($party->address_part1_delivery); ?></td>
                    <td><?php echo e($party->mobile_delivery); ?></td>
                    <td><?php echo e($party->fax_delivery); ?></td>
                    <td><?php echo e($party->description_1); ?></td> -->
                    <td>
                        <?php echo e(($party->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")); ?>

                    </td>

                    <td>
                        <table>
                          <tr>
                              <td class="">
                                  <a href="<?php echo e(Route('party_edit_view')); ?>/<?php echo e($party->id); ?>" class="btn btn-success">edit</a>
                              </td>   
                              <td class="td-pad">
                                  <a href="<?php echo e(Route('party_delete_action')); ?>/<?php echo e($party->id); ?>" class="btn btn-danger">delete</a>
                              </td>
                          </tr>
                        </table>
                    </td>
                </tr>
                  <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?> 
                    
                </tbody>
            </table>
             <?php echo e($party_list->links()); ?>

            </div>    
           
        
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>