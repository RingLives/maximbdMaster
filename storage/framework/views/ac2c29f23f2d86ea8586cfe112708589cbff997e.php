<?php $__env->startSection('page_heading',
trans('others.mxp_menu_bill_copy')); ?>
<?php $__env->startSection('section'); ?>
<?php if($errors->any()): ?>
    <div class="alert alert-danger">
        <ul>
        	<li style="list-style-type: none;">
        		<?php if(Session::has('error_code')): ?>
                	<?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('error_code') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
        		<?php endif; ?>
    		</li>
            <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
               <div style="padding-left: 15px;"><li><?php echo e($error); ?></li></div>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </ul>
    </div>
<?php endif; ?>

<div class="col-md-8 col-md-offset-2">
	<div class="panel panel-default">
		<div class="panel-heading">
		<?php echo e(trans('others.mxp_menu_bill_copy')); ?>

		</div>
		<div class="panel-body">
			<form class="" role="form" method="POST" action="<?php echo e(route('bill_genarate_action')); ?>"  enctype="multipart/form-data" 
					>
				<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

				<div class="row">
					<div class="form-group col-md-6">
						<div class="">
							<div class="select">
								<select class="form-control" type="select" name="buyer_name" >
									<option  value="" name="isActive" ></option>
									<?php $__currentLoopData = $buyer; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
									<option value="<?php echo e($value->name_buyer); ?>" name="isActive" ><?php echo e($value->name_buyer); ?></option>
									<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
							    </select>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="form-group">
							<input type="file" name="import_file" class="">
						</div>
					</div>

					</div>
					<div class="col-md-4 col-md-offset-8">
						<div class="form-group">
				            <div class="form-group">
				                <button type="submit" class="btn btn-primary print" style="margin-right: 15px;" id="">
				                    <?php echo e(trans('others.genarate_bill_button')); ?>

				            	</button>
				            </div>
				        </div>
					</div>
				
				
				
			</form>
		</div>
	</div>
</div><!-- 
    <script type="text/javascript">
		$(document).ready(function(){
			$('.print').printPage();
		});
	</script> -->

<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>