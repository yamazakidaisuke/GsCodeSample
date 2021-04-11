<?php

class Personal{
    //publicなのでクラス外からアクセス可能
    public $name;
    
    //publicなのでクラス外からアクセス可能
    public function __construct($name){
        //publicプロパティ$nameへ値を代入
        $this->name = $name;
    }
}

//Personalクラスをインスタンス化
$p = new Personal("yamazaki");
echo $p->name; //Personalクラスの$nameを参照






