
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class ProjectileShield {

	public var core:Core;

	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;

	public var StateTable:Object;
	public var SoundTable:Object;
	public var ResourceTable:Object;

	public var state:int;
	public var flag_healthbar:Boolean;

	public var health:int, total_health:int;
	public var x:int, y:int;
	public var width:uint, height:uint;
	public var index:uint;

	public var delay_flip:Object;
	public var delay_shield:Object;

	public var delay_blink:Object;
	public var delay_damage:Object;
	public var delay_healthbar:Object;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		return;
	}

	public function ProjectileShield(source:Core):void {

		core = source;

		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;

		StateTable = core.StateTable;
		ResourceTable = core.resource_manager.ResourceTable;
		SoundTable = core.sound_manager.SoundTable;

		flag_healthbar = false;
		health = 10; total_health = 10;
		delay_healthbar = core.getDelayable(0, 100);

		x = 0; y = 0; width = 48;
		height = 48; index = 17;

		delay_flip = core.getDelayable(0, 8);
		delay_shield = core.getDelayable(0, 2);

		delay_blink = core.getDelayable(0, 8);
		delay_damage = core.getDelayable(0, 60);
		state = StateTable.disabled;

		return;
	}

	public function setHealth(count:int):void {

		if (state == StateTable.damage)
			return;

		health+= count;
		if (health > 0) {

			state = StateTable.damage;

			flag_healthbar = true;
			delay_healthbar.count = 0;

			sound_manager.play(SoundTable.damage_002);
			return;
		} else health = 0;

		sound_manager.play(SoundTable.cast_002);
		state = StateTable.disabled;
		return;
	}

	public function updateFrame():void {

		if (state == StateTable.disabled)
			return;

		if (state == StateTable.damage)
		if (core.updateDelayable(delay_damage) == false)
			state = StateTable.active;

		if (flag_healthbar == true) {

			if (core.updateDelayable(delay_healthbar) == false)
				flag_healthbar = false;
		}

		if (core.updateDelayable(delay_flip) == true)
			return;
		if (index >= 18) { index = 17; return; }
	
		index++;
		return;
	}

	public function drawHealthBar():void {

		if (flag_healthbar == false)
			return;

		var index:uint = 6*(health/total_health);
		index = uint(index);

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(new Rectangle(x, y, width, height));

		core.display_manager.Draw(resource_manager
		.handle[ResourceTable.targethealth_001+index],
			relative.x+(relative.width-48)/2, relative.y-24);

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;

		if (state == StateTable.damage) {

		if (core.updateDelayable(delay_blink) == true) {

			drawHealthBar();
			return;
		}}

		drawHealthBar();

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(new Rectangle(x, y, 0, 0));

		if (core.updateDelayable(delay_shield) == true)
			core.display_manager.Draw(core.resource_projectile[19],
				relative.x, relative.y);

		core.display_manager.Draw(core.resource_projectile[index],
			relative.x, relative.y);

		return;
	}
}}
