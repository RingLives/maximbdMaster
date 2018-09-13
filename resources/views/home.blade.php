@extends ('layouts.plane')
@section ('body')
<div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
            <br /><br /><br />
               @section ('login_panel_title','Please Sign In To Access the Dashboard')
               @section ('login_panel_body')
                        <form role="form" action="">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" placeholder="E-mail" name="email" type="email" autofocus>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="Password" name="password" type="password" value="">
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input name="remember" type="checkbox" value="Remember Me">
                                        {{ trans('home.login_rememberme_label')}}
                                        
                                    </label>
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <a href="{{ url ('login') }}" class="btn btn-lg btn-success btn-block">Login</a>
                                <br>
                                <a href="{{ url ('register') }}" class="btn btn-lg btn-danger btn-block">Registration</a>
                            </fieldset>
                        </form>
                    
                @endsection
                @include('widgets.panel', array('as'=>'login', 'header'=>true))
            </div>
        </div>

    </div>
@stop