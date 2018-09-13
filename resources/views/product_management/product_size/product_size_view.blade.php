@extends('layouts.dashboard')
@section('page_heading',
trans('others.product_size_list'))
@section('section')
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                @if(Session::has('add_size_title'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('add_size_title') ))
                @endif 
                @if(Session::has('delete_size'))
                    @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('delete_size') ))
                @endif
                @if(Session::has('update_size_title'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_size_title') ))
                @endif   
<div class="row">
  <div class="col-sm-2 top-btn-pro col-sm-offset-1">
    <a href="{{ Route('add_size_view') }}" class="btn btn-success form-control">{{trans('others.add_product_size_label')}} </a>
 </div>
 <div class="col-sm-6">
   <div class="form-group custom-search-form">
     <input type="text" name="searchFld" class="form-control" placeholder="search" id="user_search">
     <button class="btn btn-default " type="button">
      <i class="fa fa-search"></i>
    </button>
   </div>
   
 </div>
</div>
<div class="col-sm-12">
    <div class="row"> 
    	<div class="col-sm-1"></div>
    		<div class="col-sm-10">
            	<table class="table table-bordered" id="tblSearch">
	                <thead>
	                    <tr>
	                    	<th width="10%">Serial no</th>
	                    	<!-- <th width="25%">Product code</th> -->
	                    	<th width="20%">Product size</th>
	                    	<th width="20%">Status</th>
	                        <th width="25%">Action</th>
	                    </tr>
	                </thead>
                <tbody>  
                    @php($i=1)
                    @foreach($productSize as $size)                  
                        <tr>                        	
                        	<td>{{$i++}}</td>
                        	<!-- <td>{{$size->product_code}}</td>                	 -->
                        	<td>{{$size->product_size}}</td>                	
                        	<td>
                            {{($size->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")}}
                          </td>                	
                        	<td>                        		
                        		<table>
                                      <tr>
                                          <td class="">
                                              <a href="{{ Route('update_size_view')}}/{{$size->proSize_id}}" class="btn btn-success">edit</a>
                                          </td>
                                          <td class="td-pad">
                                              <a href="{{ Route('delete_size_action')}}/{{$size->proSize_id}}" class="btn btn-danger">delete</a>
                                          </td>
                                      </tr>
                                  </table>                                 
                        	</td>
                         </tr>                    
                    @endforeach                       
                </tbody>
            </table>
              {{$productSize->links()}}
            </div>
            <div class="col-sm-1"></div>
    </div>
</div>
@stop