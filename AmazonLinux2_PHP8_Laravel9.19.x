###############################################################################
# 更新日：2022-10-15
#  Laravel9.19 ~ CURD実装版
#  環境：PHP8.x.x AmazonLinux2 のインストール
###############################################################################


#PHPセットアップ
#<重要！！必ず１行ずつコマンドを打つこと！>
// パッケージのアップデート
sudo yum update -y

// composerバージョンアップ(必要なくなった)
# sudo composer self-update

// PHPのパッケージをすべてアンインストール
sudo yum -y remove php-*

// amazon-linux-extrasをアップデート
sudo yum update -y amazon-linux-extras

// amazon-linux-extrasで使用中のパッケージと使えるパッケージを確認
amazon-linux-extras

// lamp-mariadb10.2-php7.2を使用停止
sudo amazon-linux-extras disable lamp-mariadb10.2-php7.2

// PHP8.0を有効化
sudo amazon-linux-extras enable php8.0

// インストールするパッケージの案内があったので、表示されたコマンドを実行
sudo yum clean metadata && sudo yum install php-cli php-pdo php-fpm php-mysqlnd
sudo yum install php-cli php-common php-devel php-fpm php-gd php-mysqlnd php-mbstring php-pdo php-xml

// apacheなどを再起動
sudo systemctl restart httpd.service
sudo systemctl restart php-fpm.service



# MaryaDB 構築
#MariaDBデフォルト確認
sudo yum list installed | grep mariadb


#MariaDBのインストール

sudo amazon-linux-extras install mariadb10.5 -y


#Apache, MariaDBの起動

sudo systemctl start mariadb

sudo mysql_secure_installation


#MaridaDBの自動起動を有効化

sudo systemctl enable mariadb

sudo systemctl is-enabled mariadb


#Composerインストール

curl -sS https://getcomposer.org/installer | php

sudo mv composer.phar /usr/bin/composer

composer


#Laravelインストール ( バージョン指定する場合 → composer create-project "laravel/laravel=9.*" cms )

composer create-project laravel/laravel cms

#ディレクトリ移動(cmsはlaravelがフォルダ名です)

cd cms

sudo composer update


################
# ここでエラー or 上手くいってないようだったら！！
################

sudo yum install php-cli php-common php-devel php-fpm php-gd php-mysqlnd php-mbstring php-pdo php-xml

sudo composer update

php artisan key:generate

################
#で解決するはず（私はこれで解決しました）
################




#BuiltInサーバーを起動：動作確認

php artisan serve --port=8080


#4. [完了]Webサーバー起動確認***
#4.1 Preview→ [Preview Running Application]選択
#4.2 /resouces/views/welcome.blade.php を編集して見よう！
#4.3 ブラウザ・更新で確認 →　変更確認できればOK





#**********************************************
#  超大事！！！！！！！！！！！！！！！
#  いつも使うので、覚えておくか直ぐコピペできる場所に書いておきましょう！
#*********************************************

#！！ [.env] 設定を変更したら必ずWebサーバーを再起動！！
------
#Webサーバー止める
[ Ctl + C ]キーでWebサーバーを止めます。
------
#Webサーバー起動（.envの再読み込み！）
php artisan serve --port=8080
-------


#6.[完了]DB接続設定完了***
#  ＜重要＞間違うと「データ構造を作成（テーブル作成）」の次章でError!




#--------------------------------------------
# ＜重要＞ AWS EC2環境では必須追記！！ → MAMP/XAMPPの場合は無視！
# /app/Providers/ AppServiceProvider.php ファイルを修正
#--------------------------------------------
use Illuminate\Support\Facades\URL;    //この行を追加
public function boot() {
   URL::forceScheme('https');          //この行を追加
}

#[完了]Laravel6以上 対応設定 完了***



#--------------------------------------------
#データベース作成
#--------------------------------------------
mysql -u root -p
root [Enterキー]
create database c9;
exit;


#--------------------------------------------
#.env（ファイル内の同じ箇所を上書き）
#--------------------------------------------
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=c9
DB_USERNAME=root
DB_PASSWORD=root



#----------------------
#phpMyAdmin設定
#----------------------
cd public   ＃/cms/publicフォルダに移動

wget https://files.phpmyadmin.net/phpMyAdmin/5.1.2/phpMyAdmin-5.1.2-all-languages.zip

unzip phpMyAdmin-5.1.2-all-languages.zip

cd ..


#＜手順解説＞
#5.1 publicフォルダ内に「phpMyAdmin-5.1.2-all-languages」フォルダが作成される 
#5.2 フォルダ名が長いので「phpMyAdmin」に変更
#5.3「Preview」でサイトを開き、URLの最後に「phpMyAdmin/index.php」をつけてEnterキーを押す
#5.4 URL例： https://＊＊＊＊＊＊.cloud9.us-east-1.amazonaws.com/phpMyAdmin/index.php
#5.5 phpMyAdmin画面が表示されたら： ユーザー名・パスワードともに「root」を入力してログイン
#5.6 ログインできればOK

#5.[完了]DB動作＆コマンド確認完了***

#*********************************************************************************
#ここまでが初期設定
#*********************************************************************************





#*********************************************************************************
# Auth( ユーザー登録・認証画面とテンプレート作成 )
#ver Laravel 9.19 ~ 以降対応
#*********************************************************************************
# laravel/ui パッケージをインストール（４ステップ！）
# 【注意】Laraveのバージョンを確認して実行しないとErrorになります！！
#  コマンド打って、yes/no がでたらyes で！！
-----

#1. Laravel 9.x の場合
sudo composer require laravel/breeze --dev

#2. artisan コマンドを実行
php artisan breeze:install

#3. npmパッケージをインストール
npm install

#4. パッケージをビルド
npm run build

#5．テーブル作成
php artisan migrate

--------------------------------------------------
// ログイン機能・画面が作成されました。






#***************************
# データ構造を作成（テーブル作成） 
#***************************
#--------------------------------------------
#１．booksテーブルを作成（マイグレーションファイル作成）
#--------------------------------------------
php artisan make:migration create_books_table --create=books

#1.[完了]Tableを作成するMigrationファイルを作成 完了***


#--------------------------------------------
#２．[年]_[月]_[日]_[時分秒]_create_books_table.php
#   57ページ
#   public function up(){...}の中を追加修正
#--------------------------------------------
public function up()
    {
        Schema::create('books', function (Blueprint $table) {
            $table->id();
            //** ↓ 下をコピー ↓ **
            $table->string('item_name');
            $table->integer('item_number');
            $table->integer('item_amount');
            $table->datetime('published');
            //** ↑ 上をコピー ↑ **
            $table->timestamps();
        });
}

#2.[完了]Table作成するスクリプト準備 完了***




#--------------------------------------------
#３．マイグレーションを実行（テーブル作成）
#   52ページ
#--------------------------------------------
php artisan migrate

#3.[完了]Table作成スクリプト実行 完了***


#--------------------------------------------
#４．MySQL DBに作成されたテーブルを確認 
#   59ページ
#--------------------------------------------
# ※コマンドで確認する（コマンドに慣れてる人用）
mysql -u root -p
root [Enterキー]
use c9;
show tables;
desc books;
exit;


#4.[完了]Table作成をMySQLコマンドで確認 完了***



#--------------------------------------------
#５．モデル＆コントローラー&Viewも一緒に作成
#   （テーブルを簡単に扱えるようにする機能）
#--------------------------------------------
php artisan make:model Book -cr

#5.[完了]DBを簡単に操作するためのファイルを作成 完了***



#--------------------------------------------
#６．モデルを作成（テーブルを簡単に扱えるようにする機能）
#   /app/models/Book.php に作成されます。
#   /app/Http/Controllers/BookController.php に生成されます。
#   /app/Http/Controllers/BookController.php にメソッドも自動で生成
#--------------------------------------------

#6.[完了]/app/models/Book.phpにファイルができて完了***





#***************************
# ルート定義（ルーティング）
#***************************
#--------------------------------------------
#１．/routes/web.php に 以下コードを貼り付けます。
#--------------------------------------------
#以下[END]までの全てのコードをコピー
<?php

use Illuminate\Support\Facades\Route;
use App\Models\Book; //Add
use Illuminate\Http\Request;
use App\Http\Controllers\BookController; //Add

//本：ダッシュボード表示(books.blade.php)
Route::get('/', [BookController::class,'index'])->middleware(['auth'])->name('book_index');

//本：追加 
Route::post('/books',[BookController::class,"store"])->name('book_store');

//本：削除 
Route::delete('/book/{book}', [BookController::class,"destroy"])->name('book_destroy');

//本：更新画面
Route::post('/booksedit/{book}',[BookController::class,"edit"])->name('book_edit'); //通常
Route::get('/booksedit/{book}', [BookController::class,"edit"])->name('edit');      //Validationエラーありの場合

//本：更新画面
Route::post('/books/update',[BookController::class,"update"])->name('book_update');

/**
* 「ログイン機能」インストールで追加されています 
*/
Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth'])->name('dashboard');

require __DIR__.'/auth.php';



#[END]--------------------------------------------





#***************************
# View
#***************************

#--------------------------------------------
# 1．/resources/views/components/collection.blade.php を作成
#    Laravel9.19~ コンポーネント必須です。登録されたデータをコンポーネント化して表示してみましょう！
#--------------------------------------------
#以下[END]までの全てのコードをコピー


<div class="flex justify-between p-4 items-center bg-blue-500 text-white rounded-lg border-2 border-white">
  <div>{{ $slot }}</div>
  <button>×</button>
</div>


#[END]--------------------------------------------



#--------------------------------------------
# 2．/resources/views/components/errors.blade.php を作成 
#--------------------------------------------
#以下[END]までの全てのコードをコピー


<!-- resources/views/components/errors.blade.php -->
@if (count($errors) > 0)
    <!-- Form Error List -->
    <div class="flex justify-between p-4 items-center bg-red-500 text-white rounded-lg border-2 border-white">
        <div><strong>入力した文字を修正してくた?さい。</strong></div> 
        <div>
            <ul>
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
            </ul>
        </div>
    </div>
@endif


#[END]--------------------------------------------




#--------------------------------------------
# 3．/resources/views/books.blade.php を作成
#--------------------------------------------
#以下[END]までの全てのコードをコピー


<!-- resources/views/books.blade.php -->
<x-app-layout>

    <!--ヘッダー[START]-->
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            <form action="{{ route('book_index') }}" method="GET" class="w-full max-w-lg">
                <x-button class="bg-gray-100 text-gray-900">{{ __('Dashboard') }}</x-button>
            </form>
        </h2>
    </x-slot>
    <!--ヘッダー[END]-->
            
        <!-- バリデーションエラーの表示に使用-->
       <x-errors id="errors" class="bg-blue-500 rounded-lg">{{$errors}}</x-errors>
        <!-- バリデーションエラーの表示に使用-->
    
    <!--全エリア[START]-->
    <div class="flex bg-gray-100">

        <!--左エリア[START]--> 
        <div class="text-gray-700 text-left px-4 py-4 m-2">
            
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 bg-white border-b border-gray-500 font-bold">
                    本を管理する
                </div>
            </div>


            <!-- 本のタイトル -->
            <form action="{{ url('books') }}" method="POST" class="w-full max-w-lg">
                @csrf
                  <div class="flex flex-col px-2 py-2">
                   <!-- カラム１ -->
                    <div class="w-full md:w-1/1 px-3 mb-2 md:mb-0">
                      <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2">
                       Book Name
                      </label>
                      <input name="item_name" class="appearance-none block w-full text-gray-700 border border-red-500 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white" type="text" placeholder="">
                    </div>
                    <!-- カラム２ -->
                    <div class="w-full md:w-1/1 px-3">
                      <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2">
                        金額
                      </label>
                      <input name="item_amount" class="appearance-none block w-full text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" type="text" placeholder="">
                    </div>
                    <!-- カラム３ -->
                    <div class="w-full md:w-1/1 px-3 mb-2 md:mb-0">
                      <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2">
                        数
                      </label>
                      <input name="item_number" class="appearance-none block w-full text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" type="text" placeholder="">
                    </div>
                    <!-- カラム４ -->
                    <div class="w-full md:w-1/1 px-3 mb-6 md:mb-0">
                      <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2">
                        発売日
                      </label>
                      <input name="published" type="date" class="appearance-none block w-full text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" type="text" placeholder="">
                    </div>
                  </div>
                  <!-- カラム５ -->
                  <div class="flex flex-col">
                      <div class="text-gray-700 text-center px-4 py-2 m-2">
                             <x-button class="bg-blue-500 rounded-lg">送信</x-button>
                      </div>
                   </div>
            </form>
        </div>
        <!--左エリア[END]--> 
    
    
    <!--右側エリア[START]-->
    <div class="flex-1 text-gray-700 text-left bg-blue-100 px-4 py-2 m-2">
        <x-collection>テスト１</x-collection>
        <x-collection>テスト２</x-collection>
        <x-collection>テスト３</x-collection>
    </div>
    <!--右側エリア[[END]-->       

</div>
 <!--全エリア[END]-->

</x-app-layout>



#[END]--------------------------------------------




#--------------------------------------------
# 4．/resources/views/components/button.blade.php 以下確認
#  *** 要チェック！！「 無ければ作成！ 」***
#    Laravel9.19~ コンポーネントがあったりなかったり、、、無ければ追加作成です！！
#--------------------------------------------
#以下[END]までの全てのコードをコピー


<button {{ $attributes->merge(['type' => 'submit', 'class' => 'inline-flex items-center px-4 py-2 bg-gray-800 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 active:bg-gray-900 focus:outline-none focus:border-gray-900 focus:ring ring-gray-300 disabled:opacity-25 transition ease-in-out duration-150']) }}>
    {{ $slot }}
</button>


#[END]--------------------------------------------






#***************************
#  コンポーネントをビルド
#  表示確認
#***************************

npm run build





#***************************
# Controller
#***************************
#--------------------------------------------
#0．/app/Http/Controllers/BookController.php
#   use の次の行に追加
#--------------------------------------------
# use App\Models\Book; 
# use Illuminate\Http\Request;

use Validator;  //この1行だけ追加！



#--------------------------------------------
#１．/app/Http/Controllers/BookController.php
#   データ登録[BookController::class,"store"]
#--------------------------------------------
#以下[END]までの全てのコードをコピー

public function store(Request $request) {
   //** ↓ 下をコピー ↓ **
   
      
    //バリデーション
    $validator = Validator::make($request->all(), [
         'item_name' => 'required|min:3|max:255',
         'item_number' => 'required | min:1 | max:3',
         'item_amount' => 'required | max:6',
         'published'   => 'required',
    ]);

    //バリデーション:エラー 
    if ($validator->fails()) {
        return redirect('/')
            ->withInput()
            ->withErrors($validator);
    }
    //以下に登録処理を記述（Eloquentモデル）

  // Eloquentモデル
  $books = new Book;
  $books->item_name   = $request->item_name;
  $books->item_number = $request->item_number;
  $books->item_amount = $request->item_amount;
  $books->published   = $request->published;
  $books->save(); 
  return redirect('/');
  
  
   //** ↑ 上をコピー ↑ **
}


#[END]--------------------------------------------



#--------------------------------------------
#2．/app/Http/Controllers/BookController.php
#   データ取得・表示[BookController::class,"index"]
#--------------------------------------------
#以下[END]までの全てのコードをコピー


public function index() {
   //** ↓ 下をコピー ↓ **    
    
    $books = Book::orderBy('created_at', 'asc')->get();
    return view('books', [
        'books' => $books
    ]);
    
    //** ↑ 上をコピー ↑ **
}


#[END]--------------------------------------------




#--------------------------------------------
# 3．/resources/views/books.blade.php
#   books.blade.phpの 右側エリアを全て上書き！！
#--------------------------------------------
#以下[END]までの全てのコードをコピー


    <!--右側エリア[START]-->
    <div class="flex-1 text-gray-700 text-left bg-blue-100 px-4 py-2 m-2">
         <!-- 現在の本 -->
        @if (count($books) > 0)
            @foreach ($books as $book)
                <x-collection id="{{ $book->id }}">{{ $book->item_name }}</x-collection>
            @endforeach
        @endif
    </div>
    <!--右側エリア[[END]-->     
    


#[END]--------------------------------------------




#--------------------------------------------
# 4．/resources/views/components/collection.blade.php を更新！！
#    collectionコンポーネントを全て上書き！！
#--------------------------------------------
#以下[END]までの全てのコードをコピー


  <!-- 本: 削除ボタン -->
<div class="flex justify-between p-4 items-center bg-blue-500 text-white rounded-lg border-2 border-white">
  <div>{{ $slot }}</div>
  
    <div>
    <form action="{{ url('booksedit/'.$id) }}" method="POST">
         @csrf
         
        <button type="submit"  class="btn bg-blue-500 rounded-lg">
            更新
        </button>
        
     </form>
  </div>
  
  <div>
    <form action="{{ url('book/'.$id) }}" method="POST">
         @csrf
         @method('DELETE')
        
        <button type="submit"  class="btn bg-blue-500 rounded-lg">
            削除
        </button>
        
     </form>
  </div>

</div>



#[END]--------------------------------------------





#--------------------------------------------
# 5．/app/Http/Controllers/BookController.php
#   データ削除[BookController::class,"destroy"]
#--------------------------------------------
#以下[END]までの全てのコードをコピー


public function destroy(Book $book) {
   //** ↓ 下をコピー ↓ **    
    
    $book->delete();       //追加
    return redirect('/');  //追加
    
     //** ↑ 上をコピー ↑ **
});



#Errorが出た場合以下のコマンドでdeleteになっているか確認
#「　php artisan route:list -v  」
#[END]--------------------------------------------





#--------------------------------------------
# 1．[更新機能] 画面を作成
#   /resources/views/booksedit.blade.php を作成
#--------------------------------------------
#以下[END]までの全てのコードをコピー


<!-- resources/views/booksedit.blade.php -->
<x-app-layout>

    <!--ヘッダー[START]-->
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            <form action="{{ route('book_index') }}" method="GET" class="w-full max-w-lg">
                <x-button class="bg-gray-100 text-gray-900">{{ __('Dashboard') }}：更新画面</x-button>
            </form>
        </h2>
    </x-slot>
    <!--ヘッダー[END]-->
            
        <!-- バリデーションエラーの表示に使用-->
        <x-errors id="errors" class="bg-blue-500 rounded-lg">{{$errors}}</x-errors>
        <!-- バリデーションエラーの表示に使用-->
    
    <!--全エリア[START]-->
    <div class="flex bg-gray-100">

        <!--左エリア[START]--> 
        <div class="text-gray-700 text-left px-4 py-4 m-2">
            
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 bg-white border-b border-gray-500 font-bold">
                    本を管理する
                </div>
            </div>


            <!-- 本のタイトル -->
            <form action="{{ url('books/update') }}" method="POST" class="w-full max-w-lg">
                @csrf
                
                  <div class="flex flex-col px-2 py-2">
                   <!-- カラム１ -->
                    <div class="w-full md:w-1/1 px-3 mb-2 md:mb-0">
                      <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2">
                       Book Name
                      </label>
                      <input name="item_name" value="{{$book->item_name}}" class="appearance-none block w-full text-gray-700 border border-red-500 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white" type="text" placeholder="">
                    </div>
                    <!-- カラム２ -->
                    <div class="w-full md:w-1/1 px-3">
                      <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2">
                        金額
                      </label>
                      <input name="item_amount" value="{{$book->item_amount}}" class="appearance-none block w-full text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" type="text" placeholder="">
                    </div>
                    <!-- カラム３ -->
                    <div class="w-full md:w-1/1 px-3 mb-2 md:mb-0">
                      <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2">
                        数
                      </label>
                      <input name="item_number" value="{{$book->item_number}}" class="appearance-none block w-full text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500" type="text" placeholder="">
                    </div>
                    <!-- カラム４ -->
                    <div class="w-full md:w-1/1 px-3 mb-6 md:mb-0">
                      <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2">
                        発売日
                      </label>
                      <input name="published" type="datetime-local" value="{{$book->published}}" class="appearance-none block w-full text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500"  placeholder="">
                    </div>
                  </div>
                  <!-- カラム５ -->
                  <div class="flex flex-col">
                      <div class="text-gray-700 text-center px-4 py-2 m-2">
                             <x-button class="bg-blue-500 rounded-lg">更新</x-button>
                      </div>
                   </div>
                <!-- id値を送信 -->
                <input type="hidden" name="id" value="{{$book->id}}">
                <!--/ id値を送信 -->
            </form>
        </div>
        <!--左エリア[END]--> 
    
    
    <!--右側エリア[START]-->
    <div class="flex-1 text-gray-700 text-left bg-blue-100 px-4 py-2 m-2">
      
    </div>
    <!--右側エリア[[END]-->       

</div>
 <!--全エリア[END]-->

</x-app-layout>



#[END]--------------------------------------------




#--------------------------------------------
# 2．[更新機能] コントローラー
#   /app/Http/Controllers/BookController.php
#   更新画面・ルーティング[BookController::class,"edit"]
#--------------------------------------------
#以下[END]までの全てのコードをコピー
    
    
 public function edit(Book $book)
    {
        //** ↓ 下をコピー ↓ **
        
        //{books}id 値を取得 => Book $books id 値の1レコード取得
        return view('booksedit', ['book' => $book]);
        
        //** ↑ 上をコピー ↑ **!
    }
    
    
#[END]--------------------------------------------




#--------------------------------------------
# 3．[更新機能] 更新処理
#   /app/Http/Controllers/BookController.php
#   データ更新・処理[BookController::class,"update"]
#--------------------------------------------
#以下[END]までの全てのコードをコピー
    
 
    public function update(Request $request, Book $book)
    {
      //** ↓ 下をコピー ↓ **


        //バリデーション
         $validator = Validator::make($request->all(), [
             'id' => 'required',
             'item_name' => 'required|min:3|max:255',
             'item_number' => 'required|min:1|max:3',
             'item_amount' => 'required|max:6',
             'published' => 'required',
        ]);
        //バリデーション:エラー
         if ($validator->fails()) {
             return redirect('/booksedit/'.$request->id)
                 ->withInput()
                 ->withErrors($validator);
        }
        
        //データ更新
        $books = Book::find($request->id);
        $books->item_name   = $request->item_name;
        $books->item_number = $request->item_number;
        $books->item_amount = $request->item_amount;
        $books->published   = $request->published;
        $books->save();
        return redirect('/');
        
        
        //** ↑ 上をコピー ↑ **!
    }
    
    
#[END]--------------------------------------------





========================================================================================================
★ Pagenation 
========================================================================================================
#**************************************************
# 1. コントローラ：indexメソッドの修正
#**************************************************
 BookController に 以下コードを貼り付けます。
#--------------------------------------------
#以下[END]までの全てのコード、indexメソッドのみ上書き。

    public function index()
    {
        $books = Book::orderBy('created_at', 'asc')->paginate(3);
        return view('books', [
            'books' => $books
        ]);
    }

#[END]--------------------------------------------

#**************************************************
# 2. ビュー：コードを追加
#**************************************************
 books.blade.php に 以下コードを追加します。
  <!--右側エリア[START]-->の下に追加
#--------------------------------------------
#以下[END]まで

        <div>
            {{ $books->links()}}
        </div>

#[END]--------------------------------------------






========================================================================================================
★ログインしたユーザーにしか表示させない設定
========================================================================================================
#--------------------------------------------
#  方法１．コンストラクタを追加 [ログインしていない場合にLOGIN画面へ遷移]
#   /app/Http/Controllers/BookController.php
#   classに追加
#--------------------------------------------
#以下[END]までの全てのコードをコピー


 public function __construct()
 {
      $this->middleware('auth');
 }


#[END]--------------------------------------------

#--------------------------------------------
#  方法２． Route::groupを使ったログイン認証
# * 注意）上記4の「コンストラクタ」か「Route::group」のどちらかだけの記述にします。
#--------------------------------------------

Route::group(['middleware' => 'auth'], function () {
   //LOGIN認証後にしか見せたくないルーティングは中に入れる
   //...
});


#[END]--------------------------------------------






========================================================================================================
★ユーザーがログインしたらユーザーが登録した本のみ表示（１ユーザー ✕ １サービス）
========================================================================================================


#**************************************************
#１．ユーザーidを登録できるようにbooksテーブルを変更
#**************************************************
/database/migrations/[yyyy_mm_dd_hhiiss]_create_books_table.php に以下１行を追加します。
#--------------------------------------------

$table->bigInteger('user_id'); //Add:user_id

#[END]--------------------------------------------



#**************************************************
#２．テーブルをリセットする
#**************************************************
#cmsディレクトリで実行
cd cms

#Migrate実行
php artisan migrate:reset

#[END]--------------------------------------------



#**************************************************
#３．テーブルを再構築
#**************************************************

php artisan migrate

#[END]--------------------------------------------

#実は以下コマンドでresetとmigrateを一気に実行可能です！
# php artisan migrate:refresh


#**************************************************
#４．再構築したテーブルを確認
#**************************************************

mysql -u root -p
root  #パスワード
use c9;
show tables;
desc books;

#[END]--------------------------------------------



#**************************************************
#５．コントローラ「BooksController@index」を修正（リスト16.13）
#**************************************************

 $books = Book::where('user_id',Auth::user()->id)->orderBy('created_at', 'asc')->paginate(3);

#[END]--------------------------------------------




#**************************************************
#６．コントローラ「BooksController@store」に追加
#**************************************************

$books->user_id  = Auth::user()->id; //追加のコード

#[END]--------------------------------------------




#**************************************************
#７．コントローラ「BooksController@update」を修正
#**************************************************

$books = Book::where('user_id',Auth::user()->id)->find($request->id);

#[END]--------------------------------------------




#**************************************************
#８．コントローラ「BooksController@edit」を修正
#**************************************************
#修正範囲が多いのでeditメソッドを上書きでもOK

//更新画面
public function edit($book_id){
    $books = Book::where('user_id',Auth::user()->id)->find($book_id);
    return view('booksedit', ['book' => $books]);
}
    
#[END]--------------------------------------------


#**************************************************
#9. ContorollerでAuthを使うための設定を追加
#   BookControllerの最初の方に記述
#**************************************************

use Auth;

#[END]--------------------------------------------



#*************************************************
#  Login画面にRegister画面のリンクを追加
#**************************************************
#<x-slot name="logo">
#   <a href="/">
#       <x-application-logo class="w-20 h-20 fill-current text-gray-500" />
#   </a>
#</x-slot>
#...

<!-- 以下を追加 -->
@if (Route::has('login'))
    <div class="hidden fixed top-0 right-0 px-6 py-4 sm:block">
        @auth
            <a href="{{ url('/dashboard') }}" class="text-sm text-gray-700 dark:text-gray-500 underline">Dashboard</a>
        @else
            <a href="{{ route('login') }}" class="text-sm text-gray-700 dark:text-gray-500 underline">Log in</a>

            @if (Route::has('register'))
                <a href="{{ route('register') }}" class="ml-4 text-sm text-gray-700 dark:text-gray-500 underline">Register</a>
            @endif
        @endauth
    </div>
@endif
<!--ここまで-->





