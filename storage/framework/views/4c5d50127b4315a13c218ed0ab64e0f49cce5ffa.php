<?php $__env->startSection('page_heading', trans("others.mxp_menu_booking_view_details") ); ?>
<?php $__env->startSection('section'); ?>
    <?php 
        // print_r("<pre>");
        // print_r($bookingDetails->ipo);
        // print_r("</pre>");
    ?>
    <div class="panel panel-default">
        <div class="panel-heading">
            <div class="col-sm-3" style="font-size: 120%">Booking Details</div>
            <!-- <div class="col-sm--3 col-sm-offset-9 "><a href="" class="btn btn-success">Generate Purchase Invoice</a></div> -->
        </div>
        <div class="panel-body aaa">
            <div class="panel panel-default col-sm-7">
                <br>
                <p >Buyer name:<b> <?php echo e($bookingDetails->buyer_name); ?></b></p>
                <p >Company name:<b> <?php echo e($bookingDetails->Company_name); ?></b></p>
                <p >Buyer address:<b> <?php echo e($bookingDetails->address_part1_invoice); ?><?php echo e($bookingDetails->address_part2_invoice); ?></p>
                <p >Mobile num:<b> <?php echo e($bookingDetails->mobile_invoice); ?></b></p>
            </div>
            <div class="panel panel-default col-sm-5">
                <br>
                <p >Booking Id:<b> <?php echo e($bookingDetails->booking_order_id); ?></b></p>
                <p >Booking status:<b> <?php echo e($bookingDetails->booking_status); ?></b></p>
                <p >Oreder Date:<b> <?php echo e($bookingDetails->bookings[0]->orderDate); ?></b></p>
                <p >Shipment Date:<b> <?php echo e($bookingDetails->bookings[0]->shipmentDate); ?></b></p>
            </div>
            <table class="table table-bordered">
                <tr>
                    <thead>
                        <th>Serial no</th>
                        <th>ERP code</th>
                        <th>Item Code</th>
                        <th>Item Size</th>
                        <th>Item Color</th>
                        <th>Quantity</th>
                        <th>Price</th>
                    </thead>
                </tr>
                <?php 
                    $j=1;
                 ?>
                <tbody>
                <?php $__currentLoopData = $bookingDetails->bookings; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $bookedItem): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <tr>
                    <td> <?php echo e($j++); ?> </td>
                    <td>
                        <?php echo e($bookedItem->erp_code); ?>

                    </td>
                    <td> <?php echo e($bookedItem->item_code); ?> </td>
                    <td> <?php echo e($bookedItem->item_size); ?> </td>
                    <td> <?php echo e($bookedItem->gmts_color); ?> </td>
                    <td> <?php echo e($bookedItem->item_quantity); ?> </td>
                    <td> <?php echo e($bookedItem->item_price); ?> </td>
                </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </tbody>
            </table>
        </div>
    </div>
    <div class="panel panel-default">
        <div class="panel-heading" style="font-size: 120%">Mrf Details</div>
        <div class="panel-body aaa">
            <table class="table table-bordered">
                <tr>
                    <thead>
                        <th>Serial no</th>
                        <th>MRF Id</th>
                        <th>Item Code</th>
                        <th>Color</th>
                        <th>Item Size</th>
                        <th>MRF Quantity</th>
                        <th>Delivered Quantity</th>
                        <th>MRF Shipment Date</th>
                        <th>MRF Status</th>
                        <th>Action</th>
                    </thead>
                </tr>
                <?php ($j=1); ?>
                <tbody>
                <?php $__currentLoopData = $bookingDetails->mrf; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <?php 
                    $gmts_color = explode(',', $value->gmts_color);
                    $itemsize = explode(',', $value->item_size);
                    $mrf_quantity = explode(',', $value->mrf_quantity);
                ?>
                <tr>
                    <td><?php echo e($j++); ?></td>
                    <td><?php echo e($value->mrf_id); ?></td>
                    <td><?php echo e($value->item_code); ?></td>
                    <td class="colspan-td">
                        <table id="sampleTbl">
                            <?php $__currentLoopData = $gmts_color; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $gmtsColor): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($gmtsColor); ?></td>
                            </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </table>
                    </td>
                    <td class="colspan-td" width="18%">
                        <table id="sampleTbl">
                            <?php $__currentLoopData = $itemsize; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $valuess): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($valuess); ?></td>
                            </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </table>
                    </td>
                    <td class="colspan-td">
                        <table id="sampleTbl">
                            <?php $__currentLoopData = $mrf_quantity; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $mrfQuantity): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($mrfQuantity); ?></td>
                            </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </table>
                    </td>
                    <td>Delivered Quantity</td>
                    <td><?php echo e($value->shipmentDate); ?></td>
                    <td><?php echo e($value->mrf_status); ?></td>
                    <td>Action</td>
                </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </tbody>
            </table>
        </div>
    </div>
    
    <div class="panel panel-default">
        <div class="panel-heading" style="font-size: 120%">IPO Details</div>
        <div class="panel-body aaa">
            <table class="table table-bordered">
                <tr>
                    <thead>
                        <th>Serial no</th>
                        <th>IPO Id</th>
                        <th>Item Code</th>
                        <th>Color</th>
                        <th>Item Size</th>
                        <th>IPO Quantity</th>
                        <th>Delivered Quantity</th>
                        <th>IPO Shipment Date</th>
                        <th>IPO Status</th>
                        <th>Action</th>
                    </thead>
                </tr>
                <?php ($j=1); ?>
                <tbody>

                <?php $__currentLoopData = $bookingDetails->ipo; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <?php 
                    $gmts_color = explode(',', $value->gmts_color);
                    $itemsize = explode(',', $value->item_size);
                    $ipo_quantity = explode(',', $value->ipo_quantity);
                ?>
                <tr>
                    <td><?php echo e($j++); ?></td>
                    <td><?php echo e($value->ipo_id); ?></td>
                    <td><?php echo e($value->item_code); ?></td>
                    <td class="colspan-td">
                        <table id="sampleTbl">
                            <?php $__currentLoopData = $gmts_color; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $gmtsColor): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($gmtsColor); ?></td>
                            </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </table>
                    </td>
                    <td class="colspan-td" width="18%">
                        <table id="sampleTbl">
                            <?php $__currentLoopData = $itemsize; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $valuess): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($valuess); ?></td>
                            </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </table>
                    </td>
                    <td class="colspan-td">
                        <table id="sampleTbl">
                            <?php $__currentLoopData = $ipo_quantity; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $ipoQuantity): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <tr>
                                <td><?php echo e($ipoQuantity); ?></td>
                            </tr>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </table>
                    </td>
                    <td>Delivered Quantity</td>
                    <td><?php echo e($value->shipmentDate); ?></td>
                    <td><?php echo e($value->ipo_status); ?></td>
                    <td>Action</td>
                    <!-- <td><?php echo e(Carbon\Carbon::parse($value->created_at)); ?></td> -->
                </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </tbody>
            </table>
        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>