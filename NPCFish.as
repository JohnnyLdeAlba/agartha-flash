
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class NPCFish extends Rectangle {

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

	public var index:uint, start_index:uint;
	public var velocity:uint;

	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;

	public var surface_boundary:Rectangle;
	public var suspend_boundary:Rectangle;
	public var evade_boundary:Rectangle;
	public var guard_boundary:Rectangle;
	
	public var delay_flip:Object;
	public var delay_hunt:Object;
	public var delay_move:Object;

	public var projectile_burstable:ProjectileBurstable;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		suspend_boundary.x = x+(width-suspend_boundary.width)/2;
		suspend_boundary.y = y+(height-suspend_boundary.height)/2;

		evade_boundary.x = x+(width-evade_boundary.width)/2;
		evade_boundary.y = y+(height-evade_boundary.height)/2;

		guard_boundary.x = x;
		guard_boundary.y = y;

		return;
	}

	public function NPCFish(source:Core):void {

		core = source;
		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;
		playable_dolphin = core.playable_dolphin;

		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;
		ResourceTable = core.resource_manager.ResourceTable;
		SoundTable = core.sound_manager.SoundTable;

		x = 0; y = 0; width = 24; height = 24;
		start_index = ResourceTable.fish_001; index = 1; velocity = 1;

		boundary_width = 12; boundary_height = 12;
		current_boundary = new Rectangle(0, 0, boundary_width,
			boundary_height);

		surface_boundary = new Rectangle(0, 0, 0, 0);
		suspend_boundary = new Rectangle(0, 0, 100, 100);
		evade_boundary = new Rectangle(0, 0, 100, 100);
		guard_boundary = new Rectangle(0, 0, 50, 50);

		delay_flip = core.getDelayable(0, 2);
		delay_move = core.getDelayable(0, 1);

		delay_hunt = core.getDelayable(0, 8);
		delay_hunt.count = delay_hunt.total;

		direction = DirectionTable.right;
		state = StateTable.disabled;

		setPoint(0, 0);
		return;
	}

	public function setIdentity(identity:String):void {

		switch (identity) { case 'reefshark': {

			start_index = 11; index = 14;
			break;
		}}

		return;
	}

	public function updateEvade():Boolean {

		if ((playable_dolphin.state == StateTable.disabled) &&
			(playable_dolphin.state == StateTable.burst))
				return false;

		if (!core.inBound(evade_boundary, playable_dolphin
			.current_boundary)) return false;

		if (x < playable_dolphin.current_boundary.x) {
		
			index = 0;
			direction = DirectionTable.left;
		}
		else if (x > playable_dolphin.current_boundary.x) {

			index = 1;
			direction = DirectionTable.right;
		}

		if (core.updateDelayable(delay_move) == true)
			return true;

		if (direction == DirectionTable.right) {

			x+= velocity+2;
			guard_boundary.x = x+guard_boundary.width;
		}
		else if (direction == DirectionTable.left) {

			x-= velocity+2;
			guard_boundary.x = x-guard_boundary.width;
		}

		if (y < playable_dolphin.current_boundary.y) {

			if (y > surface_boundary.y)
				y-= velocity;
			
			guard_boundary.y = y-guard_boundary.height;
		}
		else if (y > playable_dolphin.current_boundary.y) {

			y+= velocity;
			guard_boundary.y = y+guard_boundary.height;
		}

		return true;
	}

	public function updatePoint():void {

		if (core.updateDelayable(delay_move) == true)
			return;

		if (current_boundary.x+current_boundary.width >
			guard_boundary.x+guard_boundary.width) {
		if (!(direction == DirectionTable.left)) {

			index = 0;
			direction = DirectionTable.left;
		}}
		else if (current_boundary.x < guard_boundary.x) {
		if (!(direction == DirectionTable.right)) {

			index = 1;
			direction = DirectionTable.right;
		}}

		if (direction == DirectionTable.right)
			x+= velocity;
		else if (direction == DirectionTable.left)
			x-= velocity;

		return;
	}

	public function inBoundaryPlayable():void {

		if (state == StateTable.disabled)
			return;
		if (state == StateTable.burst)
			return;

		if (playable_dolphin.state == StateTable.disabled)
			return;
		if (playable_dolphin.state == StateTable.burst)
			return;
		if (playable_dolphin.state == StateTable.damage)
			return;

		if (core.inBound(current_boundary, playable_dolphin
			.current_boundary)) {
	
			if (playable_dolphin.health >= 6)
				return;

			playable_dolphin.health++;
			playable_dolphin.state = StateTable.collectable;
			playable_dolphin.createBurstable();
			
			state = StateTable.disabled;
			sound_manager.play(SoundTable.bubble_001);
		}

		return;
	}

	public function Process():void {

		if (state == StateTable.disabled)
			return;

		if (updateEvade() == false)
			updatePoint();

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		suspend_boundary.x = x+(width-suspend_boundary.width)/2;
		suspend_boundary.y = y+(height-suspend_boundary.height)/2;

		evade_boundary.x = x+(width-evade_boundary.width)/2;
		evade_boundary.y = y+(height-evade_boundary.height)/2;

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(Rectangle(this));

		core.display_manager.Draw(resource_manager.handle[start_index+index],
			relative.x, relative.y);

		return;
	}
}}
