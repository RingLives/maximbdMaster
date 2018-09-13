<?php $__env->startSection('title','PI Maxim'); ?>
<?php $__env->startSection('print-body'); ?>
<?php 
	$objectConvertController = new App\Http\Controllers\Source\ConverterText();
?>
<center>
	<a href="#" onclick="myFunction()" class="print">Print & Preview</a>
</center>

<?php $__currentLoopData = $companyInfo; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
	<div class="row">
		<div class="col-md-2 col-sm-12 col-xs-12">
			<?php if($value->logo_allignment === "left"): ?>
				<?php if(!empty($value->logo)): ?>
					<div class="pull-left">
						<img src="/upload/<?php echo e($value->logo); ?>" height="100px" width="150px" />
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
			<?php if($value->logo_allignment === "right"): ?>
				<?php if(!empty($value->logo)): ?>
					<div class="pull-right">
						<img src="/upload/<?php echo e($value->logo); ?>" height="100px" width="150px" />
					</div>
				<?php endif; ?>
			<?php endif; ?>
		</div>
	</div>
<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
<div class="row header-bottom">
	<div class="col-md-12 header-bottom-b">
		<span>PROFORM INVOICE</span>
	</div>
</div>

<div class="row body-top">
	<div class="col-md-8 col-sm-8 col-xs-7 body-list">
		<?php ($is=0); ?>
		<?php $__currentLoopData = $bookingDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $Details): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
			<?php for($is;$is <= 0;$is++): ?>
				<ul>
					<li>Buyer : <?php echo e($Details->buyer_name); ?></li>
					<li>Company Name  : <?php echo e($Details->Company_name); ?></li>
					<li>Address : <?php echo e($Details->address_part1_invoice); ?></li>
					<li> <?php echo e($Details->address_part2_invoice); ?>

					</li>
					<li><?php echo e(($formatTypes == 1001 )?'Contact ' :'Attn'); ?> : <?php echo e($Details->attention_invoice); ?></li>
					<li><?php echo e(($formatTypes == 1001 )?'Contact No ' :'Cell No'); ?> : <?php echo e($Details->mobile_invoice); ?></li>
				</ul>
			<?php endfor; ?>
		<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
	</div>
	
	<div class="col-md-4 col-sm-4 col-xs-5 valueGenarate">
		<?php ($i=0); ?>
		<?php $__currentLoopData = $bookingDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $details): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
			<?php for($i;$i <= 0;$i++): ?>
				<table class="tables table-bordered" style="width: 100%;">
					<tr>
						<td colspan="2">
							<div style="text-align: right;">
								<p style="padding-left :5px;"> PI No : <?php echo e($details->booking_order_id); ?> </p>
							</div>
						</td>
					</tr>
					<tr>
						<td width="50%" style="border-bottom-style:hidden;border-left-style:hidden;"> </td>
						<td width="50%">
							<div style="text-align: right;">
								<p style="padding-left :5px;"> Date : <?php echo e(Carbon\Carbon::parse($details->created_at)->format('Y-m-d')); ?></p>
							</div>
						</td>
					</tr>
						<tr>
							<td width="50%" style="border-bottom-style:hidden;border-left-style:hidden;"> </td>
							<td width="50%">
								<div style="text-align: right;">
									<p style="padding-left :5px;">FSC-MIX</p>
								</div>
							</td>
						</tr>
						<tr>
							<td width="50%" style="border-bottom-style:hidden;border-left-style:hidden;"> </td>
							<td width="50%">
								<div style="text-align: right;">
									<p style="padding-left :5px;">FSC-C121666</p>
								</div>
							</td>
						</tr>		
				</table>
			<?php endfor; ?>
		<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>		
	</div>
</div>

<div class="row">
	<div class="col-md-12 col-xs-12 col-sm-12">
		<h4>Dear Sir</h4>
		<p>We take the Plasure in issuing PROFORM INVOICE for the following article (s) on the terms and conditions set forth here under :</p>
	</div>
</div>
<?php
	$ih = 0;
	$totalUsdAmount = 0;
	$totalAllqnty = 0;
	$picate = [];

	$countTotalspan = 0;
	if($formatTypes == 1001){
		$countTotalspan = 5;
	}else{
		$countTotalspan = 5;
	}
	$rr = 0;
	foreach($bookingDetails as $Details){
		$picate[$rr][] = $Details->poCatNo;
		$picate[$rr][] = $Details->item_code;
		$rr++;
	}

	$BDTandUSD = 0;

	// print_r("<pre>");
	// print_r($picate);
	// print_r("</pre>");
?>
<table class="table table-bordered">
	<thead>
	    <tr>
	    	<?php if(1001 == $formatTypes): ?>
	    	<?php else: ?>
	    		<th width="">SL</th>
	    	<?php endif; ?>
	    	<th width="">PO / NO </th>
	    	<th width="19%">Item code</th>
	    	<th width="15%">Item no/ERP</th>
	    	<?php if(1001 == $formatTypes): ?>
	    		<th width="">Color</th>
	    	<?php endif; ?>
	        <th width="">Descreption</th>
	        <th width="">Qty / Pcs</th>
	        <th width="">Unit Price / Pcs</th>
	        <th width="15%">USD Amount / USD</th>
	    </tr>
	</thead>
	<tbody>
		<?php ($j=1); ?>
		<?php $__currentLoopData = $bookingDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $Details): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
			<?php
				$gmtsquantity = explode(',', $Details->quantity);
				$totalQntyValue = 0;
				foreach ($gmtsquantity as $qtyValue) {
					$totalQntyValue = $totalQntyValue + $qtyValue;
				}
				$totalPrice = $totalQntyValue * $Details->item_price;

				$totalAllqnty = $totalAllqnty + $totalQntyValue;
				$totalUsdAmount = $totalUsdAmount + $totalPrice;
				
				// print_r("<pre>");
				// print_r($Details);
				// print_r("</pre>");
			?>

			<tr>
				<?php if(1001 == $formatTypes): ?>
	    		<?php else: ?>
					<td><?php echo e($j++); ?></td>
				<?php endif; ?>
				<td><?php echo e($Details->poCatNo); ?></td>
				<td width="19%"><?php echo e($Details->item_code); ?></td>
				<td width="15%"><?php echo e($Details->erp_code); ?></td>
				<?php if(1001 == $formatTypes): ?>
					<td>Color</td>
				<?php endif; ?>
				<td><?php echo e($Details->item_description); ?></td>
				<td><?php echo e($totalQntyValue); ?></td>
				<td><?php echo e((!empty($Details->item_price)? '$'.$Details->item_price: '')); ?></td>
				<td><?php echo e((!empty($totalPrice)? '$'.$totalPrice: '')); ?></td>
			</tr>
		<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>		
			<tr>
				<td colspan="<?php echo e($countTotalspan); ?>"> <center><?php echo e((1003 == $formatTypes)?'TOTAL QTY & VALUE':'Total'); ?></center></td>
				<td><?php echo e($totalAllqnty); ?></td>
				<td></td>
				<td><?php echo e((!empty($totalUsdAmount)? '$'.$totalUsdAmount: '')); ?></td>
			</tr>
	
	</tbody>
</table>
	<?php
		 $fractionUSD = explode('.', $totalUsdAmount);
		 $amountInWordUsd = $objectConvertController->convertNumberToWord($fractionUSD[0]);
		 if(sizeof($fractionUSD) > 1){
		 	$fractionInWordUSD = $objectConvertController->convertNumberToWord($fractionUSD[1]);
		 }
		 

		 $fractionBD = explode('.', $BDTandUSD);
		 $amountInWordBD = $objectConvertController->convertNumberToWord($fractionBD[0]);
		 if(sizeof($fractionBD) > 1){
		 	$fractionInWordBD = $objectConvertController->convertNumberToWord($fractionBD[1]);
		 }
	?>
<div class="row">
	<div class="col-md-12 col-xs-12">
		<table  border="5px solid #DBDBDB" class="table table-bordered">
			<tr>
				<td>					
					<div style="text-align:;font-weight: bold;">
						<?php if(sizeof($fractionUSD) == 1){ ?>

						<span>1. TOTAL AMOUNT : USD : <?php echo e($amountInWordUsd); ?> <?php echo e((empty($amountInWordUsd))?'':'USD Only'); ?></span>

						<?php }else{?>

						<span>1. TOTAL AMOUNT : USD : <?php echo e($amountInWordUsd); ?> And <?php echo e($fractionInWordUSD); ?> Cents BDT Only</span>

						<?php }?>
					</div>
				</td>
			</tr>
			<!-- <tr>
				<td>
					<div style="text-align:;font-weight: bold;">
						<?php if(sizeof($fractionBD) == 1){?>
						<span>1. TOTAL AMOUNT : BDT : <?php echo e($amountInWordBD); ?> Only</span>
						<?php }else{?>
						<span>1. TOTAL AMOUNT : BDT : <?php echo e($amountInWordBD); ?> And <?php echo e($fractionInWordBD); ?> Cents Only</span>
						<?php }?>
					</div>
				</td>
			</tr> -->
		</table>
	</div>
</div>

<div class="row body-top">
	<div class="col-md-12 col-xs-12 body-list">
		<ul>
			<li>2.Payment Terms : TT/FDD/CHAQUE/CASH BEFORENSHIPMENT</li>
			<li>3.Shipment : By COURIER/ CARGO</li>
			<li>4. Packing : MAXIM STANDARD PACKING</li>
			<li>2.Payment Terms: BBLC/ CHAQUE/ CASH BEFORE SHIPMENT</li>
			<li>3.Shipment: FOB</li>
			<li>4.Packing: MAXIM STANDARD PACKING
			<li>5.Delivery: ETD 2018-01-25
			Beneficiary Bank: EASTERN BANK LTD. 
			Beneficiary: MAXIM LABEL & PACKAGING (BD) PVT. LTD</li>
			<li>Account Number:1041060234447</li>
			<li>Tax no (TIN) : 549978367844</li>
			<li>Vat No : 5011070061</li>
			<li>HS CODE: 48114110</li>
			<li>BIN NO :  000412786</li>
			<li>Origin : BANGLADESH</li>
			<li>Payment : 01.By Irrevocable Letter of Credit (L/C) to be opened in our favor to be Advised through "Eastern Bank Limited,Dhaka Main Office, Jibon Bima Bhabon, 10, Dilkusha C/A, Dhaka - 1000, Bangladesh and Original L/C must be received to Our Bank.</li>
			<li>02. Bill of Exchange will be Signed by the Applicant before Submitting to the Applicant's Bank.</li>
			<li>03. Payment to be made in US Dollar within 60/30/90 days or Sight from the Date of Delivery.</li>
			<li>04. Payment reimbursement proceeds through FDD/Cheque in Foreign Currency (US Dollar) Drawn on Bangladesh Bank.</li>
			<li>05. Overdue interest to be paid for delayed period at 12% p@ from the date of Maturity .</li>
			<li>06. All charge (Swift,Payment ,Reimbursement,Handling fee,etc) will bear by applicant</li>
			<li>07. Maturity date will be calculated from the date of delivery.</li>
			<li>08.No Discrepancy clause will be accepted for the local Back to Back LC.</li>
			<li>09.Presentation Period is 15 days from the date of delivery.</li>
			<li>10.Delivery Challan & Bill of Exchange must be Sign (by Buyer Authorized Person)  within 07 (Seven) Days from the date of Submisshion. </li>
</li>
		</ul>
	</div>
</div>

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
	    window.print();
	}
</script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('maxim.layouts.layouts', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>