@extends('print_file.layouts.layouts')
@section('print-body')

    <center>
        <a href="#" onclick="myFunction()"  class="print">Print & Preview</a>
    </center>
    @php($ik = 0)
    @foreach($headerValue as $value)
        @for($ik;$ik <= 0;$ik++)
            <div class="row">
                <div class="col-md-2 col-sm-2 col-xs-2">
                    @if($value->logo_allignment == "left")
                        @if(!empty($value->logo))
                            <div class="pull-left">
                                <img src="/upload/{{$value->logo}}" height="100px" width="150px" />
                            </div>
                        @endif
                    @endif
                </div>
                <div class="col-md-8 col-sm-8 col-xs-8" style="padding-left: 40px;">
                    <h2 align="center">{{ $value->header_title}}</h2>
                    <div align="center">
                        <p>FACTORY ADDRESS :  {{$value->address1}} {{$value->address2}} {{$value->address3}}</p>
                    </div>
                </div>
                <div class="col-md-2 col-sm-2 col-xs-2">
                    @if($value->logo_allignment == "right")
                        @if(!empty($value->logo))
                            <div class="pull-right">
                                <img src="/upload/{{$value->logo}}" height="100px" width="150px" />
                            </div>
                        @endif
                    @endif
                </div>
            </div>
        @endfor
    @endforeach
    <div class="row header-bottom">
        <div class="col-md-12 header-bottom-b">
            <span>Purchase Order</span>
        </div>
    </div>
    <br>
    <div  style="background-color: #2b542c; color: #ffffff;" class="col-sm-3 col-sm-offset-9" align="center">
        <h4 class="PONoInList"> PO no: {{ $purchaseOrders[0]->po_no }}</h4>
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
                <th>Unit Price</th>
                <th>Total Amount</th>
                </thead>
            </tr>

            <?php
                $j=1;
                $sizes = explode(',', $purchaseOrders[0]->item_sizes);
                $materials = explode(',', $purchaseOrders[0]->materials);
                $gmts_colors = explode(',', $purchaseOrders[0]->gmts_colors);
                $units = explode(',', $purchaseOrders[0]->units);
                $item_quantitys = explode(',', $purchaseOrders[0]->item_quantitys);
                $unit_prices = explode(',', $purchaseOrders[0]->unit_prices);
                $total_amounts = explode(',', $purchaseOrders[0]->total_amounts);
                $spanLength = count($item_quantitys);

                $totalQnty = $item_quantitys[0];
                $totalAmnt = $total_amounts[0];
            ?>
            {{--<form method="POST" class="purchase_order_form">--}}
            <tbody>
                <tr>
                    <td>{{ $j++ }}</td>
                    <td rowspan="{{ $spanLength }}" style="vertical-align: middle; /*horiz-align: middle;*/"><b>{{ $purchaseOrders[0]->booking_order_id }}</b></td>
                    <td rowspan="{{ $spanLength }}" style="vertical-align: middle; /*horiz-align: middle;*/"><b>{{ $purchaseOrders[0]->shipment_date }}</b></td>
                    <td rowspan="{{ $spanLength }}" style="vertical-align: middle; /*horiz-align: middle;*/">{{ $purchaseOrders[0]->erp_code }}</td>
                    <td rowspan="{{ $spanLength }}" style="vertical-align: middle; /*horiz-align: middle;*/">{{ $purchaseOrders[0]->item_code }}</td>
                    <td>{{ $sizes[0] }}</td>
                    <td>{{ $materials[0] }}</td>
                    <td>{{ $gmts_colors[0] }}</td>
                    <td>{{ $units[0] }}</td>
                    <td>{{ $item_quantitys[0] }}</td>
                    <td>{{ $unit_prices[0] }}</td>
                    <td>{{ $total_amounts[0] }}</td>
                </tr>

                @for($i = 1; $i <count($item_quantitys); $i++)
                    <tr>
                        <td>{{ $j++ }}</td>
                        <td>{{ $sizes[$i] }}</td>
                        <td>{{ $materials[$i] }}</td>
                        <td>{{ $gmts_colors[$i] }}</td>
                        <td>{{ $units[$i] }}</td>
                        <td>{{ $item_quantitys[$i] }}</td>
                        <td>{{ $unit_prices[$i] }}</td>
                        <td>{{ $total_amounts[$i] }}</td>
                    </tr>
                    <?php
                        $totalQnty += floatval($item_quantitys[$i]);
                        $totalAmnt += floatval($total_amounts[$i]);
                    ?>
                @endfor

                <tr>
                    <td colspan="9"><b> Total</b></td>
                    <td>{{ $totalQnty }}</td>
                    <td></td>
                    <td>{{ $totalAmnt }}</td>
                </tr>
            </tbody>
            {{--</form>--}}
        </table>
    </div>

        {{--<div class="pagination-container">--}}
        {{--<nav>--}}
        {{--<ul class="pagination"></ul>--}}
        {{--</nav>--}}
        {{--</div>--}}

    <h5><strong>REMARK</strong></h5>
    <p>If the quantity of goods you recevied is not in confirmity as in packing irst or the qualify, packing problem incurred, please
        inform us in 3days. After this period, you concern about this goods shall not be our responsibility.</p>
    <h5>Please confirm receipt with your signature: </h5><br><br>




    @foreach ($footerData as $value)
        @if(!empty($value->siginingPerson_1))
            <div class="row">
                <div class="col-md-12 col-xs-12" style="padding-bottom: 20px;">


                    <div class="col-md-8 col-xs-8" style="padding: 5px; padding-left: 50px;">
                        @if(!empty($value->siginingPersonSeal_1))
                            <img src="/upload/{{$value->siginingPersonSeal_1}}" height="100px" width="150px" />
                        @endif
                    </div>

                    <div class="col-md-4 col-xs-4"  style="">
                        <div align="center">
                            @if(!empty($value->siginingSignature_1))
                                <img src="/upload/{{$value->siginingSignature_1}}" height="100px" width="150px" />
                            @endif
                        </div>
                        <div align="center" style="margin:auto;
		    	border: 2px solid black;
		    	padding: 5px;margin-top:30px;">
                            {{$value->siginingPerson_1}}
                        </div>
                    </div>

                </div>
            </div>
        @endif
    @endforeach

    @foreach ($footerData as $value)
        @if(!empty($value->siginingPerson_2))
            <div class="row">
                <div class="col-md-12 col-xs-12" style="padding-bottom: 20px;">


                    <div class="col-md-8 col-xs-8" style="padding: 5px; padding-left: 50px;">
                        @if(!empty($value->siginingPersonSeal_2))
                            <img src="/upload/{{$value->siginingPersonSeal_2}}" height="100px" width="150px" />
                        @endif
                    </div>

                    <div class="col-md-4 col-xs-4"  style="">
                        <div align="center">
                            @if(!empty($value->siginingSignature_2))
                                <img src="/upload/{{$value->siginingSignature_2}}" height="100px" width="150px" />
                            @endif
                        </div>
                        <div align="center" style="margin:auto;
		    	border: 2px solid black;
		    	padding: 5px;margin-top:30px;">
                            {{$value->siginingPerson_2}}
                        </div>
                    </div>
                </div>
            </div>
        @endif
    @endforeach


    <script type="text/javascript">
        function myFunction() {
            window.print();
        }
    </script>
@endsection
