<?php $__env->startSection('body'); ?>
 <div id="wrapper">

        <!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="<?php echo e(route ('dashboard_view')); ?>">
                <!-- <?php echo e(trans('others.company_name')); ?> -->
                <img src="/assets/img/logo.png" width="180" height="">
            </a>
            </div>
            <!-- /.navbar-header -->


            <ul class="nav navbar-top-links navbar-right">
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-envelope fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-messages">
                        <li>
                            <a href="#">
                                <div>
                                    <strong>John Smith</strong>
                                    <span class="pull-right text-muted">
                                        <em>Yesterday</em>
                                    </span>
                                </div>
                                <div>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eleifend...</div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <strong>John Smith</strong>
                                    <span class="pull-right text-muted">
                                        <em>Yesterday</em>
                                    </span>
                                </div>
                                <div>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eleifend...</div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <strong>John Smith</strong>
                                    <span class="pull-right text-muted">
                                        <em>Yesterday</em>
                                    </span>
                                </div>
                                <div>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eleifend...</div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a class="text-center" href="#">
                                <strong>Read All Messages</strong>
                                <i class="fa fa-angle-right"></i>
                            </a>
                        </li>
                    </ul>
                    <!-- /.dropdown-messages -->
                </li>
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-tasks fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-tasks">
                        <li>
                            <a href="#">
                                <div>
                                    <p>
                                        <strong>Task 1</strong>
                                        <span class="pull-right text-muted">40% Complete</span>
                                    </p>

                                        <div>
                                        <?php echo $__env->make('widgets.progress', array('animated'=> true, 'class'=>'success', 'value'=>'40'), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                                            <span class="sr-only">40% Complete (success)</span>
                                        </div>

                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <p>
                                        <strong>Task 2</strong>
                                        <span class="pull-right text-muted">20% Complete</span>
                                    </p>

                                        <div>
                                        <?php echo $__env->make('widgets.progress', array('animated'=> true, 'class'=>'info', 'value'=>'20'), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                                            <span class="sr-only">20% Complete</span>
                                        </div>

                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <p>
                                        <strong>Task 3</strong>
                                        <span class="pull-right text-muted">60% Complete</span>
                                    </p>

                                        <div>
                                        <?php echo $__env->make('widgets.progress', array('animated'=> true, 'class'=>'warning', 'value'=>'60'), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                                            <span class="sr-only">60% Complete (warning)</span>
                                        </div>

                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <p>
                                        <strong>Task 4</strong>
                                        <span class="pull-right text-muted">80% Complete</span>
                                    </p>

                                        <div>
                                        <?php echo $__env->make('widgets.progress', array('animated'=> true,'class'=>'danger', 'value'=>'80'), array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>
                                            <span class="sr-only">80% Complete (danger)</span>
                                        </div>

                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a class="text-center" href="#">
                                <strong>See All Tasks</strong>
                                <i class="fa fa-angle-right"></i>
                            </a>
                        </li>
                    </ul>
                    <!-- /.dropdown-tasks -->
                </li>
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-bell fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-alerts">
                        <li>
                            <a href="#">
                                <div>
                                    <i class="fa fa-comment fa-fw"></i> New Comment
                                    <span class="pull-right text-muted small">4 minutes ago</span>
                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <i class="fa fa-twitter fa-fw"></i> 3 New Followers
                                    <span class="pull-right text-muted small">12 minutes ago</span>
                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <i class="fa fa-envelope fa-fw"></i> Message Sent
                                    <span class="pull-right text-muted small">4 minutes ago</span>
                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <i class="fa fa-tasks fa-fw"></i> New Task
                                    <span class="pull-right text-muted small">4 minutes ago</span>
                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href="#">
                                <div>
                                    <i class="fa fa-upload fa-fw"></i> Server Rebooted
                                    <span class="pull-right text-muted small">4 minutes ago</span>
                                </div>
                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a class="text-center" href="#">
                                <strong>See All Alerts</strong>
                                <i class="fa fa-angle-right"></i>
                            </a>
                        </li>
                    </ul>
                    <!-- /.dropdown-alerts -->
                </li>
                <!-- /.dropdown -->
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        <li><a href="<?php echo e(Route('user_profile_view')); ?>"><i class="fa fa-user fa-fw"></i>

                            <?php echo e(Auth::user()->first_name); ?>



                         </a>
                        </li>

                        <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a>
                        </li>
                        <li class="divider"></li>
                        <li>

                                    <li>
                                        <a href="<?php echo e(route('logout')); ?>"
                                            onclick="event.preventDefault();
                                                     document.getElementById('logout-form').submit();">
                                            Logout
                                        </a>

                                        <form id="logout-form" action="<?php echo e(route('logout')); ?>" method="POST" style="display: none;">
                                            <?php echo e(csrf_field()); ?>

                                        </form>
                                    </li>

                            </a>
                        </li>
                    </ul>
                    <!-- /.dropdown-user -->
                </li>
                <!-- /.dropdown -->
            </ul>
            <!-- /.navbar-top-links -->


             <div class="navbar-default sidebar" role="navigation">
                <div class="sidebar-nav navbar-collapse">
                    <ul class="nav" id="side-menu">
                         <li <?php echo e((Request::is('*dashboard') ? 'class="active"' : '')); ?>>
                            <a href="<?php echo e(Route ('dashboard_view')); ?>"><i class="fa fa-dashboard fa-fw"></i><?php echo e(trans('others.task_label')); ?></a>
                            
                      </li>


                        <?php if(!is_array(session()->get('UserMenus')) || is_object(session()->get('UserMenus')) ): ?>
                                <script type="text/javascript">
                                    window.location = "<?php echo e(url('/dashboard')); ?>";
                                </script>
                        <?php else: ?>

                                <?php $__currentLoopData = session()->get('UserMenus'); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $sl=>$menu): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <li>
                                    <a href="#"><i class="fa fa-cogs"></i>  <?php echo e($menu['name']); ?><span class="fa arrow"></span></a>
                                    <ul class="nav nav-second-level">

                                        <?php if($menu['subMenu']): ?>
                                            <?php $__currentLoopData = $menu['subMenu']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $sl=>$sub_menu): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                            <?php 
                                                $explode_route = explode("_",$sub_menu['route_name']);
                                                $action_route = $explode_route[count($explode_route)-1];
                                             ?>

                                                    <?php if($action_route!='action'): ?>
                                                        <li class="<?php echo e((Route::current()->getName() == $sub_menu['route_name']) ? 'active' : ''); ?>">
                                                            <a href="<?php echo e(($sub_menu['route_name'])? Route($sub_menu['route_name']):''); ?>"><?php echo e($sub_menu['name']); ?></a> </li>
                                                    <?php endif; ?>

                                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                            <!-- /.nav-second-level -->
                                        </li>
                                    <?php endif; ?>
                                    </ul>
                                    <!-- /.nav-second-level -->
                                </li>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                        <?php endif; ?>




                        

                    </ul>
                </div>
                <!-- /.sidebar-collapse -->
            </div>
            <!-- /.navbar-static-side -->
        </nav>

        <div id="page-wrapper">
			 <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header"><?php echo $__env->yieldContent('page_heading'); ?></h1>
                </div>
                <!-- /.col-lg-12 -->
           </div>
			<div class="row">
				<?php echo $__env->yieldContent('section'); ?>

            </div>
            <!-- /#page-wrapper -->
        </div>
    </div>
<?php $__env->stopSection(); ?>




<?php echo $__env->make('layouts.plane', array_except(get_defined_vars(), array('__data', '__path')))->render(); ?>