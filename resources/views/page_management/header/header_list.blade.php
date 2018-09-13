@extends('layouts.dashboard')
@section('page_heading',
trans('others.header_list_label'))
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
        @if(Session::has('page_header_added'))
                @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('page_header_added') ))
        @endif

        @if(Session::has('header_delete'))
                @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('header_delete') ))
        @endif

        @if(Session::has('header_updated'))
                @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('header_updated') ))
        @endif

    	 <div class="col-sm-3 top-btn-pro">
    	 	<a href="{{ Route('page_header_create') }}" class="btn btn-success form-control">
            {{trans('others.add_header_label')}}
            </a>
    	 </div>
        
<div class="col-sm-12 col-md-12">
            <div class="table-responsive">
                <table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                        <th>#</th>
                        <th class="">
                            {{trans('others.header_title_label')}}
                        </th>
                        <th>Header type</th>
                        <!-- <th class="">
                            {{trans('others.header_font_size_label')}}
                        </th> -->
                        <!-- <th class="">
                            {{trans('others.header_font_style_label')}}
                        </th> -->
                        <!-- <th class="">
                            {{trans('others.header_colour_label')}}
                        </th> -->
                        <th class="">
                            {{trans('others.header_logo_label')}}
                        </th>
                       <!--  <th class="">
                            {{trans('others.logo_allignment_label')}}
                        </th> -->
                        <th class="">
                            {{trans('others.header_address_label')}}
                        </th>
                        <th class="">
                            {{trans('others.action_label')}}
                        </th>
                    </tr>
                </thead>
                <tbody>
                    @php($j = 1)
                  @foreach($page_list as $page)
                  <tr>
                    <td>{{$j++}}</td>
                    <td>
                        @if($page->header_type == 11)
                        Company 

                        @elseif($page->header_type == 12)
                        Booking 
                        @else

                        @endif
                    </td>  
                    <td>{{$page->header_title}}</td>
                    <!-- <td>{{$page->header_fontsize}}</td>
                    <td>{{$page->header_fontstyle}}</td>
                    <td>{{$page->header_colour}}</td> -->
                    <td>
                        @if(!empty($page->logo))
                        <img src="/upload/{{$page->logo}}" height="50px" weidth="90px" />
                        @endif
                    </td>
                    <!-- <td>{{$page->logo_allignment}}</td> -->
                    <td>{{$page->address1}} {{(!empty($details->address2) ? ',' : '')}} {{$page->address2}} {{(!empty($details->address3) ? ',' : '')}} {{$page->address3}}</td>
                    <td>
                        <table>
                          <tr>
                              <td class="">
                                  <a href="{{ Route('page_edit_view')}}/{{$page->header_id}}" class="btn btn-success">edit</a>
                              </td>   
                              <td class="td-pad">
                                  <a href="{{ Route('page_delete_action')}}/{{$page->header_id}}" class="btn btn-danger">delete</a>
                              </td>
                          </tr>
                        </table>
                    </td>
                </tr>
                  @endforeach 
                    
                </tbody>
            </table>
            </div>    
           
        
    </div>
</div>          
            
@stop