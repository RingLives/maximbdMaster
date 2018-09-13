@extends('layouts.dashboard')
@section('page_heading',
trans('others.footer_title_label'))
@section('section')
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                @if(Session::has('add_footer_title'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('add_footer_title') ))
                @endif 
                @if(Session::has('delete_footer'))
                    @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('delete_footer') ))
                @endif
                @if(Session::has('update_footer'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_footer') ))
                @endif   

@if(empty($footers))
<div class="col-sm-1"></div>
 <div class="col-sm-2 top-btn-pro">
    <a href="{{ Route('add_footer_title_view') }}" class="btn btn-success form-control">Add Footer </a>
 </div>
 @endif

<div class="col-sm-12">
    <!-- <div class="row"> -->

                         
            <!-- <div class="input-group add-on">
              <input class="form-control" placeholder="Search{{ trans('others.search_placeholder') }}" name="srch-term" id="user_search" type="text">
              <div class="input-group-btn">
                <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search"></i></button>
              </div>
            </div>
            <br> -->
            <div class="row">
            	<div class="col-md-1"></div>
            	<div class="col-md-10">
            		<table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                    	<th>Serial no</th>
                        <th class="">Footer Title</th>
                        <th class="">Status</th>
                        <th class="">Action</th>
                    </tr>
                </thead>
                <tbody>
                    @php ($i = 1)
                    @foreach($footers as $title)
                        <tr>
                        	<td width="10%">
                               {{ $i++}}   
                            </td>
                          <td width="40%">{{ $title->title}}</td>
                        	<td width="20%">                            
                            {{($title->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")}}
                          </td>
                        	<td width="30%">
                        		<center>
                        		<table>
                                      <tr>
                                          <td class="">
                                              <a href="{{ Route('update_title_view')}}/{{$title->footer_id}}" class="btn btn-success">edit</a>
                                          </td>
                                          <td class="td-pad">
                                              <a href="{{ Route('delete_footer_action')}}/{{$title->footer_id}}" class="btn btn-danger">delete</a>
                                          </td>
                                      </tr>
                                  </table>
                                  </center>
                        	</td>
                         </tr>
                    @endforeach
                    
                          
                </tbody>
            </table>
            	</div>
            	<div class="col-md-1"></div>
            </div>
                
           
       
    </div>
</div>
@stop