package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.ui.*;

public class LevelBlock extends Rectangle {

	public var core:Core;
	public var StateTable:Object;
	public var ResourceTable:Object;

	public var playable_dolphin:PlayableDolphin;
	public var boundary:Array;

	public var surface_index:uint;
	public var surface_boundary:Rectangle;
	public var delay_surface:Object;

	public var background:BitmapData;

	public var npc_jellyfish:Array;
	public var npc_shark:Array;
	public var npc_lobster:Array;

	public var npc_fish:Array;
	public var npc_crystal:Array;
	public var npc_coral:Array;
	public var npc_consumable:Array;

	public function LevelBlock(source:Core):void {

		core = source;
		playable_dolphin = core.playable_dolphin;

		StateTable = core.StateTable;
		ResourceTable = core.resource_manager.ResourceTable;
	
		boundary = null;
		background = null;

		npc_jellyfish = null;
		npc_shark = null;

		npc_fish = null;
		npc_crystal = null;
		npc_coral = null;

		x = 0; y = 0;
		width = 320; height = 240;
		
		surface_index = ResourceTable.surface_001;
		surface_boundary = null;
		delay_surface = core.getDelayable(0, 30);

		return;
	}

	public function setBoundary(text:String, additional:uint = 0):void {

		/*      1234567890ABCDEF
		text = "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000";
		text+= "0000000000000000"; */

		var total:uint = 0;
		var index:uint = 0, count:uint = 0;

		for (index = 0; index < text.length; index++)
			if (text.charAt(index) == 'X') total++;

		boundary = new Array(total+additional);
		var column:uint = 0, row:uint = 0;

		for (index = 0; index < text.length; index++) {
			if (text.charAt(index) == 'X') {

			column = uint(index/16); row = index-(column*16);
			boundary[count] = new Rectangle(row*20+x,
				column*20+y, 20, 20);

			count++;
		}}

		return;
	}

	public function inBoundary():void {

		var current_quadrant:Rectangle = new Rectangle(uint(boundary[0].x/320)*320,
			uint(boundary[0].y/240)*240, 320, 240);

		if (core.inBound(playable_dolphin.current, current_quadrant) == false)
			return;

		if (!(surface_boundary == null)) {
			if (core.inBound(playable_dolphin
				.next_boundary, surface_boundary)) {

			if (playable_dolphin.air <= 0) {

				playable_dolphin.air = 3;

				playable_dolphin.state = StateTable.collectable;
				playable_dolphin.createBurstable();
				core.sound_manager.play(8);
			}
		}}

		for (var count:uint = 0; count < boundary.length; count++) {

			if (core.inBoundX(playable_dolphin.current_boundary,
				playable_dolphin.next_boundary, boundary[count]))
				playable_dolphin.boundary_x = true;

			if (core.inBoundY(playable_dolphin.current_boundary,
				playable_dolphin.next_boundary, boundary[count]))
				playable_dolphin.boundary_y = true;

			if ((playable_dolphin.boundary_x == true) &&
				(playable_dolphin.boundary_y == true))
					return;
		}

		return;
	}

	public function drawBoundary():void {

		var current:Rectangle = new Rectangle(x, y, width-1, height-1);
		if (core.inBound(playable_dolphin.current, current) == false)
			return;

		var relative:Rectangle	= core.viewport_manager.TranslateToViewport(current);
		core.display_manager.drawRect(relative, 0X00FF00);

		for (var count:uint = 0; count < boundary.length; count++) {

			relative = core.viewport_manager.TranslateToViewport(boundary[count]);
			core.display_manager.drawRect(relative, 0xFF0000);
		}

		return;
	}

	public function inBoundarySonar():void {

		var count:uint = 0;

		if (!(npc_crystal == null))
		for (count = 0; count < npc_crystal.length; count++)
			npc_crystal[count].inBoundarySonar();

		if (!(npc_coral == null))
		for (count = 0; count < npc_coral.length; count++)
			npc_coral[count].inBoundarySonar();

		return;
	}

	public function processSurface():void {

		if (surface_boundary == null) return;

		if (core.updateDelayable(delay_surface) == false) {

			if (surface_index == ResourceTable.surface_001)
				surface_index = ResourceTable.surface_002;
			else surface_index = ResourceTable.surface_001;
		}

		return;
	}

	public function drawSurface():void {

		if (surface_boundary == null) return;

		var relative:Rectangle = core.viewport_manager
		.TranslateToViewport(new Rectangle(surface_boundary.x, surface_boundary.y,
			surface_boundary.width, surface_boundary.height));

		core.display_manager.Draw(core.resource_manager.handle[surface_index],
			relative.x, relative.y);
		return;
	}

	public function drawBackground():void {

		if (background == null) return;

		var relative:Rectangle = core.viewport_manager
		.TranslateToViewport(new Rectangle(x, y, width, height));

		core.display_manager.Draw(background,
			relative.x, relative.y);
		return;
	}
}}
