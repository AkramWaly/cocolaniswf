package com.cocolani
{
   public class sceneListings
   {
       
      
      var rootref;
      
      var sceneList:XML;
      
      public function sceneListings(param1:*)
      {
         this.sceneList = <xml>
<Scenelist>
<Room name="Welcome">
</Room>
<Room name="Jungle">
  <File>jungle1.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Room 2">
  <File>jungle2.swf</File>
  <Tribe>1</Tribe>

</Room>
<Room name="Jungle Bridge">
  <File>jungle3.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Temple">
  <File>jungle_temple.swf</File>
  <Tribe>1</Tribe>
</Room>

<Room name="Jungle Corridor 1">
  <File>jungle_temple_corridor1.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Corridor 2">
  <File>jungle_temple_corridor2.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Centre">

  <File>jungle_village.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Furniture">
  <File>jungle_furniturestore.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="GamesRoom">
</Room>

<Room name="Jungle Pathway 1">
  <File>jungle_path1.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Pathway 2">
<File>jungle_path2.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Swimming">
  <File>jungle_leisure.swf</File>

  <Tribe>1</Tribe>
</Room>
<Room name="Volcano Bridge">
  <File>volcano_bridge.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Centre">
  <File>volcano_village.swf</File>
  <Tribe>2</Tribe>

</Room>
<Room name="Volcano Pathway 1">
  <File>volcano_path1.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Pathway 2">
  <File>volcano_path2.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Transition">
</Room>
<Room name="Volcano Leisure">
  <File>volcano_leisure.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Junkyard 1">
  <File>volcano_junkyard1.swf</File>

  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Junkyard 2">
  <File>volcano_junkyard2.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Tunnel 1">
  <File>volcano_tunnel1.swf</File>
  <Tribe>2</Tribe>

</Room>
<Room name="Volcano Tunnel 2">
  <File>volcano_tunnel2.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Tunnel 3">
  <File>volcano_tunnel3.swf</File>
  <Tribe>2</Tribe>
</Room>

<Room name="Volcano Tunnel 4">
  <File>volcano_tunnel4.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Tunnel 5">
  <File>volcano_tunnel5.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Temple 1">

  <File>volcano_temple1.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Temple 2">
  <File>volcano_temple2.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Mountain 1">
  <File>volcano_mountain1.swf</File>

  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Mountain 2">
  <File>volcano_mountain2.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Mountain 3">
  <File>volcano_mountain3.swf</File>
  <Tribe>2</Tribe>

</Room>
<Room name="Volcano Mountain 4">
  <File>volcano_mountain4.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Volcano Mountain 5">
  <File>volcano_mountain5.swf</File>
  <Tribe>2</Tribe>
</Room>

<Room name="Battle Zone1">
  <File>noman_midbridge.swf</File>
</Room>
<Room name="Volcano Furniture">
  <File>volcano_furniture.swf</File>
  <Tribe>2</Tribe>
</Room>
<Room name="Tutorial Island1">
	<File>tutorial_island.swf</File>
</Room>
<Room name="Summer Beach">
	<File>noman_summerbeach.swf</File>
</Room>
<Room name="Marbles Game">
	<File>noman_marbles.swf</File>
</Room>
<Room name="Backgammon Room">
	<Access>0</Access>
</Room>
<Room name="Connect4 Room">
	<Access>0</Access>
</Room>
<Room name="Jungle Pathway 3">
  <File>jungle_path3.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Pathway 4">
  <File>jungle_path4.swf</File>

  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Pathway 5">
  <File>jungle_path5.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Pathway 6">
  <File>jungle_path6.swf</File>
  <Tribe>1</Tribe>

</Room>
<Room name="Jungle Pathway 7">
  <File>jungle_path7.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Turn">
  <File>jungle_turn.swf</File>
  <Tribe>1</Tribe>
</Room>

<Room name="Jungle Lighthouse">
  <File>jungle_lighthouse.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Corridor 4">
  <File>jungle_temple_corridor4.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Corridor 3">

  <File>jungle_temple_corridor3.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Spare 1">
  <Tribe>1</Tribe>
</Room>
<Room name="Test Sandbox">
	<File>testSandbox.swf</File>
  <Tribe>1</Tribe>
</Room>
<Room name="Jungle Leisure Outlet">
	<File>jungle_leisure_outlet.swf</File>
  <Tribe>1</Tribe>
</Room>
</Scenelist>

</xml>;
         super();
         this.rootref = param1;
      }
      
      public function getSceneFile(param1:Number) : *
      {
         var id:Number = param1;
         try
         {
            if(this.sceneList.Scenelist.Room[id - 1].File)
            {
               return String(this.sceneList.Scenelist.Room[id - 1].File);
            }
         }
         catch(e:Error)
         {
            return false;
         }
      }
      
      public function getSceneName(param1:Number) : *
      {
         var id:Number = param1;
         try
         {
            if(this.sceneList.Scenelist.Room[id - 1].File)
            {
               return String(this.sceneList.Scenelist.Room[id - 1].@name);
            }
         }
         catch(e:Error)
         {
            return false;
         }
      }
      
      public function getName(param1:Number) : *
      {
         var id:Number = param1;
         try
         {
            if(this.sceneList.Scenelist.Room[id - 1].File)
            {
               return String(this.sceneList.Scenelist.Room[id - 1].@name);
            }
         }
         catch(e:Error)
         {
            return false;
         }
      }
      
      public function getTribe(param1:String) : *
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.sceneList.Scenelist.Room)
         {
            if(String(this.sceneList.Scenelist.Room[_loc2_].@name) == param1)
            {
               return this.sceneList.Scenelist.Room[_loc2_].Tribe;
            }
         }
         return false;
      }
      
      public function getFileByRoom(param1:String) : *
      {
         var _loc2_:* = undefined;
         if(param1.indexOf("home_tribe") > -1)
         {
            return param1;
         }
         for(_loc2_ in this.sceneList.Scenelist.Room)
         {
            if(String(this.sceneList.Scenelist.Room[_loc2_].@name) == param1)
            {
               return String(this.sceneList.Scenelist.Room[_loc2_].File);
            }
         }
         this.rootref.showmsg("Invalid room name :" + param1);
         return false;
      }
      
      public function getTribeByFile(param1:String) : *
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this.sceneList.Scenelist.Room)
         {
            if(String(this.sceneList.Scenelist.Room[_loc2_].File) == param1)
            {
               return Number(this.sceneList.Scenelist.Room[_loc2_].Tribe);
            }
         }
         return false;
      }
      
      public function getZoneSceneName(param1:Number) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this.rootref.sfs.getAllRooms();
         for(_loc3_ in _loc2_)
         {
            if(_loc2_[_loc3_].getId() == param1)
            {
               return _loc2_[_loc3_].getName();
            }
         }
         return false;
      }
      
      public function getIDFromSFS(param1:Number) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this.rootref.sfs.getRoom(param1).getName();
         for(_loc3_ in this.sceneList.Scenelist.Room)
         {
            if(this.sceneList.Scenelist.Room[_loc3_].@name == _loc2_)
            {
               return Number(_loc3_) + 1;
            }
         }
      }
      
      public function getID(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.indexOf("home_tribe") > -1)
         {
            return -1;
         }
         _loc2_ = this.rootref.sfs.getAllRooms();
         for(_loc3_ in this.sceneList.Scenelist.Room)
         {
            if(this.sceneList.Scenelist.Room[_loc3_].@name == param1)
            {
               for(_loc4_ in _loc2_)
               {
                  if(_loc2_[_loc4_].getName() == param1)
                  {
                     return _loc2_[_loc4_].getId();
                  }
               }
            }
         }
         this.rootref.showmsg("Invalid room name on SFS:" + param1);
         return false;
      }
   }
}
