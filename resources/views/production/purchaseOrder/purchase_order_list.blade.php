@extends('layouts.dashboard')
@section('page_heading', trans("others.mxp_menu_purchase_order_list") )
@section('section')

@section('section')
    <div>
        <form method="post" id="purchase_order_list_search_form">
            <input type="hidden" name="_token" value="{{ csrf_token() }}">
            <div class="col-sm-12">
                {{--<div class="col-sm-5">--}}
                    <div class="col-sm-3">
                        <label class="col-sm-12 label-control">Supplier</label>
                        <select class="form-control selections" name="supplier_id" id="supplier_id">
                            <option value="">Select Supplier</option>
                            @foreach($suppliers as $supplier)
                                <option value="{{$supplier->supplier_id}}">{{$supplier->name}}</option>
                            @endforeach
                        </select>
                    </div>
                    {{--<div class="col-sm-6 hidden">--}}
                        {{--<label class="col-sm-12 label-control">Checking no.</label>--}}
                        {{--<select name="taskType" class="form-control" id="taskType" style="display: none">--}}
                            {{--<option value="challan">Challan</option>--}}
                        {{--</select>--}}
                        {{--<input type="text" name="purchase_order_no_search" class="form-control" id="bookingId" placeholder="Checking Id">--}}
                        {{--<input type="hidden" name="bookingIdList" id="hiddenBookingIdList">--}}
                        {{--<div id="bookingIdList"></div>--}}
                    {{--</div>--}}
                {{--</div>--}}
                {{--<div class="col-sm-5">--}}
                    <div class="col-sm-3">
                        <label class="col-sm-12 label-control">PO Date from</label>
                        <input type="text" name="from_oder_date_search" class="form-control" id="from_oder_date_search">
                    </div>
                    <div class="col-sm-3">
                        <label class="col-sm-12 label-control">PO Date to</label>
                        <input type="text" name="to_oder_date_search" class="form-control" id="to_oder_date_search">
                    </div>
                {{--</div>--}}
                <br>
                <div class="col-sm-2">
                    <input class="btn btn-info" type="submit" value="Search" name="booking_advanceSearch_btn" id="booking_advanceSearch_btn">
                </div>
            </div>
        </form>
        <div style="display: none;" class="polistResetBtnAndNo">
            <div class="col-sm-2">
                <button class="btn btn-warning" type="button" id="booking_reset_btn">Reset</button>
            </div>
            <div  style="background-color: #2b542c; color: #ffffff; border-radius: 4px;" class="col-sm-3 col-sm-offset-7" align="center">
                <h4 class="PONoInList"></h4>
            </div>
        </div>
    </div>
    <br>
    <div class="row poTableList" style="display: none">
        <div class="col-md-12 col-md-offset-0">
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
                    <th class="hidden">Mrf Id</th>
                    </thead>
                </tr>
                @php($j=1)
                {{--<form method="POST" class="purchase_order_form">--}}
                    <tbody id="po_list_tbody">
                    </tbody>
                {{--</form>--}}
            </table>

            <div class="col-sm-2 col-sm-offset-10">
                <from type="post" action="{{ Route('generate_purchase_order_report') }}" id="save_purcahe_order_form">
                    <input type="hidden" name="_token" value="{{ csrf_token() }}">
                    <input type="hidden" name="report_all_data" class="report_all_data">
                    <input type="submit" id="save_purcahe_order" class="btn btn-success save_purcahe_order" value="Get Report">
                </from>
                {{--<button class="btn btn-success save_purcahe_order">Get Report</button>--}}
            </div>
            <div class="pagination-container">
                <nav>
                    <ul class="pagination"></ul>
                </nav>
            </div>
            {{--<div class="pagination-container">--}}
                {{--<nav>--}}
                    {{--<ul class="pagination"></ul>--}}
                {{--</nav>--}}
            {{--</div>--}}
        </div>
    </div>
    <script type="text/javascript">
        $(".selections").select2();
    </script>
@endsection
@section("LoadScript")
    <script type="text/javascript">
        $("#from_oder_date_search").datetimepicker();
        $("#to_oder_date_search").datetimepicker();
    </script>
@endsection