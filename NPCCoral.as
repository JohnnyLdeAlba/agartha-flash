
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class NPCCoral {
 
	public var core:Core;
	public var StateTable:Object;
	public var SoundTable:Object;
	public var ResourceTable:Object;

	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;
	public var playable_dolphin:PlayableDolphin;

	public var state:int;
	public var x:int, y:int;
	public var width:uint, height:uint;
	public var index:uint;

	public var current:Rectangle;
	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;
	
	public var projectile_bubble:ProjectileBubble;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		return;
	}

	public function NPCCoral(source:Core):void {

		core = source;

		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;
		playable_dolphin = core.playable_dolphin;

		StateTable = core.StateTable;
		ResourceTable = core.resource_manager.ResourceTable;
		SoundTable = core.sound_manager.SoundTable;

		x = 0; y = 0; width = 24; height = 24;
		index = ResourceTable.coral_002;

		current = new Rectangle(0, 0, width, height);
		boundary_width = 12; boundary_height = 12;
		current_boundary = new Rectangle(0, 0, boundary_width,
			boundary_height);

		state = StateTable.disabled;
		projectile_bubble = new ProjectileBubble(core);

		setPoint(0, 0);
		return;
	}

	public function setIdentity(identity:String):void {

		switch (identity) { case 'orange': {
			index = ResourceTable.coral_001; break; }}

		return;
	}

	public function inBoundaryPlayable():void {

		if (state == StateTable.disabled)
			return;
		if (projectile_bubble.state == StateTable.disabled)
			return;

		if (core.inBound(projectile_bubble.current_boundary,
			playable_dolphin.current_boundary)) {

			playable_dolphin.air = 3;
			projectile_bubble.state = StateTable.disabled;

			playable_dolphin.state = StateTable.collectable;
			playable_dolphin.createBurstable();
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

			if (projectile_bubble.state == StateTable.disabled) 
				if (playable_dolphin.air <= 0) {

				projectile_bubble.state = StateTable.active;
				projectile_bubble.setPoint(x+(width-projectile_bubble.width)/2,
					y+(height-projectile_bubble.height)/2);

				sound_manager.play(SoundTable.glob_001);
			}
		}}}

		return;
	}

	public function Update():void {

		if (state == StateTable.disabled)
			return;

		projectile_bubble.Process();
		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;

		projectile_bubble.Draw();

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(current);

		core.display_manager.Draw(resource_manager.handle[index],
			relative.x, relative.y);

		return;
	}
}}
