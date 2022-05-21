
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class ProjectileBomb {
 
	public var core:Core;
	public var resource_manager:ResourceManager;

	public var StateTable:Object;
	public var DirectionTable:Object;
	public var ResourceTable:Object;
	public var SoundTable:Object;

	public var state:int;
	public var direction:int;

	public var identity:String;
	public var x:int, y:int;
	public var width:uint, height:uint;
	public var index:uint;

	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;
	public var current:Rectangle;

	public var delay_burst:Object;
	public var projectile_burstable:ProjectileBurstable;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;

		current_boundary.x = x;
		current_boundary.y = y;

		return;
	}

	public function ProjectileBomb(source:Core):void {

		core = source;
		resource_manager = core.resource_manager;

		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;
		ResourceTable = core.resource_manager.ResourceTable;
		SoundTable = core.sound_manager.SoundTable;

		x = 0; y = 0; width = 24; height = 24;
		identity = 'bomb'; index = ResourceTable.consumable_bomb;

		current = new Rectangle(0, 0, width, height);
		boundary_width = 24; boundary_height = 24;

		current_boundary = new Rectangle(0, 0,
		boundary_width, boundary_height);

		delay_burst = core.getDelayable(0, 60);
		projectile_burstable = new ProjectileBurstable(core);

		state = StateTable.disabled;
		direction = DirectionTable.none;
		return;
	}

	public function setIdentity(identity:String):void {

		this.identity = identity;
		if (identity == 'megabomb')
			index = ResourceTable.consumable_megabomb;
		return;
	}

	public function Process():void {

		if (state == StateTable.disabled)
			return;

		if (state == StateTable.burst) {

			if (projectile_burstable.state == StateTable.disabled) {
				state = StateTable.disabled;
				return;
			}

			projectile_burstable.updateFrame();
			return;
		}

		if (core.updateDelayable(delay_burst) == false) {
			
			state = StateTable.burst;

			projectile_burstable.state = StateTable.active;
			projectile_burstable.x = x+(width-projectile_burstable.width)/2;
			projectile_burstable.y = y+(height-projectile_burstable.height)/2;

			core.sound_manager.play(SoundTable.burst_001);
		}

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;

		if (state == StateTable.burst) {

			projectile_burstable.Draw();
			return;
		}

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(new Rectangle(x, y, current_boundary.width-1,
				current_boundary.height-1));

		if (!(identity == 'megabomb'))
			core.display_manager.drawRect(relative, 0xFF0000);

		core.display_manager.Draw(resource_manager.handle[index],
			relative.x, relative.y);
		return;
	}
}}
