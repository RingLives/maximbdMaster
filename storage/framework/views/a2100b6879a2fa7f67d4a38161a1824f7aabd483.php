<?php $__env->startSection('print-body'); ?>

    <center>
        <a href="#" onclick="myFunction()"  class="print">Print & Preview</a>
    </center>
    <?php ($ik = 0); ?>
    <?php $__currentLoopData = $headerValue; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
        <?php for($ik;$ik <= 0;$ik++): ?>
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
            <span>Purchase Order</span>
        </div>
    </div>
    <br>
        <div class="col-sm-4">
            <p>Date: <b><?php echo e(date('Y-m-d')); ?></b></p>
            <p>Company Name: <b><?php echo e($supplier->name); ?></b></p>
            <p>Company Address: <b><?php echo e($supplier->address); ?></b></p>
            <p>Mobile No: <b><?php echo e($supplier->phone); ?></b></p>
        </div>
    <br>
    <br>
        <div  style="background-color: #2b542c; color: #ffffff;" class="col-sm-3 col-sm-offset-5" align="center">

            <h4 class="PONoInList"> PO no: <?php echo e($purchaseOrders[0]->po_no); ?></h4>
        </div>

        <br>
        <br>
    <div class="row body-top">
        <table class="table table-bordered">
            <tr>
                <thead>
                <th>Serial no</th>
                <th>Checking no</th>
                <th>Delivery Date</th>
                <th>ERP code</th>
                <th>Item code</th>
                <th>Size</th>
                <th>Material</th>
                <th>Color</th>
                <th>Unit</th>
                <th>Quantity</th>
                <th>Unit Price($)</th>
                <th>Total Amount($)</th>
                </thead>
            </tr>

            <?php
                $j=1;
                $finalQnty = 0;
                $finalAmnt = 0;
            ?>
            
            <tbody>
                <?php $__currentLoopData = $purchaseOrders; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $purchaseOrder): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <?php
                        $erp_codes = explode(',', $purchaseOrder->erp_code);
                        $item_codes = explode(',', $purchaseOrder->item_code);
                        $sizes = explode(',', $purchaseOrder->item_sizes);
                        $materials = explode(',', $purchaseOrder->materials);
                        $gmts_colors = explode(',', $purchaseOrder->gmts_colors);
                        $units = explode(',', $purchaseOrder->units);
                        $item_quantitys = explode(',', $purchaseOrder->item_quantitys);
                        $unit_prices = explode(',', $purchaseOrder->unit_prices);
                        $total_amounts = explode(',', $purchaseOrder->total_amounts);
                        $spanLength = count($item_quantitys);

                        $totalQnty = $item_quantitys[0];
                        $totalAmnt = $total_amounts[0];
                    ?>
                    <tr>
                        <td><?php echo e($j++); ?></td>
                        <td rowspan="<?php echo e($spanLength); ?>" style="vertical-align: middle; /*horiz-align: middle;*/"><b><?php echo e($purchaseOrder->booking_order_id); ?></b></td>
                        <td rowspan="<?php echo e($spanLength); ?>" style="vertical-align: middle; /*horiz-align: middle;*/"><b><?php echo e($purchaseOrder->shipment_date); ?></b></td>
                        <td><?php echo e($erp_codes[0]); ?></td>
                        <td><?php echo e($item_codes[0]); ?></td>
                        <td><?php echo e($sizes[0]); ?></td>
                        <td><?php echo e($materials[0]); ?></td>
                        <td><?php echo e($gmts_colors[0]); ?></td>
                        <td><?php echo e($units[0]); ?></td>
                        <td><?php echo e($item_quantitys[0]); ?></td>
                        <td>$<?php echo e($unit_prices[0]); ?></td>
                        <td>$<?php echo e($total_amounts[0]); ?></td>
                    </tr>

                    <?php for($i = 1; $i <count($item_quantitys); $i++): ?>
                        <tr>
                            <td><?php echo e($j++); ?></td>
                            <td><?php echo e($erp_codes[$i]); ?></td>
                            <td><?php echo e($item_codes[$i]); ?></td>
                            <td><?php echo e($sizes[$i]); ?></td>
                            <td><?php echo e($materials[$i]); ?></td>
                            <td><?php echo e($gmts_colors[$i]); ?></td>
                            <td><?php echo e($units[$i]); ?></td>
                            <td><?php echo e($item_quantitys[$i]); ?></td>
                            <td>$<?php echo e($unit_prices[$i]); ?></td>
                            <td>$<?php echo e($total_amounts[$i]); ?></td>
                        </tr>
                        <?php
                        $totalQnty += floatval($item_quantitys[$i]);
                        $totalAmnt += floatval($total_amounts[$i]);
                        ?>
                    <?php endfor; ?>
                    <tr>
                        <td colspan="9"><b> Total</b></td>
                        <td><b><?php echo e($totalQnty); ?></b></td>
                        <td></td>
                        <td><b>$<?php echo e($totalAmnt); ?></b></td>
                    </tr>
                    <?php
                        $finalQnty += $totalQnty;
                        $finalAmnt += $totalAmnt;
                    ?>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                <tr>
                    <td colspan="9"><b>Final Total</b></td>
                    <td><b><?php echo e($finalQnty); ?></b></td>
                    <td><b>US$</b></td>
                    <td><b>$<?php echo e($finalAmnt); ?></b></td>
                </tr>
                <?php
                    // $test = 1000025.05;
                    // $f = new \NumberFormatter( locale_get_default(), \NumberFormatter::SPELLOUT );
                    // $word = $f->format($finalAmnt);
                ?>
                <tr>
                    <td colspan="12"><b>Dollar <?php echo e($finalAmnt); ?> only</b></td>
                </tr>
                <tr>
                    <td colspan="10" style="font-size: 85%;"><b>Quality Requirements</b></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="10" rowspan="2">
                        <p style="font-size: 80%;">1. All the products must be passed OEK-TEX testing grade I, color fastness to washng staining required grade 4-5. Dimensional stability should br controlled into -3%to +1%</p>
                        <p style="font-size: 80%;">2. Please ensure the color is matching with the sample, label size before and after folding must follow the sample, ensure the cutting edge is straight.</p>
                        <p style="font-size: 80%;">3. Please follow the lead time and offer more 1%-2% as the spare.</p>
                        <p style="font-size: 80%;">4. Please ensure the maximum packing no more than 500pcs/bag.</p>
                    </td>
                    <td style="font-size: 85%;"><b>Tax rate: </b></td>
                    <td></td>
                </tr>
                
                    
                    
                
                <tr>
                    <td colspan="2" style="font-size: 85%;"><b>SALES NO: </b></td>
                </tr>
                <tr>
                    <td colspan="7">
                        <p style="font-size: 80%;">1. Maxim Label & Packing (BD) Pvt., Ltd hereto referred to as(Buyer) and
                        (Seller) agree on the following payment terms: Seller needs to notify Buyer before delivery with Invoice,
                        Packing list, Order number, Product name and quantity needs to be shown on Carton Box. Once buyer
                        receive the goods from seller and have completed total QC insception, Payment will be mademwithin 3 months.</p>
                        <p style="font-size: 80%;">2. Seller is responsible and confirm understanding of Buyer order form to make
                        sure that all information is correct. Seller must follow Buyers order from and production specfications. If
                        there are any changes, Buyer needs to modify the seller by way of writing.</p>
                        <p style="font-size: 80%;">3. Quality: Seller must gurantee quality, quality and lead time to Seller in
                        accordance to the Sellers requirements. If there are any issues with quality, quantity and lead time, causing damges
                        to Buyer,seller is responsilbe for full payment of damages to Buyer.</p>
                        <p style="font-size: 80%;">4. Seller must consider all information, sample, artwork etc. given by Buyer as confidential information.</p>
                        <p style="font-size: 80%;">5. This orders will commence from date of signing fro both Buyer and Seller. Orginal concat will be
                        kept by Buyer. Contract of Place at Buyers office.</p>
                        <p style="font-size: 80%;">6. If threre are any disputes risen, the laws applicable will be law of place the contract
                         was concluded. Bangladesh law will apply.</p>
                        <p style="font-size: 80%;">7. This sales contract is valid for 3 days by return.</p>
                    </td>
                    <td colspan="5" style="font-size: 85%;"><b>
                        <div class="col-sm-6">
                            <br>
                            <br>
                            <br>
                            <br>
                            <br>
                            Buyer(Stamp)
                            Authorised signatory
                            <br>
                            <br>
                            <br>
                            <br>
                            <br>
                            Date:
                        </div>
                        <div class="col-sm-6">
                            <br>
                            <br>
                            <br>
                            <br>
                            <br>
                            Seller(Stamp)
                            Authorised signatory
                            <br>
                            <br>
                            <br>
                            <br>
                            <br>
                            Date:
                        </div>
                    </b></td>
                </tr>
            </tbody>
            
        </table>
    </div>

        
        
        
        
        

    
    
        
    




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

<?php echo $__env->make('print_file.layouts.layouts', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>