<!DOCTYPE html>
<!-- <html lang="en" class="no-js"> -->
<head>
	<meta charset="utf-8"/>
	<title>Maxim</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta content="width=device-width, initial-scale=1" name="viewport"/>
	<meta content="" name="description"/>
	<meta content="" name="author"/>
	<link rel="icon" src="/public/favicon.ico" type="image/gif" sizes="16x16">
	<script src="/ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
	<link rel="stylesheet" href="<?php echo e(asset("assets/printr/css/bootstrap.css")); ?>" />
	<link rel="stylesheet" href="<?php echo e(asset("assets/printr/css/main.css")); ?>" />
	<script src="<?php echo e(asset("assets/printr/js/bootstrap.min.js")); ?>"></script>
	<script src="<?php echo e(asset("assets/scripts/jquery-3.3.1.min.js")); ?>"></script>
	<script src="<?php echo e(asset("assets/scripts/jquery.printPage.js")); ?>"></script>
</head>
<body>
	<div class="container">
			<div class="col-md-12">
				<?php echo $__env->yieldContent('print-body'); ?>
			</div>
	</div>
	
</body>
</html>