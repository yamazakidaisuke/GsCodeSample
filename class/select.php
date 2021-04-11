<?php
include "Db.class.php";

try {
    //DB処理
    $db = new Db;
    $db->sql("SELECT * FROM gs_an_table");
    //$db->bindStr(":name","Yamazaki"); //bindValue：STRING用→Classに用意してます参考まで
    //$db->bindInt(":name","Yamazaki"); //bindValue：INT用→Classに用意してます参考まで
    $db->exec();

    //表示文字列作成
    $view="";
    while( $res = $db->fetch() ){
        $view .= '<tr>';
        $view .= '<td>'.$res["name"].'</td>';
        $view .= '<td>'.$res["email"].'</td>';
        $view .= '<td>'.$res["indate"].'</td>';
        $view .= '</tr>';
    }
} catch(Exception $e){
    echo "Error:".$e->getMessage();
    exit;
}
?>


<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>フリーアンケート表示</title>
    <link rel="stylesheet" href="css/range.css">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>div{padding: 10px;font-size:16px;}</style>
</head>
<body id="main">
<!-- Head[Start] -->
<header>
    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="index.php">データ登録</a>
            </div>
        </div>
    </nav>
</header>
<!-- Head[End] -->

<!-- Main[Start] -->
<div>
    <div class="container jumbotron">
        <table><?=$view?></table>
    </div>
</div>
<!-- Main[End] -->

</body>
</html>
