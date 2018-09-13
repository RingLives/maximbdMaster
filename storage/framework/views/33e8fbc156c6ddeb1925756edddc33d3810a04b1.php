<?php $__env->startSection('page_heading',trans('others.translation_list_label')); ?>
<?php $__env->startSection('section'); ?>

<?php $__env->startSection('section'); ?>
	<div >
		<div class="col-md-3">
			<a href="<?php echo e(Route('create_translation_action')); ?>"> <?php echo $__env->make('widgets.button', array('class'=>'success', 'value'=>trans('others.add_new_key_label')), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?></a>
		</div>

        <div class="input-group custom-search-form col-md-7 col-md-offset-4">
            <input type="text" class="form-control" placeholder="<?php echo e(trans('others.search_the_translation_key_placeholder')); ?>" name="searchFld" id="searchFld">
            <button class="btn btn-default" type="button">
                <i class="fa fa-search"></i>
            </button>
            <p id="search"></p>
        </span>
        </div>

		<div id="hide_me">
	        <div class="col-md-8 col-md-offset-1">
	        	<nav aria-label="Page navigation example">
					<ul class="pagination">
						<?php if($currentPage > 1): ?>
							<li class="page-item">
								<a class="page-link" href="<?php echo e(Route('manage_translation')); ?>/<?php echo e($currentPage-1); ?>" aria-label="Previous">
								<span aria-hidden="true">&laquo;</span>
								<span class="sr-only">Previous</span>
								</a>
							</li>
				        <?php endif; ?>
				        <?php for($i = 1; (($i-1)*$limitPerPage)<$totalTrans; $i++): ?>
			        		<?php if($currentPage == $i): ?>
								<li class="active page-item"><a class="page-link" href="#" onclick='return false'><strong> <?php echo e($i); ?></strong></a></li>
			        		<?php else: ?>
								<li class="page-item"><a class="page-link" href="<?php echo e(Route('manage_translation')); ?>/<?php echo e($i); ?>"> <?php echo e($i); ?></a></li>
			        		<?php endif; ?>
			        	<?php endfor; ?>
			        	<?php if($currentPage*$limitPerPage < $totalTrans): ?>
				        	<li class="page-item">
								<a class="page-link" href="<?php echo e(Route('manage_translation')); ?>/<?php echo e($currentPage+1); ?>" aria-label="Next">
								<span aria-hidden="true">&raquo;</span>
								<span class="sr-only">Next</span>
								</a>
							</li>
			        	<?php endif; ?>
					</ul>
				</nav>
	        	
	        </div><br><br>
			<table class="table table-bordered">
	            <thead>
	                <tr>
						<th><?php echo e(trans('others.translation_key_label')); ?></th>
						<th><?php echo e(trans('others.language_label')); ?></th>
						<th><?php echo e(trans('others.language_label')); ?></th>
						<th><?php echo e(trans('others.status_label')); ?></th>
						<th><?php echo e(trans('others.action_label')); ?></th>
	                </tr>
	            </thead>
	            <tbody>
		            <?php $__currentLoopData = $translations; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $translation): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
						<?php 
							$explode_lan_name = explode(',', $translation['lan_name']);
							$explode_trans_value = explode(',', $translation['trans_value']);
							$total_rowspan = count($explode_trans_value);

							reset($explode_lan_name);
							$first_key = key($explode_lan_name);
						 ?>
						<tr>
							<td rowspan="<?php echo e($total_rowspan); ?>" style="vertical-align: middle;" > <?php echo e($translation['trans_key']); ?></td>
							<td> <?php echo e($explode_trans_value[0]); ?> </td>
							<td> <?php echo e($explode_lan_name[0]); ?> </td>
							<td rowspan="<?php echo e($total_rowspan); ?>" style="vertical-align: middle;" ><?php echo e(($translation['status'] == 1)? trans('others.action_active_label'):trans('others.action_inactive_label')); ?></td>
							<td rowspan="<?php echo e($total_rowspan); ?>" style="vertical-align: middle;" > <a href="<?php echo e(Route('update_translation_action')); ?>/<?php echo e($translation['key_id']); ?>"> <?php echo $__env->make('widgets.button', array('class'=>'success', 'value'=>trans('others.edit_button')), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?> </a>
							<a class="delete_id" href="<?php echo e(Route('delete_translation_action')); ?>/<?php echo e($translation['key_id']); ?>"> <?php echo $__env->make('widgets.button', array('class'=>'danger', 'value'=>trans('others.delete_button')), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?> </a>
							</td>
						</tr>
						<?php for($i=1 ; $i<$total_rowspan ; $i++): ?>
							<tr>
								<td> <?php echo e($explode_trans_value[$i]); ?> </td>
								<td> <?php echo e($explode_lan_name[$i]); ?> </td>
							</tr>
						<?php endfor; ?>
					<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
	            </tbody>
	        </table>
		</div>

		<div id="result">
			
		</div>
	</div>
<?php $__env->stopSection(); ?>


















<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>