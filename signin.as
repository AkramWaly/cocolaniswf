package com.cocolani
{
   import com.gsolo.encryption.MD5;
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.None;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   
   public class signin extends MovieClip
   {
      
      protected static const WINDOW_OPEN_FUNCTION:String = "window.open";
       
      
      public var utext:TextField;
      
      public var ptext:TextField;
      
      public var password:TextField;
      
      public var bt_forgotpassword:bt_loginstandard;
      
      public var username:TextField;
      
      public var bt_login:bt_loginstandard;
      
      public var tgt:MovieClip;
      
      var sfsref;
      
      var thisref;
      
      var loginbtEnabled = true;
      
      public var loginDetails;
      
      public var customLoginDetails;
      
      private var customLoginXML:XML;
      
      var stageref;
      
      var mytw;
      
      public var bgd;
      
      public var bgdRef;
      
      public var bgdContainer;
      
      public var notAnimating:Boolean = false;
      
      public var miniRegisterSeq = false;
      
      public var loginBeenSent = false;
      
      public function signin()
      {
         this.thisref = this;
         this.loginDetails = [];
         this.customLoginDetails = {};
         super();
         this.password.displayAsPassword = true;
         this.bt_login.disable(true);
         this.bt_forgotpassword.addEventListener(MouseEvent.CLICK,this.forgotPassword);
         addEventListener(Event.ADDED_TO_STAGE,this.translate);
         var _loc1_:* = new TextFormat();
         var _loc2_:* = new TextFormat();
         _loc1_.size = 30;
         _loc2_.size = 33;
         this.bt_login.setTextFormat(_loc1_,_loc2_);
         addEventListener(Event.ADDED_TO_STAGE,this.init);
         this.username.addEventListener(FocusEvent.FOCUS_IN,this.focusField);
         this.password.addEventListener(FocusEvent.FOCUS_IN,this.focusField);
      }
      
      public static function openWindow(param1:String, param2:String = "_blank", param3:String = "") : void
      {
         ExternalInterface.call(WINDOW_OPEN_FUNCTION,param1,param2,param3);
      }
      
      public function getCharData() : *
      {
         return {
            "usr":"dan",
            "pass":"dan"
         };
      }
      
      private function forgotPassword(param1:MouseEvent) : *
      {
         if(this.thisref.stage.getChildAt(0).langObj.selectedLang == 0)
         {
            openWindow("admin/psw_lost_manager.php","new","status=1,toolbar=0,width=550,height=350");
         }
         else
         {
            openWindow("admin/psw_lost_manager.php?lang=" + this.thisref.stage.getChildAt(0).langObj.getLangExtensionWeb(),"new","status=1,toolbar=0,width=550,height=350");
         }
      }
      
      private function focusField(param1:FocusEvent) : *
      {
         param1.currentTarget.setSelection(0,param1.currentTarget.text.length);
      }
      
      public function hideLoginText() : *
      {
         this.utext.visible = false;
         this.username.visible = false;
         this.ptext.visible = false;
         this.password.visible = false;
         this.bt_login.visible = false;
         this.bt_forgotpassword.visible = false;
      }
      
      public function openingAnim(param1:* = 0) : *
      {
         if(param1 == 0)
         {
            this.notAnimating = false;
            this.tgt.gotoAndPlay(2);
            this.hideLoginText();
         }
         else if(param1 == 1)
         {
            this.actionComplete(2);
         }
         else if(param1 == 2)
         {
            this.notAnimating = true;
            this.thisref.stage.getChildAt(0).signInAnimComplete();
         }
         else if(param1 == 3)
         {
            this.bgd.bgd.doors.gotoAndPlay(2);
         }
         else if(param1 == 5)
         {
            this.tgt.gotoAndStop("animateIn");
            this.hideLoginText();
         }
         else if(param1 == 6)
         {
            this.notAnimating = true;
            this.utext.visible = true;
            this.username.visible = true;
            this.ptext.visible = true;
            this.password.visible = true;
            this.bt_login.visible = true;
            this.bt_forgotpassword.visible = true;
            this.actionComplete(1);
         }
         else if(param1 == 7)
         {
            this.tgt.gotoAndPlay("animateIn");
         }
      }
      
      private function init(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.stageref = param1.currentTarget.stage.getChildAt(0);
         this.stageref.langObj.setFormat(this.username);
         this.stageref.langObj.setFormat(this.password);
         this.stageref.langObj.setFormat(this.ptext,{
            "enlarge":true,
            "noalign":true
         });
         this.stageref.langObj.setFormat(this.utext,{
            "enlarge":true,
            "noalign":true
         });
         if(this.stageref.custID < 2 && !this.stageref.FID)
         {
            _loc2_ = getDefinitionByName("bt_register_l" + this.stageref.langObj.selectedLang);
            _loc3_ = addChild(new _loc2_());
            _loc3_.x = 729;
            _loc3_.y = 483;
            _loc3_.scaleX = 0.747;
            _loc3_.scaleY = 0.773;
            _loc3_.name = "bt_register";
            _loc3_.addEventListener(MouseEvent.CLICK,this.registerme);
         }
         else if(this.stageref.FID)
         {
            this.hideLoginText();
            this.tgt.visible = false;
         }
         else if(this.stageref.custID == 3)
         {
            visible = false;
            this.tgt.visible = false;
            this.hideLoginText();
            if(LoaderInfo(stage.loaderInfo).parameters["uid"])
            {
               this.username.text = LoaderInfo(stage.loaderInfo).parameters["uid"];
               this.password.text = LoaderInfo(stage.loaderInfo).parameters["uip"];
            }
            this.password.maxChars = 40;
            trace("username : " + this.username.text);
            if(this.username.text.length == 0 && this.thisref.stage.getChildAt(0).rootURL == "")
            {
               trace("setting def credentials");
               this.username.text = "coco-m3com1";
               this.password.text = "d6e628a2d8ef0940a1d049ed601dfeaa2358547e";
            }
            this.tgt.stop();
         }
         this.actionComplete(0);
         if(this.stageref.zoneSelectorRqd && this.stageref.custID < 3)
         {
            this.openingAnim(5);
         }
         else
         {
            this.tgt.stop();
         }
      }
      
      public function fadeout() : *
      {
         this.mytw = new Tween(this.thisref,"alpha",None.easeNone,1,0,18,false);
         this.mytw.addEventListener(TweenEvent.MOTION_FINISH,this.finTween);
         this.openingAnim(2);
      }
      
      private function finTween(param1:TweenEvent) : *
      {
         this.stopTween();
      }
      
      public function stopTween() : *
      {
         if(this.mytw)
         {
            this.mytw.removeEventListener(TweenEvent.MOTION_FINISH,this.finTween);
            this.mytw.stop();
            this.mytw = undefined;
         }
         this.thisref.visible = false;
         this.thisref.alpha = 1;
         if(this.bgd)
         {
            this.bgd.bgd.doors.gotoAndStop(1);
            this.tgt.gotoAndStop(1);
         }
      }
      
      private function addGfx(param1:*) : *
      {
         this.bgdRef = param1.preloadedObjects[0];
         this.bgdContainer = addChildAt(this.bgdRef,0);
         this.bgd = this.bgdContainer.content;
         if(!this.bgd)
         {
            param1.showmsg("WARNING !! BACKGROUND HAS NO CONTENT : " + this.bgd);
            param1.showmsg("Container desc : " + this.bgdRef);
            param1.showmsg("% loaded : " + this.bgdRef.contentLoaderInfo.bytesLoaded + " / " + this.bgdRef.contentLoaderInfo.bytesTotal);
         }
         param1.preloadedObjects = undefined;
      }
      
      private function translate(param1:Event) : *
      {
         this.addGfx(param1.currentTarget.stage.getChildAt(0));
         var _loc2_:* = param1.currentTarget.stage.getChildAt(0).langObj;
         this.utext.text = _loc2_.getText("login01");
         this.ptext.text = _loc2_.getText("login02");
         if(this.bt_login.getChildByName("thetext"))
         {
            this.bt_login.thetext.text = _loc2_.getText("login03");
            this.bt_login.mytext = _loc2_.getText("login03");
            this.bt_forgotpassword.thetext.text = _loc2_.getText("login05");
         }
      }
      
      private function checkkeys(param1:KeyboardEvent) : *
      {
         if(param1.charCode == Keyboard.ENTER)
         {
            if(this.thisref.stage.focus.name == "bt_login" || this.thisref.stage.focus.name == "username" || this.thisref.stage.focus.name == "password")
            {
               this.signinfn();
            }
         }
      }
      
      public function enablelogin() : *
      {
         if(this.notAnimating)
         {
            if(this.stageref.custID != 3 && this.tgt.visible)
            {
               this.bt_login.addEventListener(MouseEvent.CLICK,this.signuserin);
               this.bt_login.enable();
               addEventListener(KeyboardEvent.KEY_DOWN,this.checkkeys);
               this.utext.visible = true;
               this.username.visible = true;
               this.ptext.visible = true;
               this.password.visible = true;
               this.bt_login.visible = true;
               this.bt_forgotpassword.visible = true;
            }
         }
      }
      
      public function clearLogin() : *
      {
         this.username.text = "";
         this.password.text = "";
         this.loginDetails = [];
         this.miniRegisterSeq = false;
         this.loginBeenSent = false;
      }
      
      public function disablelogin() : *
      {
         this.bt_login.removeEventListener(MouseEvent.CLICK,this.signuserin);
         this.bt_login.disable(true);
      }
      
      public function registerme(param1:MouseEvent) : *
      {
         var _loc2_:* = this.thisref.stage.getChildAt(0).newpopup(this.thisref.stage.getChildAt(0).baseURL + "panels/registration.swf","load","registration");
         _loc2_.tweenOn = false;
      }
      
      public function miniregisterme() : *
      {
         var _loc1_:* = "panels/register_avatar.swf";
         if(this.stageref.FID)
         {
            _loc1_ = "panels/register_avatar_fb.swf";
         }
         var _loc2_:* = this.thisref.stage.getChildAt(0).newpopup(this.thisref.stage.getChildAt(0).baseURL + _loc1_,"load","registration");
         _loc2_.tweenOn = false;
      }
      
      private function errorloadCharacterXML(param1:IOErrorEvent) : *
      {
         trace("Problem loading custom login XML " + param1);
      }
      
      private function loadedCharacterXML(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.customLoginXML = new XML(param1.currentTarget.data);
         if(this.customLoginXML.acct.err.length() > 0)
         {
            trace("Incorrect username or password error...hmmm");
            _loc2_ = this.stageref.langObj.getText("srv1");
            this.stageref.showmsg(_loc2_);
            this.enablelogin();
         }
         else
         {
            if(this.customLoginXML.acct.usr.length() == 0)
            {
               this.miniRegisterSeq = true;
               trace("no users detected..");
            }
            else
            {
               for(_loc3_ in this.customLoginXML.acct.usr)
               {
                  trace("User " + this.customLoginXML.acct.usr[_loc3_].nm);
               }
            }
            if(this.stageref.FID)
            {
               this.actionComplete(2);
            }
            else
            {
               this.openingAnim(0);
            }
         }
      }
      
      public function getCustomLoginData() : *
      {
         return this.customLoginXML;
      }
      
      public function quicklogin() : *
      {
         var _loc1_:String = null;
         if(this.stageref.custID == 3 && this.stageref.getpopup("cust3_splash"))
         {
            return;
         }
         if(this.stageref.custID < 2 && !this.stageref.FID)
         {
            this.signinfn(true);
            return;
         }
         if(!this.loginBeenSent)
         {
            if(this.stageref.sfs.isConnected)
            {
               if(this.stageref.key)
               {
                  if(this.stageref.FID)
                  {
                     this.password.text = "%<>%" + this.stageref.FID + this.stageref.FAccessToken.substr(this.stageref.FAccessToken.length - 32,32);
                     if(!this.stageref.FBVerified)
                     {
                        this.stageref.loginAfterConnect = true;
                        this.stageref.checkFB();
                        return;
                     }
                  }
                  if(this.stageref.custID == 3)
                  {
                     this.customLoginDetails = {
                        "user":this.username.text,
                        "pass":this.password.text
                     };
                  }
                  _loc1_ = MD5.encrypt(this.stageref.key + this.password.text);
                  this.sfsref = this.stageref.sfs;
                  this.sfsref.login(this.stageref.zoneName,this.username.text,_loc1_);
                  this.loginBeenSent = true;
               }
            }
            else
            {
               this.thisref.stage.getChildAt(0).Autoreconnect();
            }
         }
      }
      
      public function signinfn(param1:* = false) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         if(param1 || this.bt_login.currentFrame != 4 && this.username.text.length >= 2 && this.password.text.length >= 2)
         {
            this.disablelogin();
            if(this.stageref.customLogin)
            {
               _loc2_ = new URLRequest(this.stageref.DBURL + "plogin.php");
               _loc3_ = new URLLoader();
               _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.errorloadCharacterXML);
               _loc3_.addEventListener(Event.COMPLETE,this.loadedCharacterXML);
               _loc4_ = new URLVariables();
               if(this.stageref.FID)
               {
                  _loc4_.FID = this.stageref.FID;
               }
               else
               {
                  _loc4_.usr = this.username.text;
               }
               _loc4_.pass = MD5.encrypt(this.password.text + "switch%");
               _loc2_.data = _loc4_;
               _loc2_.method = "post";
               _loc3_.load(_loc2_);
            }
            else
            {
               this.sfsref = this.thisref.stage.getChildAt(0).sfs;
               if(this.sfsref.isConnected)
               {
                  if(this.thisref.stage.getChildAt(0).key)
                  {
                     _loc5_ = MD5.encrypt(this.thisref.stage.getChildAt(0).key + this.password.text);
                     this.sfsref.login(this.thisref.stage.getChildAt(0).zoneName,this.username.text,_loc5_);
                  }
                  else
                  {
                     this.stageref.loginAfterConnect = true;
                  }
               }
               else
               {
                  this.thisref.stage.getChildAt(0).Autoreconnect();
               }
            }
            if(this.stageref.custID >= 2)
            {
               this.loginDetails = [this.username.text,_loc5_];
            }
         }
      }
      
      public function actionComplete(param1:*, param2:* = 0) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         switch(param1)
         {
            case 0:
               if(this.stageref.custID == 2 || this.stageref.FID)
               {
                  this.stageref.customLogin = true;
               }
               if(!this.stageref.zoneSelectorRqd && !this.stageref.customLogin)
               {
                  this.stageref.connectSFS();
                  this.notAnimating = true;
               }
               if(this.stageref.zoneSelectorRqd && !this.stageref.customLogin && !this.stageref.FID)
               {
                  _loc3_ = this.stageref.newpopup(this.stageref.baseURL + "panels/zone_selector.swf","load","zoneSelector",false,false);
                  _loc3_.tweenOn = false;
               }
               else if(this.stageref.FID)
               {
                  this.stageref.connectSFS();
                  this.username.text = this.stageref.FID;
                  this.signinfn(true);
               }
               else if(this.stageref.customLogin)
               {
                  this.hideLoginText();
                  this.openingAnim(7);
               }
               break;
            case 1:
               if(this.stageref.customLogin)
               {
                  this.enablelogin();
               }
               else if(this.stageref.sfs.isConnected)
               {
                  this.enablelogin();
               }
               break;
            case 2:
               if(this.miniRegisterSeq)
               {
                  this.miniregisterme();
               }
               else if(this.stageref.customLogin && !this.stageref.getpopup("characterSelect"))
               {
                  (_loc4_ = this.stageref.newpopup(this.stageref.baseURL + "panels/char_selector.swf","load","characterSelect",false,false,{"nocentre":true})).tweenOn = false;
               }
               else if(this.bgd && !this.miniRegisterSeq)
               {
                  this.bgd.bgd.doors.gotoAndPlay(2);
               }
               else if(this.miniRegisterSeq)
               {
                  this.miniregisterme();
               }
               break;
            case 3:
               if(this.stageref.zoneSelectorRqd)
               {
                  _loc3_ = this.stageref.newpopup(this.stageref.baseURL + "panels/zone_selector.swf","load","zoneSelector",false,false);
               }
               else
               {
                  this.stageref.showmsg("current phase : " + param2);
                  if(param2 == 0)
                  {
                     this.quicklogin();
                  }
                  else
                  {
                     trace("To do... investigate when this occurs...");
                     if(this.stageref.loginAfterConnect == false)
                     {
                     }
                  }
               }
               break;
            case 4:
               if(this.stageref.custID == 3 || this.stageref.customLogin)
               {
                  this.quicklogin();
               }
               else if(this.stageref.FID)
               {
                  this.quicklogin();
               }
               else
               {
                  if(this.stageref.sfs.isConnected == false)
                  {
                     this.stageref.connectSFS();
                  }
                  this.openingAnim(7);
               }
               break;
            case 5:
               this.actionComplete(3,0);
               break;
            case 6:
               this.miniRegisterSeq = true;
               this.actionComplete(2);
         }
      }
      
      public function relog() : *
      {
         this.signinfn(true);
      }
      
      private function signuserin(param1:MouseEvent) : *
      {
         removeEventListener(KeyboardEvent.KEY_DOWN,this.checkkeys);
         this.signinfn();
      }
   }
}
