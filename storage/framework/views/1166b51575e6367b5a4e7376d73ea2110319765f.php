<?php $__env->startSection('page_heading',''); ?>
<?php $__env->startSection('section'); ?>
    <?php if(Session::has('empty_booking_data')): ?>
        <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('empty_booking_data') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
    <?php endif; ?>
    <?php if(Session::has('erro_challan')): ?>
        <?php echo $__env->make('widgets.alert', array('class'=>'danger', 'message'=> Session::get('erro_challan') ), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
    <?php endif; ?>
    <style type="text/css">
        .showTask{
            background-color: #f9f9f9;
            border-radius: 10px;
            box-sizing: border-box;
            box-shadow: 0 10px 20px rgba(0,0,0,0.10), 0 6px 6px rgba(0,0,0,0.15);
            z-index: 999;
        }
        .showTask .inputForm{
            padding-top: 15px;
        }
        .top-div{
            background-color: #f9f9f9;
            padding:5px 0px 5px 10px;
            border-radius: 7px;
        }
        #show_preloder{
            padding-bottom: 15px;
        }
    </style>
<div class="add_preload">
    <div class="row">
        <div class="col-md-8 col-sm-8 col-xs-12 col-md-offset-2 col-xs-offset">
            <div class="panel panel-default">
                <!-- <div class="panel-heading"></div> -->
                <div class="panel-body showTask">

                    <form class="form-horizontal inputForm" role="form" method="POST" action="<?php echo e(Route('task_action')); ?>">
                            <input type="hidden" name="_token" value="<?php echo e(csrf_token()); ?>">
                            <input type="hidden" name="bookingIdList" id="hiddenBookingIdList">

                            <?php if($errors->any()): ?>
                                <div class="alert alert-danger">
                                    <ul>
                                        <?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $error): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                            <li><?php echo e($error); ?></li>
                                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                    </ul>
                                </div>
                            <?php endif; ?>

                            <div class="form-group">
                                <label class="col-md-4 control-label">
                                    <span class="pull-right">Task Type</span>
                                </label>
                                <div class="col-md-6">
                                    <select name="taskType" class="form-control" id="taskType">
                                        <option value="">Select Task Type</option>
                                        <?php
if (isset($taskAccessList) && !empty($taskAccessList)) {
	foreach ($taskAccessList as $taskkey) {
		print '<option value="' . $taskkey . '">' . ucwords($taskkey) . '</option>';
	}
}
?>
                                    </select>
                                </div>
                            </div>
                            <?php if (isset($taskAccessList) && !empty($taskAccessList)) {
	?>

                            <div class="form-group buyerChange hidden">
                                <label class="col-md-4 control-label">
                                    <span class="pull-right">Buyer Name</span>
                                </label>
                                <div class="col-md-6">
                                    <select name="buyerName" class="form-control" id="buyerChange" disabled="true">
                                        <option value="">Choose buyer Name</option>
                                        <?php
$buyerName = [];
	foreach ($selectBuyer as $value) {
		$buyerName[] = $value->name_buyer;
	}
	$unique_data = array_unique($buyerName);
	?>

                                        <?php $__currentLoopData = $unique_data; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $buyer): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                            <option><?php echo e($buyer); ?></option>
                                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                                    </select>
                                </div>
                            </div>

                            <div class=" buyer_company form-group hidden">
                                <label class="col-md-4 control-label">
                                    <span class="pull-right">Company Name</span>
                                </label>
                                <div class="col-md-6">
                                    <select name="companyName" class="form-control" id="companyName" disabled="true">
                                    </select>
                                </div>
                            </div>

                            <!-- <div class="form-group piFormatH">
                                <label class="col-md-4 control-label">
                                    <span class="pull-right">PI Format</span>
                                </label>
                                <div class="col-md-6">
                                    <select name="piFormat" class="form-control" disabled="true" id="piFormat">
                                        <option>Choose Format</option>
                                        <option value="1001">CRAGHOPPERS</option>
                                        <option value="1002">REGATTA</option>
                                        <option value="1003">DARE2B</option>
                                        <option>PI Format 4</option>
                                    </select>
                                </div>
                            </div> -->

                            <div class="form-group conversion_rate hidden">
                                <label class="col-md-4 control-label">
                                    <span class="pull-right">Conversion Rate</span>
                                </label>
                                <div class="col-md-6">
                                    <input type="text" name="conversion_rate" class="form-control">
                                </div>
                            </div>

                            <div class="form-group orderId hidden">
                                <label class="col-md-4 control-label">
                                    <span class="pull-right">Order Id</span>
                                </label>
                                <div class="col-md-6">
                                    <input type="text" name="bookingId" class="form-control bookingId" disabled="true" id="bookingId" placeholder="Booking Id">
                                    
                                    

                                    <div id="bookingIdList"></div>
                                </div>
                            </div>

                            <div class="ipo_increase form-group hidden">
                                <label class="col-md-4 control-label">
                                    <span class="pull-right">IPO Increase Percentage (Optional)</span>
                                </label>
                                <div class="col-md-6">
                                    <input type="text" name="ipoIncrease" class="form-control" disabled="true" id="ipoIncrease" placeholder="Increase Value Percentage">
                                </div>
                            </div>
                            <?php }?>
                            <div class="form-group">
                                <div class="col-md-4"></div>
                                <div class="col-md-4">
                                    <button type="submit" class="btn btn-primary form-control" style="margin-right: 15px;">Submit
                                        <!-- <?php echo e(trans('others.save_button')); ?> -->
                                    </button>
                                </div>
                                 <div class="col-md-5"></div>
                            </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
<?php if (isset($taskAccessList) && !empty($taskAccessList)) {?>
<div class="row hidden" id="show_preloder">
    <div class="col-md-12 col-xs-12 col-sm-12">
        <div class="top-div">
                    <div class="row">
                        <div class="col-md-6 col-xs-6">
                            <div class="form-group">
                                <label class="col-md-4">Buyer name</label>

                                <div class="">
                                    <input type="text" name="buyerName" class="form-control" readonly="true" value="" title="Buyer Name">
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 col-xs-6">
                            <div class="form-group " >
                                <label class="col-md-4">Company name</label>

                                <div class="" >
                                    <input type="text" name="CompanyName" class="form-control" readonly="true" value="" title="Company Name">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="padding-top: 10px;"></div>
                    <table class="table-striped" width="100%">
                        <thead>
                            <tr>
                                <td>Order Date</td>
                                <td>Order No</td>
                                <td>Shipment Date</td>
                                <td>PO Cat NO</td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="form-group">
                                        <input type="Date" name="orderDate" class="form-control" placeholder="Order Date" title="Order Date">
                                    </div>
                                </td>

                                <td>
                                    <div class="form-group">
                                        <input type="text" name="orderNo" class="form-control" placeholder="Order No" title="Order No">
                                    </div>
                                </td>

                                <td>
                                    <div class="form-group">
                                        <input type="date" name="shipmentDate" class="form-control" placeholder="Shipment Date" title="Shipment Date">
                                    </div>
                                </td>

                                <td>
                                    <div class="form-group">
                                        <input type="text" name="poCatNo" class="form-control" placeholder="PO Cat No" title ="PO Cat No">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>


                </div>
    </div>
</div>
<?php }?>


<div class="pre-loader">
    <div class="sk-fading-circle">
        <div class="sk-circle1 sk-circle"></div>
        <div class="sk-circle2 sk-circle"></div>
        <div class="sk-circle3 sk-circle"></div>
        <div class="sk-circle4 sk-circle"></div>
        <div class="sk-circle5 sk-circle"></div>
        <div class="sk-circle6 sk-circle"></div>
        <div class="sk-circle7 sk-circle"></div>
        <div class="sk-circle8 sk-circle"></div>
        <div class="sk-circle9 sk-circle"></div>
        <div class="sk-circle10 sk-circle"></div>
        <div class="sk-circle11 sk-circle"></div>
        <div class="sk-circle12 sk-circle"></div>
    </div>
</div>
</div>
<style type="text/css">
    .page-header {
        border: none;
    }
</style>
<script type="text/javascript">
    (function($){
        'use strict';
        $(window).on('load', function () {
            if($(".pre-loader").length > 0)
                {
                    $(".pre-loader").fadeOut("slow");
                }
        });
    })(jQuery);
</script>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.dashboard', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>