
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class ProjectileLaser {
 
	public var core:Core;
	public var StateTable:Object;
	public var DirectionTable:Object;

	public var state:int;
	public var direction:int;

	public var x:int, y:int;
	public var width:uint, height:uint;
	public var previous_index:uint, index:uint;
	public var velocity:uint;

	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;
	public var current:Rectangle;

	public var delay_flip:Object;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		return;
	}

	public function ProjectileLaser(source:Core):void {

		core = source;
		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;

		x = 0; y = 0; width = 48; height = 48;
		index = 0; velocity = 10;

		current = new Rectangle(0, 0, width, height);
		boundary_width = 12; boundary_height = 12;

		current_boundary = new Rectangle(0, 0,
		boundary_width, boundary_height);

		delay_flip = core.getDelayable(0, 2);
		state = StateTable.disabled;
		direction = DirectionTable.none;

		return;
	}

	public function setDirection(direction:int):void {

		this.direction = direction;

		switch (this.direction) { 

		case DirectionTable.left: {
		index = 13; break; }

		case DirectionTable.right: {
		index = 14; break; }

		case DirectionTable.up: {
		index = 15; break; }

		case DirectionTable.down: {
		index = 16; break; }}

		previous_index = index;
		return;
	}

	public function Process():void {

		if (state == StateTable.disabled)
			return;

		switch (direction) { case DirectionTable.left: {
		x-= velocity; break; }

		case DirectionTable.right: {
		x+= velocity; break; }

		case DirectionTable.up: {
		y-= velocity; break; }

		case DirectionTable.down: {
		y+= velocity; break; }}

		current.x = x; current.y = y;
		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		if (!core.inBound(new Rectangle(core.viewport_manager.x, core.viewport_manager.y,
			core.viewport_manager.width, core.viewport_manager.height), current))
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

		core.display_manager.Draw(core.resource_projectile[index],
			relative.x, relative.y);

		return;
	}
}}
