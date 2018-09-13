<?php $__env->startSection('page_heading',
trans('others.update_product_label')); ?>
<?php $__env->startSection('section'); ?>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"rel="stylesheet">

    

<div class="container-fluid">
        <div class="row">
             <div class="col-md-12 ">   <!--col-md-offset-2 -->
            	<?php if(count($errors) > 0): ?>
                    <div class="alert alert-danger" role="alert">
                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                          <li><span><?php echo e($error); ?></span></li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </div>
                <?php endif; ?>

                <div class="panel panel-default">
                    <div class="panel-heading"><?php echo e(trans('others.update_product_label')); ?></div>
                    <div class="panel-body">
                        <?php $__currentLoopData = $product; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $data): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                
                        <form class="form-horizontal" action="<?php echo e(Route('update_product_action')); ?>/<?php echo e($data->product_id); ?>" method="POST" autocomplete="off">
                            <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">

                            <div class="row">
                                <div class="col-sm-12 col-md-6">
                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_code_label')); ?></label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control  input_required" name="p_code" value="<?php echo e($data->product_code); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_name_label')); ?></label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="p_name" value="<?php echo e($data->product_name); ?>">
                                        </div>
                                    </div>                         

                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_description_label')); ?></label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="p_description" value="<?php echo e($data->product_description); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_brand_label')); ?></label>
                                       <div class="col-md-6">
                                            <select class="form-control " name="p_brand" required value="">                   
                                                 <option value="<?php echo e($data->brand); ?>"><?php echo e($data->brand); ?></option>
                                                 <?php $__currentLoopData = $brands; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $brand): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                 <option value="<?php echo e($brand->brand_name); ?>"><?php echo e($brand->brand_name); ?></option>
                                                 <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?> 
                                            </select>
                                        </div>
                                    </div>   

                                                                    
                                    <div class="form-group">
                                        <label class="col-md-4 control-label">Color</label>
                                        <div class="col-md-6">
                                            <div class="product-brand-list" style="width:80%; float: left;">

                                                <select class="select-color-list" name="colors[]" multiple="multiple">
                                                    <option value="">Choose Color</option>
                                                    <?php $__currentLoopData = $colors; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $color): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                        <option value="<?php echo e($color->id); ?>,<?php echo e($color->color_name); ?>"><?php echo e($color->color_name); ?></option>
                                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                                </select>

                                            </div>
                                            <div class="add-color-btn" style="width:20%; float: left; padding-top: 5px;">
                                                <a class="hand-cursor"  data-toggle="modal" data-target="#addColorModal">
                                                    <i class="material-icons">
                                                        add_circle_outline
                                                    </i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    


                                    
                                    <div class="form-group">
                                        <label class="col-md-4 control-label">Size</label>
                                        <div class="col-md-6">
                                            <div class="product-size-list" style="width:80%; float: left;">

                                                <select class="select-size-list" name="sizes[]" multiple="multiple">
                                                    <option value="">Choose Size</option>
                                                    <?php $__currentLoopData = $sizes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $size): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                        <option value="<?php echo e($size->proSize_id); ?>,<?php echo e($size->product_size); ?>"><?php echo e($size->product_size); ?></option>
                                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                                </select>
                                            </div>
                                            <div class="add-brand-btn" style="width:20%; float: left; padding-top: 5px;">
                                                <a class="hand-cursor" data-toggle="modal" data-target="#addSizeModal">
                                                    <i class="material-icons">
                                                        add_circle_outline
                                                    </i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    

                                 

                                    <!-- <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.others_color_label')); ?></label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="others_color" value="<?php echo e($data->others_color); ?>">
                                        </div>
                                    </div> -->

                                </div>


                                <div class="col-md-6 col-sm-12">

                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_erp_code_label')); ?></label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control  input_required" name="p_erp_code" value="<?php echo e($data->erp_code); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_unit_price_label')); ?></label>
                                        <div class="col-md-6">
                                            <div style="width:100%; float: left;">
                                                <input type="text" class="form-control" name="p_unit_price" value="<?php echo e($data->unit_price); ?>">
                                            </div>
                                            <div class="add-vendor-com-price-btn" style=" width:100%; float: left; padding-top: 5px;">
                                                <a style="float:left;" class="hand-cursor" data-toggle="modal" data-target="#addVendorComPrice">
                                                    <i class="material-icons">
                                                        add_circle_outline
                                                    </i>
                                                </a>
                                                <small style="float: left; padding-top: 4px;">
                                                    Vendor Price
                                                </small>


                                                <a style=" padding-left:5px; float: left;" class="hand-cursor" data-toggle="modal" data-target="#addSupplierPrice">
                                                    <i class="material-icons">
                                                        add_circle_outline
                                                    </i>
                                                </a>
                                                <small style="float: left; padding-top: 4px;">
                                                    Vendor Price
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_weight_qty_label')); ?></label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="p_weight_qty" value="<?php echo e($data->weight_qty); ?>">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_weight_amt_label')); ?></label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="p_weight_amt" value="<?php echo e($data->weight_amt); ?>">
                                        </div>
                                    </div>

                                    
                                        
                                        
                                            
                                                
                                                    
                                                        
                                                        
                                                    
                                                        
                                                        
                                                    

                                                
                                            
                                        
                                    

                                    <div class="form-group">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.product_type_label')); ?></label>
                                        <div class="col-sm-6">
                                            <div class="select">
                                                <select class="form-control" type="select" name="product_type" >
                                                    <?php if($data->product_type == 'MRF'): ?>
                                                        <option  value="MRF" >MRF</option>
                                                        <option value="IPO" >IPO</option>
                                                    <?php else: ?>
                                                        <option value="IPO" >IPO</option>
                                                        <option  value="MRF" >MRF</option>
                                                    <?php endif; ?>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group ipo_increase_percentage" style="display: none;">
                                        <label class="col-md-4 control-label"><?php echo e(trans('others.ipo_increase_percentage')); ?></label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="item_inc_percentage" value="<?php echo e($data->item_inc_percentage); ?>">
                                        </div>
                                    </div>



                                    <div class="form-group">
                                        <label class="col-md-4">Product Status</label>
                                        <div class="col-md-6">
                                            <div class="select">
                                                <select class="form-control" type="select" name="is_active" >
                                                    <option value="<?php echo e($data->status); ?>">
                                                        <?php echo e(($data->status == 1) ? "Active" : "Inactive"); ?>

                                                    </option>

                                                    <option  value="1" name="is_active" ><?php echo e(trans('others.action_active_label')); ?></option>
                                                    <option value="0" name="is_active" ><?php echo e(trans('others.action_inactive_label')); ?></option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>



                            <!-- Add Vendor Company Price-->
							<div class="modal fade" id="addVendorComPrice" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
								<div class="modal-dialog" role="document">
									<div class="modal-content">
										<div class="modal-body">
											<div class="panel panel-default">
												<div class="panel-heading">Vendor Company Price
													<button type="button" class="close" data-dismiss="addVendorComPrice" aria-label="Close">
														<span aria-hidden="true">&times;</span>
													</button>
												</div>

												<div class="panel-body">


													



													<?php if($errors->any()): ?>
														<div class="alert alert-danger">
															<ul>
																<?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
																	<li><?php echo e($error); ?></li>
																<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
															</ul>
														</div>
													<?php endif; ?>


													<?php $__currentLoopData = $vendorCompanyListPrice; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $vCom): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
														<input type="hidden" name="price_id[]" value="<?php echo e($vCom->price_id); ?>" >
                                                        <input type="hidden" name="party_table_id[]" value="<?php echo e($vCom->party_table_id); ?>" >

														<div class="col-md-4">
															
															<input type="text" class="form-control" value="<?php echo e($vCom->party->name_buyer); ?>" disabled>
														</div>

														<div class="col-md-5">
															
															<input type="text" class="form-control" value="<?php echo e($vCom->party->name); ?>" disabled>
														</div>

														<div class="col-md-3">
															
															<input type="text" class="form-control" name="v_com_price[]" value="<?php echo e($vCom->vendor_com_price); ?>" placeholder="Enter Price">
														</div>
													<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                                                    <?php $__currentLoopData = $vendorCompanyList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $vCom): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                        <input type="hidden" name="party_table_id[]" value="<?php echo e($vCom->id); ?>" >

                                                        <div class="col-md-4">
                                                            
                                                            <input type="text" class="form-control" value="<?php echo e($vCom->name_buyer); ?>" disabled>
                                                        </div>

                                                        <div class="col-md-5">
                                                            
                                                            <input type="text" class="form-control" value="<?php echo e($vCom->name); ?>" disabled>
                                                        </div>

                                                        <div class="col-md-3">
                                                            
                                                            <input type="text" class="form-control" name="v_com_price[]" value="" placeholder="Enter Price">
                                                        </div>
                                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

													

														<div class="form-group">
															<div class="col-md-2 col-md-offset-10">
																<button class="btn btn-primary vendor-price-btn" style="margin-right: 15px;">
																	<?php echo e(trans('others.save_button')); ?>

																</button>
															</div>
														</div>
													
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>



                            <!-- Add Supplier Price-->
                            <div class="modal fade" id="addSupplierPrice" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog" role="document">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="panel panel-default">
                                                <div class="panel-heading">Supplier Price
                                                    <button type="button" class="close" data-dismiss="addSupplierPrice" aria-label="Close">
                                                        <span aria-hidden="true">&times;</span>
                                                    </button>
                                                </div>

                                                <div class="panel-body">

                                                    <?php if($errors->any()): ?>
                                                        <div class="alert alert-danger">
                                                            <ul>
                                                                <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                                    <li><?php echo e($error); ?></li>
                                                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                                            </ul>
                                                        </div>
                                                    <?php endif; ?>

                                                    <?php $__currentLoopData = $supplierPrices; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $supplierPrice): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                        <input type="hidden" name="supplie_price_id[]" value="<?php echo e($supplierPrice->supplier_price_id); ?>" >
                                                        <input type="hidden" name="supplier_id[]" value="<?php echo e($supplierPrice->supplier_id); ?>" >
                                                        <input type="hidden" name="price_id[]" value="<?php echo e($supplierPrice->price_id); ?>" >

                                                        <div class="col-md-5 col-md-offset-2">
                                                            <input type="text" class="form-control" value="<?php echo e($supplierPrice->supplier->name); ?>" disabled>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <input type="text" class="form-control" name="supplier_price[]" value="<?php echo e($supplierPrice->supplier_price); ?>" placeholder="Enter Price">
                                                        </div>
                                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                                                    <?php $__currentLoopData = $supplierList; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $supplier): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                        <input type="hidden" name="supplier_id[]" value="<?php echo e($supplier->supplier_id); ?>" >

                                                        <div class="col-md-5 col-md-offset-2">
                                                            <input type="text" class="form-control" value="<?php echo e($supplier->name); ?>" disabled>
                                                        </div>

                                                        <div class="col-md-4">
                                                            <input type="text" class="form-control" name="supplier_price[]" value="" placeholder="Enter Price">
                                                        </div>
                                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                                                    <div class="form-group">
                                                        <div class="col-md-2 col-md-offset-10">
                                                            <button class="btn btn-primary supplier-price-btn" style="margin-right: 15px;">
                                                                <?php echo e(trans('others.save_button')); ?>

                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>



                            
                            <div class="form-group">
	                            <div class="col-md-offset-10">
                                    <button type="submit" class="btn btn-primary" style="margin-right: 15px;">
                                        <?php echo e(trans('others.update_button')); ?>

                                	</button>
                                </div>
                            </div>
                        </form>

                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(".selections").select2();
        // $(".select-color-list").select2();
        // $(".select-size-list").select2();

        var selectedColors = $(".select-color-list").select2();
        var selectedSizes = $(".select-size-list").select2();

       var colors = <?php echo json_encode($colorsJs); ?>;
        var sizes = <?php echo json_encode($sizesJs); ?>;

        selectedColors.val(colors).trigger("change");
        selectedSizes.val(sizes).trigger("change");
    </script>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('product_management.product_modal', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>