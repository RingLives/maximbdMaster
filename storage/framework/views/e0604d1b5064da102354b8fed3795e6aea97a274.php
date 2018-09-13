<?php $__env->startSection('page_heading', trans("others.mxp_menu_challan_list")); ?>
<?php $__env->startSection('section'); ?>
	<button class="btn btn-warning" type="button" id="challan_reset_btn">Reset</button>
	<div id="challan_simple_search_form">
		<div class="form-group custom-search-form col-sm-9 col-sm-offset-2">
			<input type="text" name="challanIdSearchFld" class="form-control" placeholder="Challan Id search" id="challan_id_search">
			<button class="btn btn-info" type="button" id="challan_simple_search">
				Search
			</button>
		</div>
		<button class="btn btn-primary " type="button" id="challan_advanc_search">Advance Search</button>
	</div>
	<div>
		<form id="challan_advance_search_form"  style="display: none" method="post">
			<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
			<div class="col-sm-4">
				<label class="col-sm-12 label-control">Booking Id</label>
				<input type="text" name="booking_id_search" class="form-control" placeholder="Booking Id search" id="booking_id_search">
			</div>
			<div class="col-sm-8">
				<div class="col-sm-5">
					<label class="col-sm-12 label-control">Create date from</label>
					<input type="date" name="from_create_date_search" class="form-control" id="from_create_date_search">
				</div>
				<div class="col-sm-4">
					<label class="col-sm-12 label-control">Create date to</label>
					<input type="date" name="to_create_date_search" class="form-control" id="to_create_date_search">
				</div>
				<br>
				<div class="col-sm-3">
					<input class="btn btn-info" type="submit" value="Search" name="challan_advanceSearch_btn" id="challan_advanceSearch_btn">
				</div>
			</div>
			<button class="btn btn-primary" type="button" id="challan_simple_search_btn">Simple Search</button>
		</form>
	</div>
	<br>
	<div class="row">
		<div class="col-md-12 col-md-offset-0">
			<table class="table table-bordered">
				<tr>
					<thead>
					<th>Serial no</th>
					<th>Booking Id</th>
					<th>Challan Id</th>
					<th>Create Date</th>
					<th>Action</th>
					</thead>
				</tr>
				<?php ($j=1 + $challanDetails->perPage() * ($challanDetails->currentPage() - 1)); ?>
				<tbody id="challan_list_tbody">
				<?php $__currentLoopData = $challanDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
					<tr id="challan_list_table">
						<td><?php echo e($j++); ?></td>
						<td><?php echo e($value->checking_ids_of_challan); ?></td>
						<td><?php echo e($value->challan_id); ?></td>
						<td><?php echo e(Carbon\Carbon::parse($value->created_at)); ?></td>
						<td>
							<form action="<?php echo e(Route('challan_list_action_task')); ?>" role="form" target="_blank">
								<input type="hidden" name="cid" value="<?php echo e($value->challan_id); ?>">
								<input type="hidden" name="bid" value="<?php echo e($value->checking_id); ?>">
								<button class="btn btn-success" target="_blank">View</button>
							</form>
						</td>
					</tr>
				<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
				</tbody>
			</table>
			<div id="challan_list_pagination"><?php echo e($challanDetails->links()); ?>

			</div><div class="pagination-container">
				<nav>
					<ul class="pagination"></ul>
				</nav>
			</div>
		</div>
	</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>