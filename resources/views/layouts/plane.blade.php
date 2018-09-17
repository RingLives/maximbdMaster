<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8 no-js"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9 no-js"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en" class="no-js">
<!--<![endif]-->
<head>
	<meta charset="utf-8"/>
	<title>{{ trans('others.company_name')}}</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta content="width=device-width, initial-scale=1" name="viewport"/>
	<meta content="" name="description"/>
	<meta content="" name="author"/>
	<link rel="stylesheet" href="{{ asset('assets/stylesheets/styles.css') }}" />
	<link rel="stylesheet" href="{{ asset('assets/stylesheets/main.css') }}" />
	<link rel="stylesheet" href="{{ asset('assets/stylesheets/bootstrap-datepicker.css') }}" />

		{{-- for select2 --}}

	<link href="{{ asset('assets/customByMxp/css/select2.min.css') }}" rel="stylesheet" />
	<link rel="stylesheet" href="{{ asset('assets/stylesheets/preloder.css') }}" />
	<link rel="stylesheet" href="{{ asset('assets/scripts/easy-autocomplete.min.css') }}" />
	<link rel="stylesheet" href="{{ asset('assets/scripts/easy-autocomplete.themes.min.css') }}" />
	<link rel="stylesheet" href="{{ asset('assets/scripts/bootstrap-datetimepicker.min.css') }}" />
	<script src="{{ asset('assets/scripts/jquery-3.3.1.min.js') }}"></script>
	<script src="{{ asset('assets/customByMxp/js/select2.min.js') }}"></script>

</head>
<body>
	<?php $languages = App\Http\Controllers\Trans\TranslationController::getLanguageList();?>
	@yield('body')


	<script src="{{ asset('assets/scripts/moment.min.js') }}"></script>
	<script src="{{ asset('assets/scripts/bootstrap-datepicker.js') }}" type="text/javascript"></script>
	<script src="{{ asset('assets/scripts/bootstrap-datetimepicker.min.js') }}"></script>
	<script src="{{ asset('assets/scripts/frontend.js') }}" type="text/javascript"></script>
	<script type="text/javascript" src="{{ asset('js/custom.js') }}"></script>
	<script type="text/javascript" src="{{ asset('js/new_custom.js') }}"></script>
	<script type="text/javascript" src="{{ asset('js/all_product_table.js') }}"></script>
	<script type="text/javascript" src="{{ asset('js/journal.js') }}"></script>
	<script src="{{ asset('assets/scripts/json-2.4.js') }}"></script>
	{{--<!-- <script src="{{ asset('assets/scripts/bootstrap-datetimepicker.min.js') }}"></script> -->--}}
	<script src="{{ asset('assets/scripts/multipleTable.js') }}"></script>
	<script src="{{ asset('assets/scripts/task/buyer.js') }}"></script>
	<script src="{{ asset('assets/scripts/task/taskTpye.js') }}"></script>
	<script src="{{ asset('assets/scripts/item/apend_unit_price.js') }}"></script>
	<script src="{{ asset('assets/scripts/jquery.easy-autocomplete.min.js') }}"></script>
	<script type="text/javascript" src="{{ asset('js/production.js') }}"></script>

	{{--<script>--}}
	    {{--$(document).ready(function(){--}}
	      {{--var date_input=$('#datePickerDate'); //our date input has the name "date"--}}
	      {{--var container=$('.bootstrap-iso form').length>0 ? $('.bootstrap-iso form').parent() : "body";--}}
        {{--date_input.datepicker({--}}
            {{--format: 'mm/dd/yyyy',--}}
            {{--container: container,--}}
            {{--todayHighlight: true,--}}
            {{--autoclose: true,--}}
        {{--});--}}
        {{--});--}}
	{{--</script>--}}
	@yield('LoadScript')
</body>
</html>