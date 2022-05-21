
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class NPCConsumable {

	public var id:int;
	public var core:Core;

	public var StateTable:Object;
	public var DirectionTable:Object;
	public var ResourceTable:Object;
	public var SoundTable:Object;
	public var ConsumableTable:Object;

	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;
	public var playable_dolphin:PlayableDolphin;

	public var state:int;
	public var direction:int;

	public var x:int, y:int;
	public var width:uint, height:uint;
	public var index:uint;
	public var velocity:uint;

	public var origin:Rectangle, current:Rectangle;
	public var restricted_boundary:Rectangle;

	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;

	public var delay_flip:Object;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;
		origin.x = x; origin.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		restricted_boundary.x = x+(width-restricted_boundary.width)/2;
		restricted_boundary.y = y+(height-restricted_boundary.height)/2;

		return;
	}

	public function NPCConsumable(source:Core):void {

		core = source;
		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;
		playable_dolphin = core.playable_dolphin;

		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;
		ConsumableTable = core.ConsumableTable;
		SoundTable = core.sound_manager.SoundTable;
		ResourceTable = core.resource_manager.ResourceTable;

		id = ConsumableTable.airjar
		x = 0; y = 0; width = 24; height = 24;
		index = ResourceTable.consumable_airjar; velocity = 1;

		origin = new Rectangle(0, 0, width, height);
		current = new Rectangle(0, 0, width, height);

		boundary_width = 12; boundary_height = 12;
		current_boundary = new Rectangle(0, 0, boundary_width,
			boundary_height);
		restricted_boundary = new Rectangle(0, 0, 16, 16);

		delay_flip = core.getDelayable(0, 8);
		direction = DirectionTable.up;

		state = StateTable.disabled;
		setPoint(0, 0);
		return;
	}

	public function setIdentity(identity:String):void {

		switch (identity) { case 'shield': {

			index = ResourceTable.consumable_shield;
			break;
		}}

		return;
	}

	public function updatePoint():void {

		if (core.updateDelayable(delay_flip) == true)
			return;

		if (current_boundary.y+current_boundary.height >
			restricted_boundary.y+restricted_boundary.height)
				direction = DirectionTable.up;
		else if (current_boundary.y < restricted_boundary.y)
			direction = DirectionTable.down;

		if (direction == DirectionTable.up)
			y-= velocity;
		else if (direction == DirectionTable.down)
			y+= velocity;

		return;
	}

	public function inBoundaryPlayable():void {

		if (state == StateTable.disabled)
			return;

		if (core.inBound(current_boundary, playable_dolphin.current_boundary)) {

			playable_dolphin.state = StateTable.collectable;
			playable_dolphin.createBurstable();

			core.hud_manager.inventory[id]++;
			state = StateTable.disabled;
			sound_manager.play(SoundTable.bubble_001);
		}

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

		}}}

		return;
	}
	public function Update():void {

		if (state == StateTable.disabled)
			return;

		updatePoint();

		current.x = x; current.y = y;
		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(current);

		core.display_manager.Draw(resource_manager
		.handle[index],
			relative.x, relative.y);

		return;
	}
}}
