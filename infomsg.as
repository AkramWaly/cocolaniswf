package com.cocolani
{
   import com.cocolani.panels.popup;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class infomsg extends popup
   {
       
      
      public var header:TextField;
      
      var thisref;
      
      var textFormat;
      
      var entryText = null;
      
      public var thetext:TextField;
      
      public var bt_ok:MovieClip;
      
      public function infomsg()
      {
         this.textFormat = new TextFormat();
         super();
         this.thisref = this;
         this.thetext.autoSize = TextFieldAutoSize.LEFT;
         this.bt_ok.addEventListener(MouseEvent.CLICK,this.closeme);
         this.textFormat.size = 18;
         this.thetext.setTextFormat(this.textFormat);
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      public function init(param1:Event) : *
      {
         if(param1.currentTarget.stage.getChildAt(0).statusType > 6)
         {
            this.thetext.selectable = true;
         }
      }
      
      public function settext(param1:*, param2:*) : *
      {
         param2.langObj.setTextJustify(this.thetext,param1);
         this.bt_ok.setText(param2.langObj.getText("gui17"));
         this.entryText = param1;
         this.adjustTextSize(this.thetext);
      }
      
      public function closeme(param1:MouseEvent) : *
      {
         this.thisref.parent.removeChild(this.thisref);
      }
      
      public function adjustTextSize(param1:TextField) : *
      {
         var _loc2_:* = 0;
         while(param1.textHeight > 90)
         {
            --this.textFormat.size;
            param1.setTextFormat(this.textFormat);
            this.thisref.stage.getChildAt(0).langObj.setTextJustify(this.thetext,this.entryText);
            _loc2_++;
            if(_loc2_ > 100)
            {
               break;
            }
         }
      }
   }
}
