
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class ProjectilePhoton {
 
	public var core:Core;

	public var StateTable:Object;
	public var SoundTable:Object;
	public var DirectionTable:Object;
	public var ResourceTable:Object;

	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;

	public var state:int;
	public var direction:int;

	public var flag_standby:Boolean;
	public var x:int, y:int;
	public var width:uint, height:uint;
	public var previous_index:uint, index:uint;
	public var velocity:uint;

	public var target:Rectangle;
	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;
	public var current:Rectangle;

	public var projectile_burstable:ProjectileBurstable;
	public var delay_flip:Object;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		return;
	}

	public function ProjectilePhoton(source:Core):void {

		core = source;
		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;

		SoundTable = core.sound_manager.SoundTable;
		ResourceTable = core.resource_manager.ResourceTable;

		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;

		flag_standby = false;
		x = 0; y = 0; width = 24; height = 24;
		index = ResourceTable.photon_001; velocity = 1;

		current = new Rectangle(0, 0, width, height);
		boundary_width = 6; boundary_height = 6;

		current_boundary = new Rectangle(0, 0,
		boundary_width, boundary_height);

		target = new Rectangle(0, 0, 0, 0);

		projectile_burstable = new ProjectileBurstable(core);
		delay_flip = core.getDelayable(0, 2);

		state = StateTable.disabled;
		direction = DirectionTable.none;

		return;
	}

	public function setDirection(direction:int):void {

		this.direction = direction;
		return;
	}

	public function setIdentity(identity:String):void {

		switch (identity) { case 'blue': {

			index = ResourceTable.photon_002;
			break;
		}}

		return;
	}

	public function createBurstable():void {

		projectile_burstable.state = StateTable.active;
		projectile_burstable.x = x+(width-projectile_burstable.width)/2;
		projectile_burstable.y = y+(height-projectile_burstable.height)/2;
		sound_manager.play(SoundTable.burst_001)

		return;
	}

	public function Process():void {

		if (state == StateTable.disabled)
			return;

		if (state == StateTable.standby) {

			if (flag_standby == true) {

				flag_standby = false;
				state = StateTable.disabled;
				return;
			}

			if (flag_standby == false)
				flag_standby = true;
			return;
		}

		if (state == StateTable.burst) {

			if (projectile_burstable.state == StateTable.disabled) {
				state = StateTable.disabled;
				return;
			}

			projectile_burstable.updateFrame();
			return;
		}

		if (current_boundary.x > target.x) x-= velocity;
		else if (current_boundary.x < target.x) x+= velocity;

		if (current_boundary.y > target.y) y-= velocity;
		else if (current_boundary.y < target.y) y+= velocity;

		current.x = x; current.y = y;
		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		if (core.inBound(target, current_boundary)) {

			createBurstable();
			state = StateTable.burst;

			return;
		}

		if (!core.inBound(Rectangle(core.viewport_manager), current))
			state = StateTable.disabled;

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;
		if (state == StateTable.standby)
			return;

		if (state == StateTable.burst) {

			projectile_burstable.Draw();
			return;
		}

		if (core.updateDelayable(delay_flip) == false)
			return;

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(new Rectangle(x, y, 0, 0));

		core.display_manager.Draw(resource_manager.handle[index],
			relative.x, relative.y);
		return;
	}
}}
