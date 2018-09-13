<?php $__env->startSection('page_heading', "Booking List"); ?>
<?php $__env->startSection('section'); ?>
<style type="text/css">
	.b1{
		border-bottom-left-radius: 4px;
		border-top-right-radius: 0px;
	}
	.b2{
		border-bottom-left-radius: 0px;
		border-top-right-radius: 4px;
	}
	.btn-group .btn + .btn,
	 .btn-group .btn + .btn-group,
	  .btn-group .btn-group + .btn,
	   .btn-group .btn-group + .btn-group {
    margin-left: -5px;
}
</style>
	<?php if(Session::has('empty_booking_data')): ?>
        <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('empty_booking_data') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
    <?php endif; ?>
    
	<button class="btn btn-warning" type="button" id="booking_reset_btn">Reset</button>
	<div id="booking_simple_search_form">
		<div class="form-group custom-search-form col-sm-9 col-sm-offset-2">
			<input type="text" name="bookIdSearchFld" class="form-control" placeholder="Booking Id search" id="booking_id_search">
			<button class="btn btn-info" type="button" id="booking_simple_search_report">
				Search
			</button>
		</div>
		
		
		
		<button class="btn btn-primary " type="button" id="booking_advanc_search">Advance Search</button>
	</div>
	<div>
		<form id="advance_search_form"  style="display: none" method="post">
			<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
			<div class="col-sm-12">
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Order date from</label>
					<input type="date" name="from_oder_date_search" class="form-control" id="from_oder_date_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Order date to</label>
					<input type="date" name="to_oder_date_search" class="form-control" id="to_oder_date_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Shipment date from</label>
					<input type="date" name="from_shipment_date_search" class="form-control" id="from_shipment_date_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Shipment date to</label>
					<input type="date" name="to_shipment_date_search" class="form-control" id="to_shipment_date_search">
				</div>
			</div>
			<div class="col-sm-12">
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Buyer name</label>
					<input type="text" name="buyer_name_search" class="form-control" placeholder="Buyer name search" id="buyer_name_search">
				</div>
				<div class="col-sm-3">
					<label class="col-sm-12 label-control">Vendor name</label>
					<input type="text" name="company_name_search" class="form-control" placeholder="Company name search" id="company_name_search">
				</div>
				<!-- <div class="col-sm-3">
					<label class="col-sm-12 label-control">Attention</label>
					<input type="text" name="attention_search" class="form-control" placeholder="Attention search" id="attention_search">
				</div> -->
				<br>
				<div class="col-sm-3">
					<input class="btn btn-info" type="submit" value="Search" name="booking_advanceSearch_btn" id="booking_advanceSearch_btn">
				</div>
			</div>

			
			<button class="btn btn-primary" type="button" id="booking_simple_search_btn">Simple Search</button>
		</form>
	</div>
	<br>
<div class="booking_report_details_view" id="booking_report_details_view">
	

</div>
	<div class="row">
		<div class="col-md-12 col-md-offset-0">
			<table class="table table-bordered">
				<thead>
					<tr>
						<th>Job No.</th>
						<th>Buyer Name</th>
						<th>Vendor Name</th>
						<th>Attention</th>
						<th>Booking No.</th>
						<th>PI No.</th>
						<th>Order Date</th>
						<th>Shipment Date</th>
						<th>Item Code</th>
						<th>ERP Code</th>
						<th>Size</th>
						<th>Item Description</th>
						<th>Quantity</th>
						<th>Price/Pcs.</th>
						<th>Value</th>
					</tr>
				</thead>
				<?php 
					$fullTotalAmount = 0;
				?>
				<?php ($j=1); ?>
				<tbody id="booking_list_tbody">
				<?php $__currentLoopData = $bookingList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
					<?php 
						$ilc = 1;
						$TotalAmount = 0;
					?>
					<?php $__currentLoopData = $value->itemLists; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $valuelist): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
					<?php 
					$idstrcount = (8 - strlen($valuelist->id));
					if(count($value->itemLists) == 1){
					?>
					<tr id="booking_list_table">
						<td><?php echo e(str_repeat('0',$idstrcount)); ?><?php echo e($valuelist->id); ?></td>
						<td><?php echo e($value->buyer_name); ?></td>
						<td><?php echo e($value->Company_name); ?></td>
						<td><?php echo e($value->attention_invoice); ?></td>
						<td><?php echo e($value->booking_order_id); ?></td>
						<td><?php echo e($value->booking_order_id); ?></td>
						<td><?php echo e(Carbon\Carbon::parse($value->created_at)); ?></td>
						<td></td>
					<?php
					}else if(count($value->itemLists) > 1){
						if($ilc == 1){
							?>
							<tr id="booking_list_table">
								<td><?php echo e(str_repeat('0',$idstrcount)); ?><?php echo e($valuelist->id); ?></td>
								<td><?php echo e($value->buyer_name); ?></td>
								<td><?php echo e($value->Company_name); ?></td>
								<td><?php echo e($value->attention_invoice); ?></td>
								<td><?php echo e($value->booking_order_id); ?></td>
								<td><?php echo e($value->booking_order_id); ?></td>
								<td><?php echo e(Carbon\Carbon::parse($value->created_at)); ?></td>
								<td></td>
							<?php 
						}else{
							?>
							</tr>
							<tr id="booking_list_table">

							<?php 
						}
					}
					?>
							
					<?php 
					if(count($value->itemLists) == 1){
					?>

					<?php
					}else if(count($value->itemLists) > 1){
						if($ilc == 1){
							?>

							<?php 
						}else{
							?>
							<td><?php echo e(str_repeat('0',$idstrcount)); ?><?php echo e($valuelist->id); ?></td>
							<td colspan="7"></td>
							<?php 
						}
					}
					?>
							<td><?php echo e($valuelist->item_code); ?></td>
							<td><?php echo e($valuelist->erp_code); ?></td>
							<td><?php echo e($valuelist->item_size); ?></td>
							<td><?php echo e($valuelist->item_description); ?></td>
							<td><?php echo e($valuelist->item_quantity); ?></td>
							<td>$<?php echo e($valuelist->item_price); ?></td>
							<td>$<?php echo e($valuelist->item_quantity*$valuelist->item_price); ?></td>
							<?php
								$fullTotalAmount += $valuelist->item_quantity*$valuelist->item_price;
								$TotalAmount += $valuelist->item_quantity*$valuelist->item_price;
							?>
							</tr>
							<?php 
							if(count($value->itemLists) == 1){
							?>
							<tr>
								<td colspan="13"></td>
								<td><strong>Total :</strong></td>
								<td><strong>$<?php echo e(round($TotalAmount,2)); ?></strong></td>
							</tr>
							<?php
							}else if(count($value->itemLists) > 1){
								if($ilc == count($value->itemLists)){
									?>
									<tr>
										<td colspan="13"></td>
										<td><strong>Total :</strong></td>
										<td><strong>$<?php echo e(round($TotalAmount,2)); ?></strong></td>
									</tr>
									<?php 
								} 
							}
							?>
						<?php 
						$ilc = $ilc+1;
						?>
					<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
				<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
					<tr>
						<td colspan="13"></td>
						<td><strong>All Total :</strong></td>
						<td><strong>$<?php echo e(round($fullTotalAmount,2)); ?></strong></td>
					</tr>
				</tbody>
			</table>

			<div id="booking_list_pagination"><?php echo e($bookingList->links()); ?></div>
			<div class="pagination-container">
				<nav>
					<ul class="pagination"></ul>
				</nav>
			</div>
		</div>
	</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>