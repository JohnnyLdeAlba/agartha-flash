package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.ui.*;

public class ResourceLevel001 {

	public var core:Core;
	public var StateTable:Object;
	public var DirectionTable:Object;

	public var soundtrack_index:int, previous_index:int;
	public var index:int, total:uint;
	public var urlRequest:Array, handle:Array;
	public var soundchannel:SoundChannel;

	public var soundtrack:Sound;
	public var bitmapLoader:Loader;
	
	public function ResourceLevel001(source:Core):void {

		core = source;
		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;

		soundtrack_index = 0; previous_index = -1;
		index = 0; total = 21;
		urlRequest = new Array(total);
		handle = new Array(total);

		urlRequest[0] = new URLRequest('data/level001-001.png');
		urlRequest[1] = new URLRequest('data/level001-002.png');
		urlRequest[2] = new URLRequest('data/level001-003.png');
		urlRequest[3] = new URLRequest('data/level001-004.png');
		urlRequest[4] = new URLRequest('data/level001-005.png');
		urlRequest[5] = new URLRequest('data/level001-006.png');
		urlRequest[6] = new URLRequest('data/level001-007.png');
		urlRequest[7] = new URLRequest('data/level001-008.png');
		urlRequest[8] = new URLRequest('data/level001-009.png');
		urlRequest[9] = new URLRequest('data/level001-010.png');
		urlRequest[10] = new URLRequest('data/level001-011.png');
		urlRequest[11] = new URLRequest('data/level001-012.png');
		urlRequest[12] = new URLRequest('data/level001-013.png');
		urlRequest[13] = new URLRequest('data/level001-014.png');
		urlRequest[14] = new URLRequest('data/level001-015.png');
		urlRequest[15] = new URLRequest('data/level001-016.png');
		urlRequest[16] = new URLRequest('data/level001-017.png');
		urlRequest[17] = new URLRequest('data/level001-018.png');
		urlRequest[18] = new URLRequest('data/level001-019.png');
		urlRequest[19] = new URLRequest('data/level001-020.png');
		urlRequest[20] = new URLRequest('data/parallax001.png');

		bitmapLoader = new Loader();
		bitmapLoader.contentLoaderInfo
		.addEventListener(Event.COMPLETE, loaderComplete);
		
		soundchannel = new SoundChannel();

		return;
	}

	public function getSoundTrack():void {

		soundtrack = new Sound();
		soundtrack.load(new URLRequest('data/crestoe-caverns-of-the-forgotton.mp3'));
		soundtrack.addEventListener(Event.COMPLETE, soundLoaderComplete);

		return;
	}

	public function getResource():void {

		if (previous_index == index)
			return;

		previous_index = index;
		bitmapLoader.load(urlRequest[index]);
		return;
	}

	public function getParallax():BitmapData {

		return handle[total-1];
	}

	public function getBlock001():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 0; block.y = 0;
		block.background = handle[0];

		var text:String;		
		//      1234567890ABCDEF
		text = "0000000000000000";
		text+= "X000000000000000";
		text+= "0X00000000000000";
		text+= "00X0000000000000";
		text+= "00X0000000000000";
		text+= "0X00000000000000";
		text+= "X000000000000000";
		text+= "0X00000000000000";
		text+= "00X0000000000000";
		text+= "0X00000000000000";
		text+= "00X0000000000000";
		text+= "00X0000000000000";

		block.setBoundary(text, 2);

		block.boundary[block.boundary.length-1] = new Rectangle(0, 0, 1, 240);
		block.boundary[block.boundary.length-2] = new Rectangle(0, 75, 320, 1);
		block.surface_boundary = block.boundary[block.boundary.length-2];

		block.npc_jellyfish = new Array(2);
		block.npc_jellyfish[0] = new NPCJellyfish(core);
		block.npc_jellyfish[0].setPoint(200, 190);
		block.npc_jellyfish[0].state = StateTable.suspend;

		block.npc_jellyfish[1] = new NPCJellyfish(core);
		block.npc_jellyfish[1].setIdentity('lionsmane');
		block.npc_jellyfish[1].setPoint(100, 190);
		block.npc_jellyfish[1].state = StateTable.suspend;

		block.npc_shark = new Array(4);

		block.npc_shark[0] = new NPCShark(core);
		block.npc_shark[0].setPoint(200, 190);
		block.npc_shark[0].state = StateTable.suspend;

		block.npc_shark[1] = new NPCShark(core);
		block.npc_shark[1].setIdentity('reefshark');
		block.npc_shark[1].setPoint(200, 170);
		block.npc_shark[1].state = StateTable.suspend;

		block.npc_shark[2] = new NPCShark(core);
		block.npc_shark[2].setIdentity('blueray');
		block.npc_shark[2].setPoint(200, 150);
		block.npc_shark[2].state = StateTable.suspend;

		block.npc_shark[3] = new NPCShark(core);
		block.npc_shark[3].setIdentity('brownray');
		block.npc_shark[3].setPoint(200, 130);
		block.npc_shark[3].state = StateTable.suspend;

		for (var count:uint = 0; count < block.npc_shark.length; count++)
			block.npc_shark[count].surface_boundary = block.surface_boundary;

		block.npc_crystal = new Array(1);
		block.npc_crystal[0] = new NPCCrystal(core);
		block.npc_crystal[0].setPoint(100, 130);
		block.npc_crystal[0].state = StateTable.active;

		block.npc_coral = new Array(1);
		block.npc_coral[0] = new NPCCoral(core);
		block.npc_coral[0].setPoint(130, 130);
		block.npc_coral[0].state = StateTable.active;

		block.npc_fish = new Array(1);
		block.npc_fish[0] = new NPCFish(core);
		
		block.npc_fish[0].setPoint(130, 190);
		block.npc_fish[0].state = StateTable.suspend;
		block.npc_fish[0].surface_boundary = block.surface_boundary;

		block.npc_consumable = new Array(1);
		block.npc_consumable[0] = new NPCConsumable(core);
		block.npc_consumable[0].setPoint(160, 130);
		block.npc_consumable[0].state = StateTable.active;

		block.npc_lobster = new Array(2);
		block.npc_lobster[0] = new NPCLobster(core);
		block.npc_lobster[0].setPoint(40, 190);
		block.npc_lobster[0].direction = DirectionTable.right;
		block.npc_lobster[0].state = StateTable.suspend;

		block.npc_lobster[1] = new NPCLobster(core);
		block.npc_lobster[1].setPoint(40, 210);
		block.npc_lobster[1].direction = DirectionTable.right;
		block.npc_lobster[1].state = StateTable.suspend;

		return block;
	}

	public function getBlock002():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 320; block.y = 0;
		block.background = handle[1];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text, 1);

		block.boundary[block.boundary.length-1] = new Rectangle(320, 75, 320, 1);
		block.surface_boundary = block.boundary[block.boundary.length-1];

		return block;
	}

	public function getBlock003():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 640; block.y = 0;
		block.background = handle[2];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock004():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 960; block.y = 0;
		block.background = handle[3];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock005():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 0; block.y = 240;
		block.background = handle[4];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock006():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 320; block.y = 240;
		block.background = handle[5];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock007():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 640; block.y = 240;
		block.background = handle[6];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock008():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 960; block.y = 240;
		block.background = handle[7];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}


	public function getBlock009():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 0; block.y = 480;
		block.background = handle[8];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock010():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 320; block.y = 480;
		block.background = handle[9];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock011():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 640; block.y = 480;
		block.background = handle[10];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock012():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 960; block.y = 480;
		block.background = handle[11];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock013():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 0; block.y = 720;
		block.background = handle[12];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock014():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 320; block.y = 720;
		block.background = handle[13];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock015():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 640; block.y = 720;
		block.background = handle[14];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock016():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 960; block.y = 720;
		block.background = handle[15];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock017():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 0; block.y = 960;
		block.background = handle[16];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock018():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 320; block.y = 960;
		block.background = handle[17];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock019():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 640; block.y = 960;
		block.background = handle[18];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function getBlock020():LevelBlock {

		var block:LevelBlock = new LevelBlock(core);

		block.x = 960; block.y = 960;
		block.background = handle[19];

		var text:String;		
		//      1234567890ABCDEF
		text = "X000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";

		block.setBoundary(text);
		return block;
	}

	public function loaderComplete(event:Event):void {

		handle[index] = Bitmap(bitmapLoader.content).bitmapData;
		index++; return;
	}

	public function soundLoaderComplete(event:Event):void {

		soundtrack_index++; return;
	}
}}
