@extends('layouts.dashboard')
@section('page_heading',
trans('others.item_description_list_label'))
@section('section')
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                @if(Session::has('add_description'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('add_description') ))
                @endif 
                @if(Session::has('description_delete'))
                    @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('description_delete') ))
                @endif
                @if(Session::has('update_description'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_description') ))
                @endif   
<div class="row">
    <div class="col-sm-2 col-sm-offset-1 top-btn-pro">
        <a href="{{ Route('addDescription_view') }}" class="btn btn-success form-control">
            {{trans('others.add_description_label')}}</a>
    </div>
    <div class="col-sm-6">
        <div class="form-group custom-search-form">
            <input type="text" name="searchFld" class="form-control" placeholder="search" id="user_search">
            <button class="btn btn-default" type="button">
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
	                    	<th width="10%">Id No.</th>
	                    	<th width="45%">Description</th>
	                        <th width="25%">Action</th>
	                    </tr>
	                </thead>
                <tbody>  
                    @php($i=1)
                    @foreach($items as $item)                  
                        <tr>                        	
                        	<td>{{$i}}</td>
                        	<td>{{$item->name}}</td>                	            	
                        	<td>                        		
                        		<table>
                                  <tr>
                                      <td class="">
                                          <a href="{{ Route('update_description_view')}}/{{$item->id}}" class="btn btn-success">edit</a>
                                      </td>
                                      <td class="td-pad">
                                          <a href="{{ Route('delete_description_action')}}/{{$item->id}}" class="btn btn-danger">delete</a>
                                      </td>
                                  </tr>
                              </table>                                 
                        	</td>
                         </tr>
                        @php($i++)
                    @endforeach

                </tbody>
            </table>
            {{$items->links()}}
            </div>
            <div class="col-sm-1"></div>
    </div>
</div>
@stop