package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.ui.*;

public class Level001 {

	private var parallax001:BitmapData;

	public var core:Core;
	public var StateTable:Object;

	public var sound_manager:SoundManager;
	public var playable_dolphin:PlayableDolphin;

	public var display_manager:DisplayManager;
	public var viewport_manager:ViewportManager;
	public var npc_manager:NPCManager;
	public var hud_manager:HUDManager;
	
	public var state:uint;
	public var block:Array;
	public var quadrant:Array;
	public var parallax:BitmapData;
	public var delay_respawn:Object;

	public var soundtrack:Sound;
	public var soundchannel:SoundChannel;

	public var resource:ResourceLevel001;

	public function Level001(source:Core):void {
	
		core = source;
		StateTable = core.StateTable;

		sound_manager = core.sound_manager;
		playable_dolphin = core.playable_dolphin;

		playable_dolphin.health = 6;
		playable_dolphin.air = 3;

		display_manager = core.display_manager;
		viewport_manager = core.viewport_manager;
		hud_manager = core.hud_manager;
		
		block = null;
		quadrant = new Array(4);
		for (var count:uint = 0; count < quadrant.length; count++)
			quadrant[count] = null;
		delay_respawn = core.getDelayable(0, 80);

		npc_manager = new NPCManager(core);
		resource = new ResourceLevel001(core);
		resource.getSoundTrack();

		core.level900.setBackground(0);
		state = StateTable.disabled;

		return;
	}

	public function Loading():void {

		core.level900.current = resource.index;
		core.level900.total = resource.total;

		if (core.level900.current >= core.level900.total){

			state = StateTable.dispatch;

			core.level900.Destroy();
			return;
		}

		if (resource.index < resource.total)
			resource.getResource();

		core.level900.Process();
		return;
	}

	public function Dispatch():void {

		viewport_manager.setWorldSize(1280, 1200);
		viewport_manager.setPoint(0, 0);
		playable_dolphin.setPoint(50, 115);
		
		soundtrack = resource.soundtrack;
		soundchannel = soundtrack.play();
		soundchannel.addEventListener(Event.SOUND_COMPLETE,
			soundComplete);

		block = new Array(20);
		block[0] = resource.getBlock001();
		block[1] = resource.getBlock002();
		block[2] = resource.getBlock003();
		block[3] = resource.getBlock004();

		block[4] = resource.getBlock005();
		block[5] = resource.getBlock006();
		block[6] = resource.getBlock007();
		block[7] = resource.getBlock008();

		block[8] = resource.getBlock009();
		block[9] = resource.getBlock010();
		block[10] = resource.getBlock011();
		block[11] = resource.getBlock012();

		block[12] = resource.getBlock013();
		block[13] = resource.getBlock014();
		block[14] = resource.getBlock015();
		block[15] = resource.getBlock016();

		block[16] = resource.getBlock017();
		block[17] = resource.getBlock018();
		block[18] = resource.getBlock019();
		block[19] = resource.getBlock020();
		
		parallax = resource.getParallax();
		var text:Array = new Array(3);

		text[0] = "HALF MOON BAY";

		text[1] = "\nCONTROLS \n\n";
		text[1]+= "W > UP, A > LEFT, S > DOWN,\nD > RIGHT,";
		text[1]+= "\n\nI > INVENTORY, J > SONAR,\nK > TOGGLE ITEM, L > USE ITEM.";

		text[2] = "A SECLUDED BEACH WITH WARM WATER,\nTEAMING WITH LIFE AND RESOURCES";
		text[2]+= "\nFOR A SMALL POD. THE WATER IS\nCRYSTAL CLEAR WITH CORAL,";
		text[2]+= "SPONGES\nAND EXOTIC FISH OF VARIOUS\nCOLORS.\n\nTHE ONLY DANGERS";
		text[2]+= " LURKING ABOUT\nARE SHARKS AND JELLYFISH.";

		core.hud_manager.dispatchMessage(text);
		state = StateTable.active;

		getQuadrant();
		npc_manager.dispatchQuadrant(quadrant);
		return;
	}

	public function Destroy():void {

		soundchannel.stop();
		soundchannel.removeEventListener(Event.SOUND_COMPLETE,
			soundComplete);

		return;
	}

	public function playableRespawn():void {

		if (!(playable_dolphin.state == StateTable.disabled))
			return;
		if (playable_dolphin.health > 0)
			return;

		if (core.updateDelayable(delay_respawn) == true)
			return;

		playable_dolphin.health = 6;
		playable_dolphin.air = 3;
		playable_dolphin.state = StateTable.active;

		viewport_manager.setPoint(0, 0);
		playable_dolphin.setPoint(50, 120);

		soundchannel.stop();
		soundchannel.removeEventListener(Event.SOUND_COMPLETE,
			soundComplete);

		soundchannel = soundtrack.play();
		soundchannel.addEventListener(Event.SOUND_COMPLETE,
			soundComplete);

		getQuadrant();
		npc_manager.dispatchQuadrant(quadrant);
		return;
	}

	public function getQuadrant():void {

		var count:uint = 0, index:uint = 0;

		for (count = 0; count < quadrant.length; count++)
			quadrant[count] = null;
		for (count = 0; count < block.length; count++) {

		if (index > quadrant.length)
			break;

		if (core.inBound(Rectangle(viewport_manager),
			Rectangle(block[count]))) {

			quadrant[index] = block[count];
			index++;
		}}

		return;
	}

	public function inBoundary():void {

		if (playable_dolphin.state == StateTable.disabled)
			return;
		if (playable_dolphin.state == StateTable.burst)
			return;

		for (var count:uint = 0; count < quadrant.length; count++)
			if (!(quadrant[count] == null)) quadrant[count]
				.inBoundary();
		return;
	}

	public function processSurface():void {

		for (var count:uint = 0; count < quadrant.length; count++)
			if (!(quadrant[count] == null)) quadrant[count]
				.processSurface();
		return;
	}

	public function drawParallax():void {

		// (world.w/320)-((parallax.w-320)/320)
		core.display_manager.Draw(parallax, 0, viewport_manager.y/-4);
		return;
	}

	public function drawSurface():void {

		for (var count:uint = 0; count < quadrant.length; count++)
			if (!(quadrant[count] == null)) quadrant[count]
				.drawSurface();
		return;
	}

	public function drawBackground():void {

		for (var count:uint = 0; count < quadrant.length; count++)
			if (!(quadrant[count] == null)) quadrant[count]
				.drawBackground();
		return;
	}

	public function drawBoundary():void {

		for (var count:uint = 0; count < quadrant.length; count++)
			if (!(quadrant[count] == null)) quadrant[count]
				.drawBoundary();
		return;
	}

	public function Process():void {

		switch (state) { case StateTable.disabled: {
			Loading(); return;
		}

		case StateTable.dispatch: {
			Dispatch(); return;
		}}

		getQuadrant();
		npc_manager.processQuadrant(quadrant);

		hud_manager.Process();
		playableRespawn();

		playable_dolphin.Process();
		npc_manager.Process();
		processSurface();
		inBoundary();

		playable_dolphin.Update();
		viewport_manager.Update();

		Draw();
		return;
	}

	public function Draw():void {

		drawParallax();
		drawSurface();
		drawBackground();

		npc_manager.Draw();
		playable_dolphin.Draw();

		// drawBoundary();
		hud_manager.Draw();
		
		display_manager.Flip();
		return;
	}

	public function soundComplete(event:Event):void {

		soundchannel = soundtrack.play();
		soundchannel.addEventListener(Event.SOUND_COMPLETE,
			soundComplete);

		return;
	}
}}
