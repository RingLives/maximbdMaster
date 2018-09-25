@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_booking_view_details") )
@section('section')
    <?php 
        // print_r("<pre>");
        // print_r($bookingDetails->bookings);
        // print_r("</pre>");
    ?>
    <div class="panel panel-default">
        <div class="panel-heading">
            <div style="font-size: 120%">Booking Details</div>
            <!-- <div class="col-sm--3 col-sm-offset-9 "><a href="" class="btn btn-success">Generate Purchase Invoice</a></div> -->
        </div>
        <div class="panel-body aaa">
            <div class="panel panel-default col-sm-7">
                <br>
                <p >Buyer name:<b> {{ $bookingDetails->buyer_name }}</b></p>
                <p >Company name:<b> {{ $bookingDetails->Company_name }}</b></p>
                <p >Buyer address:<b> {{ $bookingDetails->address_part1_invoice }}{{ $bookingDetails->address_part2_invoice }}</p>
                <p >Mobile num:<b> {{ $bookingDetails->mobile_invoice }}</b></p>
            </div>
            <div class="panel panel-default col-sm-5">
                <br>
                <p >Booking Id:<b> {{ $bookingDetails->booking_order_id }}</b></p>
                <p >Booking status:<b> {{ $bookingDetails->booking_status }}</b></p>
                <p >Oreder Date:<b> {{ $bookingDetails->bookings[0]->orderDate }}</b></p>
                <p >Shipment Date:<b> {{ $bookingDetails->bookings[0]->shipmentDate }}</b></p>
            </div>
            <table class="table table-bordered">
                <tr>
                    <thead>
                        <th>Job No.</th>
                        <th width="15%">ERP Code</th>
                        <th width="20%">Item / Code No.</th>
                        <th width="5%">Season Code</th>
                        <th>OOS No.</th>
                        <th>Style</th>
                        <th>PO/Cat No.</th>
                        <th>GMTS Color</th>
                        <th width="15%">Size</th>
                        <th>Sku</th>
                        <th>Order Qty</th>
                        <!-- <th>Price</th> -->
                    </thead>
                </tr>
                @php
                    $j=1;
                @endphp
                <tbody>
                @foreach($bookingDetails->bookings as $bookedItem)
                <?php $jobId = (8 - strlen($bookedItem->id)); ?>
                <tr>
                    <td>{{ str_repeat('0',$jobId) }}{{ $bookedItem->id }}</td>                
                    <td>{{$bookedItem->erp_code}}</td>
                    <td>{{$bookedItem->item_code}}</td>
                    <td>{{$bookedItem->season_code}}</td>
                    <td>{{$bookedItem->oos_number}}</td>
                    <td>{{$bookedItem->style}}</td>
                    <td>{{$bookedItem->poCatNo}}</td>
                    <td>{{$bookedItem->gmts_color }}</td>
                    <td>{{$bookedItem->item_size}}</td>
                    <td>{{$bookedItem->sku}}</td>
                    <td>{{$bookedItem->item_quantity}}</td>
                    <!-- <td> {{ $bookedItem->item_price }} </td> -->
                </tr>
                @endforeach
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
                @php($j=1)
                <tbody>
                @foreach($bookingDetails->mrf as $value)
                <?php 
                    $gmts_color = explode(',', $value->gmts_color);
                    $itemsize = explode(',', $value->item_size);
                    $mrf_quantity = explode(',', $value->mrf_quantity);
                ?>
                <tr>
                    <td>{{$j++}}</td>
                    <td>{{$value->mrf_id}}</td>
                    <td>{{$value->item_code}}</td>
                    <td class="colspan-td">
                        <table id="sampleTbl">
                            @foreach($gmts_color as $gmtsColor)
                            <tr>
                                <td>{{$gmtsColor}}</td>
                            </tr>
                            @endforeach
                        </table>
                    </td>
                    <td class="colspan-td" width="18%">
                        <table id="sampleTbl">
                            @foreach($itemsize as $valuess)
                            <tr>
                                <td>{{$valuess}}</td>
                            </tr>
                            @endforeach
                        </table>
                    </td>
                    <td class="colspan-td">
                        <table id="sampleTbl">
                            @foreach($mrf_quantity as $mrfQuantity)
                            <tr>
                                <td>{{$mrfQuantity}}</td>
                            </tr>
                            @endforeach
                        </table>
                    </td>
                    <td>Delivered Quantity</td>
                    <td>{{$value->shipmentDate}}</td>
                    <td>{{$value->mrf_status}}</td>
                    <td>Action</td>
                </tr>
                @endforeach
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
                @php($j=1)
                <tbody>

                @foreach($bookingDetails->ipo as $value)
                <?php 
                    $gmts_color = explode(',', $value->gmts_color);
                    $itemsize = explode(',', $value->item_size);
                    $ipo_quantity = explode(',', $value->ipo_quantity);
                ?>
                <tr>
                    <td>{{$j++}}</td>
                    <td>{{$value->ipo_id}}</td>
                    <td>{{$value->item_code}}</td>
                    <td class="colspan-td">
                        <table id="sampleTbl">
                            @foreach($gmts_color as $gmtsColor)
                            <tr>
                                <td>{{$gmtsColor}}</td>
                            </tr>
                            @endforeach
                        </table>
                    </td>
                    <td class="colspan-td" width="18%">
                        <table id="sampleTbl">
                            @foreach($itemsize as $valuess)
                            <tr>
                                <td>{{$valuess}}</td>
                            </tr>
                            @endforeach
                        </table>
                    </td>
                    <td class="colspan-td">
                        <table id="sampleTbl">
                            @foreach($ipo_quantity as $ipoQuantity)
                            <tr>
                                <td>{{$ipoQuantity}}</td>
                            </tr>
                            @endforeach
                        </table>
                    </td>
                    <td>Delivered Quantity</td>
                    <td>{{$value->shipmentDate}}</td>
                    <td>{{$value->ipo_status}}</td>
                    <td>Action</td>
                    <!-- <td>{{Carbon\Carbon::parse($value->created_at)}}</td> -->
                </tr>
                @endforeach
                </tbody>
            </table>
        </div>
    </div>
@endsection
