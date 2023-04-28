package com.cocolani
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class preloader extends MovieClip
   {
       
      
      public var load_bar:MovieClip;
      
      var totalWidth = 200;
      
      var thisref;
      
      var stageref;
      
      var baseSize = 0.2;
      
      var resourcesLoaded = 0;
      
      var resourceInit = false;
      
      var langID = 0;
      
      var custID = 0;
      
      var resourcesToLoad;
      
      var loaderObjects;
      
      var totalLoaderCount = 0;
      
      var totalLoadedCount = 0;
      
      public function preloader()
      {
         this.thisref = this;
         this.resourcesToLoad = [];
         this.loaderObjects = [];
         super();
         this.load_bar.width = 0;
         this.thisref.parent.stop();
         var _loc1_:* = addEventListener(Event.ENTER_FRAME,this.chkloading);
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function init(param1:Event) : *
      {
         this.stageref = param1.currentTarget.stage.getChildAt(0);
         this.langID = this.stageref.langObj.selectedLang;
         if(LoaderInfo(param1.currentTarget.stage.loaderInfo).parameters["lang"])
         {
            this.langID = Number(LoaderInfo(param1.currentTarget.stage.loaderInfo).parameters["lang"]);
         }
         this.loadExtra();
      }
      
      private function loadExtra() : *
      {
         var _loc2_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc1_:* = stage;
         if(LoaderInfo(_loc1_.loaderInfo).parameters["baseURL"])
         {
            _loc2_ = LoaderInfo(_loc1_.loaderInfo).parameters["baseURL"] + "/" + LoaderInfo(_loc1_.loaderInfo).parameters["swfURL"];
         }
         else
         {
            _loc2_ = "swf/";
         }
         if(LoaderInfo(_loc1_.loaderInfo).parameters["cid"])
         {
            this.custID = LoaderInfo(_loc1_.loaderInfo).parameters["cid"];
         }
         else
         {
            this.custID = _loc1_.getChildAt(0).custID;
         }
         if(this.custID < 2)
         {
            this.resourcesToLoad.push("lang/registerbt_l");
         }
         var _loc3_:* = new URLRequest(_loc2_ + "panels/login_bgd.swf");
         var _loc4_:* = new Loader();
         this.stageref.preloadedObjects.push(_loc4_);
         _loc4_.load(_loc3_);
         _loc4_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.chkResourceLoad);
         _loc4_.contentLoaderInfo.addEventListener(Event.INIT,this.resourcesInit);
         _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.resourcesFailed);
         var _loc5_:* = 0;
         while(_loc5_ < this.resourcesToLoad.length)
         {
            this.loaderObjects.push(new Loader());
            (_loc8_ = this.loaderObjects[this.loaderObjects.length - 1]).contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.chkResourceLoad);
            _loc8_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.resourcesFailed);
            _loc8_.contentLoaderInfo.addEventListener(Event.INIT,this.resourcesInit);
            _loc5_++;
         }
         this.totalLoaderCount = this.resourcesToLoad.length;
         var _loc6_:*;
         (_loc6_ = new LoaderContext()).applicationDomain = ApplicationDomain.currentDomain;
         var _loc7_:* = 0;
         while(_loc7_ < this.loaderObjects.length)
         {
            _loc9_ = _loc2_ + this.resourcesToLoad.pop() + this.langID + ".swf";
            _loc10_ = new URLRequest(_loc9_);
            this.loaderObjects[_loc7_].load(_loc10_,_loc6_);
            _loc7_++;
         }
      }
      
      private function resourcesFailed(param1:IOErrorEvent) : *
      {
         this.stageref.showmsg("Failed loading resources or invalid language.");
      }
      
      private function resourcesInit(param1:Event) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.loaderObjects.length)
         {
            if(this.loaderObjects[_loc2_].contentLoaderInfo == param1.currentTarget)
            {
               this.loaderObjects[_loc2_].contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.chkResourceLoad);
               this.loaderObjects[_loc2_].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.resourcesFailed);
               this.loaderObjects[_loc2_].contentLoaderInfo.removeEventListener(Event.INIT,this.resourcesInit);
               this.loaderObjects.splice(_loc2_,1);
               ++this.totalLoadedCount;
               break;
            }
            _loc2_++;
         }
         if(this.stageref.preloadedObjects[0].contentLoaderInfo.bytesLoaded == this.stageref.preloadedObjects[0].contentLoaderInfo.bytesTotal && this.stageref.preloadedObjects[0].contentLoaderInfo.bytesLoaded > 0 && this.loaderObjects.length == 0)
         {
            this.resourceInit = true;
         }
      }
      
      private function chkResourceLoad(param1:ProgressEvent) : *
      {
         var _loc6_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc3_ < this.loaderObjects.length)
         {
            _loc6_ = this.loaderObjects[_loc3_].contentLoaderInfo;
            _loc2_ += _loc6_.bytesLoaded / _loc6_.bytesTotal;
            _loc3_++;
         }
         _loc2_ += this.totalLoadedCount;
         var _loc4_:* = this.stageref.preloadedObjects[0].contentLoaderInfo.bytesLoaded / this.stageref.preloadedObjects[0].contentLoaderInfo.bytesTotal;
         var _loc5_:* = _loc2_ / this.totalLoaderCount;
         this.resourcesLoaded = (_loc4_ * (1 / (this.totalLoaderCount + 1)) + _loc5_ * 1 / (this.totalLoaderCount + 1)) * (1 - this.baseSize);
      }
      
      private function chkloading(param1:Event) : *
      {
         this.load_bar.width = (this.resourcesLoaded + this.thisref.parent.loaderInfo.bytesLoaded / this.thisref.parent.loaderInfo.bytesTotal * this.baseSize) * this.totalWidth;
         if(this.resourceInit && this.thisref.parent.loaderInfo.bytesLoaded == this.thisref.parent.loaderInfo.bytesTotal)
         {
            removeEventListener(Event.ENTER_FRAME,this.chkloading);
            this.thisref.parent.gotoAndStop(3);
         }
      }
   }
}
