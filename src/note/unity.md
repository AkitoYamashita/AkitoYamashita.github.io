# Unity

## バージョン依存

* **Unity2020.3.0f1(LTS)**
  * ダークモード
* Unity2019.4.6f1(LTS)
  * ヒエラルキーでの非表示機能
* Unity2018.4.22f1(LTS)
  * StandardAssets

## パッケージ(マネージャー)依存

* `Cinemachine`
* `Post Processing`
* `TextMeshPro`

## デフォルト設定

* CameraBackgroundColor:#314D79
* MaterialInternalErrorColor:#FF00FF

## 逆引きTIPS

**太字箇所は初期段階で設定しとくべし(副作用はある)**

* **開発時シーンの再生が遅い**  
=>(`Configurable Enter Play Mode`)を使う  
=>編集.プロジェクト設定.再生モード開始時設定:true,ドメインを再ロード:false,シーンを再ロード:false
   * ※`Reload Domain`  
   =>staticなフィールド/イベントがリセットされないので手動で初期化が必要
   * ※`Reload Scene`  
   =>シーンをリロードせず変更されたコンテンツだけリセットされる  
   =>Awakeが呼ばれなくなる,
   初期値の暗黙的なNULLが保証されなくなる  
   (インスタンスが作成済みになるためListなどの初期値は明示的なNULLを設定する)
   * <https://madnesslabo.net/utage/?page_id=10983>
* **デフォルトエディタを変更したい**=>Edit.Preference.ExternalTools.ExternalScriptEditor:Browse.SublimeText
* **スマホ対応**  
=> ProjectSetting.Player.WebGL settings
  * PublishSettings.DecompressionFallbackをチェック
  * ?OtherSettings.AutoGraphicsAPIのアンチェック
    * GraphicsAPIのWebGL2(OpenGLES3)を削除
    * GraphicsAPIにWebGL1(OpenGLES2)を追加
* **画面サイズ変えたい**=>GameViewのFreeAspectを調整
* インスペクタ上のパラメータがEditorと一致しない  
=>Inspector.ケバブメニュー.`Normal`=>`Debug`を選択  
=>だめならDocumentかSourceを読め
* Spriteがドラックアンドドロップで配置できない  
=>SelectAsset.TextureType:Sprite(2D and UI)
* Spriteをバラバラにしたい  
  =>Usage:SelectAsset->SpriteMode:Multiple  
  <https://unity-senpai.hatenablog.com/entry/2019/08/10/235344>  
* MP4を表示したい  
=>`Video Player`コンポーネントを追加し、`Video Clip`に指定
* シーンビューの移動量多い/少ない
=>シーンカメラ.`有効視野FOV`を調整
  

## Issue/Error

* (Overlay)Canvasの`AdditionalShaderChannel`:`Mixed`に警告が出る  
=>`Shader channels Normal and Tangent are most often used with lighting, which an Overlay an Overlay canvas does not support. Its likely these channels are not needed.`  
=>TextMeshProが悪さをしてるっぽい。静的なCanvasなら`Nothing`にすれば消せるけど動的なCanvasの場合、生成時に設定しても反映されないし警告レベルなので無視が良さそう  
(※全オブジェクト生成後、キー入力をトリガーにして設定したら反映された)

## Cinemachineでカメラをブレさせる

1. パッケージマネージャーから`Cinemachine`を検索し、インストール

## PostEffectを使う(Post Processing Stack版)

1. パッケージマネージャーから`Post Processing`を検索し、インストール

## 3D移動させたい

```cs
void Update(){
    if(Input.GetKeyDown(KeyCode.Space)){ 
        this.transform.localPosition=Vector3.zero;
        this.transform.rotation=Quaternion.Euler(Vector3.zero);
        this.transform.localScale=Vector3.one;
    }
    if(Input.GetKey(KeyCode.W)) this.transform.Translate (0.0f,0.0f,0.03f,Space.Self);
    if(Input.GetKey(KeyCode.S)) this.transform.Translate (0.0f,0.0f,-0.03f,Space.Self);
    if(Input.GetKey(KeyCode.A)) this.transform.Translate (-0.03f,0.0f,0.0f,Space.Self);
    if(Input.GetKey(KeyCode.D)) this.transform.Translate (0.03f,0.0f,0.0f,Space.Self);

    if(Input.GetKey(KeyCode.UpArrow)) this.transform.Translate (0.0f,0.03f,0.0f,Space.World);
    if(Input.GetKey(KeyCode.DownArrow)) this.transform.Translate (0.0f,-0.03f,0.0f,Space.World);
    if(Input.GetKey(KeyCode.LeftArrow)) this.transform.Rotate(0.0f,-0.25f,0.0f,Space.World);
    if(Input.GetKey(KeyCode.RightArrow)) this.transform.Rotate(0.0f,0.25f,0.0f,Space.World);

    if(Input.GetKey(KeyCode.PageUp)) this.transform.Rotate(-0.25f,0f,0.0f,Space.Self);
    if(Input.GetKey(KeyCode.PageDown)) this.transform.Rotate(0.25f,0f,0.0f,Space.Self);
}
```

## 2D移動させたい

```cs
void Update(){
    //if(Input.GetKeyDown(KeyCode.Space)){ Debug.Log("SPACE"); }
    if(Input.GetKey(KeyCode.W)||Input.GetKey(KeyCode.UpArrow)) this.transform.Translate(0.0f,0.03f,0.0f);
    if(Input.GetKey(KeyCode.S)||Input.GetKey(KeyCode.DownArrow)) this.transform.Translate(0.0f,-0.03f,0.0f);
    if(Input.GetKey(KeyCode.A)||Input.GetKey(KeyCode.LeftArrow)) this.transform.Translate(-0.03f,0.0f,0.0f);
    if(Input.GetKey(KeyCode.D)||Input.GetKey(KeyCode.RightArrow)) this.transform.Translate(0.03f,0.0f,0.0f);
}
```

## デバッグ用のCubeオブジェクトがほしい 

```cs
using UnityEngine;

[ExecuteInEditMode]
public class LineCube : MonoBehaviour{
    //[SerializeField]
    private Vector3 scale = new Vector3(1f, 1f, 1f);
    // [SerializeField] private Material material;
    void Start(){
        this.transform.position = new Vector3 (0.0f,2.0f,0.0f);
    }
    void Update(){
        this.transform.Rotate (0.1f, 0.1f, 0.1f);
    }
    private void OnRenderObject(){
        // material.SetPass(0);
        Vector3 halfScale = scale * 0.5f;
        GL.PushMatrix();
        GL.MultMatrix(transform.localToWorldMatrix);
        drawRectXY(halfScale, -halfScale.z);
        drawRectXY(halfScale, halfScale.z);
        drawLineZ(halfScale, -halfScale.x, -halfScale.y);
        drawLineZ(halfScale, halfScale.x, -halfScale.y);
        drawLineZ(halfScale, halfScale.x, halfScale.y);
        drawLineZ(halfScale, -halfScale.x, halfScale.y);
        GL.PopMatrix();
    }
    private void drawRectXY(Vector3 halfScale, float z){
        GL.Begin(GL.LINE_STRIP);
        GL.Vertex(new Vector3(-halfScale.x, -halfScale.y, z));
        GL.Vertex(new Vector3(halfScale.x, -halfScale.y, z));
        GL.Vertex(new Vector3(halfScale.x, halfScale.y, z));
        GL.Vertex(new Vector3(-halfScale.x, halfScale.y, z));
        GL.Vertex(new Vector3(-halfScale.x, -halfScale.y, z));
        GL.End();
    }
    private void drawLineZ(Vector3 halfScale, float x, float y){
        GL.Begin(GL.LINES);
        GL.Vertex(new Vector3(x, y, -halfScale.z));
        GL.Vertex(new Vector3(x, y, halfScale.z));
        GL.End();
    }
}
```

## デバッグ用のPlaneオブジェクトがほしい

```cs
using UnityEngine;

[ExecuteInEditMode]
public class LinePlane : MonoBehaviour{
    //[SerializeField]
    private Vector2 scale = new Vector2(10f, 10f);
    //[SerializeField]
    private Vector2Int division = new Vector2Int(10, 10);
    //[SerializeField] private Material material;
    void start(){
        //material =  new Material (Shader.Find ("Unlit/TransparentShader"));
    }
    private void OnRenderObject(){
        // material.SetPass(0);
        Vector2 stepSize = scale / division;
        Vector2 halfScale = scale * 0.5f;
        GL.PushMatrix();
        GL.MultMatrix(transform.localToWorldMatrix);
        for (int x = 0; x <= division.x; x++){
            GL.Begin(GL.LINES);
            for (int z = 0; z < division.y; z++){
                GL.Vertex(new Vector3(x * stepSize.x - halfScale.x, 0f, z * stepSize.y - halfScale.y));
                GL.Vertex(new Vector3(x * stepSize.x - halfScale.x, 0f, (z + 1) * stepSize.y - halfScale.y));
            }
            GL.End();
        }
        for (int z = 0; z <= division.y; z++){
            GL.Begin(GL.LINES);
            for (int x = 0; x < division.x; x++){
                GL.Vertex(new Vector3(x * stepSize.x - halfScale.x, 0f, z * stepSize.y - halfScale.y));
                GL.Vertex(new Vector3((x + 1) * stepSize.x - halfScale.x, 0f, z * stepSize.y - halfScale.y));
            }
            GL.End();
        }
        GL.PopMatrix();
    }
}
```

## キーコードを知りたい

```cs
if (Input.anyKeyDown) {
    foreach(KeyCode code in System.Enum.GetValues(typeof(KeyCode))){
        if (Input.GetKeyDown(code)){
            Debug.Log("Code:"+(int)code+", Key:"+code.ToString());
        }
    }
}
```

## StandardAssets(for Unity2018.4)を使う

* <https://assetstore.unity.com/packages/essentials/asset-packs/standard-assets-for-unity-2018-4-32351>

```
/SampleScenes/*
/Standard Assets/
```

## SQLite3を使う(NoCheck)

* <https://qiita.com/hiroyuki7/items/5335e391c9ed397aee50>
* [Github@Busta117/SQLiteUnityKit](https://github.com/Busta117/SQLiteUnityKit)


## FadeManager(FadeCamera)

* <http://tsubakit1.hateblo.jp/entry/2015/11/04/015355>
* [Github@naichilab/Unity-FadeManager](https://github.com/naichilab/Unity-FadeManager)

## Spineを使う(for 2020.3)

* [Download@spine-unity](http://ja.esotericsoftware.com/spine-unity-download/)
* [UnityPackage@spine-unity](https://esotericsoftware.com/files/runtimes/unity/spine-unity-3.8-2021-03-09.unitypackage)
* [Github@spine-runtimes](https://github.com/EsotericSoftware/spine-runtimes)

```
/Spine/*
/Spine Examples/*
(/Assets/Resources/Spine/*)
```

Exportファイル

```
skelton.atlas.txt
skelton.json
skelton.png
```

### SpineExportForUnity2020.3

1. Export.ExportJSON 
  * Extension:`.json`
  * Format:`JSON`
  * Pretty print:`true`
  * Output:`Nonessential data`,`Animation clean up`,`Warrnings`
  * Texture Atlas.Pack:`true`
2. Create atlas.Options.アトラス拡張子設定:`.atlas`=>`.atlas.txt`に変更  

### 手動でUnityのSceneへ配置してアニメーション

1. SpineからExportしたファイルをAssets配下へ移動
2. `skeleton_SkeletonData.asset`をヒエラルキー上にドラッグ&ドロップし`SkeltonAnimation`
3. インスペクタ.SkeltonAnimation.Animation Name:`<None>`=>`アニメーション名`
4. シーン再生

### ScriptでSpineAnimation

```cs
////Spine(path="Assets/Resources/Spine/*.asset")
public static GameObject UiSpine(GameObject canvas,string path,string animation=null){
    GameObject obj=_.Obj(canvas,"_spine");
    obj.AddComponent<SkeletonGraphic>();
    SkeletonGraphic skeletonGraphic=obj.GetComponent<SkeletonGraphic>();
    skeletonGraphic.skeletonDataAsset=AssetDatabase.LoadAssetAtPath(path,typeof(SkeletonDataAsset)) as SkeletonDataAsset;
    skeletonGraphic.Initialize(true);
    if(animation!=null){
        skeletonGraphic.AnimationState.SetAnimation(0, animation, true);
    }
    return obj;
}
public static GameObject Spine(GameObject parent,string path,string animation=null){
    GameObject obj=_.Obj(parent,"_spine");
    obj.AddComponent<SkeletonAnimation>();
    SkeletonAnimation skeletonAnimation=obj.GetComponent<SkeletonAnimation>();
    skeletonAnimation.skeletonDataAsset=AssetDatabase.LoadAssetAtPath(path,typeof(SkeletonDataAsset)) as SkeletonDataAsset;
    skeletonAnimation.ClearState();
    skeletonAnimation.Initialize(true);
    if(animation!=null){
        skeletonAnimation.loop=true;
        skeletonAnimation.AnimationName=animation;
    }
    return obj;
}
```

## SubstancePainter

* [SubstancePainter](https://www.substance3d.com/products/substance-painter/)
* [Asset@Substance in Unity](https://assetstore.unity.com/packages/tools/utilities/substance-in-unity-110555?locale=ja-JP)
  ※Substance.Substance Sourceを利用することで所持マテリアルが`/Materials/*.sbsar`としてダウンロードできる

## Unity-Chan素材を使う

※UCLロゴ、もしくはライセンス表記が必要(詳細は[ガイドライン](https://unity-chan.com/contents/guideline/)で確認)

* [ユニティちゃん ダウンロードページ](https://unity-chan.com/download/)
* [ユニティちゃん 3Dモデルデータ](https://unity-chan.com/download/releaseNote.php?id=UnityChan)
* [ユニティちゃん 2Dデータ](https://unity-chan.com/download/releaseNote.php?id=UnityChan2D)
* [SDユニティちゃん 3Dモデルデータ](https://unity-chan.com/download/releaseNote.php?id=SDUnityChan)
* [ユニティちゃんトゥーンシェーダー2.0](https://unity-chan.com/download/releaseNote.php?id=UTS2_0)
* [ローポリユニティちゃん](https://unity-chan.com/download/releaseNote.php?id=LowPolyUnityChan)

## UnityでNuGetパッケージマネージャーを使う(NoCheck)

* [Github@GlitchEnzo/NuGetForUnity](https://github.com/GlitchEnzo/NuGetForUnity)
* <https://baba-s.hatenablog.com/entry/2018/01/25/095900>

## uGUIでGifを表示する(NoCheck)

* <https://develop.hateblo.jp/entry/unity-gif-anime>
* <https://github.com/WestHillApps/UniGif>

(Usage:Canvas.RawImage=>Attach&Setting:UniGifImage,UniGifImageAspectController)

1. [レポジトリ](https://github.com/WestHillApps/UniGif)の`Assets/UniGif`をプロジェクト内にコピー
2. Gifアニメを再生させたいGameObjectに`Uni Gif Image`と`RawImage`,`Uni Gif Image Aspect`のコンポーネントを追加
3. `Uni Gif Image`の`Raw Image`と`Img  Aspect Crl`に`RawImage`,`Uni Gif Image Aspect`を設定
  (シーン再生からGif再生させたい場合は「Load On Start」にチェックをいれる)
4. `Load On Start Url`に再生させたいGifアニメのファイル名(Ex:`onoie.gif`)を指定する
5. `/StreamingAssets`ディレクトリにgif画像を配置

## 簡易Skyboxを作る

<https://qiita.com/aike@github/items/cf4a8289fef65c9652a7>

1. 1024x1024のPNGを作ってAssetsフォルダに入れる
2. 画像プロパティをTexture Shape:Cube->Apply
3. Assets.Create.Materialで新規マテリアル作成。
4. マテリアルプロパティをShader:Skybox/Cubemap、Cubemapに作成した画像を指定
5. Window.Rendering.Lighting Settingsを開く
6. Environment.Skybox Materialに作成したマテリアルを指定

## 認証にJWTを使う

```cs
static protected string host="HOSTNAME";
protected string jwt_token;
static protected string jwt_login="http://"+host+"/jwt/";
static protected string jwt_test="http://"+host+"/jwt/test";
void Start () {
    StartCoroutine(LoginJWT());
}
IEnumerator LoginJWT() {
    var uwr = new UnityWebRequest(jwt_login, "POST");
    byte[] bodyRaw = Encoding.UTF8.GetBytes("{\"user\":\"guest\",\"password\":\"password\"}");
    uwr.uploadHandler = (UploadHandler) new UploadHandlerRaw(bodyRaw);
    uwr.downloadHandler = (DownloadHandler) new DownloadHandlerBuffer();
    uwr.SetRequestHeader("Content-Type", "application/json");
    yield return uwr.SendWebRequest();
    JWT jwt = JsonUtility.FromJson<JWT> (uwr.downloadHandler.text);
    //Debug.Log("Token:"+jwt.token);
    jwt_token=jwt.token;
}
//StartCoroutine(TestJWT());
IEnumerator TestJWT(){
    UnityWebRequest uwr = UnityWebRequest.Get(jwt_test);
    uwr.SetRequestHeader("Authorization", "Bearer " + jwt_token);
    yield return uwr.SendWebRequest();
    if (uwr.isNetworkError){
        Debug.Log(uwr.error);
    }else{
        Debug.Log("Received:"+uwr.downloadHandler.text);
    }
}
[Serializable]
public class JWT{
    public string token;
}
```

## Jsonを扱う

```
/Script/Json/demo.json
/Script/Json/JsonDemo.cs
/Script/Json/JsonReaderDemo.cs
```

```cs
////JsonReaderDemo.cs
using System;
using System.IO;
using System.Text;
using System.Collections;
using UnityEngine;

public class JsonReaderDemo : MonoBehaviour{
    void Start(){
    	////Resources/Json/demo.json
    	//inputString = Resources.Load<TextAsset>("Json/demo").ToString();
    	string inputString = "";
  		FileInfo fi = new FileInfo(Application.dataPath + "/Scripts/Json/demo.json");
        using (StreamReader sr = new StreamReader(fi.OpenRead(), Encoding.UTF8)){
            inputString += sr.ReadToEnd();
        }
        Debug.Log(inputString);
        JsonDemo inputJson = JsonUtility.FromJson<JsonDemo>(inputString);
        Debug.Log("[0].key:"+inputJson.keyval[0].key);
        Debug.Log("[0].val:"+inputJson.keyval[0].val);
    }
}
```

```cs
////JsonDemo.cs
using System;
using UnityEngine;

[Serializable]
public class JsonDemo{
    public KeyValDemo[] keyval;
    public VarDemo[] var;
    public string[] list;
    public string comment;
}

[Serializable]
public class KeyValDemo{
    public string key;
    public string val;
}
[Serializable]
public class VarDemo{
    public string name;
    public string type;
    public string value;
}

```

```json
{
  "comment": "COMMENT#demo.json",
  "list": [
    "item"
  ],
  "keyval": [
    { "key":"key1","val":"val1" },
    { "key":"key2","val":"val2" }
  ],
  "var": [
    {"name": "sample", "type": "text", "value": "value"}
  ]
}
```

## ネットワーク通信にWebSocketを使う

**WebSocket(websocket-sharp)**
>Unable to open Assets/Plugins/websocket-sharp.dll: Check external application preferences.  
(※DLLに関連付けがされてない場合の警告?=>再起動で解決)

<https://github.com/sta/websocket-sharp>

```
/Plugins/websocket-sharp.dll
```

**WebSocketforWebGL(unity-websocket-webgl)**
>プロジェクトのターゲットプラットフォームに基づいて、ブラウザまたはネイティブ実装を自動的にコンパイルします。

<https://github.com/jirihybek/unity-websocket-webgl>

```
(/Scripts/WebSocketDemo.cs)
/Plugins/WebSocket.cs
/Plugins/WebSocket.jslib
```

```cs
////WebSocketDemo.cs
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;
// Use plugin namespace
// https://github.com/jirihybek/unity-websocket-webgl
using HybridWebSocket;
public class WebSocketDemo : MonoBehaviour {
	protected string websocket_server="ws://echo.websocket.org:80/";
	protected WebSocket ws;
	void Start () {
        // Create WebSocket instance
        ws = WebSocketFactory.CreateInstance(websocket_server);
        // Add OnOpen event listener
        ws.OnOpen += () =>{
            Debug.Log("WS Connected Status:"+ws.GetState().ToString());
            WsSubmit();
        };
        // Add OnMessage event listener
        ws.OnMessage += (byte[] msg) =>{
            Debug.Log("WS received message: " + Encoding.UTF8.GetString(msg));
            //ws.Close();
        };
        // Add OnError event listener
        ws.OnError += (string errMsg) =>{
            Debug.Log("WS error: " + errMsg);
        };
        // Add OnClose event listener
        ws.OnClose += (WebSocketCloseCode code) =>{
            Debug.Log("WS closed with code: " + code.ToString());
        };
        // Connect to the server
        ws.Connect();
    }
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyDown(KeyCode.Space)){
            WsSubmit();
		}
	}
    void WsSubmit() {
        DateTime now=DateTime.Now;
        ws.Send(Encoding.UTF8.GetBytes(now.ToString()));
    }
}
```

## uGUIテキストで「Font Awesome」のアイコンを使う

Reference:<https://answers.unity.com/questions/1434980/how-to-add-font-awesome-into-unity-using-textmesh.html>

```
(/Fonts/fontawesome-webfont.ttf)
(/TextMesh Pro/)
/Fonts/fontawesome-webfont SDF.asset
```

1. <https://fontawesome.com/v4.7.0/get-started/>から`font-awesome-4.7.0.zip`をダウンロード
2. `font-awesome-4.7.0/fonts/fontawesome-webfont.ttf`をプロジェクト内(`/Fonts/fontawesome-webfont.ttf`)へ移動
3. `Window.TextMeshPro.Font Asset Creator`を起動  
`Import TMP Essentials`を行う(`Import EMP Examples & Extras`は不要)
5. AssetCreatorFontSettings
    - Font Source : `fontawesome-webfont`
    - Font Size : `Auto Sizing`
    - Font Padding : `5`
    - Packing method : `Fast (or Optimum, as you want)`
    - Atlas Resolution : `2048 x 2048 (4096 x 4096 crashed my Unity)`
    - Charactter Set : `Custom Range`
    - Character Sequence : `61440-62176 (See bottom note to understand why these values)`
    - Font Style : `Normal, 2`
    - Rendering mode : `SDF16`
6. `Generate Font Atlas`
7. `Save`し`/Fonts/fontawesome-webfont SDF.asset`で保存
8. `UI.Canvas`を作成
9. `UI.Text - TextMeshPro`のフォントに`fontawesome-webfont SDF`を設定
10. テキストにUnicode(Ex:`\U0000f259`)を設定  
※<https://fontawesome.com/v4.7.0/icons/>で確認

(※TextUnicode.csを入れる必要あるかも)

```cs
using System.Globalization;
using System.Text.RegularExpressions;

namespace UnityEngine.UI
{
    public class TextUnicode : Text
    {
        private bool disableDirty = false;
        private Regex regexp = new Regex( @"\\u(?<Value>[a-zA-Z0-9]{4})" );

        protected override void OnPopulateMesh( VertexHelper vh )
        {
            string cache = text;
            disableDirty = true;
            text = Decode( text );
            base.OnPopulateMesh( vh );
            text = cache;
            disableDirty = false;
        }
        private string Decode( string value )
        {
            return regexp.Replace( value, m => ( ( char )int.Parse( m.Groups[ "Value" ].Value, NumberStyles.HexNumber ) ).ToString() );
        }

        public override void SetLayoutDirty()
        {
            if ( disableDirty ) return;
            base.SetLayoutDirty();
        }

        public override void SetVerticesDirty()
        {
            if ( disableDirty ) return;
            base.SetVerticesDirty();
        }

        public override void SetMaterialDirty()
        {
            if ( disableDirty ) return;
            base.SetMaterialDirty();
        }
    }
}
```

## Reference

[Unity](https://unity.com/)
