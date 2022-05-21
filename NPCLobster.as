
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class NPCLobster {
 
	public var PhaseTable:Object = { none:0, recoiling:1, stunned:2 }

	public var core:Core;

	public var StateTable:Object;
	public var DirectionTable:Object;
	public var ProjectileTable:Object;
	public var SoundTable:Object;
	public var ResourceTable:Object;

	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;
	public var playable_dolphin:PlayableDolphin;

	public var state:int, phase:int;
	public var direction:int, recoiling_direction:int;

	public var flag_healthbar:Boolean;

	public var health:int, total_health:int;
	public var x:int, y:int;
	public var width:uint, height:uint;
	public var index:uint, start_index:uint;
	public var velocity:uint;

	public var current:Rectangle;
	public var recoiling_boundary:Rectangle;

	public var primary_boundary:Rectangle;
	public var secondary_boundary:Rectangle;

	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;

	public var delay_flip:Object;
	public var delay_healthbar:Object;

	public var delay_projectile:Object;
	public var delay_stunned:Object;
	public var delay_blink:Object;
	public var delay_damage:Object;

	public var projectile_burstable:ProjectileBurstable;
	public var projectile_photon:ProjectilePhoton;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		primary_boundary.x = x+(width-primary_boundary.width)/2;
		primary_boundary.y = y+(height-primary_boundary.height)/2;

		secondary_boundary.x = x;
		secondary_boundary.y = y;

		return;
	}

	public function NPCLobster(source:Core):void {

		core = source;

		resource_manager = core.resource_manager;
		sound_manager = core.sound_manager;
		playable_dolphin = core.playable_dolphin;

		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;
		ProjectileTable = core.ProjectileTable;

		ResourceTable = core.resource_manager.ResourceTable;
		SoundTable = core.sound_manager.SoundTable;

		flag_healthbar = false;
		health = 10; total_health = 10;
		x = 0; y = 0; width = 24; height = 24;
		start_index = ResourceTable.lobster_001; index = 0; velocity = 1;

		current = new Rectangle(0, 0, width, height);
		recoiling_boundary = new Rectangle(0, 0, width, height);

		boundary_width = 12; boundary_height = 12;
		current_boundary = new Rectangle(0, 0, boundary_width,
			boundary_height);

		primary_boundary = new Rectangle(0, 0, 100, 100);
		secondary_boundary = new Rectangle(0, 0, 100, 100);

		projectile_photon = new ProjectilePhoton(core);
		projectile_photon.setIdentity('blue');

		projectile_burstable = new ProjectileBurstable(core);

		delay_flip = core.getDelayable(0, 30);
		delay_healthbar = core.getDelayable(0, 100);
		delay_projectile = core.getDelayable(0, 100);
		delay_stunned = core.getDelayable(0, 30);
		delay_blink = core.getDelayable(0, 8);
		delay_damage = core.getDelayable(0, 60);

		direction = DirectionTable.left;
		recoiling_direction = DirectionTable.none;

		state = StateTable.disabled;
		phase = PhaseTable.none;

		setPoint(0, 0);
		return;
	}

	public function setIdentity(identity:String):void {

		switch (identity) { case 'lionsmane': {

			start_index = ResourceTable.lionsmane_001;
			break;
		}}

		return;
	}

	public function Respawn():void {

		health = total_health;
		flag_healthbar = false;

		setPoint(secondary_boundary.x, secondary_boundary.y);
		return;
	}

	public function updateFrame():void {

		if (core.updateDelayable(delay_flip) == true)
			return;
		
		if (!(playable_dolphin.state == StateTable.disabled) &&
			!(playable_dolphin.state == StateTable.burst)) {

			if (x < playable_dolphin.current_boundary.x) {

			if (direction == DirectionTable.left)
				direction = DirectionTable.right;
			}
			else if (x > playable_dolphin.current_boundary.x) {

			if (direction == DirectionTable.right)
				direction = DirectionTable.left;
			}
		}

		switch (direction) { case DirectionTable.left:
			if (index >= 2) { index = 0; return; }

		case DirectionTable.right:
			if (index >= 5) { index = 3; return; }}

		index++;
		return;
	}

	public function setHealth(count:int):void {

		if (state == StateTable.damage)
			return;

		health+= count;
		if (health > 0) {

			state = StateTable.damage;
			phase = PhaseTable.recoiling;

			index = 0;
			recoiling_boundary.x = current.x;
			recoiling_boundary.y = current.y;

			flag_healthbar = true;
			delay_healthbar.count = 0;

			sound_manager.play(SoundTable.damage_002);
			return;
		} else health = 0;

		projectile_burstable.state = StateTable.active;
		projectile_burstable.x = x+(width-projectile_burstable.width)/2;
		projectile_burstable.y = y+(height-projectile_burstable.height)/2;

		sound_manager.play(SoundTable.burst_001);
		state = StateTable.burst;
		return;
	}

	public function updateRecoil():Boolean {

		switch (recoiling_direction) { case DirectionTable.left: {

			if (x < recoiling_boundary.x-10)
				return false;

			x-= velocity; break;
		}

		case DirectionTable.right: {

			if (x > recoiling_boundary.x+10)
				return false;

			x+= velocity; break;
		}

		case DirectionTable.up: {

			if (y < recoiling_boundary.y-10)
				return false;

			y-= velocity; break;
		}

		case DirectionTable.down: {

			if (y > recoiling_boundary.y+10)
				return false;

			y+= velocity; break;
			
		}}

		current.x = x; current.y = y;
		current_boundary.x = current.x+(width-boundary_width)/2;
		current_boundary.y = current.y+(height-boundary_height)/2;

		primary_boundary.x = x+(width-primary_boundary.width)/2;
		primary_boundary.y = y+(height-primary_boundary.height)/2;

		return true;
	}

	public function inBoundaryPlayable():void {

		if (state == StateTable.disabled)
			return;
		if (state == StateTable.burst)
			return;

		if (playable_dolphin.state == StateTable.disabled)
			return;
		if (playable_dolphin.state == StateTable.burst)
			return;
		if (playable_dolphin.state == StateTable.damage)
			return;

		if (core.inBound(current_boundary, playable_dolphin.current_boundary))
			playable_dolphin.setHealth(-1);

		return;
	}

	public function photonInBoundary():void {

		if (state == StateTable.disabled)
			return;
		if (state == StateTable.burst)
			return;

		if (playable_dolphin.state == StateTable.disabled)
			return;
		if (playable_dolphin.state == StateTable.burst)
			return;
		if (playable_dolphin.state == StateTable.damage)
			return;

		if (projectile_photon.state == StateTable.disabled)
			return;

		if (core.inBound(projectile_photon.current_boundary,
			playable_dolphin.current_boundary)) {

		if (projectile_photon.state == StateTable.active) {

			projectile_photon.createBurstable();
			projectile_photon.state = StateTable.burst;
		}

		playable_dolphin.setHealth(-1); }

		return;
	}

	public function inBoundarySonar():void {

		if (state == StateTable.disabled)
			return;
		if (state == StateTable.burst)
			return;

		if (playable_dolphin.state == StateTable.disabled)
			return;
		if (playable_dolphin.state == StateTable.burst)
			return;
		if (playable_dolphin.state == StateTable.damage)
			return;

		for (var count:uint = 0; count < playable_dolphin
			.projectile_sonar.length; count++) {
		if (playable_dolphin.projectile_sonar[count]
			.state == StateTable.active) {

		if (core.inBound(current_boundary, playable_dolphin
			.projectile_sonar[count].current_boundary)) {

			playable_dolphin.projectile_sonar[count]
			.state = StateTable.disabled;

			if (!(state == StateTable.damage)) {

				recoiling_direction = playable_dolphin
				.projectile_sonar[count].direction;

				setHealth(-1);
			}
		}}}

		return;
	}

	public function inBoundaryBomb(projectile_bomb:ProjectileBomb):void {

		if (projectile_bomb.state == StateTable.disabled)
			return;
		if (projectile_bomb.state == StateTable.active)
			return;

		if (core.inBound(current_boundary, projectile_bomb
			.current_boundary)) {

		if (!(state == StateTable.damage)) {

			recoiling_direction = projectile_bomb.direction;
			setHealth(-1);
		}}

		return;
	}

	public function inBoundaryMegaBomb():void {

		if (core.inBound(current_boundary, playable_dolphin
			.projectile_megabomb.current_boundary)) {

			recoiling_direction = playable_dolphin
			.projectile_megabomb.direction;

			setHealth(-1);
		}

		return;
	}

	public function inBoundaryLaser(projectile_laser:ProjectileLaser):void {

		if (projectile_laser.state == StateTable.disabled)
			return;

		if (core.inBound(current_boundary, projectile_laser
			.current_boundary)) {

		projectile_laser.state = StateTable.disabled;
		if (!(state == StateTable.damage)) {

			recoiling_direction = projectile_laser.direction;
			setHealth(-1);
		}}

		return;
	}

	public function inBoundaryPhoton(projectile_photon:ProjectilePhoton):void {

		if (projectile_photon.state == StateTable.disabled)
			return;

		if (projectile_photon.state == StateTable.standby) {

			projectile_photon.target.x = current_boundary.x;
			projectile_photon.target.y = current_boundary.y;
			projectile_photon.target.width = current_boundary.width;
			projectile_photon.target.height = current_boundary.height;

			projectile_photon.state = StateTable.active;
			sound_manager.play(SoundTable.laser_001);
		}

		if (core.inBound(current_boundary, projectile_photon
			.current_boundary)) {

		if (projectile_photon.state == StateTable.active) {

			projectile_photon.createBurstable();
			projectile_photon.state = StateTable.burst;
		}

		if (!(state == StateTable.damage)) {

			recoiling_direction = projectile_photon.direction;
			setHealth(-1);
		}}

		return;
	}

	public function inBoundaryProjectile():void {

		if (state == StateTable.disabled)
			return;
		if (state == StateTable.burst)
			return;

		if (playable_dolphin.state == StateTable.disabled)
			return;
		if (playable_dolphin.state == StateTable.burst)
			return;
		if (playable_dolphin.state == StateTable.damage)
			return;

		var projectile_manager:ProjectileManager = playable_dolphin
			.projectile_manager;

		for (var count:uint = 0; count < projectile_manager.total; count++) {

		switch (projectile_manager.handle[count]) { case ProjectileTable.laser: {

			inBoundaryLaser(projectile_manager
				.projectile_laser[count]);
			break;
		}

		case ProjectileTable.bomb: {

			inBoundaryBomb(projectile_manager
				.projectile_bomb[count]);
			break;
		}

		case ProjectileTable.photon: {

			inBoundaryPhoton(projectile_manager
				.projectile_photon[count]);
			break;
		}}}

		return;
	}

	public function updateState():Boolean {

		if (state == StateTable.disabled)
			return true;

		photonInBoundary();
		projectile_photon.Process();

		switch (state) { case StateTable.damage: {

			if (core.updateDelayable(delay_damage) == false)
				state = StateTable.active;


			switch (phase) { case PhaseTable.recoiling: {

				if (updateRecoil() == false)
					phase = PhaseTable.stunned;

				return true;
			}

			case PhaseTable.stunned: {

				if (core.updateDelayable(delay_stunned) == false)
					phase = PhaseTable.none;

				return true;
			}}

			break;
		}

		case StateTable.burst: {

			if (projectile_burstable.state == StateTable.disabled) {

				Respawn();
				state = StateTable.disabled;
				return true;
			}

			projectile_burstable.updateFrame();
			return true;
		}}

		if (flag_healthbar == true)
			if (core.updateDelayable(delay_healthbar) == false)
				flag_healthbar = false;

		return false;
	}

	public function Process():void {

		if (updateState() == true)
			return;
		updateFrame();

		if (core.updateDelayable(delay_projectile) == false) {
		if (projectile_photon.state == StateTable.disabled) {

			projectile_photon.setPoint(x+width/2, y+height/2);

			projectile_photon.target.x = playable_dolphin.current_boundary.x+
				playable_dolphin.current_boundary.width/2;
			projectile_photon.target.y = playable_dolphin.current_boundary.y+
				playable_dolphin.current_boundary.height/2;

			projectile_photon.target.width = playable_dolphin.current_boundary.width/2;
			projectile_photon.target.height = playable_dolphin.current_boundary.height/2;

			projectile_photon.state = StateTable.active;
			sound_manager.play(SoundTable.laser_001);
		}}

		current.x = x; current.y = y;
		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		primary_boundary.x = x+(width-primary_boundary.width)/2;
		primary_boundary.y = y+(height-primary_boundary.height)/2;

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

		projectile_photon.Draw();

		switch (state) { case StateTable.damage: {

			if (core.updateDelayable(delay_blink) == true) {

				drawHealthBar();
				return;
			}

			break;
		}

		case StateTable.burst: {

			projectile_burstable.Draw();
			return;
		}}

		drawHealthBar();

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(current);

		core.display_manager.Draw(resource_manager.handle[start_index+index],
			relative.x, relative.y);

		return;
	}
}}
