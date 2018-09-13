@extends('layouts.dashboard')
@section('page_heading',trans('others.product_list_label'))
@section('section')
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
    @if(Session::has('new_product_create'))
        @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('new_product_create') ))
    @endif 
    @if(Session::has('new_product_delete'))
        @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('new_product_delete') ))
    @endif
    @if(Session::has('update_product_create'))
        @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_product_create') ))
    @endif

 <div class="col-sm-3 top-btn-pro">
    <a href="{{ Route('add_product_view') }}" class="btn btn-success form-control">{{trans('others.add_product_label')}}</a>
  </div>
  <div class="col-sm-6">
      <div class="form-group custom-search-form">
        <input type="text" name="searchFld" class="form-control" placeholder="search" id="user_search">
        <button class="btn btn-default" type="button">
                <i class="fa fa-search"></i>
        </button>
      </div>
  </div>

<div class="col-sm-12">
    <!-- <div class="row"> -->

                            
            <!-- <div class="input-group add-on">
              <input class="form-control" placeholder="Search{{ trans('others.search_placeholder') }}" name="srch-term" id="user_search" type="text">
              <div class="input-group-btn">
                <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
              </div>
            </div>
            <br> -->

            <table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                        <!-- <th>serial no</th> -->
                        <th class="">ERP Code</th>
                        <th class="">Item Code</th>
                        <th class="">Item Name</th>
                        <!-- <th class="">Description</th> -->
                        <th class="">Brand</th>                        
                        <th class="">Unit Price</th>
                        <th class="">Sizes</th>
                        <th class="">Colors</th>
                        <!-- <th class="">Weight Qty</th> -->
                        <!-- <th class="">Weight Amt</th> -->
                        <th class="">status</th>
                        <th class="">Action</th>                        
                    </tr>
                </thead>
                <tbody>
                      @php ($i=1)
                     @foreach($products as $product)
                        <tr>
                          <!-- <td>{{$i++}}</td> -->
                          <td>{{$product->erp_code}}</td>
                          <td>{{$product->product_code}}</td>
                          <td>{{$product->product_name}} </td>
                          <!-- <td>{{$product->product_description}}</td> -->
                          <td>{{$product->brand}}</td>
                          
                          <td>{{$product->unit_price}}</td>
                          <!-- <td>{{$product->weight_qty}}</td> -->
                          <!-- <td>{{$product->weight_amt}}</td> -->
                          <td>
                              @foreach($product->sizes as $size)
                                  {{ $size->product_size }}@if (!$loop->last),@endif
                              @endforeach
                          </td>

                          <td>
                              @foreach($product->colors as $color)
                                  {{$color->color_name}}@if (!$loop->last),@endif
                              @endforeach
                          </td>
                          <td>
                            {{($product->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")}}
                          </td>
                          <td>
                              <table>
                                  <tr>
                                      <td class="">
                                          <a href="{{ Route('update_product_view')}}/{{$product->product_id}}" class="btn btn-success">edit</a>
                                      </td>
                                      <td class="td-pad">
                                          <a href="{{ Route('delete_product_action')}}/{{$product->product_id}}" class="btn btn-danger">delete</a>
                                      </td>
                                  </tr>
                              </table>
                          </td>
                        </tr>
                    @endforeach      
                          
                </tbody>
            </table>           
        {{$products->links()}}
    </div>
</div>
@stop