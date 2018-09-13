<?php $__env->startSection('title','Booking Maxim'); ?>
<?php $__env->startSection('print-body'); ?>
<?php
	$mn = 1;
	$getBuyerName = '';
	$TotalBookingQty = 0;
	foreach($bookingReport as $details){
		$getBuyerName = $details->buyer_name;
	}
?>
	<center>
		<div class="topPreviews">
			<a href="#" onclick="myFunction()"  class="print" id="print">Print & Preview</a>
		</div>
	</center>
<?php $__currentLoopData = $companyInfo; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
	<div class="row">
		<div class="col-md-2 col-sm-12 col-xs-12">
			<?php if($value->logo_allignment == "left"): ?>
				<?php if(!empty($value->logo)): ?>
					<div class="pull-left">
						<img src="/upload/58906.png" height="50px" width="150px" />
					</div>
				<?php endif; ?>
			<?php endif; ?>
		</div>
		<div class="col-md-8 col-sm-12 col-xs-12" style="padding-left: 40px;">
			<h2 align="center"><?php echo e($value->header_title); ?></h2>
			<div align="center">
				<p>OFFICE ADDRESS :  <?php echo e($value->address1); ?> <?php echo e($value->address2); ?> <?php echo e($value->address3); ?></p>
			</div>
		</div>
		<div class="col-md-2 col-sm-12 col-xs-12">
			<?php if($value->logo_allignment == "right"): ?>
				<?php if(!empty($value->logo)): ?>
					<div class="pull-right">
						<img src="/upload/<?php echo e($value->logo); ?>" height="100px" width="150px" />
					</div>
				<?php endif; ?>
			<?php endif; ?>
		</div>
	</div>
<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
<div class="row">
	<div style="background-color: #000;">
		<h3 align="center" style="color:#fff; padding:8px; font-weight: bold;">BOOKING FORM</h3>
	</div>

	<div style="padding-top: 10px;">
		<?php ($k =0); ?>
		<?php $__currentLoopData = $bookingReport; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $details): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
			<?php for($k;$k <= 0; $k++): ?>
			<div class="col-xs-6 col-md-6" style="padding-left: -40px">
				<!-- <div class="pull-left"> -->
					<span >Booking Date: <?php echo e(Carbon\Carbon::parse($details->created_at)->format('d-m-Y')); ?></span>
				<!-- </div> -->
			</div>
			<div class="col-xs-6 col-md-6">
				<div class="pull-right">
					<ul>
						<li>Booking No: <?php echo e($details->booking_order_id); ?></li>
						<li>Request Delivery Date: <?php echo e(Carbon\Carbon::parse($details->shipmentDate)->format('d-m-Y')); ?></li>
					</ul>
				<?php if($details->is_type == 'fsc'): ?>
					<ul style="border: 1px solid #ddd;padding: 5px; width:90%;float: right;">
						<li>
							<span style="padding-left: 5px; font-weight: bold;">FSC-MIX</span>
						</li>
						<li>
							<span style="padding-left: 5px; font-weight: bold;">License Code : FSC-C121666</span>
						</li>
					</ul>
				<?php endif; ?>
				</div>
			</div>
			<?php endfor; ?>
		<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
	</div>
</div>

<div class="row body-top">
	<div class="col-md-8 col-sm-8 col-xs-7 body-list">
		<ul>
			<li style="font-weight: bold;">Buyer : <?php echo e($getBuyerName); ?></li>
		</ul>
	</div>
	<div class="col-md-4 col-sm-4 col-xs-5">
	</div>
</div>
<?php $itemcodestatus = ''; ?>
<?php $__currentLoopData = $bookingReport; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $details): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
   	<?php
        $gmtsColor = explode(',', $details->gmtsColor);
        $itemSize = explode(',', $details->itemSize);
        $quantity = explode(',', $details->quantity);
        $idstrcount = (8 - strlen($details->id));
    ?>
	<table class="table table-bordered">
	    <thead>
	        <tr>
	        	<th>Job No.</th>
	        	<th width="15%">ERP Code</th>
	        	<th width="15%">Item / Code No.</th>
	        	<th>Season Code</th>
	        	<th>OOS No.</th>
	        	<th>Style</th>
	        	<th>PO/Cat No.</th>
	        	<th>GMTS Color</th>
	        	<th>Size</th>
	        	<th>Sku</th>
	        	<th>Order Qty</th>
	        	<th>Unit</th>
	        </tr>
	    </thead>
	    <tbody>
	    	<?php $rowspanValue = 0; ?>

		    <?php $__currentLoopData = $quantity; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $qtyValue): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>

		    	<?php $TotalBookingQty += $qtyValue; $rowspanValue += $rowspanValue +1; ?>

		    	<tr>
			    	<td><?php echo e(str_repeat('0',$idstrcount)); ?><?php echo e($details->id); ?></td>
			    	<!-- <td width="15%"><?php echo e($details->erp_code); ?></td> -->
			    	<?php if($itemcodestatus != $details->item_code): ?>
				    	<td width="15%" rowspan="<?php echo e(count($quantity)); ?>">
				    		<div><?php echo e($details->erp_code); ?></div>
				    	</td>
			    	<?php endif; ?>
			    	<!-- <td width="15%"><?php echo e($details->item_code); ?></td> -->
			    	<td width="15%"><?php echo e($details->oos_number); ?></td>
			    	<td width="15%"><?php echo e($details->season_code); ?></td>
			    	<td width="15%"><?php echo e($details->style); ?></td>
			    	<?php if($itemcodestatus != $details->item_code): ?>
				    	<td width="15%" rowspan="<?php echo e(count($quantity)); ?>">
				    		<div><?php echo e($details->item_code); ?></div>
				    	</td>
			    	<?php endif; ?>
			    	<!-- <td><?php echo e($details->poCatNo); ?></td> -->
			    	<?php if($itemcodestatus != $details->item_code): ?>
				    	<td rowspan="<?php echo e(count($quantity)); ?>">
				    		<div><?php echo e($details->poCatNo); ?></div>
				    	</td>
			    	<?php endif; ?>
			    	<td><?php echo e($gmtsColor[$key]); ?></td>
			    	<td><?php echo e($itemSize[$key]); ?></td>
			        <td><?php echo e($details->sku); ?></td>
			        <td><?php echo e($qtyValue); ?></td>
			        <!-- <td>PCS</td> -->
			        <?php if($itemcodestatus != $details->item_code): ?>
				    	<td rowspan="<?php echo e(count($quantity)); ?>">
				    		<div>PSC</div>
				    	</td>
			    	<?php endif; ?>
		        </tr>

		        <?php $itemcodestatus = $details->item_code; ?>

		    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

	    </tbody>
	</table>

	
<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
<table class="table table-bordered">
	<tr>
		<td>
			<span class="pull-right" style="font-weight: bold; padding-right: 20px;">Booking Total Qty : <?php echo e($TotalBookingQty); ?>

			</span>
		</td>
	</tr>	
</table>
<?php $__currentLoopData = $footerData; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
	<?php if(!empty($value->siginingPerson_2)): ?>
		<div class="row">
			<div class="col-md-12 col-xs-12" style="padding-bottom: 20px;">
				<div class="col-md-8 col-xs-8" style="padding: 5px; padding-left: 50px;">
					<?php if(!empty($value->siginingPersonSeal_2)): ?>
						<img src="/upload/<?php echo e($value->siginingPersonSeal_2); ?>" height="100px" width="150px" />
					<?php endif; ?>

					<?php if(!empty($value->siginingPerson_1)): ?>
						<div class="col-md-7 col-xs-7"  style="">
							<div align="center" style="margin:auto;
						    	border: 2px solid black;
						    	padding: 5px;margin-top:30px;">
								<?php echo e($value->siginingPerson_1); ?>

							</div>
						</div>
					<?php endif; ?>
				</div>
				
				<div class="col-md-4 col-xs-4"  style="">
					<div align="center">
						<?php if(!empty($value->siginingSignature_2)): ?>
							<img src="/upload/<?php echo e($value->siginingSignature_2); ?>" height="100px" width="150px" />
						<?php endif; ?>
					</div>

					<?php if(!empty($value->siginingPerson_2)): ?>
						<div align="center" style="margin:auto;
					    	border: 2px solid black;
					    	padding: 5px;margin-top:30px;">
							<?php echo e($value->siginingPerson_2); ?>

						</div>
					<?php endif; ?>
				</div>
			</div>
		</div>
	<?php endif; ?>
<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

	<script type="text/javascript">
		function myFunction() {
			$(".print").addClass("hidden");
		    window.print();
		}
	</script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('maxim.layouts.layouts', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>