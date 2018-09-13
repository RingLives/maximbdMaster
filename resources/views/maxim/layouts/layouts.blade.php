<!DOCTYPE html>
<!-- <html lang="en" class="no-js"> -->
<head>
	<meta charset="utf-8"/>
	<!-- <title>Maxim</title> -->
	<title>
		@yield('title')
	</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta content="width=device-width, initial-scale=1" name="viewport"/>
	<meta content="" name="description"/>
	<meta content="" name="author"/>
	<link rel="icon" src="/public/favicon.ico" type="image/gif" sizes="16x16">
	<link rel="stylesheet" href="{{ asset('assets/printr/css/bootstrap.css') }}" />
	<link rel="stylesheet" href="{{ asset('assets/printr/css/main.css') }}" />
	<script src="{{ asset('assets/scripts/jquery-3.3.1.min.js') }}"></script>
	<script src="{{ asset('assets/scripts/jquery.printPage.js') }}"></script>
</head>
<body>
	<div class="container">
			<div class="col-md-12">
				@yield('print-body')
			</div>
	</div>
	
</body>
</html>