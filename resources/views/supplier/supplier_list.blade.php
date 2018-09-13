@extends('layouts.dashboard')
{{--@section('page_heading', trans('others.party_list_label'))--}}
@section('page_heading', 'Supplier List')
@section('section')
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>


    <!-- <div class="row"> -->
        @if(Session::has('party_added'))
                @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('party_added') ))
        @endif

        @if(Session::has('party_delete'))
                @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('party_delete') ))
        @endif

        @if(Session::has('party_updated'))
                @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('party_updated') ))
        @endif

 <div class="col-sm-3 top-btn-pro">
 	<a href="{{ Route('supplier_add_view') }}" class="btn btn-success form-control">
        Add Supplier
    </a>
 </div>
<div class="col-sm-6">
    <div class="form-group custom-search-form">
        <input type="text" name="searchFld" class="form-control" placeholder="search" id="user_search">
        <button class="btn btn-default" type="button">
            <i class="fa fa-search"></i>
        </button>
    </div>
</div>
        
           
            <!-- <div class="input-group add-on">
              <input class="form-control" placeholder="Search{{ trans('others.search_placeholder') }}" name="srch-term" id="user_search" type="text">
              <div class="input-group-btn">
                <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
              </div>
            </div>
            <br> -->
<div class="col-sm-12 col-md-12">
            <div class="table-responsive">
                <table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                        <th class="">Sl</th>
                        <th class="">Supplier Name</th>
                        <th class="">Contact</th>
                        <th class="">Address</th>
                        <th class="">Status</th>
                        <th class="">Action</th>
                    </tr>
                </thead>
                <tbody>
                  @foreach($suppliers as $key => $supplier)
                  <tr>
                    <td>{{$key+1}}</td>
                    <td>{{$supplier->name}}</td>
                    <td>{{$supplier->phone}}</td>
                    <td>{{$supplier->address}}</td>

                    <td>
                        {{($supplier->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")}}
                    </td>

                    <td>
                        <table>
                          <tr>
                              <td class="">
                                  <a href="{{ Route('supplier_update')}}/{{$supplier->supplier_id}}" class="btn btn-success">edit</a>
                              </td>   
                              <td class="td-pad">
                                  <a href="{{ Route('supplier_delete_action')}}/{{$supplier->supplier_id}}" class="btn btn-danger">delete</a>
                              </td>
                          </tr>
                        </table>
                    </td>
                </tr>
                  @endforeach 
                    
                </tbody>
            </table>
             {{--{{$party_list->links()}}--}}
            </div>    
           
        
    </div>
</div>
@stop