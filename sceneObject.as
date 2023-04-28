package com.cocolani
{
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public dynamic class sceneObject extends MovieClip
   {
       
      
      public var thisref;
      
      public var objid;
      
      public var thisYcoord:Point;
      
      public var stageRef;
      
      public var sceneRef;
      
      public var seating;
      
      public var handlesOptions = false;
      
      var requiresLayering;
      
      var hasBlackBorder = false;
      
      var unselectFilter;
      
      var selectFilter2;
      
      public var ownsInteractity = false;
      
      protected var objSeperated = false;
      
      public var distanceToActive = 200;
      
      public var internalFunctions = false;
      
      public function sceneObject()
      {
         this.thisref = this;
         this.seating = [];
         this.unselectFilter = new GlowFilter(0,1,1.5,1.5,25,BitmapFilterQuality.MEDIUM,false,false);
         this.selectFilter2 = new GlowFilter(16777215,1,8,8,2,BitmapFilterQuality.MEDIUM,false,false);
         super();
         stop();
         if(getChildByName("yline"))
         {
            this.thisref.yline.visible = false;
         }
         else
         {
            trace("No yline present in object:" + this.thisref.name);
            this.thisref.alpha = 0.5;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.init);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function optionResult(param1:*) : *
      {
         if(this.stageRef.mc_scene.sceneRef)
         {
            this.stageRef.mc_scene.sceneRef.hideOptions();
            if(param1 == 7)
            {
            }
         }
      }
      
      public function get mySeating() : *
      {
         return [1];
      }
      
      public function updateY() : *
      {
         this.thisYcoord = this.thisref.localToGlobal(new Point(this.thisref.yline.x,this.thisref.yline.y));
         if(this.sceneRef)
         {
            this.sceneRef.setObjY(this.thisref,this.thisYcoord.y);
         }
      }
      
      public function gotClick() : *
      {
      }
      
      private function init(param1:Event) : *
      {
         if(!this.thisref.stage.getChildAt(0).getChildByName("mc_scene"))
         {
            trace("SORRY THESE OBJECTS CANNOT RUN IN STANDALONE MODE.");
            return;
         }
         if(!this.thisref.getChildByName("yline"))
         {
            trace("Warning : " + this.thisref.name + " is missing a yline.");
         }
         else
         {
            this.thisYcoord = this.thisref.localToGlobal(new Point(this.thisref.yline.x,this.thisref.yline.y));
         }
         this.stageRef = this.thisref.stage.getChildAt(0);
         this.sceneRef = this.stageRef.mc_scene.sceneRef;
         if(this.thisref.parent.getChildByName("background"))
         {
            this.thisref.parent.setObjY(this.thisref,this.thisYcoord.y);
         }
         this.seating = this.mySeating;
         this.initSettings();
      }
      
      private function initSettings() : *
      {
         if(this.getoptions().length > 1)
         {
            this.handlesOptions = true;
            this.setInteractive();
         }
      }
      
      public function setBorder() : *
      {
         this.hasBlackBorder = true;
         this.thisref.filters = [this.unselectFilter];
      }
      
      private function clickthrough(param1:MouseEvent) : *
      {
         if(param1.type == "click")
         {
            this.stageRef.mc_scene.gotclick(param1);
         }
      }
      
      public function setChildren(param1:Array) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         mouseChildren = true;
         mouseEnabled = false;
         var _loc2_:* = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(getChildAt(_loc2_).name == param1[_loc4_])
               {
                  _loc3_ = true;
                  this.thisref.getChildAt(_loc2_).mouseEnabled = true;
                  this.thisref.getChildAt(_loc2_).mouseChildren = false;
                  trace("found child on " + this.thisref.name);
                  break;
               }
               _loc4_++;
            }
            if(!_loc3_)
            {
               if(this.thisref.getChildAt(_loc2_) is Shape)
               {
                  trace("PROBLEM -- THERE IS A SHAPE IN THE OBJECT CALLED " + this.thisref.name + ". CLICKING ON THIS WILL NOT PASS THROUGH TO LOWER LAYERS!");
               }
               else
               {
                  this.thisref.getChildAt(_loc2_).addEventListener(MouseEvent.CLICK,this.clickthrough);
                  this.thisref.getChildAt(_loc2_).mouseEnabled = false;
                  this.thisref.getChildAt(_loc2_).mouseChildren = false;
               }
            }
            _loc2_++;
         }
      }
      
      public function setInteractive() : *
      {
         mouseEnabled = true;
         this.ownsInteractity = true;
         this.thisref.addEventListener(MouseEvent.MOUSE_OVER,this.mousecatcher);
         addEventListener(MouseEvent.MOUSE_OUT,this.mousecatcher);
         addEventListener(MouseEvent.CLICK,this.mousecatcher);
         this.thisref.buttonMode = true;
         if(this.hasBlackBorder)
         {
            this.thisref.filters = [this.unselectFilter];
         }
         else
         {
            this.thisref.filters = [];
         }
      }
      
      public function removeInteractive() : *
      {
         mouseEnabled = true;
         this.ownsInteractity = false;
         this.thisref.removeEventListener(MouseEvent.MOUSE_OVER,this.mousecatcher);
         removeEventListener(MouseEvent.MOUSE_OUT,this.mousecatcher);
         removeEventListener(MouseEvent.CLICK,this.mousecatcher);
         this.thisref.buttonMode = false;
         if(this.hasBlackBorder)
         {
            this.thisref.filters = [this.unselectFilter];
         }
         else
         {
            this.thisref.filters = [];
         }
      }
      
      public function getoptions() : *
      {
         var _loc1_:* = [];
         _loc1_.push({"id":5});
         return _loc1_;
      }
      
      public function mousecatcher(param1:MouseEvent) : *
      {
         this.sceneRef = this.stageRef.mc_scene.sceneRef;
         if(!this.stageRef.getChildByName("mc_scene") || this.distanceToActive == -1 || this.sceneRef.getDistanceToObject(this.thisref) <= this.distanceToActive)
         {
            buttonMode = true;
            if(param1.type == "mouseOver")
            {
               if(this.hasBlackBorder)
               {
                  param1.currentTarget.filters = [this.unselectFilter,this.selectFilter2];
               }
               else
               {
                  param1.currentTarget.filters = [this.selectFilter2];
               }
            }
            else if(param1.type == "click")
            {
               if(this.stageRef.mc_interface.speechHandlerRef)
               {
                  this.stageRef.mc_interface.speechHandlerRef.shutdown();
               }
               if(this.handlesOptions)
               {
                  this.stageRef.mc_scene.sceneRef.newOptions(this.thisref,this.getoptions());
               }
               else
               {
                  this.stageRef.mc_scene.sceneRef.roomObjClicked(this.thisref);
               }
               if(this.internalFunctions)
               {
                  this.gotClick();
               }
            }
            else if(this.hasBlackBorder)
            {
               param1.currentTarget.filters = [this.unselectFilter];
            }
            else
            {
               param1.currentTarget.filters = [];
            }
         }
         else
         {
            buttonMode = false;
            if(this.hasBlackBorder)
            {
               param1.currentTarget.filters = [this.unselectFilter];
            }
            else
            {
               param1.currentTarget.filters = [];
            }
            if(param1.type == "click")
            {
               this.stageRef.mc_scene.gotclick(param1);
            }
         }
      }
      
      public function isinfrontof(param1:*) : *
      {
         return param1 > this.thisYcoord;
      }
      
      public function getY() : *
      {
         return this.thisYcoord.y;
      }
      
      public function enableMouse() : *
      {
         mouseEnabled = true;
      }
   }
}
