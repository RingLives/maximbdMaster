<?php $__env->startSection('page_heading', trans("others.mxp_menu_challan_boxing_list") ); ?>
<?php $__env->startSection('section'); ?>

<?php $__env->startSection('section'); ?>
<?php
	// print_r("<pre>");
	// print_r($challanHistory);
	// print_r("</pre>");
?>
    <div class="container-fluid">
    	<?php if(Session::has('erro_challan')): ?>
            <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
		<?php endif; ?>
		<div class="row">
			<div class="col-md-12 col-md-offset-0">
				
				<div class="panel panel-default">
					<div class="panel-heading"><?php echo e(trans('others.mxp_menu_challan_boxing_list')); ?></div>
					<div class="panel-body">
							<?php if(!empty($bookingDetails)): ?>							
							<!-- <div class="col-md-12"> -->
								<!-- <span style="font-size:15px;padding-bottom: 15px;">Challan data for edit</span> -->
								<form class="form-horizontal" role="form" method="POST" action="<?php echo e(Route('multiple_challan_action_task')); ?>">
									<input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

									<table class="table table-bordered table-striped" >
										<thead>
											<tr>
												<th>SerialNo</th>
												<th width="">ERP Code</th>
												<th width="">Item Code</th>
												<th width="">Item Size</th>
												<th width="">Item Color</th>
												<th width="">Challan Quantity</th>
												<th width="">Booking Quantity</th>
												<th width="">Delivery Quantity</th>
												<th width="">Balance Quantity</th>
											</tr>
										</thead>
										<?php
										   $i=1;

										 ?>
										<?php $itemcodestatus = ''; ?>
										<?php $__currentLoopData = $bookingDetails; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>

											<?php
							    				$itemsize = explode(',', $item->item_size);
							    				$qty = explode(',', $item->item_quantity);
							    				$colors  =explode(',', $item->gmts_color);
//							    				$itemQtyValue = array_combine($itemsize, $qty);
//                                                $bookingIds = explode(',',$item->booking_order_id);
                                            $bookingIdList = explode(',',$item->booking_order_id);
//                                                $bookingIdList = array_unique($bookingIds);

//                                                print_r("<pre>");
//												print_r($qty);
//                                            	print_r($itemsize);
//                                            print_r($itemsize);
//                                            print_r("<pre>");

                                                $challanIdList = explode('_',$item->booking_challan_id);
//                                                $challanIdList = array_unique($booking_challan_ids);

//                                                var_dump($challanIdList);
							    			?>
										<tbody>

											<?php $it = 0; ?>
											<?php $__currentLoopData = $itemsize; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key=>$value/* $size => $Qty*/): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
											<tr>
												<td>
													<?php if($itemcodestatus != $item->item_code): ?>
														<?php echo e($i++); ?>

													<?php endif; ?>
												</td>
												<td>
													<?php if($itemcodestatus != $item->item_code): ?>
														<?php echo e($item->erp_code); ?>

													<?php endif; ?>
												</td>
												<td>
													<?php if($itemcodestatus != $item->item_code): ?>
														<?php echo e($item->item_code); ?>

													<?php endif; ?>
												</td>
												
								    				

								    					<?php if(empty($value)): ?>
								    					
								    						<td ></td>
															<td >
																<?php echo e($colors[$key]); ?>

															</td>
											    			<td width="50%" class="aaa">
											    				<input type="hidden" name="allId[]" value="<?php echo e($challanIdList[$it]); ?>">
																<input type="text" class="form-control item_quantity" name="product_qty[]" meta:index="<?php echo e($qty[$key]); ?>" value="<?php echo e($qty[$key]); ?>">
																<input type="hidden" name="itemDetails[]" value="<?php echo e($item->erp_code.'~'.$item->item_code.'~'.$value.'~'.$colors[$key]); ?>">
											    			</td>
		    			    								<?php
                                                                $orderItemQuantity = 0;
                                                                foreach ($bookingIdList as $bookingId){

                                                                    $orderItemQuantity += App\Http\Controllers\taskController\TaskController::getOrderQuantity($bookingId,$item->item_code, null, $colors[$key]);
                                                                }
//                                                                echo $orderItemQuantity;
//		    				    								$orderItemQuantity = App\Http\Controllers\taskController\TaskController::getOrderQuantity($item->booking_order_id,$item->item_code);
		    				    								$deliverredQuantity = ($orderItemQuantity - $qty[$key]);
		    			    								?>
		    			    								<td width=""><?php echo $orderItemQuantity; ?></td>
		    			    								<td width=""><?php echo $deliverredQuantity; ?></td>
		    			    								<td width=""><?php echo e($qty[$key]); ?></td>
											    		
								    					<?php else: ?>
								    					
								    						<td>
								    							<?php echo e($value); ?>

								    						</td>
								    						<td>
								    							<?php echo e($colors[$key]); ?>

								    						</td>
											    			<td width="50%" class="aaa">
								    							<input type="hidden" name="allId[]" value="<?php echo e($challanIdList[$it]); ?>">
								    							<input type="hidden" name="itemDetails[]" value="<?php echo e($item->erp_code.'~'.$item->item_code.'~'.$value.'~'.$colors[$key]); ?>">
								    							<div class="question_div">
																<input type="text" class="form-control item_quantity" name="product_qty[]" meta:index="<?php echo e($qty[$key]); ?>" value="<?php echo e($qty[$key]); ?>">
											    				</div>
											    			</td>
							    								<?php
                                                                    $orderItemQuantity = 0;
                                                                    foreach ($bookingIdList as $bookingId){

                                                                        $orderItemQuantity += App\Http\Controllers\taskController\TaskController::getOrderQuantity($bookingId,$item->item_code,$value, $colors[$key]);

//                                                                        echo $bookingId." qnty ".$orderItemQuantity." code ".$item->item_code." // ";
                                                                    }
//								    								$orderItemQuantity = App\Http\Controllers\taskController\TaskController::getOrderQuantity($item->booking_order_id,$item->item_code,$value);
								    								$deliverredQuantity = ($orderItemQuantity - $qty[$key]);
							    								?>
							    			    			<td width=""><?php echo $orderItemQuantity; ?></td>
							    			    			<td width=""><?php echo $deliverredQuantity; ?></td>
							    			    			<td width=""><?php echo e($qty[$key]); ?></td>
								    					
								    					<?php endif; ?>
												<?php $it++; ?>

								    				
								    			
											</tr>
											<?php
												$itemcodestatus = $item->item_code;
											?>
											<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
										</tbody>
										<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
										
									</table>


									<div class="form-group ">
										<div class="col-md-6 col-md-offset-10">
											<button type="submit" class="btn btn-primary" id="rbutton">
												<?php echo e(trans('others.genarate_bill_button')); ?>

											</button>
										</div>
									</div>
								</form>
							<!-- </div> -->

							<?php if(!empty($multipleChallanList)): ?>
								<span style="font-size:15px;">Multiple Challan list</span>
								<table class="table table-bordered">
									<thead>
										<th>Serial No</th>
										<th>Invo no</th>
										<th>Challan no</th>
									</thead>
									<?php ($k = 1); ?>
									<?php $__currentLoopData = $multipleChallanList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $ChallanList): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
										<tr>
											<td><?php echo e($k++); ?></td>
											<td><?php echo e($ChallanList->bill_id); ?></td>
											<td><?php echo e($ChallanList->challan_id); ?></td>
										</tr>
									<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
								</table>
							<?php endif; ?>
						<?php endif; ?>
					</div>
				</div>
			</div>
		</div>
	</div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>