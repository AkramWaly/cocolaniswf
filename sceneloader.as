package com.cocolani
{
   import com.gsolo.encryption.MD5;
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.None;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.LocalConnection;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   
   public class sceneloader extends Sprite
   {
       
      
      var thisref;
      
      var loadHomeOtherTribe = false;
      
      var context:LoaderContext;
      
      private var preloaderRef;
      
      public var sceneHolder:MovieClip;
      
      public var speechHolder:Sprite;
      
      public var clickPadShp:Shape;
      
      public var clickPad:Sprite;
      
      public var clickEnable:Boolean = false;
      
      public var foreElements:Sprite;
      
      var sceneLoader:Loader;
      
      var gameLoader:Loader;
      
      var gameLoaderProgress;
      
      var gameMask:Shape;
      
      var urlReq:URLRequest;
      
      var fadetw;
      
      var bitmapct;
      
      public var sceneRef;
      
      public var gameRef;
      
      private var loadingRoomID;
      
      public var loadNewRoomID;
      
      public var previousRoomID;
      
      public var loadHomeID;
      
      public var loadTribeID;
      
      public var loadInternalHome;
      
      public var loadInitProps;
      
      public var loadExtraResources = false;
      
      public var saveFNProps;
      
      private var firstLoad:Boolean = true;
      
      public var sceneEnabled:Boolean = true;
      
      public var lastClickOnPad;
      
      private var maxClickTime = 600;
      
      var receivingLC:LocalConnection;
      
      var sendingLC:LocalConnection;
      
      var gameProps:Object;
      
      public function sceneloader()
      {
         this.thisref = this;
         this.sceneHolder = new MovieClip();
         this.speechHolder = new Sprite();
         this.clickPadShp = new Shape();
         this.clickPad = new Sprite();
         this.foreElements = new Sprite();
         this.sceneLoader = new Loader();
         this.gameMask = new Shape();
         this.saveFNProps = [];
         this.sendingLC = new LocalConnection();
         super();
         this.thisref.visible = false;
         this.clickPad.addChild(this.clickPadShp);
         this.sceneHolder.addChild(this.clickPad);
         this.clickPad.graphics.beginFill(10066329,0.5);
         this.clickPad.graphics.drawRect(0,0,this.thisref.stage.getChildAt(0).stageScale[0],this.thisref.stage.getChildAt(0).stageScale[1]);
         this.clickPad.graphics.endFill();
         this.clickPad.cacheAsBitmap = true;
         addChild(this.sceneHolder);
         addChild(this.speechHolder);
         addChild(this.foreElements);
         this.gameMask.graphics.beginFill(16777215);
         this.gameMask.graphics.drawRect(0,0,600,400);
         this.gameMask.graphics.endFill();
         this.speechHolder.mouseEnabled = true;
         this.speechHolder.mouseChildren = true;
         this.speechHolder.addEventListener(MouseEvent.CLICK,this.clickthroughSpeech);
         this.sceneHolder.x = 0;
         this.sceneHolder.y = 0;
         this.sceneLoader.mouseEnabled = false;
         this.context = new LoaderContext();
         this.context.applicationDomain = ApplicationDomain.currentDomain;
         this.sceneLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.erroropen);
         this.sceneLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loadProgress);
         this.sceneLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.finloading);
         this.sceneLoader.contentLoaderInfo.addEventListener(Event.INIT,this.init);
         this.sceneLoader.contentLoaderInfo.addEventListener(Event.OPEN,this.opennew);
      }
      
      public function addInventoryItem() : *
      {
         if(this.sceneEnabled)
         {
            this.sceneRef.addInventoryItem();
         }
      }
      
      public function placeFurniture(param1:*) : *
      {
         if(this.sceneEnabled)
         {
            this.sceneRef.placeFurniture(param1);
         }
      }
      
      public function adjustFurniture(param1:*) : *
      {
         if(this.sceneEnabled)
         {
            this.sceneRef.adjustFurniture(param1);
         }
      }
      
      public function removeFurniture(param1:*) : *
      {
         if(this.sceneEnabled)
         {
            this.sceneRef.removeFurniture(param1);
         }
      }
      
      public function battleExit(param1:Boolean = false) : *
      {
         var _loc2_:* = this.thisref.stage.getChildAt(0);
         if(param1)
         {
            if(_loc2_.myTribe == 1)
            {
               this.loadNewRoom("Jungle Centre");
            }
            else if(_loc2_.myTribe == 2)
            {
               this.loadNewRoom("Volcano Centre");
            }
         }
         else if(this.previousRoomID && _loc2_.sceneLists.getZoneSceneName(this.previousRoomID) && _loc2_.sceneLists.getZoneSceneName(this.previousRoomID).indexOf("home") == -1)
         {
            this.loadNewRoom(_loc2_.sceneLists.getZoneSceneName(this.previousRoomID));
         }
         else
         {
            this.loadNewRoom("Battle Zone1");
         }
      }
      
      public function loadGame(param1:*, param2:Object = null) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(!this.gameLoader)
         {
            this.clickEnable = false;
            this.gameLoader = new Loader();
            addChild(this.gameLoader);
            this.gameLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loadProgressGame);
            this.gameLoader.contentLoaderInfo.addEventListener(Event.INIT,this.initgame);
            this.gameLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.erroropen);
            trace("load game " + param1);
            addChild(this.gameMask);
            this.gameLoader.mask = this.gameMask;
            this.gameProps = param2;
            if(!(param2 && param2.AS3))
            {
               if(!this.receivingLC)
               {
                  this.receivingLC = new LocalConnection();
                  this.receivingLC.connect("cocolaniConnector");
                  this.receivingLC.client = this.thisref;
               }
               if(!this.sendingLC)
               {
                  this.sendingLC = new LocalConnection();
               }
            }
            _loc3_ = "";
            if(!param2 || param2 && !param2.langOverride)
            {
               _loc3_ = this.thisref.stage.getChildAt(0).langObj.getLangExtension();
            }
            _loc4_ = new URLRequest(this.thisref.stage.getChildAt(0).baseURL + "games/" + param1 + _loc3_ + ".swf");
            this.gameLoader.unload();
            this.gameLoader.load(_loc4_,this.context);
            _loc5_ = getDefinitionByName("mc_progress");
            this.gameLoaderProgress = addChild(new _loc5_());
            this.gameLoaderProgress.percentagetxt.text = "0%";
            if(param2 && param2.size)
            {
               this.gameMask.width = param2.size[0];
               this.gameMask.height = param2.size[1];
               this.gameLoader.x = (this.thisref.stage.getChildAt(0).stageScale[0] - param2.size[0]) / 2;
               this.gameLoader.y = (this.thisref.stage.getChildAt(0).stageScale[1] - param2.size[1]) / 2;
               this.gameLoader.y -= 40;
            }
            else
            {
               this.gameLoader.x = (this.thisref.stage.getChildAt(0).stageScale[0] - 600) / 2;
               this.gameLoader.y = (this.thisref.stage.getChildAt(0).stageScale[1] - 400) / 2;
               this.gameLoader.y -= 40;
               this.gameMask.width = 600;
               this.gameMask.height = 400;
            }
            if(param2 && param2.xOffset)
            {
               this.gameLoader.x += param2.xOffset;
            }
            if(param2 && param2.yOffset)
            {
               this.gameLoader.y += param2.yOffset;
            }
            this.gameMask.x = this.gameLoader.x;
            this.gameMask.y = this.gameLoader.y;
            this.gameLoaderProgress.x = this.thisref.stage.getChildAt(0).stageScale[0] / 2 - this.gameLoaderProgress.width / 2;
            this.gameLoaderProgress.y = this.thisref.stage.getChildAt(0).stageScale[1] / 2 - this.gameLoaderProgress.height / 2;
            return this.gameLoader;
         }
         trace("There is already a game being loaded!");
         return this.gameLoader;
      }
      
      public function broadcastGameSound(param1:*) : *
      {
         this.sendingLC.send("cocolaniConnectorFrm","setsound",this.thisref.stage.getChildAt(0).mc_interface.audio.audioMain);
      }
      
      private function initgame(param1:Event) : *
      {
         this.gameRef = param1.target.content;
         trace("INIT GAME....");
         this.gameLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.loadProgressGame);
         this.gameLoader.contentLoaderInfo.removeEventListener(Event.INIT,this.initgame);
         this.gameLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.erroropen);
         removeChild(this.gameLoaderProgress);
         this.gameLoaderProgress = undefined;
         dispatchEvent(new Event("gameLoaded"));
      }
      
      public function gameReply(param1:Object) : *
      {
         if(this.gameProps && this.gameProps.AS3)
         {
            this.gameRef.sendResponse(param1);
         }
         else if(this.loadInitProps && this.loadInitProps.gameID)
         {
            this.sceneRef.sendResponse(param1);
         }
         else
         {
            this.sendingLC.send("cocolaniConnectorFrm","highScoreResponse",param1.hs);
         }
      }
      
      public function gamesAS3Connector(param1:* = null, param2:* = null, param3:* = null, param4:* = null) : *
      {
         if(param1 == "SHUTDOWN")
         {
            this.gameShutdown();
            this.clickEnable = true;
            this.gameRef = undefined;
            removeChild(this.gameLoader);
            this.gameLoader.unload();
            this.gameLoader = undefined;
            removeChild(this.gameMask);
            if(this.sceneRef)
            {
               this.sceneRef.gameObjectClosed();
            }
         }
         else
         {
            if(param1 == "GAMELOADED")
            {
               this.gameInitialized(param2);
               return true;
            }
            this.gamesConnector(param1,param2,param3,param4);
         }
      }
      
      private function gameInitialized(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this.thisref.stage.getChildAt(0).loadedAVData.gam;
         if(_loc2_ == "")
         {
            _loc2_ = [];
         }
         else
         {
            _loc2_ = _loc2_.split(",");
         }
         this.thisref.stage.getChildAt(0).sendXTmessage({
            "ext":"nav",
            "cmd":"setBusy",
            "t":1
         },1);
         if(!this.thisref.stage.getChildAt(0).checkExistInArray(_loc2_,param1))
         {
            _loc2_.push(param1);
            _loc3_ = {
               "cmd":"plygame",
               "ext":"gameManager",
               "id":param1
            };
            this.thisref.stage.getChildAt(0).sendXTmessage(_loc3_);
            this.thisref.stage.getChildAt(0).loadedAVData.gam = _loc2_.join(",");
            this.thisref.stage.getChildAt(0).mc_interface.playerPopupRef.rewardsContainer.updateStats();
         }
      }
      
      private function gameShutdown() : *
      {
         if(!this.thisref.stage.getChildAt(0).shuttingDown)
         {
            this.thisref.stage.getChildAt(0).sendXTmessage({
               "ext":"nav",
               "cmd":"setBusy",
               "t":undefined
            },1);
         }
      }
      
      public function gamesConnector(param1:*, param2:* = null, param3:* = null, param4:* = null) : *
      {
         var req:* = undefined;
         if(param1 == "SHUTDOWN")
         {
            this.gameShutdown();
            this.clickEnable = true;
            this.gameLoader.unload();
            this.receivingLC.close();
            this.gameRef = undefined;
            this.receivingLC = undefined;
            removeChild(this.gameLoader);
            this.gameLoader = undefined;
            removeChild(this.gameMask);
            if(this.sceneRef)
            {
               try
               {
                  this.sceneRef.gameObjectClosed();
                  if(this.thisref.stage.getChildAt(0).mc_interface.speechHandlerRef)
                  {
                     this.thisref.stage.getChildAt(0).mc_interface.speechHandlerRef.endgameEvent();
                  }
               }
               catch(e:Error)
               {
                  trace("Warning, SHUTDOWN functions hazard exists when shutting down elements during a shutdown. SHUTDOWN = " + thisref.stage.getChildAt(0).shuttingDown + " .. Error = " + e);
               }
            }
         }
         else if(param1 == "COLLECTREWARDS")
         {
            req = new Object();
            req.cmd = "collectRewards";
            req.ext = "gameManager";
            req.rwd = param2;
            req.gid = param3;
         }
         else if(param1 == "HIGHSCORE")
         {
            req = new Object();
            req.cmd = "submitHS";
            req.ext = "gameManager";
            req.hs = param2;
            req.win = param3;
            req.gid = param4;
            req.prm = new Date().getTime();
            req.agent = String(ExternalInterface.call("window.navigator.userAgent.toString"));
            req.prm2 = MD5.encrypt(req.hs + "IPledgePeaceAndLoveOnEarth" + req.prm + this.thisref.stage.getChildAt(0).sfs.myUserId);
            this.thisref.stage.getChildAt(0).sendXTmessage(req);
            if(this.thisref.stage.getChildAt(0).mc_interface.speechHandlerRef)
            {
               this.thisref.stage.getChildAt(0).mc_interface.speechHandlerRef.fingameEvent(param2,param3);
            }
            if(this.sceneRef)
            {
               this.sceneRef.gameMessage(param1,param2,param3,param4);
            }
         }
         else if(param1 == "SENDHACK")
         {
            req = new Object();
            req.cmd = "hack";
            req.gid = param2;
            req.hs = param3;
            req.ext = "gameManager";
            this.thisref.stage.getChildAt(0).sendXTmessage(req);
         }
         else if(param1 == "GETSCORES")
         {
            req = new Object();
            req.cmd = "getHS";
            req.ext = "gameManager";
            req.gid = param2;
            this.thisref.stage.getChildAt(0).sendXTmessage(req);
         }
         else if(param1 == "SCENEMESSAGE")
         {
            if(this.thisref.sceneRef)
            {
               this.thisref.sceneRef.gameMessage(param2,param3,param4);
            }
         }
         else if(param1 == "getaudio")
         {
            this.sendingLC.send("cocolaniConnectorFrm","setsound",this.thisref.stage.getChildAt(0).mc_interface.audio.audioMain);
         }
         else if(param1 == "GAMELOADED")
         {
            this.gameInitialized(param2);
            this.sendingLC.send("cocolaniConnectorFrm","permToPlay",true);
         }
      }
      
      private function loadProgressGame(param1:ProgressEvent) : *
      {
         if(this.gameLoaderProgress)
         {
            this.gameLoaderProgress.percentagetxt.text = Math.round(param1.bytesLoaded / param1.bytesTotal * 100) + "%";
         }
      }
      
      public function loadHome(param1:*, param2:*, param3:* = false, param4:Boolean = false) : *
      {
         var _loc6_:* = undefined;
         var _loc5_:* = this.thisref.stage.getChildAt(0);
         if(!param4 && _loc5_.currentTribe != param1 && _loc5_.statusType < 7)
         {
            _loc5_.showmsg(_loc5_.langObj.getText("hom32"));
            return;
         }
         this.loadNewRoomID = undefined;
         this.loadInitProps = null;
         this.loadHomeID = param2;
         this.loadTribeID = param1;
         this.loadInternalHome = param3;
         this.thisref.stage.getChildAt(0).currentTribe = param1;
         if(this.sceneRef)
         {
            (_loc6_ = new BitmapData(945,600,false,0)).draw(this.sceneLoader,null,null,null,new Rectangle(0,0,945,600),true);
            this.bitmapct = new Bitmap(_loc6_,PixelSnapping.NEVER,true);
            this.sceneRef.shutdown();
            this.thisref.stage.getChildAt(0).mc_interface.scroller.disableScroller();
            if(this.thisref.stage.getChildAt(0).sfs.activeRoomId)
            {
               if(this.thisref.stage.getChildAt(0).sfs.activeRoomId != this.loadingRoomID)
               {
                  this.thisref.stage.getChildAt(0).sfs.leaveRoom(this.thisref.stage.getChildAt(0).sfs.activeRoomId);
               }
            }
            this.thisref.stage.getChildAt(0).sfs.joinRoom(_loc5_.sceneLists.getID("Transition"));
            if(this.loadingRoomID && this.loadingRoomID > 0 && this.thisref.stage.getChildAt(0).sfs.activeRoomId != this.loadingRoomID)
            {
               this.thisref.stage.getChildAt(0).sfs.leaveRoom(this.loadingRoomID);
            }
         }
         if(param3)
         {
            this.loadScene("home_tribe" + param1 + "_interior.swf",param4);
         }
         else
         {
            this.loadScene("home_tribe" + param1 + "_exterior.swf",param4);
         }
         this.thisref.stage.getChildAt(0).mc_interface.disableForLoad();
      }
      
      public function getEgoReference() : *
      {
         var _loc1_:* = this.thisref.stage.getChildAt(0);
         var _loc2_:* = _loc1_.sfs.getActiveRoom();
         return _loc2_.getUser(_loc1_.sfs.myUserId);
      }
      
      public function exitFullScreenGame() : *
      {
         var _loc1_:* = undefined;
         if(this.previousRoomID > 0)
         {
            _loc1_ = this.thisref.stage.getChildAt(0);
            this.loadNewRoom(_loc1_.sceneLists.getSceneName(this.previousRoomID),false);
         }
      }
      
      public function getRootRoomID() : *
      {
         return this.loadingRoomID;
      }
      
      public function loadNewRoom(param1:*, param2:* = false, param3:Object = undefined) : *
      {
         var _loc4_:* = this.thisref.stage.getChildAt(0);
         if(!param2 && param1 == _loc4_.sfs.getActiveRoom().getName())
         {
            _loc4_.showmsg(_loc4_.langObj.getText("err09"));
            return;
         }
         this.loadInitProps = param3;
         this.loadHomeID = null;
         var _loc5_:*;
         (_loc5_ = new BitmapData(945,600,false,0)).draw(this.sceneLoader,null,null,null,new Rectangle(0,0,945,600),true);
         this.bitmapct = new Bitmap(_loc5_,PixelSnapping.NEVER,true);
         this.sceneRef.shutdown();
         this.thisref.stage.getChildAt(0).mc_interface.scroller.disableScroller();
         if(this.thisref.stage.getChildAt(0).sfs.activeRoomId)
         {
            if(this.thisref.stage.getChildAt(0).sfs.activeRoomId != this.loadingRoomID)
            {
               this.thisref.stage.getChildAt(0).sfs.leaveRoom(this.thisref.stage.getChildAt(0).sfs.activeRoomId);
            }
         }
         this.thisref.stage.getChildAt(0).sfs.joinRoom(_loc4_.sceneLists.getID("Transition"));
         if(this.thisref.stage.getChildAt(0).sfs.getRoom(this.loadingRoomID).getName() == "GamesRoom")
         {
            this.thisref.stage.getChildAt(0).sfs.leaveRoom(this.loadingRoomID);
         }
         this.loadScene(param1,false,param2);
         this.thisref.stage.getChildAt(0).mc_interface.disableForLoad();
      }
      
      public function loadScene(param1:*, param2:Boolean = false, param3:Boolean = false) : *
      {
         var _loc5_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc4_:* = this.thisref.stage.getChildAt(0);
         this.sceneRef = undefined;
         if(!param3)
         {
            trace("Load room " + param1);
            _loc5_ = _loc4_.sceneLists.getFileByRoom(param1);
            trace("RETRIEVED FILENAME HERE: " + _loc5_);
         }
         else if(this.loadInitProps && this.loadInitProps.gameID == 19)
         {
            _loc5_ = "yek_skiing.swf";
         }
         else
         {
            _loc5_ = "war1/war.swf";
         }
         this.previousRoomID = this.loadingRoomID;
         this.loadingRoomID = _loc4_.sceneLists.getID(param1);
         var _loc6_:* = 1;
         if(!this.loadExtraResources)
         {
            if(this.sceneRef)
            {
               this.sceneRef.removeEventListener(MouseEvent.MOUSE_DOWN,this.gotclick);
            }
            this.thisref.visible = true;
            if(!contains(this.sceneHolder))
            {
               addChild(this.sceneHolder);
            }
            this.sceneLoader.unload();
            if(this.preloaderRef)
            {
               removeChild(this.preloaderRef);
               this.preloaderRef = undefined;
            }
            _loc8_ = getDefinitionByName("mc_progress2");
            this.preloaderRef = addChild(new _loc8_());
            if(!param2)
            {
               this.preloaderRef.bgd.visible = false;
               (_loc9_ = new Shape()).graphics.beginFill(0);
               _loc9_.graphics.drawRect(0,0,945,600);
               _loc9_.graphics.endFill();
               _loc9_.alpha = 0;
               this.preloaderRef.addChildAt(_loc9_,0);
               this.fadetw = new Tween(_loc9_,"alpha",None.easeNone,0,0.7,4,false);
               this.preloaderRef.addChildAt(this.bitmapct,0);
            }
            this.preloaderRef.percentagetxt.text = "0%";
            this.preloaderRef.gotoAndStop(1);
            this.preloaderRef.gfx.maskReveal.y = 80;
            if(this.firstLoad && this.thisref.stage.getChildAt(0).MOTD)
            {
               _loc4_.langObj.setTextJustify(this.preloaderRef.MOTD,this.thisref.stage.getChildAt(0).MOTD,{
                  "htmlText":true,
                  "forceAlign":"center"
               });
               this.firstLoad = false;
            }
            else
            {
               this.preloaderRef.MOTD.text = "";
            }
            if(!this.sceneHolder.contains(this.sceneLoader))
            {
               this.sceneHolder.addChild(this.sceneLoader);
            }
         }
         var _loc7_:*;
         if((_loc7_ = _loc4_.sceneLists.getTribeByFile(_loc5_)) > 0 && _loc4_.tribeAudioLoaded.indexOf(_loc7_) == -1)
         {
            _loc4_.tribeAudioLoaded.push(_loc7_);
            _loc4_.resourceloader.addResources(["sfx_tribe" + _loc7_ + ".swf"],"audio");
            this.loadExtraResources = true;
            this.saveFNProps = [this.loadScene,[param1,param2,param3]];
            this.waitForResourceLoad();
         }
         else
         {
            if(!param3)
            {
               this.urlReq = new URLRequest(this.thisref.stage.getChildAt(0).baseURL + "scenes/" + _loc5_);
            }
            else
            {
               this.urlReq = new URLRequest(this.thisref.stage.getChildAt(0).baseURL + "games/" + _loc5_);
            }
            this.sceneLoader.load(this.urlReq,this.context);
            this.thisref.stage.getChildAt(0).mc_interface.hidePanel("speechHandler");
         }
      }
      
      private function waitForResourceLoad() : *
      {
         var _loc1_:* = this.thisref.stage.getChildAt(0);
         _loc1_.resourceloader.addEventListener("update_loader",this.updateProgress);
         _loc1_.resourceloader.addEventListener("loading_fin",this.finishResourceLoading);
      }
      
      private function updateProgress(param1:ProgressEvent) : *
      {
         if(this.preloaderRef)
         {
            this.preloaderRef.percentagetxt.text = Math.round(param1.bytesLoaded / param1.bytesTotal * 100) + "%";
         }
      }
      
      private function finishResourceLoading(param1:Event) : *
      {
         var _loc2_:* = this.thisref.stage.getChildAt(0);
         _loc2_.resourceloader.removeEventListener("update_loader",this.updateProgress);
         _loc2_.resourceloader.removeEventListener("loading_fin",this.finishResourceLoading);
         this.saveFNProps[0].apply(null,this.saveFNProps[1]);
         this.saveFNProps = [];
         this.loadExtraResources = false;
      }
      
      private function finloading(param1:Event) : *
      {
         this.sceneRef = param1.target.content;
      }
      
      private function init(param1:Event) : *
      {
         this.sceneRef = param1.target.content;
         this.sceneRef.x = 0;
         this.clickPad.addEventListener(MouseEvent.MOUSE_DOWN,this.gotclick);
         this.clickEnable = true;
         if(this.loadingRoomID == -1 && this.thisref.stage.getChildAt(0).hasJoinedRoom)
         {
            this.joinhome();
         }
         else if(this.sceneRef.isReady)
         {
            this.thisref.stage.getChildAt(0).joinroom(this.loadingRoomID);
         }
         if(this.loadInitProps)
         {
            if(this.loadInitProps.battlegame)
            {
               this.sceneRef.setGameType(this.loadInitProps.battle);
               this.sceneRef.setGameProps(this.loadInitProps);
            }
         }
      }
      
      public function sceneReady() : *
      {
         this.thisref.stage.getChildAt(0).joinroom(this.loadingRoomID);
      }
      
      public function joinhome() : *
      {
         var _loc1_:* = {};
         _loc1_.cmd = "home";
         _loc1_.ext = "home";
         _loc1_.hid = this.loadHomeID;
         _loc1_.tid = this.loadTribeID;
         if(this.loadInternalHome)
         {
            _loc1_.ins = true;
         }
         this.thisref.stage.getChildAt(0).sendXTmessage(_loc1_);
      }
      
      public function joinroom(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1.isGame() == false && param1.getName() != "GamesRoom" && param1.getName() != "Transition" && !param1.getVariable("gam"))
         {
            this.loadingRoomID = param1.getId();
         }
         if(param1.getVariable("gam") == 1)
         {
            this.sceneRef.gameRoomJoined(param1);
            return;
         }
         if(this.preloaderRef && this.sceneRef.isReady)
         {
            this.preloaderRef.gotoAndStop(2);
         }
         if(!isNaN(param1.getVariable("tb")) && this.thisref.stage.getChildAt(0).currentTribe != param1.getVariable("tb"))
         {
            this.thisref.stage.getChildAt(0).currentTribe = param1.getVariable("tb");
            this.thisref.stage.getChildAt(0).mc_interface.bt_currency.refreshCredit();
            if(this.thisref.stage.getChildAt(0).mc_interface.playerPopupRef && this.thisref.stage.getChildAt(0).mc_interface.playerPopupRef.mapContainer)
            {
               this.thisref.stage.getChildAt(0).mc_interface.playerPopupRef.mapContainer.updateTribe();
            }
         }
         this.sceneRef.joinRoom(param1);
         this.thisref.stage.getChildAt(0).mc_interface.enableForLoad();
         if(param1.isGame() == false && param1.getName() != "GamesRoom")
         {
            this.thisref.stage.frameRate = 20;
            _loc2_ = param1.getVariable("tb") == this.thisref.stage.getChildAt(0).myTribe;
            if(this.loadHomeID && !isNaN(this.thisref.stage.getChildAt(0).myHomeAddr))
            {
               _loc3_ = param1.getName().substr(4,2) == "In" ? true : false;
               if(!_loc3_ && int(this.thisref.stage.getChildAt(0).myHomeAddr / 3) == Number(param1.getVariable("addr")) && _loc2_)
               {
                  this.thisref.stage.getChildAt(0).mc_interface.bt_home.visible = false;
               }
               else if(_loc3_ && Number(param1.getVariable("addr")) == Number(this.thisref.stage.getChildAt(0).myHomeAddr) && _loc2_)
               {
                  this.thisref.stage.getChildAt(0).mc_interface.bt_home.visible = false;
               }
               else
               {
                  this.thisref.stage.getChildAt(0).mc_interface.bt_home.visible = true;
               }
            }
            else if(!isNaN(this.thisref.stage.getChildAt(0).myHomeAddr))
            {
               this.thisref.stage.getChildAt(0).mc_interface.bt_home.visible = true;
            }
         }
         else
         {
            this.thisref.stage.frameRate = 25;
            this.thisref.stage.getChildAt(0).mc_interface.bt_home.visible = true;
         }
      }
      
      private function loadProgress(param1:ProgressEvent) : *
      {
         this.preloaderRef.percentagetxt.text = Math.round(param1.bytesLoaded / param1.bytesTotal * 100) + "%";
         this.preloaderRef.gfx.maskReveal.y = 80 - 130 * (param1.bytesLoaded / param1.bytesTotal);
      }
      
      private function erroropen(param1:IOErrorEvent) : *
      {
         this.clickEnable = false;
         this.thisref.stage.getChildAt(0).showmsg("THERE WAS A LOAD ERROR : " + param1);
      }
      
      public function removePreloader() : *
      {
         this.sceneRef.setupScrollers();
         this.fadetw = new Tween(this.preloaderRef,"alpha",None.easeNone,1,0,3,false);
         this.fadetw.addEventListener(TweenEvent.MOTION_FINISH,this.finclosePreloader);
      }
      
      private function finclosePreloader(param1:TweenEvent) : *
      {
         removeChild(this.preloaderRef);
         this.preloaderRef = undefined;
      }
      
      private function opennew(param1:Event) : *
      {
      }
      
      public function gotclick(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         if(!this.lastClickOnPad || this.lastClickOnPad && getTimer() - this.lastClickOnPad > this.maxClickTime)
         {
            if(this.clickEnable && this.sceneEnabled)
            {
               if(this.sceneRef)
               {
                  this.lastClickOnPad = getTimer();
                  _loc2_ = this.sceneRef.globalToLocal(new Point(param1.stageX,param1.stageY));
                  _loc2_.x = Math.round(_loc2_.x);
                  _loc2_.y = Math.round(_loc2_.y);
                  this.sceneRef.walkAV(_loc2_);
                  if(this.thisref.stage.getChildAt(0).mc_interface.speechHandlerRef)
                  {
                     this.thisref.stage.getChildAt(0).mc_interface.speechHandlerRef.shutdown();
                  }
               }
            }
         }
      }
      
      private function clickthroughSpeech(param1:MouseEvent) : *
      {
         this.gotclick(param1);
      }
      
      public function playerAction(param1:*) : *
      {
         if(this.sceneEnabled)
         {
            this.sceneRef.userAction(param1);
         }
      }
      
      public function publicmessage(param1:*, param2:*, param3:*) : *
      {
         if(this.sceneEnabled && this.sceneRef)
         {
            this.sceneRef.usermessage(param1,param2,param3);
         }
      }
      
      public function setPreloaderMessage(param1:String) : *
      {
         if(this.preloaderRef)
         {
            this.preloaderRef.MOTD.htmlText = param1;
         }
      }
      
      public function setPreloaderAttrib(param1:Object) : *
      {
         if(this.preloaderRef)
         {
            switch(param1.type)
            {
               case "updatePerc":
                  this.preloaderRef.percentagetxt.text = param1.perc + "%";
            }
         }
      }
      
      public function logout() : *
      {
         this.firstLoad = true;
         this.thisref.stage.frameRate = 20;
         if(this.receivingLC)
         {
            if(this.sendingLC)
            {
               this.sendingLC.send("cocolaniConnectorFrm","SHUTDOWN");
            }
            this.gamesConnector("SHUTDOWN");
         }
         this.loadHomeID = undefined;
         this.loadTribeID = undefined;
         this.loadInitProps = {};
         if(this.gameMask && getChildByName("gameMask"))
         {
            removeChild(this.gameMask);
         }
         this.clickPad.removeEventListener(MouseEvent.MOUSE_DOWN,this.gotclick);
         if(this.sceneRef)
         {
            this.sceneRef.shutdown();
         }
         this.thisref.stage.getChildAt(0).mc_interface.scroller.disableScroller();
         this.sceneRef = undefined;
         this.thisref.visible = false;
         this.clickEnable = false;
         if(this.gameLoaderProgress)
         {
            removeChild(this.gameLoaderProgress);
         }
         if(this.gameLoader)
         {
            this.gameLoader.unload();
            removeChild(this.gameLoader);
         }
         this.gameLoader = undefined;
         this.sceneLoader.unload();
         this.thisref.stage.getChildAt(0).resourceloader.removeEventListener("update_loader",this.updateProgress);
         this.thisref.stage.getChildAt(0).resourceloader.removeEventListener("loading_fin",this.finishResourceLoading);
         this.loadExtraResources = false;
         this.saveFNProps = [];
      }
   }
}
