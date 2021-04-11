<?php
/**
 * Database: Example DBObject
 * Auther: yamazakidaisuke
 * Create: --
 * Update: --
 */
class Db
{
    //****************************************************
    // プロパティ(MAMP設定)
    //****************************************************
    private $dbtype="mysql";
    private $dbname="dbname=gs_db;";
    private $char="charset=utf8;";
    private $host="host=localhost;";
    private $id="root";
    private $pw="root";
    protected $pdo;
    protected $stmt;
    private $names="";


    //****************************************************
    // コンストラクタ
    //****************************************************
    /**
     * Db constructor.
     */
    public function __construct(){
        try {
            $this->pdo = new PDO($this->dbtype.':'.$this->dbname.$this->char.$this->host, $this->id,$this->pw);
        } catch (PDOException $e) {
            throw new Exception("DbConnectError:".$e->getMessage());
        }
    }

    //****************************************************
    // Public
    //****************************************************
    /**
     * @param $sql_string (String)
     */
    public function sql($sql_string=""){
        if($sql_string!="") {
            $this->stmt = $this->pdo->prepare($sql_string);
        }else{
            throw new Exception("SQLString");
        }
    }

    /**
     * @param $name (String)
     * @param $str (String)
     */
    public function bindStr($name="",$str=""){
        if($name!="" && $str!="") {
            $this->stmt->bindValue($name, $str, PDO::PARAM_STR);
        }else{
            throw new Exception("bindStr::(".$name.",".$str.")");
        }
    }

    /**
     * @param $name (String)
     * @param $number (Integer)
     */
    public function bindInt($name="",$number=0){
        if($name!="" && is_int($number)) {
            $this->stmt->bindValue($name, $number, PDO::PARAM_INT);
        }else{
            throw new Exception("bindInt::(".$name.",".$number.")");
        }
    }

    /**
     * @return mixed (DataObject)
     */
    public function fetch(){
        return $this->stmt->fetch(PDO::FETCH_ASSOC);
    }

    /**
     * @param string $url
     */
    public function exec($url=""){
        //SQL実行
        $status = $this->stmt->execute();
        //Error
        if($status==false){
            $this->_error();
        }
        //URLが記述されていればリダイレクト
        if($url!=""){
            $this->_redirect($url);
        }
    }


    //****************************************************
    // Private
    //****************************************************
    //Error処理
    private function _error(){
        $error = $this->stmt->errorInfo();
        throw new Exception("QueryError:".$error[2]);
    }
    //header
    private function _redirect($url){
        header("Location: ".$url);
        exit;
    }

}