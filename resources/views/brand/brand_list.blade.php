@extends('layouts.dashboard')
@section('page_heading',
trans('others.brand_list_label'))
@section('section')
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                @if(Session::has('add_brand'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('add_brand') ))
                @endif 
                @if(Session::has('brand_delete'))
                    @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('brand_delete') ))
                @endif
                @if(Session::has('update_brand'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_brand') ))
                @endif   
 <div class="col-sm-2 top-btn-pro">
    <a href="{{ Route('addbrand_view') }}" class="btn btn-success form-control">
    {{trans('others.add_brand_label')}}</a>
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
	                    	<th width="10%">Serial no</th>
	                    	<th width="45%">Brand</th>
	                    	<th width="20%">Status</th>
	                        <th width="25%">Action</th>
	                    </tr>
	                </thead>
                <tbody>  
                    @php($i=1)
                    @foreach($brands as $brand)                  
                        <tr>                        	
                        	<td>{{$i++}}</td>
                        	<td>{{$brand->brand_name}}</td>                	
                        	<td>
                              {{($brand->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")}}
                          </td>                	
                        	<td>                        		
                        		<table>
                                      <tr>
                                          <td class="">
                                              <a href="{{ Route('update_brand_view')}}/{{$brand->brand_id}}" class="btn btn-success">edit</a>
                                          </td>
                                          <td class="td-pad">
                                              <a href="{{ Route('delete_brand_action')}}/{{$brand->brand_id}}" class="btn btn-danger">delete</a>
                                          </td>
                                      </tr>
                                  </table>                                 
                        	</td>
                         </tr>                    
                    @endforeach                      
                </tbody>
            </table>
            {{$brands->links()}}
            </div>
            <div class="col-sm-1"></div>
    </div>
</div>
@stop