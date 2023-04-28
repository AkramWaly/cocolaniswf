package com.cocolani
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   
   public dynamic class sceneInteractive extends MovieClip
   {
       
      
      var selectFilter;
      
      var unselectFilter;
      
      public var thisref;
      
      public var stageref;
      
      var hasBlackBorder = false;
      
      public var sceneObjId = 0;
      
      public var distanceToActive = 200;
      
      public var internalFunctions = false;
      
      public function sceneInteractive()
      {
         this.selectFilter = new GlowFilter(16777215,1,8,8,2,BitmapFilterQuality.MEDIUM,false,false);
         this.unselectFilter = new GlowFilter(0,1,1.5,1.5,25,BitmapFilterQuality.MEDIUM,false,false);
         this.thisref = this;
         super();
         this.thisref.filters = [];
         this.setInteractive();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      public function init(param1:Event) : *
      {
         this.stageref = this.thisref.stage.getChildAt(0);
      }
      
      public function setBorder() : *
      {
         this.hasBlackBorder = true;
         filters = [this.unselectFilter];
      }
      
      public function setInteractive() : *
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.mousecatcher);
         addEventListener(MouseEvent.MOUSE_OUT,this.mousecatcher);
         addEventListener(MouseEvent.CLICK,this.mousecatcher);
         buttonMode = true;
      }
      
      public function removeInteractive() : *
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.mousecatcher);
         removeEventListener(MouseEvent.MOUSE_OUT,this.mousecatcher);
         removeEventListener(MouseEvent.CLICK,this.mousecatcher);
         buttonMode = false;
      }
      
      public function gotClick() : *
      {
      }
      
      public function mousecatcher(param1:MouseEvent) : *
      {
         if(!this.stageref.getChildByName("mc_scene") || this.distanceToActive == -1 || this.stageref.mc_scene.sceneRef.getDistanceToObject(this.thisref) <= this.distanceToActive)
         {
            buttonMode = true;
            if(param1.type == "mouseOver")
            {
               if(this.hasBlackBorder)
               {
                  filters = [this.unselectFilter,this.selectFilter];
               }
               else
               {
                  filters = [this.selectFilter];
               }
            }
            else if(param1.type == "click")
            {
               if(this.stageref.mc_interface.speechHandlerRef)
               {
                  this.stageref.mc_interface.speechHandlerRef.shutdown();
               }
               this.stageref.mc_scene.sceneRef.roomObjClicked(this.thisref);
               if(this.internalFunctions)
               {
                  this.gotClick();
               }
            }
            else if(this.hasBlackBorder)
            {
               filters = [this.unselectFilter];
            }
            else
            {
               filters = [];
            }
         }
         else
         {
            buttonMode = false;
            if(this.hasBlackBorder)
            {
               filters = [this.unselectFilter];
            }
            else
            {
               filters = [];
            }
         }
      }
   }
}
