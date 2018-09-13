@extends('layouts.dashboard')
{{-- @section('page_heading','Add Role') --}}
@section('section')
           
<div class="col-sm-12">
    <div class="row">
        <div class="col-sm-5 col-sm-offset-3">
            
            @if(count($errors) > 0)
                    <div class="alert alert-danger" role="alert">
                        @foreach($errors->all() as $error)
                          <li><span>{{ $error }}</span></li>
                        @endforeach
                    </div>
            @endif
           {{--  @if(Session::has('new_user_create'))
                @include('widgets.alert', array('class'=>'success', 'message'=> Session::get('new_user_create') ))
            @endif --}}
            

            <form role="form" action="{{ Route('company_user_update_action') }}" method="post">

                <input type="hidden" name="_token" value="{{ csrf_token() }}">
                <input type="hidden" name="user_id" value="{{ $selectedUser->user_id }}">
                
                <div class="form-group">
                    <input class="form-control input_required" type="text" name="personal_name" value="{{ $selectedUser->name }}" disabled>
                </div>

                <div class="form-group">
                    <select class="form-control input_required" name="roleId" >
                        <option value="">{{ trans('others.select_role_option_label') }}</option>
                        @foreach($roleList as $role)
                            <option @if($selectedUser->user_role_id == $role->id) {{ 'selected' }} @endif value="{{ $role->id }}">{{ $role->name }}</option>
                        @endforeach
                    </select>
                </div>

                <div class="form-group">
                    <input class="form-control input_required" type="text" name="personal_name" value="{{ $selectedUser->first_name }}" placeholder="{{ trans('others.employee_name_label') }}">
                </div>
                <div class="form-group">
                    <input class="form-control" type="text" name="personal_phone_number" value="{{ $selectedUser->phone_no }}" placeholder="{{ trans('others.personal_phone_number_label') }}">
                </div>

                <div class="form-group">
                    <input class="form-control input_required" type="text" name="employee_address" value="{{ $selectedUser->address }}" placeholder="{{ trans('others.employee_address_label') }}">
                </div>



                <div class="form-group">
                    <input class="form-control input_required" type="email" name="email" value="{{ $selectedUser->email }}" placeholder="{{ trans('others.enter_email_address') }}" required="email">
                </div>

                <div class="form-group">
                        <input type="password" class="form-control input_required" name="password" value="" placeholder="Password{{ trans('others.enter_password') }}">
                </div>

                

                

                <div class="form-group">
                    <select class="form-control input_required" name="is_active">
                        
                        <option value="0">{{ trans('others.action_inactive_label') }}</option>
                        <option @if($selectedUser->active_user == 1) {{ 'selected' }} @endif value="1">{{ trans('others.action_active_label') }}</option>
                    </select>
                </div>

                


                <div class="form-group">
                    <input class="form-control  btn btn-primary btn-outline" type="submit" value="Update User{{ trans('others.ss') }}" >
                </div>
            </form>
        </div>
    </div>
</div>
            
@stop

