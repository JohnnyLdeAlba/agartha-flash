
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class ProjectileBurstable {

	public var core:Core;
	public var StateTable:Object;

	public var state:int;
	public var x:int, y:int;
	public var width:uint, height:uint;
	public var index:uint;

	public var delay_flip:Object;

	public function ProjectileBurstable(source:Core):void {

		core = source;
		StateTable = core.StateTable;

		x = 0; y = 0; width = 24;
		height = 24; index = 0;

		delay_flip = core.getDelayable(0, 5);
		state = StateTable.disabled;

		return;
	}

	public function updateFrame():void {

		if (state == StateTable.disabled)
			return;

		if (core.updateDelayable(delay_flip) == true)
			return;

		if (index >= 2) {

			index = 0;
			state = StateTable.disabled;
			return;
		}
	
		index++;
		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(new Rectangle(x, y, 0, 0));

		core.display_manager.Draw(core.resource_projectile[index],
			relative.x, relative.y);

		return;
	}
}}
