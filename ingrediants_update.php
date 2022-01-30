<?php
$host = "pgsql.hrz.tu-chemnitz.de";
$port = "5432"; // should be 5432
$databaseName = "test_1";
$userName = "test_1_rw";
$password = "choot6poMei";
$db_handle = pg_connect("host=" . $host . " port=" . $port . " dbname=" . $databaseName . " user=" . $userName . " password=" . $password) or die("Die Verbindung konnte nicht aufgebaut werden.");
$ingredientId = $_GET['id'];
if (isset($_POST['update'])) {
    $Name = $_POST['inName'];
    $Provenance = $_POST['inReg'];
    $Price = floatval($_POST['inPrice']);
    $from_baker = $_POST['isshowed'];
    $Stock = $_POST['inStock'];
    $Price_show = $_POST['isshowed1'];


    $query = "select * from update_ingredients('$ingredientId','$Name','$Provenance','$Price','$from_baker','$Stock','$Price_show');";

    $result = pg_query($db_handle, $query);
}
?>

<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Ingrediants Update</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.7 -->
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/bower_components/bootstrap/dist/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <!--    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/bower_components/font-awesome/css/font-awesome.min.css">-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/bower_components/Ionicons/css/ionicons.min.css">
    <!-- jvectormap -->
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/bower_components/jvectormap/jquery-jvectormap.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="https://adminlte.io/themes/AdminLTE/dist/css/skins/_all-skins.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Google Font -->
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
</head>
<body class="hold-transition skin-red sidebar-mini">
<div class="wrapper">

    <header class="main-header">

        <!-- Logo -->
        <a href="index2.html" class="logo">
            <!-- mini logo for sidebar mini 50x50 pixels -->
            <!-- logo for regular state and mobile devices -->
            <span class="logo-lg"><b> MY Pizza</b>Store</span>
        </a>

        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top">
            <!-- Sidebar toggle button-->
            <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
                <span class="sr-only">Toggle navigation</span>
            </a>
            <!-- Navbar Right Menu -->
            <div class="navbar-custom-menu">
            </div>

        </nav>
    </header>
    <?php
    include 'sidebar.php'
    ?>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">

        </section>
        <section class="content">
            <form action="ingrediants_update.php?id=<?php echo $_GET['id']?>" method="post">
                <div class="form-group">
                                <label for="exampleInputEmail1">Name</label>
                                <input  <?php
                                $querypizzacomp = "select * from get_all_ingredients()";

                                $compositoinres = pg_query($db_handle, $querypizzacomp) or die("Cannot execute query: $querypizzacomp\n");
                                if ($compositoinres){
                                    while($row = pg_fetch_row($compositoinres))
                                    {
                                        echo $row[1];

                                    }
                                }
                                ?>

                                        type="text" class="form-control" id="exampleInputEmail1" name="inName" placeholder="Name">
                                <label for="exampleInputEmail1">Regional Provenance</label>
                                <input type="text" class="form-control" id="exampleInputEmail1" name="inReg" placeholder="Regional Provenance">
                                <label for="exampleInputEmail1">Price</label>
                                <input type="text" class="form-control" id="exampleInputEmail1" name="inPrice" placeholder="Price">
                                <br>
                                <label for="exampleInputPassword1">From Baker</label>
                                <select name="isshowed">
                                    <option selected></option>
                                    <option value="true">true</option>
                                    <option value="false">false</option>
                                </select>
                                <br>
                                <br>
                                <label for="exampleInputEmail1">Stock Amount</label>
                                <input type="text" class="form-control" id="exampleInputEmail1" name="inStock" placeholder="Stock Amount">
                                <br>
                                <label for="exampleInputPassword1">Ingrediants Show</label>
                                <select name="isshowed1">
                                    <option selected></option>
                                    <option value="true">true</option>
                                    <option value="false">false</option>
                                </select>
                                <button type="submit" name="update" class="btn btn-primary">Update</button>

                </div>

            </form>

        </section>
        <!-- Main content -->

        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->
    <div class="box-body">

        <table class="table table-striped">
            <thead>
            <tr>
                <th>
                    Name
                </th>
                <th>
                    Is active
                </th>
            </tr>
            </thead>
            <tbody>


            </tbody>
        </table>
    </div>

</div>
<!-- ./wrapper -->

<!-- jQuery 3 -->
<script src="https://adminlte.io/themes/AdminLTE/bower_components/jquery/dist/jquery.min.js"></script>
<!-- Bootstrap 3.3.7 -->
<script src="https://adminlte.io/themes/AdminLTE/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- FastClick -->
<script src="https://adminlte.io/themes/AdminLTE/bower_components/fastclick/lib/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="https://adminlte.io/themes/AdminLTE/dist/js/adminlte.min.js"></script>
<!-- Sparkline -->
<script src="https://adminlte.io/themes/AdminLTE/bower_components/jquery-sparkline/dist/jquery.sparkline.min.js"></script>
<!-- jvectormap  -->
<script src="https://adminlte.io/themes/AdminLTE/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
<script src="https://adminlte.io/themes/AdminLTE/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
<!-- SlimScroll -->
<script src="https://adminlte.io/themes/AdminLTE/bower_components/jquery-slimscroll/jquery.slimscroll.min.js"></script>
<!-- ChartJS -->
<script src="https://adminlte.io/themes/AdminLTE/bower_components/chart.js/Chart.js"></script>
<!-- AdminLTE dashboard demo (This is only for demo purposes) -->
<script src="https://adminlte.io/themes/AdminLTE/dist/js/pages/dashboard2.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="https://adminlte.io/themes/AdminLTE/dist/js/demo.js"></script>
</body>
</html>


