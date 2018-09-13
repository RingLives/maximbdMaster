@extends('layouts.dashboard')
@section('page_heading',trans('others.update_report_footer_label'))
@section('section')

@section('section')
    <div class="container-fluid">
    						@if ($errors->any())
							    <div class="alert alert-danger">
							        <ul>
							            @foreach ($errors->all() as $error)
							                <li>{{ $error }}</li>
							            @endforeach
							        </ul>
							    </div>
							@endif

		<div class="row">		
			<div class="col-md-12">
				<div class="panel panel-default">
					<div class="panel-heading">{{ trans('others.page_footer_title_label') }}</div>
					<div class="panel-body">
						@foreach($datas as $data)
						<form class="" role="form" method="POST" action="{{route('update_report_action')}}/{{$data->re_footer_id}}"
							enctype="multipart/form-data">
							<input type="hidden" name="_token" value="{{ csrf_token() }}">
							<div class="row">
							<div class="col-md-12">							
								<div class="form-group">
									<div class="col-md-2"></div>
	                                <label class="col-md-2 control-label">{{ trans('others.report_name_label') }}</label>
	                                <div class="col-md-6">
	                                    <input type="text" class="form-control" name="report_name" value="{{$data->reportName}}">
	                                </div>
	                            </div>

	                            <div class="form-group">
									<div class="col-md-3 col-md-offset-4">
										<div class="select">
											<select class="form-control" type="select" name="isActive" >
												<option  value="1" name="isActive" >{{ trans('others.action_active_label') }}</option>
												<option value="0" name="isActive" >{{ trans('others.action_inactive_label') }}</option>
										   </select>
										</div>
									</div>
								</div>
			                </div>
			                </div>

			                <div class="row">
			                <div class="col-md-12">
								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-heading">{{ trans('others.re_fo_siginingPerson_1_label') }}</div>
										<div class="panel-body">

											<div class="form-group">
												<div class="col-md-2"></div>
				                                <label class="col-md-2 control-label">{{ trans('others.person_name_label') }}</label>
				                                <div class="col-md-6">
				                                    <input type="text" class="form-control" name="per1_name" value="{{$data->siginingPerson_1}}">
				                                </div>
				                            </div>

											<div class="form-group">
				                                <label class="col-md-4 control-label">{{ trans('others.person_1_signature') }}</label>
				                                <div class="col-md-8">
				                                    <input type="file" class="" name="signature_1" value="{{old('signature_1')}}">
				                                </div>
				                            </div>

				                            <div class="form-group">
				                                <label class="col-md-4 control-label">{{ trans('others.persion_seal_label') }}</label>
				                                <div class="col-md-8">
				                                    <input type="file" class="" name="seal_1" value="{{old('seal_1')}}">
				                                </div>
				                            </div>
										</div>
									</div>

								</div>

								<div class="col-md-6">
									<div class="panel panel-default">
										<div class="panel-heading">{{ trans('others.re_fo_siginingPerson_2_label') }}</div>
										<div class="panel-body">

											<div class="form-group">
												<div class="col-md-2"></div>
				                                <label class="col-md-2 control-label">{{ trans('others.person_name_label') }}</label>
				                                <div class="col-md-6">
				                                    <input type="text" class="form-control" name="per2_name" value="{{$data->siginingPerson_2}}">
				                                </div>
				                            </div>

											<div class="form-group">
				                                <label class="col-md-4 control-label">{{ trans('others.person_1_signature') }}</label>
				                                <div class="col-md-8">
				                                    <input type="file" class="" name="signature_2" value="{{old('signature_2')}}">
				                                </div>
				                            </div>

				                            <div class="form-group">
				                                <label class="col-md-4 control-label">{{ trans('others.persion_seal_label') }}</label>
				                                <div class="col-md-8">
				                                    <input type="file" class="" name="seal_2" value="{{old('seal_2')}}">
				                                </div>
				                            </div>
				                        </div>

									</div>

								</div>
							</div>
							</div>

							<div class="row">
							<div class="col-md-12">
								<div class="form-group">
		                            <div class="col-md-offset-10">
	                                    <button type="submit" class="btn btn-primary" style="margin-right: 15px;">
	                                        {{ trans('others.update_button') }}
	                                	</button>
	                                </div>
	                            </div>
                            </div>
                            </div>
							
						</form>

						@endforeach
					</div>
				</div>
			</div>
		</div>
	</div>
@endsection
