<?php $__env->startSection('page_heading',trans('others.update_report_footer_label')); ?>
<?php $__env->startSection('section'); ?>

<?php $__env->startSection('section'); ?>
    <div class="container-fluid">
    						<?php if($errors->any()): ?>
							    <div class="alert alert-danger">
							        <ul>
							            <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
							                <li><?php echo e($error); ?></li>
							            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
							        </ul>
							    </div>
							<?php endif; ?>

		<div class="row">		
			<div class="col-md-12">
				<div class="panel panel-default">
					<div class="panel-heading"><?php echo e(trans('others.page_footer_title_label')); ?></div>
					<div class="panel-body">
						<?php $__currentLoopData = $datas; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $data): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
						<form class="" role="form" method="POST" action="<?php echo e(route('update_report_action')); ?>/<?php echo e($data->re_footer_id); ?>"
							enctype="multipart/form-data">
							<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
							<div class="row">
							<div class="col-md-12">							
								<div class="form-group">
									<div class="col-md-2"></div>
	                                <label class="col-md-2 control-label"><?php echo e(trans('others.report_name_label')); ?></label>
	                                <div class="col-md-6">
	                                    <input type="text" class="form-control" name="report_name" value="<?php echo e($data->reportName); ?>">
	                                </div>
	                            </div>

	                            <div class="form-group">
									<div class="col-md-3 col-md-offset-4">
										<div class="select">
											<select class="form-control" type="select" name="isActive" >
												<option  value="1" name="isActive" ><?php echo e(trans('others.action_active_label')); ?></option>
												<option value="0" name="isActive" ><?php echo e(trans('others.action_inactive_label')); ?></option>
										   </select>
										</div>
									</div>
								</div>
			                </div>
			                </div>

			                <div class="row">
			                <div class="col-md-12">
								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-heading"><?php echo e(trans('others.re_fo_siginingPerson_1_label')); ?></div>
										<div class="panel-body">

											<div class="form-group">
												<div class="col-md-2"></div>
				                                <label class="col-md-2 control-label"><?php echo e(trans('others.person_name_label')); ?></label>
				                                <div class="col-md-6">
				                                    <input type="text" class="form-control" name="per1_name" value="<?php echo e($data->siginingPerson_1); ?>">
				                                </div>
				                            </div>

											<div class="form-group">
				                                <label class="col-md-4 control-label"><?php echo e(trans('others.person_1_signature')); ?></label>
				                                <div class="col-md-8">
				                                    <input type="file" class="" name="signature_1" value="<?php echo e(old('signature_1')); ?>">
				                                </div>
				                            </div>

				                            <div class="form-group">
				                                <label class="col-md-4 control-label"><?php echo e(trans('others.persion_seal_label')); ?></label>
				                                <div class="col-md-8">
				                                    <input type="file" class="" name="seal_1" value="<?php echo e(old('seal_1')); ?>">
				                                </div>
				                            </div>
										</div>
									</div>

								</div>

								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-heading"><?php echo e(trans('others.re_fo_siginingPerson_2_label')); ?></div>
										<div class="panel-body">

											<div class="form-group">
												<div class="col-md-2"></div>
				                                <label class="col-md-2 control-label"><?php echo e(trans('others.person_name_label')); ?></label>
				                                <div class="col-md-6">
				                                    <input type="text" class="form-control" name="per2_name" value="<?php echo e($data->siginingPerson_2); ?>">
				                                </div>
				                            </div>

											<div class="form-group">
				                                <label class="col-md-4 control-label"><?php echo e(trans('others.person_1_signature')); ?></label>
				                                <div class="col-md-8">
				                                    <input type="file" class="" name="signature_2" value="<?php echo e(old('signature_2')); ?>">
				                                </div>
				                            </div>

				                            <div class="form-group">
				                                <label class="col-md-4 control-label"><?php echo e(trans('others.persion_seal_label')); ?></label>
				                                <div class="col-md-8">
				                                    <input type="file" class="" name="seal_2" value="<?php echo e(old('seal_2')); ?>">
				                                </div>
				                            </div>
				                        </div>

									</div>

								</div>
							</div>
							</div>

							<div class="row">
							<div class="col-md-12">
								<div class="form-group">
		                            <div class="col-md-offset-10">
	                                    <button type="submit" class="btn btn-primary" style="margin-right: 15px;">
	                                        <?php echo e(trans('others.update_button')); ?>

	                                	</button>
	                                </div>
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
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>