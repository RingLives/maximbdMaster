<?php $__env->startSection('title','Challan Maxim'); ?>
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
			<span>Challan / Packing List</span>
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
			<?php $__currentLoopData = $multipleChallan; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $billdata): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
				<?php for($i;$i <= 0;$i++): ?>
				<table class="tables table-bordered" style="width: 100%;">
					<tr >
						
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;"> Date : <?php echo e(Carbon\Carbon::now()->format('Y-m-d')); ?></p>
							</div>
						</td>
					</tr>
					<tr>
						
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;"> Challan no :<?php echo e($billdata->challan_id); ?></p>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;">Booking order No :<?php echo e($billdata->checking_ids_of_challan); ?>  </p>

								<!-- <?php echo e(Carbon\Carbon::parse($billdata->created_at)->format('dmY')); ?>: -->
							</div>
						</td>
					</tr>
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
        	<th width="5%">SI No</th>
        	<th width="15%">Checking Id</th>
        	<th width="15%">Description</th>
        	<th width="15%">Item code</th>
        	<th width="5%">OSS</th>
            <th width="5%">Style</th>
            <th width="14%">Size</th>
            <th width="14%">Color</th>
            <th width="6%">Quantity</th>
            <th width="5%">Weight</th>
            <th width="5%">Box</th>
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
    		<?php $__currentLoopData = $multipleChallan; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>

    			<?php
    				$totalQty =0;
    				$itemsize = explode(',', $item->item_size);
    				$qty = explode(',', $item->quantity);
    				$clr = explode(',', $item->gmts_color);
    				$itemlength = 0;
    				foreach ($itemsize as $itemlengths) {
    					$itemlength = sizeof($itemlengths);
    				}
    				$itemQtyValue = array_combine($itemsize, $qty);
    			?>
	    			<tr>
	    				<td><?php echo e($j++); ?></td>
	    				<td rowspan="<?php echo e($itemlength); ?>"><?php echo e($item->checking_id); ?></td>
	    				<td rowspan="<?php echo e($itemlength); ?>"><?php echo e($item->erp_code); ?></td>
	    				<td rowspan="<?php echo e($itemlength); ?>"><?php echo e($item->item_code); ?></td>
	    				<td rowspan="<?php echo e($itemlength); ?>"><?php echo e($item->oss); ?></td>
			    		<td rowspan="<?php echo e($itemlength); ?>"><?php echo e($item->style); ?></td>

			    			<?php if($itemlength >= 1 ): ?>
				    			<td colspan="3" class="colspan-td">
				    				<table>
				    					<?php $__currentLoopData = $itemsize; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key=>$value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
				    					<?php
				    						$i++;
				    						$totalQty += $qty[$key];
				    					?>
				    					<tr>
				    						<td width="39%"><?php echo e($value); ?></td>
							    			<td width="42%"><?php echo e($clr[$key]); ?></td>
							    			<td width="19%"><?php echo e($qty[$key]); ?></td>
				    					</tr>
				    					<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

				    					<?php if( $i > 1 ): ?>
				    					<tr>
				    						<td width="40%"></td>
				    						<td width="40%"></td>
				    						<td width="20%"><?php echo e($totalQty); ?></td>
				    					</tr>
				    					<?php endif; ?>
				    				</table>
				    			</td>
				    		<?php endif; ?>
			    		<td rowspan="<?php echo e($itemlength); ?>"></td>

			    		<?php
    						$totalAllQty += $totalQty;
    					?>
    					<td></td>
	    			</tr>
    		<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
    	
    	<tr>
			<td colspan="8"><div style="text-align: center; font-weight: bold;font-size: ;"><span>Total Qty </span></div></td>
			<td><?php echo e($totalAllQty); ?></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="9"><div style="text-align: center;font-weight: bold;font-size: ;"><span> Total weight & Box : </span></div></td>
			<td></td>
			<td></td>
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