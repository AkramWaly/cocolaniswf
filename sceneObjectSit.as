package com.cocolani
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class sceneObjectSit extends sceneObject
   {
       
      
      public var seatinglist;
      
      public var seatID;
      
      public var myDir = 1;
      
      public var sitDistance = 80;
      
      public var handlesSeating = false;
      
      public function sceneObjectSit()
      {
         this.seatinglist = [];
         super();
         ownsInteractity = true;
      }
      
      public function commonSceneObjClick(param1:*) : *
      {
      }
      
      override public function optionResult(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(stageRef.mc_scene.sceneRef)
         {
            stageRef.mc_scene.sceneRef.hideOptions();
            if(param1 == 7)
            {
               if(this.sitDistance == -1 || stageRef.mc_scene.sceneRef.getDistanceToObject(thisref) <= this.sitDistance)
               {
                  if(this.handlesSeating)
                  {
                     this.commonSceneObjClick(param1);
                  }
                  else
                  {
                     _loc2_ = this.getSpareSeat();
                     if(_loc2_.length > 0)
                     {
                        stageRef.mc_scene.sceneRef.avatarSit(stageRef.mc_scene.sceneRef.egoref,thisref,_loc2_[0]);
                        _loc3_ = {};
                        _loc3_.stob = this.seatID;
                        _loc3_.stsid = _loc2_[0];
                        stageRef.sendXTmessage({
                           "ext":"nav",
                           "cmd":"sit",
                           "t":_loc3_
                        },1);
                        this.setInteractiveChildren();
                     }
                     else
                     {
                        stageRef.showmsg(stageRef.langObj.getText("com09"));
                     }
                  }
               }
               else
               {
                  stageRef.mc_interface.feedback.revealmessage(stageRef.langObj.getText("com00"),"");
               }
            }
            else if(param1 == 8)
            {
               stageRef.mc_scene.sceneRef.avatarStand(stageRef.mc_scene.sceneRef.egoref,thisref);
               _loc3_ = {};
               _loc3_.stob = undefined;
               _loc3_.stsid = undefined;
               stageRef.sendXTmessage({
                  "ext":"nav",
                  "cmd":"sit",
                  "t":_loc3_
               },1);
               trace("Stand up....");
            }
         }
      }
      
      public function setInteractiveChildren() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(ownsInteractity)
         {
            if(this.seatinglist.length > 0)
            {
               objSeperated = true;
               mouseEnabled = true;
               mouseChildren = true;
               removeEventListener(MouseEvent.MOUSE_OVER,mousecatcher);
               removeEventListener(MouseEvent.MOUSE_OUT,mousecatcher);
               removeEventListener(MouseEvent.CLICK,mousecatcher);
               thisref.buttonMode = false;
               _loc1_ = ["fgd","bgd"];
               _loc2_ = 0;
               while(_loc2_ < _loc1_.length)
               {
                  _loc3_ = getChildByName(_loc1_[_loc2_]);
                  if(_loc3_)
                  {
                     _loc3_.addEventListener(MouseEvent.MOUSE_OVER,mousecatcher);
                     _loc3_.addEventListener(MouseEvent.MOUSE_OUT,mousecatcher);
                     _loc3_.addEventListener(MouseEvent.CLICK,mousecatcher);
                     _loc3_.mouseChildren = false;
                     _loc3_.buttonMode = true;
                  }
                  _loc2_++;
               }
            }
            else
            {
               mouseChildren = false;
               addEventListener(MouseEvent.MOUSE_OVER,mousecatcher);
               addEventListener(MouseEvent.MOUSE_OUT,mousecatcher);
               addEventListener(MouseEvent.CLICK,mousecatcher);
               thisref.buttonMode = true;
               _loc1_ = ["fgd","bgd"];
               _loc2_ = 0;
               while(_loc2_ < _loc1_.length)
               {
                  _loc3_ = getChildByName(_loc1_[_loc2_]);
                  _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,mousecatcher);
                  _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,mousecatcher);
                  _loc3_.removeEventListener(MouseEvent.CLICK,mousecatcher);
                  _loc2_++;
               }
            }
         }
      }
      
      public function releaseSeat(param1:* = 1) : *
      {
         this.seatinglist[param1] = undefined;
         this.destroy();
      }
      
      public function destroy() : *
      {
      }
      
      public function releaseAV(param1:*) : *
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.seatinglist)
         {
            if(param1.sfsAV.getId() == this.seatinglist[_loc2_].sfsAV.getId())
            {
               this.releaseSeat(_loc2_);
            }
         }
      }
      
      public function avSit(param1:*, param2:*) : *
      {
         trace("sitpos 1 = " + thisref.sitpos1);
         trace("seating list = " + this.seatinglist);
         this.seatinglist[param2] = param1;
         thisref.sitpos1.addChild(param1);
         param1.x = 0;
         param1.y = 0;
         this.setInteractiveChildren();
      }
      
      public function avStand(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = false;
         for(_loc3_ in this.seatinglist)
         {
            if(this.seatinglist[_loc3_])
            {
               if(this.seatinglist[_loc3_].sfsAV.getName() == param1.sfsAV.getName())
               {
                  _loc4_ = _loc3_;
                  thisref["sitpos" + _loc4_].removeChild(this.seatinglist[_loc4_]);
                  _loc5_ = thisref.localToGlobal(new Point(thisref["standpos" + _loc4_].x,thisref["standpos" + _loc4_].y));
                  _loc5_ = stageRef.mc_scene.sceneRef.globalToLocal(_loc5_);
                  param1.x = _loc5_.x;
                  param1.y = _loc5_.y;
                  this.seatinglist[_loc4_] = undefined;
                  _loc2_ = true;
               }
            }
         }
         if(!_loc2_)
         {
            thisref.stage.getChildAt(0).showmsg("Problem in object. Please contact technical support.>");
         }
      }
      
      override public function get mySeating() : *
      {
         return [1];
      }
      
      override public function getoptions() : *
      {
         var _loc1_:* = [];
         if(!stageRef.mc_scene.sceneRef || stageRef.mc_scene.sceneRef.egoref.isSitting == false || this.isEgoSittingHere())
         {
            if(this.isEgoSitting())
            {
               _loc1_.push({"id":8});
            }
            else if(this.getSpareSeat().length > 0)
            {
               _loc1_.push({"id":7});
            }
         }
         _loc1_.push({"id":5});
         return _loc1_;
      }
      
      public function getSpareSeat() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = [];
         for(_loc2_ in this.mySeating)
         {
            if(!this.seatinglist[this.mySeating[_loc2_]])
            {
               _loc1_.push(this.mySeating[_loc2_]);
            }
         }
         return _loc1_;
      }
      
      public function isEgoSittingHere() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.seatinglist)
         {
            if(this.seatinglist[_loc1_].isego)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isEgoSitting() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.seatinglist)
         {
            if(stageRef.mc_scene.sceneRef.egoref == this.seatinglist[_loc1_])
            {
               return true;
            }
         }
         return false;
      }
   }
}
