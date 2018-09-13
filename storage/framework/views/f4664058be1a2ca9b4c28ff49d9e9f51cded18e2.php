<?php $__env->startSection('page_heading',
trans('others.report_footer_list')); ?>
<?php $__env->startSection('section'); ?>
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                <?php if(Session::has('new_report_create')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('new_report_create') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?> 
                <?php if(Session::has('delete_report_footer')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('delete_report_footer') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?>
                <?php if(Session::has('update_report_footer')): ?>
                    <?php echo $__env->make('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_report_footer') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                <?php endif; ?>   
 <div class="col-sm-2 top-btn-pro">
    <a href="<?php echo e(Route('addreport_footer_view')); ?>" class="btn btn-success form-control"><?php echo e(trans('others.add_report_footer_label')); ?></a>
 </div>

<div class="col-sm-12">
    <!-- <div class="row"> -->            
            		<table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                    	<th>Serial no</th>
                        <th>Report Name</th>
                        <th>Persion -1</th>
                        <th>signature -1</th>
                        <th>Seal -1</th>
                        <th>Persion -2</th>
                        <th>Signature -2</th>
                        <th>Seal -2</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>  
                    <?php ($i=1); ?>
                    <?php $__currentLoopData = $reports; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $roport): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>                  
                        <tr>                        	
                        	<td><?php echo e($i++); ?></td>
                        	<td><?php echo e($roport->reportName); ?></td>
                        	<td><?php echo e($roport->siginingPerson_1); ?></td>                 
                        	<td>
                                <?php if(!empty($roport->siginingSignature_1)): ?>
                                <img src="/upload/<?php echo e($roport->siginingSignature_1); ?>" height="50px" width="90px" />
                                <?php endif; ?>
                            </td>
                            <!-- <td><?php echo e($roport->siginingPersonSeal_1); ?></td> -->
                            <td>
                                <?php if(!empty($roport->siginingPersonSeal_1)): ?>
                                <img src="/upload/<?php echo e($roport->siginingPersonSeal_1); ?>" height="50px" width="90px" />
                                <?php endif; ?>
                            </td>
                        	<td><?php echo e($roport->siginingPerson_2); ?></td>
                        	<!-- <td><?php echo e($roport->siginingSignature_2); ?></td> -->
                            <td>
                                <?php if(!empty($roport->siginingSignature_2)): ?>
                                <img src="/upload/<?php echo e($roport->siginingSignature_2); ?>" height="50px" width="90px" />
                                <?php endif; ?>
                            </td>
                        	<!-- <td><?php echo e($roport->siginingPersonSeal_2); ?></td> -->
                            <td>
                                <?php if(!empty($roport->siginingPersonSeal_2)): ?>
                                <img src="/upload/<?php echo e($roport->siginingPersonSeal_2); ?>" height="50px" width="90px" />
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php echo e(($roport->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")); ?>

                            </td>
                        	<td>
                        		<center>
                        		<table>
                                      <tr>
                                          <td class="">
                                              <a href="<?php echo e(Route('update_report_view')); ?>/<?php echo e($roport->re_footer_id); ?>" class="btn btn-success">edit</a>
                                          </td>
                                          <td class="td-pad">
                                              <a href="<?php echo e(Route('delete_report_action')); ?>/<?php echo e($roport->re_footer_id); ?>" class="btn btn-danger">delete</a>
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
</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>