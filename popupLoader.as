package com.cocolani
{
   import com.greensock.TweenLite;
   import fl.transitions.Tween;
   import fl.transitions.easing.None;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   
   public class popupLoader extends MovieClip
   {
       
      
      public var stageref;
      
      public var tweenOn = true;
      
      public var thisref;
      
      private var preloaderref;
      
      public var contentref;
      
      public var mydata;
      
      private var urlREQ:URLRequest;
      
      private var urlLoader:URLLoader;
      
      public var loader:Loader;
      
      public var popupName:String;
      
      public var ratio;
      
      public var myTween:Array;
      
      public var loadData;
      
      private var effects;
      
      public function popupLoader()
      {
         this.thisref = this;
         this.loader = new Loader();
         this.myTween = [];
         this.loadData = {};
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      public function init(param1:Event) : *
      {
         this.stageref = this.thisref.stage.getChildAt(0);
         this.ratio = this.stageref.stageRatio;
      }
      
      public function centre() : *
      {
         if(this.loadData && this.loadData.nocentre)
         {
            return;
         }
         this.thisref.x = this.stageref.stageScale[0] / 2 - this.thisref.width / 2;
         this.thisref.y = this.stageref.stageScale[1] / 2 - this.thisref.height / 2;
         if(this.popupName == "registration")
         {
            this.thisref.x = 0;
            this.thisref.y = 0;
         }
         if(this.popupName == "store")
         {
            this.thisref.x = this.stageref.stageScale[0] / 2;
            this.thisref.y = this.stageref.stageScale[1] / 2;
         }
      }
      
      public function setData(param1:*) : *
      {
         this.loadData = param1;
      }
      
      public function setContent(param1:*) : *
      {
         var _loc2_:* = getDefinitionByName(param1);
         this.contentref = addChild(new _loc2_());
         this.centre();
      }
      
      public function loadContent(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = new LoaderContext();
         if(this.loadData && this.loadData.classes && this.loadData.classes == "global")
         {
            _loc2_.applicationDomain = ApplicationDomain.currentDomain;
         }
         addChild(this.loader);
         if(!this.loadData || this.loadData && !this.loadData.nopreloader)
         {
            _loc3_ = getDefinitionByName("mc_progress");
            this.preloaderref = addChild(new _loc3_());
            this.preloaderref.percentagetxt.text = "0%";
            this.preloaderref.x = this.thisref.stage.stageWidth * this.ratio[0] / 2 - this.thisref.width / 2 + 20;
            this.preloaderref.y = this.thisref.stage.stageHeight * this.ratio[1] / 2 - this.thisref.height / 2;
         }
         this.urlREQ = new URLRequest(param1);
         if(!this.loadData || this.loadData && !this.loadData.nopreloader)
         {
            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loaderprogress);
         }
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadererror);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.finloading);
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.initload);
         this.loader.load(this.urlREQ,_loc2_);
      }
      
      public function setLoadedEffect(param1:*) : *
      {
         this.effects = param1;
      }
      
      public function get getEffects() : *
      {
         return this.effects;
      }
      
      private function loadererror(param1:IOErrorEvent) : *
      {
         trace("Error loading " + param1);
      }
      
      private function loaderprogress(param1:ProgressEvent) : *
      {
         if(this.preloaderref)
         {
            this.preloaderref.percentagetxt.text = Math.round(param1.bytesLoaded / param1.bytesTotal * 100) + "%";
         }
      }
      
      private function initload(param1:Event) : *
      {
         var myeffects:* = undefined;
         var i:* = undefined;
         var e:Event = param1;
         if(!this.loadData || this.loadData && !this.loadData.nopreloader)
         {
            removeChild(this.preloaderref);
            this.preloaderref = undefined;
         }
         this.contentref = this.loader.content;
         this.centre();
         if(this.effects)
         {
            if(this.effects.effect)
            {
               myeffects = this.effects.effect;
               for(i in myeffects)
               {
                  if(myeffects == "fadein")
                  {
                     this.thisref.alpha = 0;
                     TweenLite.to(this.thisref,0.8,{"alpha":1});
                  }
               }
            }
            if(this.effects.initVars)
            {
               for(i in this.effects.initVars)
               {
                  try
                  {
                     this.contentref[i] = this.effects.initVars[i];
                  }
                  catch(E:Error)
                  {
                     trace("Cannot initialize variable " + i + " in initialization for popup");
                  }
               }
            }
         }
         else if(this.tweenOn)
         {
            this.myTween[0] = new Tween(this.thisref,"scaleX",None.easeOut,0.3,1,0.5,true);
            this.myTween[1] = new Tween(this.thisref,"scaleY",None.easeOut,0.3,1,0.5,true);
            this.myTween[2] = new Tween(this.thisref,"alpha",None.easeOut,0,1,0.5,true);
         }
         var readyEvent:* = new Event("ready");
         this.thisref.dispatchEvent(readyEvent);
      }
      
      private function finloading(param1:Event) : *
      {
      }
      
      private function checkresponse(param1:Event) : *
      {
         if(param1.type == "YES")
         {
         }
      }
   }
}
