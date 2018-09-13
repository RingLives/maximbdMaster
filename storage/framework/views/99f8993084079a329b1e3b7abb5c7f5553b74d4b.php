<?php $__env->startSection('title','MRF Maxim'); ?>
<?php $__env->startSection('print-body'); ?>

	<center>
		<a href="#" onclick="myFunction()"  class="print">Print & Preview</a>
	</center>

	<?php ($i=0); ?>
	<?php $__currentLoopData = $headerValue; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
	<?php for($i;$i <= 0;$i++): ?>
	<div class="row">
		<div class="col-md-2 col-sm-2 col-xs-2">
			<?php if($value->logo_allignment == "left"): ?>
				<?php if(!empty($value->logo)): ?>
					<div class="pull-left">
						<img src="/upload/<?php echo e($value->logo); ?>" height="100px" width="150px" />
					</div>
				<?php endif; ?>
			<?php endif; ?>
		</div>
		<div class="col-md-8 col-sm-8 col-xs-8" style="padding-left: 40px;">
			<h2 align="center"><?php echo e($value->header_title); ?></h2>
			<div align="center">
					<p>FACTORY ADDRESS :  <?php echo e($value->address1); ?> <?php echo e($value->address2); ?> <?php echo e($value->address3); ?></p>
			</div>
		</div>
		<div class="col-md-2 col-sm-2 col-xs-2">
			<?php if($value->logo_allignment == "right"): ?>
				<?php if(!empty($value->logo)): ?>
					<div class="pull-right">
						<img src="/upload/<?php echo e($value->logo); ?>" height="100px" width="150px" />
					</div>
				<?php endif; ?>
			<?php endif; ?>
		</div>
	</div>
	<?php endfor; ?>
	<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
	<div class="row header-bottom">
		<div class="col-md-12 header-bottom-b">
			<span>MRF List</span>
		</div>
	</div>

	<div class="row body-top">
		<div class="col-md-8 col-sm-8 col-xs-7 body-list">
					<?php ($i=0); ?>
					<?php $__currentLoopData = $buyerDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $Details): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
					<?php for($i;$i <= 0;$i++): ?>
						<ul>
							<li>Buyer : <?php echo e($Details->buyer_name); ?></li>
							<li>Sold To : <?php echo e($Details->Company_name); ?></li>
							<li><?php echo e($Details->address_part1_invoice); ?>

						<?php echo e($Details->address_part2_invoice); ?></li>
							<li>Atten : <?php echo e($Details->attention_invoice); ?></li>
							<li>Cell : <?php echo e($Details->mobile_invoice); ?></li>
						</ul>
					<?php endfor; ?>
					<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
		</div>

		<div class="col-md-4 col-sm-4 col-xs-5 valueGenarate">
			<?php ($i=0); ?>
			<?php $__currentLoopData = $mrfDeatils; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $billdata): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
				<?php for($i;$i <= 0;$i++): ?>
				<table class="tables table-bordered" style="width: 100%;">
					<tr>
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;"> MRF No : <?php echo e($billdata->mrf_id); ?></p>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;">Booking No : <?php echo e($billdata->booking_order_id); ?>  </p>

								<!-- <?php echo e(Carbon\Carbon::parse($billdata->created_at)->format('dmY')); ?>: -->
							</div>
						</td>
					</tr>
					</div>
				</table>
			<?php endfor; ?>
			<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

		</div>
	</div>

<div class="row">
	<div class="col-md-12">
		<h4>Dear Sir</h4>
		<p>We take the Plasure in issuing PROFORM INVOICE for the following article (s) on the terms and conditions set forth here under</p>
	</div>
</div>


<table class="table table-bordered">
    <thead>
        <tr>
        	<th width="4%">SI No</th>
        	<th width="15%">Description</th>
        	<th width="10%">Item code</th>
        	<!-- <th width="10%">OSS</th> -->
            <!-- <th width="10%">Style</th> -->
            <th width="14%">Color</th>
            <th width="14%">Size</th>
            <th width="7%">MRF Quantity</th>
        </tr>
    </thead>
    <tbody>
    	<?php
    		$j = 1;
    		$i = 0;
    		$totalAllQty = 0;
    		$totalUsdAmount = 0;
    		$BDTandUSDavarage = 80;
    		// print_r("<pre>");
    		// print_r($sentBillId);die();
    	 ?>
    		<?php $__currentLoopData = $mrfDeatils; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>

    			<?php
    				$totalQty =0;
    				$itemsize = explode(',', $item->item_size);
    				$itemcolor = explode(',', $item->gmts_color);
    				$qty = explode(',', $item->mrf_quantity);
    				$itemlength = 0;
    				foreach ($itemsize as $itemlengths) {
    					$itemlength = sizeof($itemlengths);
    				}
    				$itemQtyValue = array_combine($itemsize, $qty);

    				$emptyCheckMrf = 0;
    				foreach ($qty as $mrfQtys) {
    					$emptyCheckMrf += $mrfQtys;
    				}
    			?>
    			<?php if( $emptyCheckMrf > 0): ?>
	    			<tr>
	    				<td><?php echo e($j++); ?></td>
	    				<td><?php echo e($item->erp_code); ?></td>
	    				<td><?php echo e($item->item_code); ?></td>

						<?php if($itemlength >= 1 ): ?>
							<td colspan="3" class="colspan-td">
								<table>
									<?php $__currentLoopData = $qty; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $quantity): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
									<tr>
										<td width="40%"><?php echo e($itemcolor[$key]); ?></td>
										<td width="40%"><?php echo e($itemsize[$key]); ?></td>
										<td width="20%" style="text-align: center;"><?php echo e($quantity); ?></td>
									</tr>
										<?php 
											$i++;
											$totalQty += $quantity;
										 ?>
									<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

									<?php if( $i > 1 ): ?>
									<tr>
										<td colspan="2" style="text-align: center; font-weight: bold;">Item Total</td>
										<td style="font-weight: bold; text-align: center;" ><?php echo e($totalQty); ?></td>
									</tr>
									<?php endif; ?>
								</table>
							</td>
						<?php endif; ?>

			    		<?php
    						$totalAllQty += $totalQty;
    					?>
	    			</tr>
	    		<?php endif; ?>
    		<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

    	<tr>
			<td colspan="5"><div style="text-align: center; font-weight: bold;font-size: ;"><span>Total Qty </span></div></td>
			<td style="text-align: center;"><?php echo e($totalAllQty); ?></td>
		</tr>
		<tr>
			<td colspan="5"><div style="text-align: center;font-weight: bold;font-size: ;"><span> Total weight & Box : </span></div></td>
			<td style="text-align: center;"><?php echo e($totalAllQty); ?></td>
		</tr>

    </tbody>
</table>

<h5><strong>REMARK</strong></h5>
<p>If the quantity of goods you recevied is not in confirmity as in packing irst or the qualify, packing problem incurred, please
inform us in 3days. After this period, you concern about this goods shall not be our responsibility.</p>
<h5>Please confirm receipt with your signature: </h5><br><br>




<?php $__currentLoopData = $footerData; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
<?php if(!empty($value->siginingPerson_1)): ?>
<div class="row">
	<div class="col-md-12 col-xs-12" style="padding-bottom: 20px;">


		<div class="col-md-8 col-xs-8" style="padding: 5px; padding-left: 50px;">
			<?php if(!empty($value->siginingPersonSeal_1)): ?>
				<img src="/upload/<?php echo e($value->siginingPersonSeal_1); ?>" height="100px" width="150px" />
			<?php endif; ?>
		</div>

		<div class="col-md-4 col-xs-4"  style="">
			<div align="center">
				<?php if(!empty($value->siginingSignature_1)): ?>
				<img src="/upload/<?php echo e($value->siginingSignature_1); ?>" height="100px" width="150px" />
				<?php endif; ?>
			</div>
			<div align="center" style="margin:auto;
		    	border: 2px solid black;
		    	padding: 5px;margin-top:30px;">
				<?php echo e($value->siginingPerson_1); ?>

			</div>
		</div>

	</div>
</div>
<?php endif; ?>
<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

<?php $__currentLoopData = $footerData; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
<?php if(!empty($value->siginingPerson_2)): ?>
<div class="row">
	<div class="col-md-12 col-xs-12" style="padding-bottom: 20px;">


		<div class="col-md-8 col-xs-8" style="padding: 5px; padding-left: 50px;">
			<?php if(!empty($value->siginingPersonSeal_2)): ?>
				<img src="/upload/<?php echo e($value->siginingPersonSeal_2); ?>" height="100px" width="150px" />
			<?php endif; ?>
		</div>

		<div class="col-md-4 col-xs-4"  style="">
			<div align="center">
				<?php if(!empty($value->siginingSignature_2)): ?>
					<img src="/upload/<?php echo e($value->siginingSignature_2); ?>" height="100px" width="150px" />
				<?php endif; ?>
			</div>
			<div align="center" style="margin:auto;
		    	border: 2px solid black;
		    	padding: 5px;margin-top:30px;">
				<?php echo e($value->siginingPerson_2); ?>

			</div>
		</div>
	</div>
</div>
<?php endif; ?>
<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>


<script type="text/javascript">
		function myFunction() {
	    window.print();
	}
</script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('maxim.layouts.layouts', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>