@extends('layouts.dashboard')
@section('page_heading',$taskType)
@section('section')
  <style type="text/css">
    .top-div{
      background-color: #f9f9f9;
      padding:5px 0px 5px 10px;
      border-radius: 7px;
    }

    .btn-file {
      position: relative;
      overflow: hidden;
    }

    .btn-file input[type=file] {
      position: absolute;
      top: 0;
      right: 0;
      min-width: 100%;
      min-height: 100%;
      font-size: 100px;
      text-align: right;
      filter: alpha(opacity=0);
      opacity: 0;
      outline: none;
      background: white;
      cursor: inherit;
      display: block;
    }
    .idclone .form-group{
      width: 130px !important;
    }
  </style>

<?php 
    $general = 'Create Booking';
    $fsc     = 'Create FSC Booking'
?>




<div class="col-md-12">
  @if ($errors->any())
      <div class="alert alert-danger">
          <ul>
              @foreach ($errors->all() as $error)
                 <li>{{ $error }}</li>
              @endforeach
          </ul>
      </div>
  @endif

  @if(Session::has('error_code'))
      @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('error_code') ))
  @endif

  <form class="" action="{{ Route('booking_order_action') }}" role="form" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="_token" value="{{ csrf_token() }}">
    <input type="hidden" name="buyerDetails" value="{{$buyerDetails}}">
    @if($taskType == $general)
      <input type="hidden" name="is_type" value="general">
    @elseif($taskType == $fsc)
    <input type="hidden" name="is_type" value="fsc">
    @endif
    <div class="col-md-12" style="margin-top: 10px;">
      <div class="pull-left">
        <div class="form-group button_add pull-right">
          {{--<input type="file" name="booking_files[]" class="btn btn-success" id="" ><i class="fa fa-file" style="font-size:`16px;color:white; margin-right:7px;"></i>Add Files</input>--}}

          <label class="btn btn-default btn btn-success">
            <i class="fa fa-file" style="font-size:`16px;color:white; margin-right:7px;"></i>
            Select Files <input type="file" style="display: none;" name="booking_files[]" class="" id="" multiple disabled>
          </label>
        </div>
      </div>
    </div>

    <div class="top-div">
      <?php
        $buyerName = '';
        $CompanyName = '';
      ?>
      @foreach ($buyerDetails as $buyer)
        <?php
          $buyerName = $buyer->name_buyer;
          $CompanyName = $buyer->name;
          $companyId = $buyer->id;
        ?>
      @endforeach
      <div class="row">
        <div class="col-md-6 col-xs-6">
          <div class="form-group">
            <label class="col-md-4">Buyer name</label>

            <div class="">
              <input type="text" name="buyerName" class="form-control" readonly="true" value="{{$buyerName}}" title="Buyer Name">
            </div>
          </div>
        </div>

        <div class="col-md-6 col-xs-6">
          <div class="form-group " >
            <label class="col-md-4">Vendor name</label>

            <div class="" >
              <input type="text" name="CompanyName" class="form-control" readonly="true" value="{{$CompanyName}}" title="Company Name">
              <input type="hidden" name="companyIdForBookingOrder" value="{{$companyId}}">
            </div>
          </div>
        </div>
      </div>

      <div style="padding-top: 10px;"></div>
      <table class="table-striped" width="100%">
        <thead>
          <tr>
            <td>Order Date</td>
            <!-- <td>OOS Number</td> -->
            <!-- Shipment Date repalce to Request Date-->
            <td>Requested Delivery Date</td>
            <!-- <td>PO/Cat NO</td> -->
            <td>Season Code</td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <div class="form-group">
                <input type="text" name="orderDate" class="form-control" placeholder="Order Date" title="Order Date" value="{{carbon\carbon::today()->format('d-m-Y')}}" readonly>
              </div>
            </td>

            <!-- <td>
              <div class="form-group">
                <input type="text" name="orderNo" class="form-control" placeholder="orderNo" title="orderNo">
              </div>
            </td> -->

            <!-- <td>
              <div class="form-group">
                <input type="text" name="oos_number" class="form-control" placeholder="OOS Number" title="OOS Number">
              </div>
            </td> -->

            <td>
              <div class="form-group">
                <input type="date" id="datePickerDate" name="shipmentDate" class="form-control" placeholder="Request Date" title="Request Date" required>
              </div>
            </td>

            <!-- <td>
              <div class="form-group">
                <input type="text" name="poCatNo" class="form-control" placeholder="PO Cat No" title ="PO Cat No">
              </div>
            </td> -->

            <td>
              <div class="form-group">
                <input type="text" name="season_code" class="form-control" placeholder="Season Code" title ="Season Code">
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>


  <div style="padding-top: 20px;"></div>


  <div class="table-responsive">
    <table class="table-striped " style="overflow-y: scroll;" id="filed_increment">
      <thead>
        <tr>
          <th width="10%">PO/Cat No</th>
          <th width="10%">OOS No</th>
          <th width="10%">Item Code</th>
          <th width="10%">ERP Code</th>
          <th width="10%">Item Description</th>
          <th width="15%">GMTS / Item Color</th>
          <th width="15%">Item Size</th>
          <th width="15%">Style</th>
          <th width="15%">SKU</th>
          <th width="15%">Item Qty</th>
          <th width="15%">Item price</th>
          <!-- <th></th> -->
        </tr>
      </thead>
      <tbody class="idclone" >
        <tr class="tr_clone">
            <input type="hidden" name="others_color[]" class="others_color" id="others_color" value="">
            
          <!-- PO/Cat No -->
          <td>
            <div class="form-group">
                <input type="text" name="poCatNo[]" class="form-control" placeholder="PO Cat No" title ="PO Cat No" id="item_po_cat_no" >
              </div>
          </td>
          <!-- end -->

          <!-- OOS Number -->
          <td>
            <div class="form-group ">
                <input type="text" name="oos_number[]" class="form-control" placeholder="OOS Number" title="OOS Number" id="item_oos_number">
              </div>
          </td>
          <!-- end -->

          <td width="15%" style="padding-top: 15px;">
            <div class="form-group item_codemxp_parent">
              <input class="booking_item_code item_code easyitemautocomplete" type="text" name="item_code[]"  id="item_codemxp" data-parent="tr_clone">

            </div>
          </td>
          <td>
            <div class="form-group" style="    width: 200px !important;">
              <input type="text" name="erp[]" class="form-control erpNo" id="erpNo" readonly = "true">
              <!-- <select name="erp[]" class="form-control erpNo" id="erpNo" readonly = "true"> -->
              </select>
            </div>
          </td>

          <!-- description -->
          <td>
            <div class="form-group">
              <input type="text" name="item_description[]" class="item_description form-control" id="item_description" value="" readonly>
            </div>
          </td>
          <!--end -->

          <td>
            <div class="form-group" style="    width: 145px !important;">
              <select name="item_gmts_color[]" class="form-control itemGmtsColor" id="itemGmtsColor" readonly="true"></select>
            </div>
          </td>
          <td>
            <div class="form-group">
              {{--<input type="text" name="item_size[]" class="form-control">--}}

              <select name="item_size[]" class="form-control itemSize" id="itemSize" disabled = "true" >
              </select>
            </div>
          </td>


          <!-- Style -->
          <td>
            <div class="form-group">
              <input type="text" name="style[]" class="form-control item_style" id="item_style">
            </div>
          </td>
          <!-- end -->

          <td>
            <div class="form-group">
              <input type="text" name="sku[]" class="form-control item_sku" id="item_sku">
            </div>
          </td>

          <td>
            <div class="form-group">
              <input type="text" name="item_qty[]" class="form-control easyitemautocomplete item_qty" id="item_qtymxp">
            </div>
          </td>

          <td>
            <div class="form-group">
              <input type="text" name="item_price[]" class="form-control item_price" readonly="true">
              <!-- readonly -->
            </div>
          </td>
          <td></td>
        </tr>
      </tbody>
    </table>
   </div>



    <div class="form-group button_add pull-right">
      <button type="submit" class="btn btn-success" id="add"><i class="fa fa-copy" style="padding-right: 5px;"></i>Copy Item</button>
      <button type="submit" class="btn btn-success" id="order_copy"><i class="fa fa-plus" style="padding-right: 5px;"></i>Add New Item</button>
      <button type="submit" class="btn btn-primary">Submit</button>
    </div>

  </form>
</div>
@endsection
