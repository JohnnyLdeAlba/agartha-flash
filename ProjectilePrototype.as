
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class ProjectilePrototype {
 
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
	public var velocity_x:int, velocity_y:int;

	public var target:Rectangle;
	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;
	public var current:Rectangle;

	public var projectile_burstable:ProjectileBurstable;
	public var delay_flip:Object;
	public var delay_velocity:Object;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		return;
	}

	public function ProjectilePrototype(source:Core):void {

		core = source;
		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;

		SoundTable = core.sound_manager.SoundTable;
		ResourceTable = core.resource_manager.ResourceTable;

		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;

		flag_standby = false;
		x = 0; y = 0; width = 24; height = 24;
		index = 0; velocity_x = 1; velocity_y = 1;

		current = new Rectangle(0, 0, width, height);
		boundary_width = width; boundary_height = height;

		current_boundary = new Rectangle(0, 0,
		boundary_width, boundary_height);

		target = new Rectangle(0, 0, 0, 0);

		projectile_burstable = new ProjectileBurstable(core);
		delay_flip = core.getDelayable(0, 2);
		delay_velocity = core.getDelayable(0, 2);

		state = StateTable.disabled;
		direction = DirectionTable.none;

		return;
	}

	public function setDirection(direction:int):void {

		this.direction = direction;
		return;
	}

	public function UpdatePoint():void {

		if ((direction == DirectionTable.left) ||
			(direction == DirectionTable.right)) {

			x+= velocity_x;
			if (core.updateDelayable(delay_velocity) == false)
				y+= velocity_y;

			return;
		}

		y+= velocity_y;
		if (core.updateDelayable(delay_velocity) == false)
			x+= velocity_x;

		return;
	}

	public function Process():void {

		if (state == StateTable.disabled)
			return;

		UpdatePoint();

		current.x = x; current.y = y;
		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		if (!core.inBound(Rectangle(core.viewport_manager), current))
			state = StateTable.disabled;

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;

		if (core.updateDelayable(delay_flip) == false)
			return;

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(new Rectangle(x, y, 0, 0));

		core.display_manager.Draw(resource_manager.handle[ResourceTable.photon_001],
			relative.x, relative.y);
		return;
	}
}}
