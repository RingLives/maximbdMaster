<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ trans('others.company_name_label')}}</title>

    <link href="/css/app.css" rel="stylesheet">

    <!-- Fonts -->
    <link href='//fonts.googleapis.com/css?family=Roboto:400,300' rel='stylesheet' type='text/css'>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle Navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#"><img src="{{ asset('assets') }}/img/logo.png" height="35px;" style="    margin-top: -7px;"></a>
            </div>

            <div class="col-md-5 col-md-offset-2"><h3><b>Maxim Order Management System</b></h3></div>

            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    {{-- <li><a href="/">Home</a></li> --}}
                </ul>

                <ul class="nav navbar-nav navbar-right">
                    @if (Auth::guest())
                        <li><a href="{{ Route('login') }}">{{ trans('others.login_label')}}</a></li>
                        <li><a href="{{ Route('register') }}">{{ trans('others.register_label')}}</a></li>
                    @else
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">{{ Auth::user()->first_name }} <span class="caret"></span></a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="/logout">{{ trans('others.logout_label')}}</a></li>
                            </ul>
                        </li>
                    @endif
                    <li>
                        <?php $languages = App\Http\Controllers\Trans\TranslationController::getLanguageList();?>
                        <div class="" style="margin-top: 8px;">
                            <select name="languageSwitcher" id="languageSwitcher" class="btn btn-primary form-control"  type="button">

                                @foreach($languages as $language)
                                    <option class="Sbutton" value="{{ $language->lan_code }}"
                                    {{ ($language->lan_code == Session::get('locale')) ? 'selected' : '' }}>
                                    {{ $language->lan_name }}</option>
                                @endforeach

                                {{ csrf_field() }}
                            </select>
                        </div>
                    </li>
                    
                </ul>
            </div>
        </div>
    </nav>

    @yield('content')

    <!-- Scripts -->
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.1/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="{{ asset("js/custom.js") }}"></script>
</body>
</html>




