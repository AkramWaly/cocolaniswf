package com.cocolani
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class resourceLoader extends EventDispatcher
   {
      
      public static const UPDATE_LOADER:String = "update_loader";
      
      public static const LOADING_FIN:String = "loading_fin";
      
      public static const FILE_FIN:String = "file_fin";
       
      
      private var _resources:Array;
      
      var _resourcetype:String;
      
      var resourceCatalogue;
      
      private var resourceloader_loaderArr;
      
      var _resourcecount = 0;
      
      var resourceLoadingState:Boolean = false;
      
      var classlist;
      
      var loaderContext:LoaderContext;
      
      var urlbase:String = "/";
      
      var thisref;
      
      var rootref;
      
      private var loading:Boolean = false;
      
      private var loadedResources:Array;
      
      private var indexIDs:Array;
      
      public function resourceLoader(param1:Array, param2:String = "", param3:* = "")
      {
         this._resources = [];
         this.resourceCatalogue = new Array();
         this.resourceloader_loaderArr = new Array();
         this.classlist = [];
         super();
         this.rootref = param3;
         this.thisref = this;
         if(param1 != null && param1.length > 0)
         {
            this.addResources(param1,param2);
         }
      }
      
      public function addResources(param1:Array, param2:String = "", param3:String = null) : *
      {
         if(this.indexIDs == null)
         {
            this.indexIDs = [];
         }
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            if(this.checkIfExists(param1[_loc4_]))
            {
               trace("Resource " + param1[_loc4_] + " already exists.");
            }
            else
            {
               this.indexIDs.push(param3);
               this.resourceCatalogue.push(param1[_loc4_]);
               this._resourcetype = param2;
               this.urlbase = "";
               switch(param2)
               {
                  case "obj":
                     this.urlbase = "obj/";
                     break;
                  case "audio":
                     this.urlbase = "aud/";
                     break;
                  case "lang":
                     this.urlbase = "lang/";
                     break;
                  case "none":
                     this.urlbase = "";
                     break;
                  case "panels":
                     this.urlbase = "panels/";
                     break;
                  case "cust":
                     this.urlbase = "cust/";
               }
               param1[_loc4_] = this.urlbase + param1[_loc4_];
               this._resources.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         if(this._resources.length > 0)
         {
            this.loading = true;
            this.loadresources();
         }
      }
      
      public function checkIfExists(param1:*) : *
      {
         var _loc2_:* = false;
         var _loc3_:* = 0;
         while(_loc3_ < this.resourceCatalogue.length)
         {
            if(this.resourceCatalogue[_loc3_] == param1)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function setListeners(param1:*) : *
      {
         param1.contentLoaderInfo.addEventListener(Event.INIT,this.loadingInitListener);
         param1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorListener);
         param1.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loadingSectionListener);
         param1.contentLoaderInfo.addEventListener(Event.COMPLETE,this.complListener);
         param1.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
      }
      
      public function complListener(param1:Event) : *
      {
      }
      
      public function ioErrorListener(param1:IOErrorEvent) : *
      {
         trace("IO ERROR " + param1);
         var _loc2_:* = 0;
         while(_loc2_ < this.resourceloader_loaderArr.length)
         {
            if(this.resourceloader_loaderArr[_loc2_].contentLoaderInfo == param1.target)
            {
               if(this.rootref.statusType > 6)
               {
                  this.rootref.showmsg("Could not load " + param1.text + " URL : " + this.resourceloader_loaderArr[_loc2_].contentLoaderInfo.loaderURL);
               }
               this.resourceloader_loaderArr.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         if(this.resourceloader_loaderArr.length == 0)
         {
            this.resourceLoadingState = false;
            this.loading = false;
            this.thisref.dispatchEvent(new Event(resourceLoader.LOADING_FIN));
         }
      }
      
      public function loadresources() : *
      {
         var _loc1_:* = undefined;
         this.resourceLoadingState = true;
         this.loading = true;
         this.loaderContext = new LoaderContext();
         this.loaderContext.applicationDomain = ApplicationDomain.currentDomain;
         while(this._resources.length > 0)
         {
            _loc1_ = this.resourceloader_loaderArr[this.resourceloader_loaderArr.push(new Loader()) - 1];
            this.setListeners(_loc1_);
            if(this.rootref.baseURL)
            {
               _loc1_.load(new URLRequest(this.rootref.baseURL + this._resources.shift()),this.loaderContext);
            }
            else
            {
               _loc1_.load(new URLRequest(this._resources.shift()),this.loaderContext);
            }
         }
      }
      
      public function getqueu() : *
      {
         return this._resources;
      }
      
      public function loadingSectionListener(param1:Event) : *
      {
         var _loc2_:* = new ProgressEvent(resourceLoader.UPDATE_LOADER);
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc5_ < this.resourceloader_loaderArr.length)
         {
            _loc3_ += this.resourceloader_loaderArr[_loc5_].contentLoaderInfo.bytesLoaded;
            _loc4_ += this.resourceloader_loaderArr[_loc5_].contentLoaderInfo.bytesTotal;
            _loc5_++;
         }
         _loc2_.bytesLoaded = _loc3_;
         _loc2_.bytesTotal = _loc4_;
         this.thisref.dispatchEvent(_loc2_);
      }
      
      public function getLoading() : *
      {
         return [this.resourceloader_loaderArr.length,this._resourcecount];
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
      }
      
      public function loadingInitListener(param1:Event) : *
      {
         if(this.loadedResources == null)
         {
            this.loadedResources = [];
         }
         if(this.indexIDs.length > 0)
         {
            this.loadedResources[this.indexIDs.shift()] = param1.target.content;
         }
         this.thisref.dispatchEvent(new Event(resourceLoader.FILE_FIN));
         var _loc2_:* = 0;
         while(_loc2_ < this.resourceloader_loaderArr.length)
         {
            if(this.resourceloader_loaderArr[_loc2_].contentLoaderInfo == param1.target)
            {
               this.resourceloader_loaderArr.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         if(this.resourceloader_loaderArr.length == 0)
         {
            this.loading = false;
            this.resourceLoadingState = false;
            this.thisref.dispatchEvent(new Event(resourceLoader.LOADING_FIN));
         }
      }
      
      public function getResource(param1:String) : *
      {
         return this.loadedResources[param1];
      }
   }
}
