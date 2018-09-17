@extends('layouts.dashboard')
@section('page_heading',
trans('others.buyer_list_label'))
@section('section')
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                @if(Session::has('add_buyer'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('add_buyer') ))
                @endif 
                @if(Session::has('buyer_delete'))
                    @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('buyer_delete') ))
                @endif
                @if(Session::has('update_buyer'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_buyer') ))
                @endif   
 <div class="col-sm-2 top-btn-pro">
    <a href="{{ Route('addbuyer_view') }}" class="btn btn-success form-control">
    {{trans('others.add_buyer_label')}}</a>
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
    <div class="row"> 
    	<div class="col-sm-1"></div>
    		<div class="col-sm-10">
            	<table class="table table-bordered" id="tblSearch">
	                <thead>
	                    <tr>
	                    	<th width="10%">Id No.</th>
	                    	<th width="45%">buyer</th>
	                        <th width="25%">Action</th>
	                    </tr>
	                </thead>
                <tbody>  
                    @php($i=1)
                    @foreach($buyers as $buyer)                  
                        <tr>                        	
                        	<td>{{$buyer->id_mxp_buyer}}</td>
                        	<td>{{$buyer->buyer_name}}</td>                	            	
                        	<td>                        		
                        		<table>
                                  <tr>
                                      <td class="">
                                          <a href="{{ Route('update_buyer_view')}}/{{$buyer->id_mxp_buyer}}" class="btn btn-success">edit</a>
                                      </td>
                                      <td class="td-pad">
                                          <a href="{{ Route('delete_buyer_action')}}/{{$buyer->id_mxp_buyer}}" class="btn btn-danger">delete</a>
                                      </td>
                                  </tr>
                              </table>                                 
                        	</td>
                         </tr>                    
                    @endforeach                      
                </tbody>
            </table>
            {{$buyers->links()}}
            </div>
            <div class="col-sm-1"></div>
    </div>
</div>
@stop