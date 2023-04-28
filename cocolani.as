package com.cocolani
{
   import com.cocolani.gui.ASCIIcontext;
   import com.cocolani.gui.buddyListController;
   import com.cocolani.lang.Language;
   import com.cocolani.obj.furnItem;
   import com.cocolani.obj.furn_wallItem;
   import com.cocolani.scenes.scene;
   import com.greensock.TweenLite;
   import flash.display.DisplayObjectContainer;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.LocalConnection;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   import it.gotoandplay.smartfoxserver.SmartFoxClient;
   
   public class cocolani extends MovieClip
   {
      
      static var startRoom = "jungle_village.swf";
      
      static var startRoomId = 8;
      
      static var startConfigs = [{"name":"Jungle Bridge"},{"name":"Volcano Bridge"}];
      
      static var startAtHome = false;
      
      static var startInsideHome = false;
      
      static var gotoPreviousRoom = false;
      
      static var lastLoginRm = -1;
       
      
      public var mc_scene:sceneloader;
      
      public var debug:TextField;
      
      public var login:signin;
      
      public var langObj;
      
      public var sceneLists;
      
      public var zoneSelectorRqd:Boolean = false;
      
      public var customLogin:Boolean = false;
      
      public var connLimits = 1;
      
      public var hasJoinedRoom = false;
      
      public var hasJoinedScene = false;
      
      public var myTribe = -1;
      
      public var currentTribe = 1;
      
      public var previousTribe = -1;
      
      public var statusType = 0;
      
      public var targetRoomID = 0;
      
      public var myHomeAddr = -1;
      
      public var myHomeID = -1;
      
      public var invVars:Array;
      
      public var pzlVars:Array;
      
      public var prvpzlVars;
      
      public var myIPAddress;
      
      public var loadedAVData;
      
      public var FID;
      
      public var FAccessToken = null;
      
      public var FBVerified = false;
      
      public var FBPaymentCat = 0;
      
      public var isDebug = false;
      
      public var limitZoneFeed = true;
      
      public var sessionMemory;
      
      public var usertypes = "";
      
      public var MOTD;
      
      public var sfs:SmartFoxClient;
      
      public var intro:MovieClip;
      
      public var mc_interface;
      
      public var cursorRef;
      
      public var levelThreshold;
      
      private var contextSetting;
      
      public var buddylistControl:buddyListController;
      
      public var DBURL = "http://localhost/cocolani/php/req/";
      
      public var ip = "127.0.0.1";
      
      public var sfsPort = "9339";
      
      public var swfURL = "swf/";
      
      public var baseURL = "";
      
      public var rootURL = "";
      
      public var zoneName = "cocolani";
      
      public var custID = 0;
      
      public var appID = "308987892500579";
      
      public var key;
      
      public var connectionCheck:LocalConnection;
      
      public var isConnectionOwner = true;
      
      public var stageRatio;
      
      public var stageScale;
      
      public var sceneOffset;
      
      var thisref;
      
      var initialized = false;
      
      var initGUI = false;
      
      var initialResourceLoad = false;
      
      public var loginAfterConnect = false;
      
      var loggingin = true;
      
      var sceneinit:scene;
      
      var sceneObjBase:sceneObject;
      
      var sceneobj:sceneInteractive;
      
      var afurnItem:furnItem;
      
      var awallItem:furn_wallItem;
      
      public var tribeAudioLoaded;
      
      public var shuttingDown = false;
      
      var walking:Boolean = false;
      
      var msgWindow;
      
      public var popupWindows;
      
      public var preloadedObjects;
      
      var preloaderRef;
      
      public var resourceloader;
      
      public var reconnectTimer;
      
      public var mailcost = 1;
      
      public var tribeData;
      
      public var banmessage = "You where banned by a moderator because: ";
      
      public var SRPaymentEnabled = 1;
      
      public function cocolani()
      {
         this.langObj = new Language();
         this.sceneLists = new sceneListings(this);
         this.sessionMemory = {};
         this.levelThreshold = [];
         this.contextSetting = new ASCIIcontext(this);
         this.stageRatio = [];
         this.stageScale = [925,600];
         this.sceneOffset = [];
         this.thisref = this;
         this.tribeAudioLoaded = [2];
         this.popupWindows = new Array();
         this.preloadedObjects = new Array();
         this.reconnectTimer = new Timer(15000);
         this.tribeData = [{
            "id":1,
            "name":"Yeknom"
         },{
            "id":2,
            "name":"Hu Hu Hlua"
         }];
         super();
         Security.allowDomain("superrewards-offers.com");
         Security.allowDomain("dev.cocolani.com");
         this.stageRatio[0] = this.stageScale[0] / stage.stageWidth;
         this.stageRatio[1] = this.stageScale[1] / stage.stageHeight;
         if(LoaderInfo(stage.loaderInfo).parameters["ip"])
         {
            this.ip = LoaderInfo(stage.loaderInfo).parameters["ip"];
            this.DBURL = LoaderInfo(stage.loaderInfo).parameters["regurl"];
            this.custID = Number(LoaderInfo(stage.loaderInfo).parameters["cid"]);
         }
         if(LoaderInfo(stage.loaderInfo).parameters["port"])
         {
            this.sfsPort = LoaderInfo(stage.loaderInfo).parameters["port"];
         }
         if(LoaderInfo(stage.loaderInfo).parameters["lang"])
         {
            this.langObj.selectedLang = Number(LoaderInfo(stage.loaderInfo).parameters["lang"]);
         }
         if(LoaderInfo(stage.loaderInfo).parameters["swfURL"])
         {
            this.swfURL = LoaderInfo(stage.loaderInfo).parameters["swfURL"];
         }
         if(LoaderInfo(stage.loaderInfo).parameters["baseURL"])
         {
            this.baseURL = LoaderInfo(stage.loaderInfo).parameters["baseURL"] + "/" + this.swfURL;
            this.rootURL = LoaderInfo(stage.loaderInfo).parameters["baseURL"] + "/";
         }
         else
         {
            this.rootURL = this.baseURL;
            this.baseURL += this.swfURL;
         }
         if(LoaderInfo(stage.loaderInfo).parameters["zone"])
         {
            this.zoneName = LoaderInfo(stage.loaderInfo).parameters["zone"];
         }
         if(LoaderInfo(stage.loaderInfo).parameters["zn"])
         {
            this.zoneSelectorRqd = LoaderInfo(stage.loaderInfo).parameters["zn"] == "1";
         }
         if(LoaderInfo(stage.loaderInfo).parameters["fid"])
         {
            this.FID = LoaderInfo(stage.loaderInfo).parameters["fid"];
         }
         if(LoaderInfo(stage.loaderInfo).parameters["awrd"])
         {
            this.FBPaymentCat = LoaderInfo(stage.loaderInfo).parameters["awrd"];
         }
         if(LoaderInfo(stage.loaderInfo).parameters["lmtZn"])
         {
            this.limitZoneFeed = LoaderInfo(stage.loaderInfo).parameters["lmtZn"];
         }
         if(LoaderInfo(stage.loaderInfo).parameters["SRon"])
         {
            this.SRPaymentEnabled = LoaderInfo(stage.loaderInfo).parameters["SRon"];
         }
         var resources:* = [];
         this.resourceloader = new resourceLoader(resources,"",this);
         this.resourceloader.addEventListener(resourceLoader.UPDATE_LOADER,this.onLoadResourceLoading);
         this.resourceloader.addEventListener(resourceLoader.LOADING_FIN,this.onLoadResourceDone);
         try
         {
            if(LoaderInfo(stage.loaderInfo).parameters["connLimit"] == "1")
            {
               this.connectionCheck = new LocalConnection();
               this.connectionCheck.connect("CocolaniConnection");
            }
            this.connLimits = Number(LoaderInfo(stage.loaderInfo).parameters["connLimit"]);
         }
         catch(e:Error)
         {
            isConnectionOwner = false;
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.CloseConnection);
      }
      
      public function verifyFBSession(param1:Object, param2:Object) : *
      {
         if(param1)
         {
            this.FBVerified = true;
            if(this.loginAfterConnect)
            {
               this.login.actionComplete(3);
            }
         }
         else
         {
            ExternalInterface.call("feedback","Facebook verification failed: " + param2["error"]);
            this.destroyInstance();
            this.FBVerified = false;
         }
      }
      
      public function checkFB() : *
      {
         this.FBVerified = true;
         if(this.loginAfterConnect)
         {
            this.login.actionComplete(3);
         }
      }
      
      private function testthisoneout(param1:* = null) : *
      {
         trace("HIDE FLASH CALL BACK SUCCESS.");
      }
      
      public function initMain() : *
      {
         if(this.isConnectionOwner)
         {
            this.sceneOffset[0] = this.mc_scene.x;
            this.sceneOffset[1] = this.mc_scene.y;
            this.sfs = new SmartFoxClient(true);
            this.sfs.smartConnect = true;
            this.sfs.addEventListener(SFSEvent.onAdminMessage,this.onsfsAdminevent);
            this.sfs.addEventListener(SFSEvent.onObjectReceived,this.onObjectReceivedHandler);
            this.sfs.addEventListener(SFSEvent.onConnectionLost,this.onConnectionLostHandler);
            this.sfs.addEventListener(SFSEvent.onConnection,this.onConnectionHandler);
            this.sfs.addEventListener(SFSEvent.onExtensionResponse,this.onExtensionResponseHandler);
            this.sfs.addEventListener(SFSEvent.onJoinRoom,this.onJoinRoom);
            this.sfs.addEventListener(SFSEvent.onJoinRoomError,this.onJoinRoomError);
            this.sfs.addEventListener(SFSEvent.onLogin,this.onLoginHandler);
            this.sfs.addEventListener(SFSEvent.onModeratorMessage,this.onsfsModeratorevent);
            this.sfs.addEventListener(SFSEvent.onPublicMessage,this.onPublicMessageHandler);
            this.sfs.addEventListener(SFSEvent.onRandomKey,this.onRandomKeyHandler);
            this.sfs.addEventListener(SFSEvent.onRoomAdded,this.onRoomAddedHandler);
            this.sfs.addEventListener(SFSEvent.onRoomDeleted,this.onRoomDeletedHandler);
            this.sfs.addEventListener(SFSEvent.onRoomListUpdate,this.onRoomListupd);
            this.sfs.addEventListener(SFSEvent.onRoomVariablesUpdate,this.onRoomVariablesUpdate);
            this.sfs.addEventListener(SFSEvent.onUserCountChange,this.onUserCountChange);
            this.sfs.addEventListener(SFSEvent.onUserEnterRoom,this.onUserEnterRoom);
            this.sfs.addEventListener(SFSEvent.onUserLeaveRoom,this.onUserLeaveRoom);
            this.sfs.addEventListener(SFSEvent.onUserVariablesUpdate,this.onUserVariablesUpdateHandler);
            this.sfs.addEventListener(SFSEvent.onLogout,this.onLogoutHandler);
            this.buddylistControl = new buddyListController(this.thisref);
         }
         else
         {
            this.showmsg(this.langObj.getText("err06"));
         }
         if(this.custID == 3)
         {
            this.newpopup(this.baseURL + "cust/cust3_splash_l" + this.langObj.selectedLang + ".swf","load","cust3_splash",false,false,{
               "nocentre":true,
               "effect":["fadein"]
            });
         }
         else if(this.custID == 1)
         {
            this.newpopup(this.baseURL + "cust/cust1_splash_l" + this.langObj.selectedLang + ".swf","load","cust1_splash",false,false,{
               "nocentre":true,
               "effect":["fadein"]
            });
         }
         if(this.FID)
         {
            if(LoaderInfo(stage.loaderInfo).parameters["fbToken"])
            {
               this.FAccessToken = LoaderInfo(stage.loaderInfo).parameters["fbToken"];
               this.appID = LoaderInfo(stage.loaderInfo).parameters["faid"];
            }
            this.checkFB();
         }
      }
      
      public function connectSFS() : *
      {
         trace("Connecting to " + this.ip + " on port : " + this.sfsPort);
         this.sfs.connect(this.ip,this.sfsPort);
      }
      
      private function CloseConnection(param1:Event) : *
      {
         if(this.connectionCheck)
         {
            this.connectionCheck.close();
         }
      }
      
      private function onLoadResourceLoading(param1:ProgressEvent) : *
      {
         if(this.preloaderRef)
         {
            this.preloaderRef.percentagetxt.text = Math.round(param1.bytesLoaded / param1.bytesTotal * 100) + "%";
         }
      }
      
      private function onLoadResourceDone(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(!this.initialResourceLoad)
         {
            this.resourceloader.removeEventListener(resourceLoader.LOADING_FIN,this.onLoadResourceDone);
            this.resourceloader.removeEventListener(resourceLoader.UPDATE_LOADER,this.onLoadResourceLoading);
            if(!this.mc_interface)
            {
               _loc2_ = getDefinitionByName("com.cocolani.gui.world_interface");
               this.mc_interface = addChild(new _loc2_());
            }
            this.initInterface();
            this.initialResourceLoad = true;
            this.initialized = true;
         }
         if(this.loggingin)
         {
            this.loggedinfn();
         }
      }
      
      private function onsfsAdminevent(param1:SFSEvent) : void
      {
         if(param1.params.message.indexOf("#ERR") > -1)
         {
            this.showmsg(this.langObj.getErrMsg(param1.params.message));
         }
         else
         {
            this.showmsg(param1.params.message);
         }
         if(param1.params.message.indexOf(this.banmessage) > -1)
         {
         }
      }
      
      private function logoutfunctions() : *
      {
         try
         {
            this.mc_interface.logout(false);
         }
         catch(e:*)
         {
            trace("Error closing interface " + e);
         }
         var i:* = 0;
         while(i < this.popupWindows.length)
         {
            trace("Remove " + this.popupWindows[i]);
            this.popupWindows[i].parent.removeChild(this.popupWindows[i]);
            i++;
         }
         this.popupWindows = [];
         try
         {
            this.mc_scene.logout();
         }
         catch(e:*)
         {
            trace("Error closing scene " + e);
         }
         if(this.intro && getChildByName("intro"))
         {
            this.thisref.removeChild(this.intro);
         }
         this.initialized = true;
         this.loggingin = true;
         this.hasJoinedRoom = false;
         this.hasJoinedScene = false;
         this.initGUI = true;
         this.login.visible = true;
         this.login.addChildAt(this.login.bgdContainer,0);
         this.login.clearLogin();
         this.mc_interface.audio.fadeOut();
         if(!this.FID && !this.zoneSelectorRqd)
         {
            this.login.enablelogin();
         }
         else if(this.FID)
         {
            this.login.openingAnim(5);
            this.login.signinfn(true);
         }
         else if(this.custID < 3)
         {
            if(!this.zoneSelectorRqd)
            {
               this.login.openingAnim(5);
               this.login.signinfn(true);
            }
            else
            {
               this.login.openingAnim(5);
               this.login.actionComplete(3,1);
            }
         }
         this.sfs.addEventListener(SFSEvent.onRoomListUpdate,this.onRoomListupd);
         this.shuttingDown = false;
         if(this.custID == 3)
         {
            this.login.visible = false;
            if(this.login.customLoginDetails)
            {
               trace("user = " + this.login.customLoginDetails.user);
               this.login.username.text = this.login.customLoginDetails.user;
               this.login.password.text = this.login.customLoginDetails.pass;
            }
            this.newpopup(this.baseURL + "cust/cust3_splash_l" + this.langObj.selectedLang + ".swf","load","cust3_splash",false,false,{
               "nocentre":true,
               "effect":["fadein"]
            });
         }
      }
      
      private function onConnectionLostHandler(param1:SFSEvent) : void
      {
         this.shuttingDown = true;
         if(this.mc_interface && !this.loggingin)
         {
            this.mc_interface.logout(false);
            this.logoutfunctions();
         }
      }
      
      private function onConnectionHandler(param1:SFSEvent) : void
      {
         if(param1.params.success)
         {
            if(this.reconnectTimer.hasEventListener(TimerEvent.TIMER))
            {
               this.reconnectTimer.removeEventListener(TimerEvent.TIMER,this.reconnectTimerListener);
               this.reconnectTimer.stop();
            }
            if(this.custID >= 2)
            {
               if(this.key == undefined)
               {
                  this.sfs.getRandomKey();
               }
               else
               {
                  this.login.quicklogin();
               }
            }
            else
            {
               if(this.key == undefined)
               {
                  this.sfs.getRandomKey();
               }
               else if(this.loginAfterConnect)
               {
                  this.login.signinfn(true);
               }
               this.login.enablelogin();
            }
            if(this.sfs.getConnectionMode() == "http")
            {
               this.showmsg(this.repText(this.langObj.getText("err01"),this.sfsPort));
            }
         }
         else if(!this.reconnectTimer.hasEventListener(TimerEvent.TIMER))
         {
            this.reconnectTimer.addEventListener(TimerEvent.TIMER,this.reconnectTimerListener);
            this.reconnectTimer.stop();
            this.reconnectTimer.start();
         }
      }
      
      private function onExtensionResponseHandler(param1:SFSEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:String = param1.params.type;
         _loc3_ = param1.params.dataObj;
         if(_loc2_ == "str")
         {
            if(_loc4_ = this.mc_scene.sceneRef)
            {
               _loc4_.extReply(_loc3_,_loc2_);
            }
         }
         else
         {
            if(_loc3_.pzlupd)
            {
               this.prvpzlVars = this.clone(this.pzlVars);
               this.pzlVars = _loc3_.pzlupd.split(",");
            }
            switch(_loc3_._cmd)
            {
               case "logKO":
                  if(_loc3_.err.indexOf("#FUN") > -1)
                  {
                     this.login.miniRegisterSeq = true;
                     this.login.loginBeenSent = false;
                     if(this.custID == 3 && this.login.username.length < 1 && this.login.password.length < 10)
                     {
                        this.showmsg("Missing credentials error.");
                        return;
                     }
                     this.login.openingAnim(1);
                  }
                  else
                  {
                     if(!(_loc7_ = this.langObj.getErrMsg(_loc3_.err)))
                     {
                        _loc7_ = _loc3_.err;
                     }
                     this.showmsg(_loc7_);
                     this.login.enablelogin();
                  }
                  break;
               case "init":
                  this.buddylistControl.reset();
                  this.myTribe = Number(_loc3_.tb);
                  this.myHomeAddr = Number(_loc3_.had);
                  this.myHomeID = Number(_loc3_.hid);
                  this.statusType = Number(_loc3_.st);
                  this.usertypes = _loc3_.mbr;
                  lastLoginRm = _loc3_.prm;
                  this.previousTribe = _loc3_.prtb;
                  if(this.previousTribe && Number(this.previousTribe) > 0)
                  {
                     this.currentTribe = this.previousTribe;
                  }
                  this.loadedAVData = _loc3_;
                  this.MOTD = _loc3_.motd;
                  this.invVars = _loc3_.invars.split(",");
                  if(_loc3_.pvars.length > 0)
                  {
                     this.pzlVars = _loc3_.pvars.split(",");
                  }
                  else
                  {
                     this.pzlVars = [];
                  }
                  this.prvpzlVars = this.pzlVars;
                  this.levelThreshold = _loc3_.lvl.split(",");
                  if(this.langObj.selectedLang != Number(_loc3_.lang))
                  {
                     this.showmsg(this.langObj.getText("err04"));
                     this.langObj.selectedLang = Number(_loc3_.lang);
                  }
                  if(this.mc_interface)
                  {
                     this.initInterface();
                  }
                  this.tribeData = [];
                  for(_loc8_ in _loc3_.tribeData)
                  {
                     this.tribeData.push({
                        "id":_loc3_.tribeData[_loc8_].id,
                        "name":_loc3_.tribeData[_loc8_].name,
                        "chief":_loc3_.tribeData[_loc8_].chief
                     });
                  }
                  break;
               case "sceneRep":
                  if(_loc3_.invvar)
                  {
                     this.invVars = _loc3_.invvar.split(",");
                  }
                  if(this.mc_scene && this.mc_scene.sceneRef)
                  {
                     this.mc_scene.sceneRef.extReply(_loc3_);
                  }
                  break;
               case "sceneRepAuto":
                  if(this.mc_scene && this.mc_scene.sceneRef)
                  {
                     this.mc_scene.sceneRef.extReplyAuto(_loc3_);
                  }
                  break;
               case "gameRep":
                  this.mc_scene.gameReply(_loc3_);
                  break;
               case "interface":
                  if(this.mc_interface)
                  {
                     this.mc_interface.XTResponse(_loc3_);
                  }
                  break;
               case "purse":
                  this.mc_interface.setcredit(_loc3_.cr);
                  break;
               case "error":
                  this.showmsg(_loc3_.err);
                  break;
               case "action":
                  this.mc_scene.playerAction(_loc3_);
                  break;
               case "hp":
                  this.mc_interface.updatehappyness(_loc3_.hp);
                  break;
               case "buy":
                  if(_loc3_.cr)
                  {
                     this.mc_interface.setcredit(_loc3_.cr);
                  }
                  else if(_loc3_.altcr)
                  {
                     this.mc_interface.bt_currency.setAltCredit(_loc3_.altcr);
                  }
                  this.mc_interface.updatehappyness(_loc3_.hp);
                  if(_loc3_.adinv)
                  {
                     this.mc_interface.addInventoryItem(_loc3_.adinv);
                     this.mc_scene.addInventoryItem();
                  }
                  break;
               case "afrn":
                  this.mc_scene.adjustFurniture(_loc3_.frn);
                  break;
               case "dinv":
                  this.mc_interface.dropInventoryItem(_loc3_.id);
                  break;
               case "dinvM":
                  _loc5_ = _loc3_.ids.split(",");
                  for(_loc8_ in _loc5_)
                  {
                     this.mc_interface.dropInventoryItem(_loc5_[_loc8_]);
                  }
                  break;
               case "ginv":
                  this.mc_interface.addInventoryItem(_loc3_.adinv);
                  break;
               case "rfrn":
                  this.mc_scene.removeFurniture(_loc3_.id);
                  break;
               case "pfrn":
                  this.mc_interface.dropInventoryItem(_loc3_.id);
                  this.mc_scene.placeFurniture(_loc3_.frn);
                  break;
               case "popupReply":
                  for(_loc8_ in this.popupWindows)
                  {
                     if(this.popupWindows[_loc8_].popupName == _loc3_.popup)
                     {
                        this.popupWindows[_loc8_].contentref.XTreply(_loc3_);
                     }
                  }
                  break;
               case "profile":
                  if(this.mc_interface.playerPopupRef && this.mc_interface.playerPopupRef.profileContainer)
                  {
                     this.mc_interface.playerPopupRef.profileContainer.setData(_loc3_);
                  }
                  break;
               case "trdrq":
                  this.mc_interface.incomingInvOffer(_loc3_);
                  break;
               case "mail":
                  _loc8_ = 0;
                  while(_loc8_ < this.popupWindows.length)
                  {
                     if(this.popupWindows[_loc8_].popupName == "mail")
                     {
                        this.popupWindows[_loc8_].contentref.mailin(_loc3_.data.split("|"));
                     }
                     _loc8_++;
                  }
                  break;
               case "sendSucc":
                  _loc6_ = this.getWindowByName("mail");
                  if(_loc3_.fail)
                  {
                     if(_loc6_)
                     {
                        _loc6_.contentref.sendfail();
                     }
                  }
                  else
                  {
                     this.showmsg(this.langObj.repText("com07",_loc3_.to));
                     if(_loc6_)
                     {
                        _loc6_.contentref.sendsuccess();
                     }
                     this.mc_interface.setcredit(_loc3_.cr);
                  }
                  break;
               case "exchangeRt":
                  if(this.mc_interface.speechHandlerRef)
                  {
                     this.mc_interface.speechHandlerRef.setExchangeRate(_loc3_.rt);
                  }
                  break;
               case "exchangeRsp":
                  if(this.mc_interface.speechHandlerRef)
                  {
                     this.mc_interface.speechHandlerRef.setExchangeResponse(_loc3_);
                  }
                  break;
               case "adminFn":
                  for(_loc8_ in this.popupWindows)
                  {
                     if(this.popupWindows[_loc8_].popupName == "admin")
                     {
                        this.popupWindows[_loc8_].contentref.XTreply(_loc3_);
                     }
                  }
                  break;
               case "VarUpd":
                  for(_loc8_ in _loc3_)
                  {
                     if(_loc8_ != "_cmd")
                     {
                        this.loadedAVData[_loc8_] = _loc3_[_loc8_];
                     }
                     if(_loc8_ == "invars")
                     {
                        this.invVars = _loc3_[_loc8_].split(",");
                     }
                  }
                  break;
               case "mod_response":
                  this.buddylistControl.Moderator_PvtMessage_Response(_loc3_);
                  break;
               case "refreshBrowser":
                  this.refreshBrowser(_loc3_.period);
            }
         }
      }
      
      public function refreshBrowser(param1:*) : *
      {
         trace("Caliing refresh browser..");
         var _loc2_:* = new Timer(param1 * 1000);
         _loc2_.addEventListener(TimerEvent.TIMER,this.refreshNow);
         _loc2_.start();
      }
      
      public function refreshNow(param1:TimerEvent) : *
      {
         param1.currentTarget.stop();
         var _loc2_:* = ExternalInterface.call("window.location.href.toString");
         if(_loc2_)
         {
            navigateToURL(new URLRequest(_loc2_),"_self");
         }
      }
      
      public function getWindowByName(param1:String) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.popupWindows.length)
         {
            if(this.popupWindows[_loc2_].popupName == param1)
            {
               return this.popupWindows[_loc2_];
            }
            _loc2_++;
         }
         return false;
      }
      
      private function onJoinRoom(param1:SFSEvent) : void
      {
         if(param1.params.room.getName() == "Transition")
         {
            if(this.targetRoomID > 0)
            {
               if(this.mc_scene.sceneRef && this.mc_scene.sceneRef.isReady)
               {
                  this.joinroom(this.targetRoomID);
               }
               this.targetRoomID = 0;
            }
            return;
         }
         if(param1.params.room.getName() != "Welcome")
         {
            this.mc_scene.joinroom(param1.params.room);
         }
         else if(param1.params.room.getName() != "GamesRoom")
         {
            if(!param1.params.room.isGame())
            {
               this.hasJoinedRoom = true;
               if(this.loggingin && this.initialResourceLoad)
               {
                  this.loggedinfn();
               }
               if(startAtHome && this.myHomeAddr && this.mc_scene.sceneRef)
               {
                  this.mc_scene.joinhome();
               }
            }
         }
      }
      
      private function onJoinRoomError(param1:SFSEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(param1.params.error.indexOf("full") > -1)
         {
            this.showmsg(this.langObj.getText("fdb06"));
            _loc2_ = this.sfs.getAllRooms();
            _loc3_ = this.sfs.activeRoomId;
            _loc4_ = 0;
            _loc5_ = false;
            _loc6_ = ["Jungle","Volcano"];
            for(_loc7_ in _loc2_)
            {
               if(_loc2_[_loc7_].getId() == _loc3_)
               {
                  _loc4_ = _loc7_;
               }
            }
            _loc7_ = _loc4_ + 1;
            while(_loc7_ < _loc2_.length)
            {
               if(_loc2_[_loc7_].getName().indexOf(_loc6_[this.myTribe - 1]) > -1 && _loc2_[_loc7_].getUserCount() < _loc2_[_loc7_].getMaxUsers())
               {
                  this.mc_scene.loadNewRoom(_loc2_[_loc7_].getName());
                  _loc5_ = true;
                  break;
               }
               _loc7_++;
            }
            if(!_loc5_)
            {
               _loc7_ = _loc4_ - 1;
               while(_loc7_ >= 0)
               {
                  if(_loc2_[_loc7_].getName().indexOf(_loc6_[this.myTribe - 1]) > -1 && _loc2_[_loc7_].getUserCount() < _loc2_[_loc7_].getMaxUsers())
                  {
                     this.mc_scene.loadNewRoom(_loc2_[_loc7_].getName());
                     _loc5_ = true;
                     break;
                  }
                  _loc7_--;
               }
            }
            this.sfs.getRoomList();
         }
         else
         {
            this.showmsg(param1.params.error);
         }
      }
      
      private function onLogoutHandler(param1:SFSEvent) : void
      {
         this.shuttingDown = true;
         this.logoutfunctions();
      }
      
      private function onRandomKeyHandler(param1:SFSEvent) : void
      {
         this.key = param1.params.key;
         if(this.loginAfterConnect)
         {
            this.login.quicklogin();
         }
      }
      
      private function onsfsModeratorevent(param1:SFSEvent) : void
      {
         this.showmsg("Moderator " + param1.params.sender.getName() + " said : " + param1.params.message);
      }
      
      private function onPublicMessageHandler(param1:SFSEvent) : void
      {
         this.mc_interface.publicmessage(param1.params.message,param1.params.sender,param1.params.roomId);
         this.mc_scene.publicmessage(param1.params.message,param1.params.sender,param1.params.roomId);
      }
      
      private function onRoomAddedHandler(param1:SFSEvent) : void
      {
      }
      
      private function onRoomDeletedHandler(param1:SFSEvent) : void
      {
      }
      
      private function onRoomListupd(param1:SFSEvent) : void
      {
         var _loc2_:* = undefined;
         this.sfs.removeEventListener(SFSEvent.onRoomListUpdate,this.onRoomListupd);
         this.sfs.autoJoin();
         if(!this.initialized)
         {
            this.initialized = true;
            this.resourceloader.addResources(["avatar1.swf","avatar2.swf"],"avatar");
            this.resourceloader.addResources(["shared.swf","gui.swf"],"");
            if(this.myTribe > 0)
            {
               this.resourceloader.addResources(["sfx_tribe" + this.myTribe + ".swf"],"audio");
               this.tribeAudioLoaded.push(this.myTribe);
            }
            _loc2_ = getDefinitionByName("mc_progress");
            this.preloaderRef = addChildAt(new _loc2_(),getChildIndex(this.login));
            this.preloaderRef.percentagetxt.text = "0%";
            this.preloaderRef.x = this.stageScale[0] / 2 - 8;
            this.preloaderRef.y = this.stageScale[1] / 2 - 16;
         }
         else
         {
            this.loggedinfn();
         }
      }
      
      private function onRoomVariablesUpdate(param1:SFSEvent) : void
      {
         this.mc_scene.sceneRef.roomVarUpdate(param1.params.changedVars);
      }
      
      private function onUserCountChange(param1:SFSEvent) : void
      {
      }
      
      private function onUserEnterRoom(param1:SFSEvent) : void
      {
         if(this.mc_scene.sceneRef)
         {
            this.mc_scene.sceneRef.userjoinroom(param1.params.user,param1.params.roomId);
         }
      }
      
      private function onUserLeaveRoom(param1:SFSEvent) : void
      {
         if(this.mc_scene.sceneRef)
         {
            this.mc_scene.sceneRef.userleaveroom(param1.params.userId,param1.params.roomId,param1.params.userName);
         }
      }
      
      private function onUserVariablesUpdateHandler(param1:SFSEvent) : void
      {
         if(this.mc_scene.sceneRef)
         {
            this.mc_scene.sceneRef.uservarupdate(param1.params.user,param1.params.changedVars);
         }
      }
      
      private function onObjectReceivedHandler(param1:SFSEvent) : void
      {
         if(this.mc_scene.sceneRef)
         {
            this.mc_scene.sceneRef.objectReceived(param1.params.obj,param1.params.sender);
         }
      }
      
      private function initInterface() : *
      {
         var _loc1_:* = true;
         if(!this.initGUI)
         {
            this.buddylistControl.mc_interface = this.mc_interface;
            this.mc_interface.setstageref(this.thisref);
            this.mc_interface.loadPanels();
            this.initGUI = true;
            _loc1_ = false;
         }
         if(!this.loadedAVData)
         {
            this.showmsg("AVATAR DATA NOT AVAILABLE.");
            return;
         }
         this.mc_interface.setcredit(this.loadedAVData.cr);
         this.mc_interface.updatehappyness(Number(this.loadedAVData.hp),false);
         if(this.myTribe > 0)
         {
            this.mc_interface.initializeLogin(_loc1_);
         }
      }
      
      public function autoTeleport() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.loadedAVData.tb == 0)
         {
            this.showmsg("Need to define character data..");
            return;
         }
         if(this.loadedAVData.dotutorial == true)
         {
            _loc1_ = this.newpopup(this.baseURL + "panels/tutorial_toon_c" + this.custID + "_l" + this.langObj.selectedLang + ".swf","load","tutorial_toon",false,false,{
               "nocentre":true,
               "openIn":this.mc_scene
            });
            this.mc_scene.visible = true;
         }
         else
         {
            if(startAtHome && this.myHomeAddr || this.previousTribe == this.myTribe && !this.sceneLists.getSceneFile(lastLoginRm) && this.myHomeAddr)
            {
               this.mc_scene.loadHome(this.myTribe,this.myHomeAddr,startInsideHome,true);
            }
            else if(this.sceneLists.getSceneFile(lastLoginRm))
            {
               if(this.hasJoinedScene == true)
               {
                  this.mc_scene.loadNewRoom(this.sceneLists.getSceneName(lastLoginRm),false);
               }
               else
               {
                  this.mc_scene.loadScene(this.sceneLists.getSceneName(lastLoginRm),true);
               }
            }
            else
            {
               _loc2_ = Number(this.previousTribe - 1);
               if(Number(_loc2_) < 0)
               {
                  _loc2_ = this.myTribe - 1;
               }
               if(this.hasJoinedScene == true)
               {
                  trace("Already logged in..");
                  this.mc_scene.loadNewRoom(startConfigs[_loc2_].name,false);
               }
               else
               {
                  trace("Start config... " + startConfigs[_loc2_].name);
                  this.mc_scene.loadScene(startConfigs[_loc2_].name,true);
               }
            }
            this.hasJoinedScene = true;
         }
      }
      
      public function signInAnimComplete() : *
      {
         this.loggedinfn();
      }
      
      private function loggedinfn() : *
      {
         if(this.hasJoinedRoom && this.login.notAnimating && this.initialResourceLoad)
         {
            if(this.preloaderRef)
            {
               removeChild(this.preloaderRef);
               this.preloaderRef = undefined;
            }
            this.loggingin = false;
            this.login.removeChild(this.login.bgdContainer);
            this.login.stopTween();
            this.autoTeleport();
            this.mc_interface.loggedin();
            this.mc_interface.setInv(this.loadedAVData.inv);
            if(this.custID == 2)
            {
               this.getAltCurrency();
            }
            this.newpopup(this.baseURL + "panels/msg_warning_l" + this.langObj.selectedLang + ".swf","load","warning",false,false,{
               "effect":["fadein"],
               "nocentre":true,
               "nopreloader":true
            });
         }
      }
      
      public function getAltCurrency() : *
      {
         var _loc1_:* = {
            "cmd":"getS",
            "ext":"altCurrency"
         };
         this.sendXTmessage(_loc1_);
      }
      
      private function onLoginHandler(param1:SFSEvent) : void
      {
         this.sfs.loadBuddyList();
         this.shuttingDown = false;
         this.loginAfterConnect = false;
         this.sessionMemory = {};
         if(param1.params.success)
         {
            if(this.FID)
            {
               this.login.openingAnim(3);
            }
            else if(this.custID == 2)
            {
               if(!(this.getWindowByName("characterSelect") && this.getWindowByName("characterSelect").contentref.animating))
               {
                  this.login.openingAnim(3);
               }
            }
            else if(this.custID == 3)
            {
               this.login.openingAnim(1);
            }
            else if(this.login.miniRegisterSeq && this.login.loginDetails.length > 1)
            {
               this.login.openingAnim(3);
            }
            else
            {
               this.login.openingAnim();
            }
         }
         else
         {
            if(param1.params.error.indexOf("#ERR") > -1)
            {
               this.showmsg(this.langObj.getErrMsg(String(param1.params.error)));
            }
            else
            {
               this.showmsg(param1.params.error);
            }
            this.login.enablelogin();
         }
      }
      
      private function reconnectTimerListener(param1:TimerEvent) : *
      {
         this.sfs.connect(this.ip,this.sfsPort);
      }
      
      public function Autoreconnect() : *
      {
         this.sfs.connect(this.ip,this.sfsPort);
         this.debug.text = "";
         this.loginAfterConnect = true;
         this.key = undefined;
      }
      
      public function newpopup(param1:String, param2:String, param3:String = "", param4:* = false, param5:* = false, param6:Object = null) : *
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         if(!param4)
         {
            _loc7_ = 0;
            while(_loc7_ < this.popupWindows.length)
            {
               if(this.popupWindows[_loc7_].popupName == param3)
               {
                  return this.popupWindows[_loc7_].contentref;
               }
               _loc7_++;
            }
         }
         switch(param2)
         {
            case "load":
               if(param6 && param6.openIn)
               {
                  this.popupWindows.push(param6.openIn.addChild(new popupLoader()));
               }
               else
               {
                  this.popupWindows.push(addChild(new popupLoader()));
               }
               (_loc8_ = this.popupWindows[this.popupWindows.length - 1]).setData(param6);
               _loc8_.loadContent(param1);
               _loc8_.popupName = param3;
               _loc8_.setLoadedEffect(param6);
               if(param5)
               {
                  setChildIndex(_loc8_,getChildIndex(this.mc_interface));
               }
               return _loc8_;
            case "class":
               this.popupWindows.push(addChild(new popupLoader()));
               (_loc8_ = this.popupWindows[this.popupWindows.length - 1]).setData(param6);
               _loc8_.setContent(param1);
               _loc8_.popupName = param3;
               if(param5)
               {
                  setChildIndex(_loc8_,getChildIndex(this.mc_interface));
               }
               if(param6)
               {
                  if(param6.effect)
                  {
                     _loc9_ = param6.effect;
                     for(_loc7_ in _loc9_)
                     {
                        if(_loc9_ == "fadein")
                        {
                           _loc8_.contentref.alpha = 0;
                           TweenLite.to(_loc8_.contentref,0.8,{"alpha":1});
                        }
                     }
                  }
               }
               return _loc8_.contentref;
            default:
               return;
         }
      }
      
      public function removepopup(param1:*) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.popupWindows.length)
         {
            if(String(this.popupWindows[_loc2_].contentref).indexOf("_Preloader_") > -1)
            {
               trace("Try publishing the popup in FP9");
            }
            if(this.popupWindows[_loc2_].contentref == param1 || this.popupWindows[_loc2_].popupName == param1)
            {
               if(this.popupWindows[_loc2_].getEffects && this.popupWindows[_loc2_].getEffects.openIn)
               {
                  this.popupWindows[_loc2_].getEffects.openIn.removeChild(this.popupWindows[_loc2_]);
               }
               else
               {
                  removeChild(this.popupWindows[_loc2_]);
               }
               this.popupWindows.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function getpopup(param1:*, param2:* = "content") : *
      {
         var _loc3_:* = 0;
         while(_loc3_ < this.popupWindows.length)
         {
            if(this.popupWindows[_loc3_].contentref == param1 || this.popupWindows[_loc3_].popupName == param1)
            {
               if(param2 == "content")
               {
                  return this.popupWindows[_loc3_].contentref;
               }
               if(param2 == "loader")
               {
                  return this.popupWindows[_loc3_];
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      public function sendXTmessage(param1:*, param2:* = 0) : *
      {
         var _loc7_:* = undefined;
         var _loc3_:* = param1;
         var _loc4_:* = param1.cmd;
         var _loc5_:* = param1.ext;
         var _loc6_:*;
         if(!(_loc6_ = param1.rid))
         {
            _loc6_ = -1;
         }
         switch(param2)
         {
            case 0:
               _loc7_ = "xml";
               param1.cmd = undefined;
               param1.ext = undefined;
               param1.rid = undefined;
               break;
            case 1:
               _loc7_ = "json";
               delete param1.cmd;
               delete param1.ext;
               delete param1.rid;
         }
         this.sfs.sendXtMessage(_loc5_,_loc4_,_loc3_,_loc7_,_loc6_);
      }
      
      public function getEgo() : *
      {
         return this.sfs.getRoom(this.sfs.getActiveRoom().getId()).getUser(this.sfs.myUserId);
      }
      
      public function logout() : *
      {
         this.sfs.logout();
      }
      
      public function joinroom(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(this.sfs.getRoom(this.sfs.activeRoomId) && (this.sfs.getRoom(this.sfs.activeRoomId).getName() == "Transition" || this.sfs.getRoom(this.sfs.activeRoomId).getName() == "Welcome"))
         {
            this.sfs.joinRoom(param1);
            if(this.sfs.getActiveRoom() == null || this.sfs.getActiveRoom().isGame())
            {
               _loc2_ = this.sfs.getRoomByName("GamesRoom");
               this.sfs.leaveRoom(_loc2_.getId());
            }
         }
         else
         {
            this.targetRoomID = param1;
         }
      }
      
      public function walkto(param1:*) : *
      {
      }
      
      public function showmsg(param1:*) : *
      {
         this.msgWindow = addChild(new mc_msg());
         this.msgWindow.settext(param1,this.thisref);
         this.msgWindow.header.text = this.langObj.getText("gui54");
         this.msgWindow.bt_ok.setText(this.langObj.getText("gui17"));
         this.langObj.setFormat(this.msgWindow.header);
      }
      
      public function getNewPzlVar() : *
      {
         return this.getNewEntry(this.pzlVars,this.prvpzlVars);
      }
      
      public function getNewEntry(param1:*, param2:*) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc3_:* = [];
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = false;
            for(_loc6_ in param2)
            {
               if(param1[_loc4_] == param2[_loc6_])
               {
                  _loc5_ = true;
                  break;
               }
            }
            if(!_loc5_)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function clone(param1:Object) : *
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      public function repText(param1:String, param2:* = null, param3:Array = null) : *
      {
         var _loc4_:* = undefined;
         if(param1.indexOf("%rep1%") == -1)
         {
            return param1;
         }
         param1 = param1.substr(0,param1.indexOf("%rep1%")) + param2 + param1.substr(param1.indexOf("%rep1%") + 6,param1.length);
         if(param3)
         {
            for(_loc4_ in param3)
            {
               param1 = param1.substr(0,param1.indexOf("%rep" + (_loc4_ + 2) + "%")) + param3[_loc4_] + param1.substr(param1.indexOf("%rep" + (_loc4_ + 2) + "%") + 6,param1.length);
            }
         }
         return param1;
      }
      
      public function checkExistInArray(param1:Array, param2:*) : *
      {
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function updateHealth(param1:Number, param2:Number) : *
      {
         var _loc3_:* = this.loadedAVData.skill[0];
         if(param1 - Number(_loc3_) > 100)
         {
            this.showmsg("Error with updating experience.. Experience increase too much!");
         }
         else
         {
            this.loadedAVData.skill = [param1,param2];
         }
      }
      
      public function destroyInstance() : *
      {
         this.destroy(this.thisref);
         this.visible = false;
         trace("Destroyed.");
      }
      
      public function destroy(param1:*) : *
      {
         trace("Destroy called.");
         var _loc2_:* = 0;
         while(param1.numChildren > 0)
         {
            _loc2_++;
            if(_loc2_ > 500)
            {
               break;
            }
            if(param1.getChildAt(0) is MovieClip)
            {
               param1.getChildAt(0).stop();
            }
            if(param1.getChildAt(0) is DisplayObjectContainer)
            {
               this.destroy(param1.getChildAt(0));
            }
            param1.removeChildAt(0);
         }
      }
   }
}
