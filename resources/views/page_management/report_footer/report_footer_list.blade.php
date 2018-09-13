@extends('layouts.dashboard')
@section('page_heading',
trans('others.report_footer_list'))
@section('section')
<style type="text/css">
	.top-btn-pro{
		padding-bottom: 15px;
	}
    .td-pad{
        padding-left: 15px;
    }
</style>
                @if(Session::has('new_report_create'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('new_report_create') ))
                @endif 
                @if(Session::has('delete_report_footer'))
                    @include('widgets.alert', array('class'=>'danger', 'message'=> Session::get('delete_report_footer') ))
                @endif
                @if(Session::has('update_report_footer'))
                    @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('update_report_footer') ))
                @endif   
 <div class="col-sm-2 top-btn-pro">
    <a href="{{ Route('addreport_footer_view') }}" class="btn btn-success form-control">{{trans('others.add_report_footer_label')}}</a>
 </div>

<div class="col-sm-12">
    <!-- <div class="row"> -->            
            		<table class="table table-bordered" id="tblSearch">
                <thead>
                    <tr>
                    	<th>Serial no</th>
                        <th>Report Name</th>
                        <th>Persion -1</th>
                        <th>signature -1</th>
                        <th>Seal -1</th>
                        <th>Persion -2</th>
                        <th>Signature -2</th>
                        <th>Seal -2</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>  
                    @php($i=1)
                    @foreach($reports as $roport)                  
                        <tr>                        	
                        	<td>{{$i++}}</td>
                        	<td>{{$roport->reportName}}</td>
                        	<td>{{$roport->siginingPerson_1}}</td>                 
                        	<td>
                                @if(!empty($roport->siginingSignature_1))
                                <img src="/upload/{{$roport->siginingSignature_1}}" height="50px" width="90px" />
                                @endif
                            </td>
                            <!-- <td>{{$roport->siginingPersonSeal_1}}</td> -->
                            <td>
                                @if(!empty($roport->siginingPersonSeal_1))
                                <img src="/upload/{{$roport->siginingPersonSeal_1}}" height="50px" width="90px" />
                                @endif
                            </td>
                        	<td>{{$roport->siginingPerson_2}}</td>
                        	<!-- <td>{{$roport->siginingSignature_2}}</td> -->
                            <td>
                                @if(!empty($roport->siginingSignature_2))
                                <img src="/upload/{{$roport->siginingSignature_2}}" height="50px" width="90px" />
                                @endif
                            </td>
                        	<!-- <td>{{$roport->siginingPersonSeal_2}}</td> -->
                            <td>
                                @if(!empty($roport->siginingPersonSeal_2))
                                <img src="/upload/{{$roport->siginingPersonSeal_2}}" height="50px" width="90px" />
                                @endif
                            </td>
                            <td>
                                {{($roport->status == 1)? trans("others.action_active_label"):trans("others.action_inactive_label")}}
                            </td>
                        	<td>
                        		<center>
                        		<table>
                                      <tr>
                                          <td class="">
                                              <a href="{{ Route('update_report_view')}}/{{$roport->re_footer_id}}" class="btn btn-success">edit</a>
                                          </td>
                                          <td class="td-pad">
                                              <a href="{{ Route('delete_report_action')}}/{{$roport->re_footer_id}}" class="btn btn-danger">delete</a>
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
</div>
@stop