<?php

class Personal{
    //privateなのでクラス外から直接アクセスはできない
    private $name; //プロパティ
    
    //publicなのでクラス外からアクセス可能
    public function setName($name){
        //privateプロパティ$nameへ値を代入
        $this->name = $name;
    }

    //publicなのでクラス外からアクセス可能
    public function getName(){
        //privateプロパティ$nameを返す
        return $this->name;
    }
}

$personal = new Personal;
$personal->setName("やまざき");
echo $personal->getName();






