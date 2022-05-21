
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class ProjectileBubble {
 
	public var core:Core;
	public var StateTable:Object;

	public var state:int;
	public var x:int, y:int;
	public var width:uint, height:uint;
	public var index:uint;
	public var velocity:uint;

	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;
	public var current:Rectangle;
	public var restricted_boundary:Rectangle;

	public var delay_flip:Object;
	public var delay_blink:Object;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		restricted_boundary.x = x+(width-restricted_boundary.width)/2;
		restricted_boundary.y = y+(height-restricted_boundary.height)/2;

		return;
	}

	public function ProjectileBubble(source:Core):void {

		core = source;
		StateTable = core.StateTable;

		x = 0; y = 0; width = 24; height = 24;
		index = 11; velocity = 1;

		current = new Rectangle(0, 0, width, height);
		boundary_width = 12; boundary_height = 12;

		current_boundary = new Rectangle(0, 0,
		boundary_width, boundary_height);
		restricted_boundary = new Rectangle(0, 0, 100, 100);

		delay_flip = core.getDelayable(0, 8);
		delay_blink = core.getDelayable(0, 4);
		state = StateTable.disabled;

		return;
	}

	public function Process():void {

		if (state == StateTable.disabled)
			return;

		if (core.updateDelayable(delay_flip) == true)
			return;
	
		if (index == 12) index = 11;
			else index = 12;

		y-= velocity; current.x = x; current.y = y;
		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		if (!core.inBound(restricted_boundary, current_boundary))
			state = StateTable.disabled;

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;
		if (core.updateDelayable(delay_blink) == true)
			return;

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(new Rectangle(x, y, 0, 0));

		core.display_manager.Draw(core.resource_projectile[index],
			relative.x, relative.y);

		return;
	}
}}
