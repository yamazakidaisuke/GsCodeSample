###############################################################################
# 更新日：2023-12-13
#  Laravel0 ~ CURD実装版
#  環境：PHP8.2.9 Amazon Linux 2023 のインストール
#  解説Video 
#  2023/12/13 17時公開: ************
###############################################################################

# MaryaDB 再構築
#MariaDBデフォルト確認
sudo yum list installed | grep mariadb

#Apache, MariaDBの起動

sudo systemctl start mariadb

sudo mysql_secure_installation


#MaridaDBの自動起動を有効化

sudo systemctl enable mariadb

sudo systemctl is-enabled mariadb


# DB接続確認

mysql -u root -p

root

exit;


#Composerインストール

curl -sS https://getcomposer.org/installer | php

sudo mv composer.phar /usr/bin/composer

composer


#Laravelインストール
# バージョン指定する場合 → composer create-project "laravel/laravel=10.*" cms 
# Laravel0.x 最新を指定 → composer create-project --prefer-dist laravel/laravel cms dev-master

composer create-project laravel/laravel cms

#ディレクトリ移動(cmsはlaravelがフォルダ名です)

cd cms

sudo composer update



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
#ver Laravel 9.48 ~ 以降対応
#*********************************************************************************
# laravel/ui パッケージをインストール（４ステップ！）
# 【注意】Laraveのバージョンを確認して実行しないとErrorになります！！
#  コマンド打って、yes/no がでたらyes で！！
-----
# 0. ＜＜重要＞＞cmsの中で実行
cd cms

#1. Laravel 10.x の場合
sudo composer require laravel/breeze --dev

#2. artisan コマンドを実行
php artisan breeze:install


#3.以下が表示されます
「 Blade with Alpine 」をキーボードの↑↓で選択してEnter

#4
 Yes 選択してEnter

#5
PHPUnit を選択してEnter

#6. パッケージをビルド
npm run build

#8．テーブル作成
php artisan migrate

--------------------------------------------------
// ログイン機能・画面が作成されました。


### 3．Login画面とRegister画面にリンクを追加( 2ファイル修正)
- /resources/views/auth/register.blade.php
- /resources/views/auth/login.blade.php


##### `<x-guest-layout>`の次「2行目」に以下を貼り付け ... 
```
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
```


---


### 4. データ構造を作成（テーブル作成） 
##### １．booksテーブルを作成（マイグレーションファイル作成）
```
sail artisan make:migration create_books_table --create=books
```


##### 2．[年]_[月]_[日]_[時分秒]_create_books_table.phpが作成されます
- /database/migrations/フォルダの中に生成されます
- 生成されたファイルを開き、public function up(){...}の中を追加修正
```
public function up()
    {
        Schema::create('books', function (Blueprint $table) {
            $table->id();
            //** ↓ 下をコピー ↓ **
            
            $table->string('item_name');     //ここを追加
            $table->integer('item_number');  //ここを追加
            $table->integer('item_amount');  //ここを追加
            $table->date('published');       //ここを追加
            
            //** ↑ 上をコピー ↑ **
            $table->timestamps();
        });
}
```


##### 3．マイグレーションを実行（テーブル作成）
```
sail artisan migrate
```


##### 4．MySQL DBに作成されたテーブルを確認 
phpMyAdmin
```
http://localhost:8080/
```

##### 5．ModelとControllerを一括作成
- ModelとはDB周りを簡単に扱えるようにする部分を書くファイル
- Controllerとは処理の部分(if文とかfor文とか)を書くファイル
```
sail artisan make:model Book -cr
```


##### 6．生成されたファイルを確認
- /app/models/Book.php に作成されます。
- /app/Http/Controllers/BookController.php に生成されます＋メソッドも自動で生成

###### [ 参考Documents ]

[Laravel Document マイグレーション](https://readouble.com/laravel/10.x/ja/migrations.html)

[Laravel Document コントロール](https://readouble.com/laravel/10.x/ja/controllers.html)

[Laravel Document モデル](https://readouble.com/laravel/10.x/ja/eloquent.html)

---




### 5. ルート定義（ルーティング）
##### 1. /routes/web.php に 以下コードを貼り付けます。
```
<?php
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request; //Add
use App\Http\Controllers\BookController; //Add

//本：ダッシュボード表示(books.blade.php)
Route::get('/', [BookController::class,'index'])->middleware(['auth'])->name('book_index');
Route::get('/dashboard', [BookController::class,'index'])->middleware(['auth'])->name('dashboard');

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
//Route::get('/dashboard', function () {
//    return view('dashboard');
//})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';
```

###### [ 参考Documents ]
[Laravel Document ルーティング](https://readouble.com/laravel/10.x/ja/routing.html)


---



### 6. View
##### 1. /resources/views/components/collection.blade.php を作成
- 以下のコードを貼り付ける
```
<div class="flex justify-between p-4 items-center bg-blue-500 text-white rounded-lg border-2 border-white">
  <div>{{ $slot }}</div>
  <button>×</button>
</div>
```


##### 2. /resources/views/components/errors.blade.php を作成 
- 以下のコードを貼り付ける
```
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
```


##### 3. /resources/views/books.blade.php を作成
- 以下のコードを貼り付ける
```
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
                      <input name="published" type="date" class="appearance-none block w-full text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500">
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
```


##### 4. /resources/views/components/button.blade.php を作成
- 以下のコードを貼り付ける
```
<button {{ $attributes->merge(['type' => 'submit', 'class' => 'inline-flex items-center px-4 py-2 bg-gray-800 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 active:bg-gray-900 focus:outline-none focus:border-gray-900 focus:ring ring-gray-300 disabled:opacity-25 transition ease-in-out duration-150']) }}>
    {{ $slot }}
</button>
```

##### 5. componentファイルとbladeファイルをBuild!!
- bladeファイルとcomponentファイルを合体させます
- JS/CSS(TailwindCSS)も同時にBuildされます
- <重要>　フロント側の修正したら必ず実行してください
```
npm run build
```

###### 参考Documents
[Laravel Document View](https://readouble.com/laravel/10.x/ja/views.html)



---


### 7. Controller
##### 1. app/Http/Controllers/BookController.php を開く
- このControllerでValidatorを使えるようにする
- このControllerでAuthを使えるようにする
```
# use App\Models\Book;
# use Illuminate\Http\Request;

use Illuminate\Support\Facades\Validator; //この2行を追加！
use Illuminate\Support\Facades\Auth;      //この2行を追加！
```
上記 または 以下どちらか
```
use Validator;  //この2行を追加！
use Auth;       //この2行を追加！
```


##### 2. /app/Http/Controllers/BookController.php を開く
- [データ登録処理] public function store の中に以下を追加
```
public function store(Request $request)
{
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
```


##### 3. /app/Http/Controllers/BookController.php を開く
- [データ取得・表示処理] public function index() 内に以下を追加
```
public function index() {
   //** ↓ 下をコピー ↓ **    
   
    $books = Book::orderBy('created_at', 'asc')->get();
    return view('books', [
        'books' => $books
    ]);
    
    //** ↑ 上をコピー ↑ **
}
```


##### 4. /resources/views/books.blade.php を開く
- books.blade.php の ***「右側エリア」*** を全て上書き！！
```
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
```



##### 5. /resources/views/components/collection.blade.php を開く
- collection.blade.php 内のcomponentを以下CODEに ***全て上書き！！*** 
```
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
```



##### 6. /app/Http/Controllers/BookController.php を開く
- [データ削除処理] public function destroy に以下コードを追加
```
public function destroy(Book $book)
{
   //** ↓ 下をコピー ↓ **    
    
    $book->delete();       //追加
    return redirect('/');  //追加
    
     //** ↑ 上をコピー ↑ **
}
```

- [Errorが出た場合] 以下のコマンドでdeleteになっているか確認
```
sail artisan route:list -v
```

###### [ 参考Documents ]

[Laravel Document コントロール](https://readouble.com/laravel/10.x/ja/controllers.html)



--- 


### 8. 更新機能を作成 
##### 1. [更新機能] view画面を作成
- /resources/views/booksedit.blade.php を新規作成
- 以下コードを貼り付ける
```
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
                      <input name="published" type="date" value="{{$book->published}}" class="appearance-none block w-full text-gray-700 border border-gray-200 rounded py-3 px-4 leading-tight focus:outline-none focus:bg-white focus:border-gray-500">
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
```


##### 2．[更新機能] コントローラー
- /app/Http/Controllers/BookController.phpを開く
- 以下コードを ***edit*** に追加する
```   
   public function edit(Book $book)
    {
        //** ↓ 下をコピー ↓ **
        
        //{books}id 値を取得 => Book $books id 値の1レコード取得
        return view('booksedit', ['book' => $book]);
        
        //** ↑ 上をコピー ↑ **!
    }
```

###### 更新画面へのルーティングは以下(/routes/web.php)
```
Route::post('/booksedit/{book}',[BookController::class,"edit"])->name('book_edit'); //通常
Route::get('/booksedit/{book}', [BookController::class,"edit"])->name('edit');      //Validationエラーありの場合
```


##### 3．[更新機能] 更新処理
- /app/Http/Controllers/BookController.php を開く
- 以下コードを ***update*** メソッドに追加する
``` 
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
```




---




### 9. Pagenation機能

##### 1. コントローラ：indexメソッドの修正
- BookController.phpの ***indexメソッド*** に以下コードを上書き
- paginate(3); の箇所だけ変わります
```
    public function index()
    {
        $books = Book::orderBy('created_at', 'asc')->paginate(3);
        return view('books', [
            'books' => $books
        ]);
    }
```


##### 2. Viewにリンクを生成するコードを追加
- books.blade.php に 以下コードを追加します。
-  `<!--右側エリア[START]-->`の下くらいに追加
```
        <div>
            {{ $books->links()}}
        </div>
```




### 10. ユーザーがログインしたらユーザーが登録した本のみ表示
- １ユーザー ✕ １サービス

##### 1. ユーザーidを登録できるようにbooksテーブルを変更
- /database/migrations/[yyyy_mm_dd_hhiiss]_create_books_table.php に以下***１行を追加します***。
```
$table->bigInteger('user_id'); //追加:user_id
```

##### 2. テーブルを再構築する
- テーブルをリセットして、再構築するコマンド
```
sail artisan migrate:refresh
```

##### 3．再構築されたbooksテーブルを確認 
phpMyAdmin
```
http://localhost:8080/
```


##### 5. コントローラ「BooksController@index」を修正
- 以下indexメソッドの「Book」モデルの条件を変えます
- "where('user_id',Auth::user()->id)->"を追加して認証してる人のAuthIDを条件に追加しています
```
 $books = Book::where('user_id',Auth::user()->id)->orderBy('created_at', 'asc')->paginate(3);
```


##### 6. コントローラ「BooksController@store」に追加
```
$books->user_id  = Auth::user()->id; //追加のコード
```

##### 7. コントローラ「BooksController@update」を修正
```
$books = Book::where('user_id',Auth::user()->id)->find($request->id);
```

##### 8. コントローラ「BooksController@edit」を修正
- 修正範囲が多いのでeditメソッドを上書き
```
public function edit($book_id)
{
    $books = Book::where('user_id',Auth::user()->id)->find($book_id);
    return view('booksedit', ['book' => $books]);
}
 ```
 
 ---
 
 
## 補足
####  ★Laravel Document
https://readouble.com/laravel/10.x/ja/

#### ★Auth(認証)USER情報取得
  ```
//Authを使うControllerに追加してあること
use Illuminate\Support\Facades\Auth;

// 現在認証しているユーザーを取得
$user = Auth::user();

// 現在認証しているユーザーのIDを取得
$id = Auth::id();
```

### ★【保存版】バリデーションルールのまとめ
https://www.wakuwakubank.com/posts/376-laravel-validation/


#### ★Validatorの日本語対応方法例1
https://utubou-tech.com/laravel_validation_ja/
  

#### ★Validatorの日本語対応方法例2
```
  $rulus = [
    'name' => 'required',
    'age' => 'integer | between:0,150',
    'sex' => ['max:1', 'regex:/^[男|女]+$/u'],
  ];

  $message = [
    'name.required' => '名前を入力してください',
    'age.numeric' => '整数で入力してください',
    'age.between' => '0～150で入力してください'
    'sex.regex' => '男か女で入力してください',
  ];

  $validator = Validator::make($request->all(), $rulus, $message);
  ```

  ####  ★Validatorの日本語対応方法例3 FormRequestクラスを使った場合
  https://qiita.com/daisu_yamazaki/items/e44d4b744d9d5f9bc8b3
 


  
 #### ★データテーブルをJOINしてデータを取得したい
 
 ***参考URL***
 https://migisanblog.com/laravel-eloquent-relation/
 
 ***Qiita参考URL***
 https://qiita.com/zaburo/items/d665804f8ea850502c64
 
