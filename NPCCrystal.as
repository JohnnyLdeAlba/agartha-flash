
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class NPCCrystal {
 
	public var core:Core;

	public var StateTable:Object;
	public var DirectionTable:Object;

	public var SoundTable:Object;
	public var ResourceTable:Object;

	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;
	public var playable_dolphin:PlayableDolphin;

	public var state:int;
	public var direction:int;
	public var text:Array;

	public var x:int, y:int;
	public var width:uint, height:uint;
	public var start_index:uint, primary_index:uint;
	public var secondary_index:uint;

	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;

	public var current:Rectangle;
	public var current_hologram:Rectangle;

	public var delay_hologram:Object;
	public var delay_blink:Object;

	public var projectile_burstable:ProjectileBurstable;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		setDirection(DirectionTable.right);
		return;
	}

	public function setDirection(direction:int):void {

		this.direction = direction;

		if (direction == DirectionTable.left) {

			primary_index = 0;
			current_hologram.x = x-current_hologram.width;
			
		} else {

			primary_index = 1;
			current_hologram.x = x+width;
		}

		current_hologram.y = y+(height-current_hologram.height)/2;
		return;
	}

	public function NPCCrystal(source:Core):void {

		core = source;

		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;
		playable_dolphin = core.playable_dolphin;

		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;

		SoundTable = core.sound_manager.SoundTable;
		ResourceTable = core.resource_manager.ResourceTable;

		x = 0; y = 0; width = 24; height = 24;
		start_index = ResourceTable.hercules_001; primary_index = 1;
		secondary_index = ResourceTable.crystal_001;

		current = new Rectangle(0, 0, width, height);
		current_hologram = new Rectangle(0, 0, 48, 48);

		boundary_width = 12; boundary_height = 12;
		current_boundary = new Rectangle(0, 0, boundary_width,
			boundary_height);

		delay_hologram = core.getDelayable(0, 500);
		delay_blink = core.getDelayable(0, 2);

		text = null;
		direction = DirectionTable.right;
		state = StateTable.disabled;

		setPoint(0, 0);
		return;
	}

	public function setIdentity(identity:String):void {

		switch (identity) { case 'nalia': {

			start_index = 0; primary_index = 0;
			secondary_index = 0;
			break;
		}}

		return;
	}

	public function inBoundarySonar():void {

		if (state == StateTable.disabled)
			return;

		for (var count:uint = 0; count < playable_dolphin
			.projectile_sonar.length; count++) {
		if (playable_dolphin.projectile_sonar[count]
			.state == StateTable.active) {

		if (core.inBound(current_boundary, playable_dolphin
			.projectile_sonar[count].current_boundary)) {

			playable_dolphin.projectile_sonar[count]
			.state = StateTable.disabled;
			sound_manager.play(SoundTable.crystal_001);

			if (state == StateTable.hologram) return;
			if (text == null) return;

			state = StateTable.hologram;
			core.hud_manager.dispatchMessage(text);
		}}}

		return;
	}

	public function Update():void {

		if (state == StateTable.disabled)
			return;
		if (state == StateTable.hologram) {

			if (core.updateDelayable(delay_hologram) == false)
				state = StateTable.active;
		}

		return;
	}

	public function drawHologram():void {

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(current_hologram);

		core.display_manager.Draw(resource_manager.handle[start_index+primary_index],
			relative.x, relative.y);

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;
		if (state == StateTable.hologram) {

			if (core.updateDelayable(delay_blink) == true)
				drawHologram();

		}

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(current);

		core.display_manager.Draw(resource_manager.handle[secondary_index],
			relative.x, relative.y);

		return;
	}
}}
