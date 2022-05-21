
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class NPCShark extends Rectangle {
 
	public var PhaseTable:Object = { none:0, rebound:1, stunned:2 }

	public var core:Core;	
	
	public var playable_dolphin:PlayableDolphin;
	public var resource_manager:ResourceManager;
	public var sound_manager:SoundManager;

	public var StateTable:Object;
	public var DirectionTable:Object;
	public var ResourceTable:Object;
	public var SoundTable:Object;
	public var ProjectileTable:Object;

	public var state:int, phase:int;

	public var boundary_width:uint, boundary_height:uint;
	public var current_boundary:Rectangle;

	public var surface_boundary:Rectangle;
	public var guard_boundary:Rectangle;
	public var rebound_boundary:Rectangle;
	public var blitz_boundary:Rectangle;
	public var velocity:uint;
	public var direction:int, rebound_direction:int;

	public var flag_healthbar:Boolean;
	public var flag_predator:Boolean;

	public var health:int, total_health:int;
	public var index:uint, start_index:uint;
	
	public var delay_flip:Object;
	public var delay_move:Object;
	public var delay_blitz:Object;

	public var delay_healthbar:Object;
	public var delay_stunned:Object;
	public var delay_blink:Object;
	public var delay_damage:Object;
	
	public var projectile_burstable:ProjectileBurstable;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		guard_boundary.x = x;
		guard_boundary.y = y;

		blitz_boundary.x = x+(width-blitz_boundary.width)/2;
		blitz_boundary.y = y+(height-blitz_boundary.height)/2;

		return;
	}

	public function getManager():void {

		playable_dolphin = core.playable_dolphin;
		resource_manager = core.resource_manager;
		sound_manager = core.sound_manager;
		
		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;

		ResourceTable = core.resource_manager.ResourceTable;
		SoundTable = core.sound_manager.SoundTable;
		ProjectileTable = core.ProjectileTable;

		state = StateTable.disabled;
		phase = PhaseTable.none;

		return;
	}

	public function loadBoundary():void {

		x = 0; y = 0; width = 48;
		height = 48; velocity = 1;

		boundary_width = 24; boundary_height = 24;
		current_boundary = new Rectangle(0, 0,
			boundary_width, boundary_height);

		surface_boundary = new Rectangle(0, 0, 0, 0);
		guard_boundary = new Rectangle(0, 0, 100, 100);
		rebound_boundary = new Rectangle(0, 0, width, height);
		blitz_boundary = new Rectangle(0, 0, 150, 150);

		direction = DirectionTable.right;
		rebound_direction = DirectionTable.none;

		setPoint(0, 0);
		return;
	}

	public function NPCShark(source:Core):void {

		core = source;
		getManager();
		loadBoundary();

		flag_healthbar = false;
		flag_predator = true;

		health = 10; total_health = 10;
		start_index = ResourceTable.shark_001;
		index = 3;

		delay_flip = core.getDelayable(0, 8);
		delay_move = core.getDelayable(0, 1);

		delay_blitz = core.getDelayable(0, 8);
		delay_blitz.count = delay_blitz.total;

		delay_healthbar = core.getDelayable(0, 100);
		delay_stunned = core.getDelayable(0, 30);
		delay_blink = core.getDelayable(0, 8);
		delay_damage = core.getDelayable(0, 30);

		projectile_burstable = new ProjectileBurstable(core);
		return;
	}

	public function setIdentity(identity:String):void {

		switch (identity) { case 'reefshark': {

			start_index = ResourceTable.reefshark_001;
			break;
		}

		case 'blueray': {

			start_index = ResourceTable.blueray_001;
			flag_predator = false; delay_flip.total = 16; break;
		}

		case 'brownray': {

			start_index = ResourceTable.brownray_001;
			flag_predator = false; delay_flip.total = 16; break;
		}}

		return;
	}

	public function Respawn():void {

		health = total_health;
		flag_healthbar = false;

		setPoint(guard_boundary.x, guard_boundary.y);
		return;
	}

	public function updateFrame():void {

		if (core.updateDelayable(delay_flip) == true)
			return;

		if (direction == DirectionTable.left) {
		if (index >= 2) {

			index = 0;
			return;
		}}
		else if (direction == DirectionTable.right) {
		if (index >= 5) {

			index = 3;
			return;
		}}

		index++;
		return;
	}

	public function updateBlitz():Boolean {

		if (flag_predator == false) return false;

		if ((playable_dolphin.state == StateTable.disabled) ||
			(playable_dolphin.state == StateTable.burst))
				return false;

		if (!core.inBound(blitz_boundary, playable_dolphin
			.current_boundary)) return false;

		if (core.updateDelayable(delay_blitz) == false) {

		if (x > playable_dolphin.x) {

			index = 6;
			direction = DirectionTable.left;
		}
		else if (x < playable_dolphin.x) {

			index = 7;
			direction = DirectionTable.right;
		}}

		if (core.updateDelayable(delay_move) == true)
			return true;

		if (direction == DirectionTable.right)
			x+= velocity+2;
		else if (direction == DirectionTable.left)
			x-= velocity+2;

		if (y < playable_dolphin.y)
			y+= velocity;
		else if (y > playable_dolphin.y) {

			if (y > surface_boundary.y)
				y-= velocity;
		}

		return true;
	}

	public function updatePoint():Boolean {

		delay_blitz.count = delay_blitz.total;

		if (current_boundary.x+current_boundary.width >
			guard_boundary.x+guard_boundary.width) {
		if (!(direction == DirectionTable.left)) {

			index = 0;
			direction = DirectionTable.left;
		}}
		else if (current_boundary.x < guard_boundary.x) {
		if (!(direction == DirectionTable.right)) {

			index = 3;
			direction = DirectionTable.right;
		}}

		if (core.updateDelayable(delay_move) == true)
			return false;

		if (y > guard_boundary.y) y-= velocity;
		else if (y < guard_boundary.y) y+= velocity;

		if (direction == DirectionTable.right)
			x+= velocity;
		else if (direction == DirectionTable.left)
			x-= velocity;

		return false;
	}

	public function setHealth(count:int):void {

		if (state == StateTable.damage)
			return;

		health+= count;
		if (health > 0) {

			state = StateTable.damage;
			phase = PhaseTable.rebound;

			if (direction == DirectionTable.left)
				index = 0;
			else if (direction == DirectionTable.right)
				index = 3;

			rebound_boundary.x = x;
			rebound_boundary.y = y;

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

				rebound_direction = playable_dolphin
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

			rebound_direction = projectile_bomb.direction;
			setHealth(-1);
		}}

		return;
	}

	public function inBoundaryMegaBomb():void {

		if (core.inBound(current_boundary, playable_dolphin
			.projectile_megabomb.current_boundary)) {

			rebound_direction = playable_dolphin
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

			rebound_direction = projectile_laser.direction;
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

		if (projectile_photon.state == StateTable.active) {
		if (core.inBound(current_boundary, projectile_photon
			.current_boundary)) {

		projectile_photon.createBurstable();
		projectile_photon.state = StateTable.burst;

		if (!(state == StateTable.damage)) {

			rebound_direction = projectile_photon.direction;
			setHealth(-1);
		}}}

		return;
	}

	public function inBoundaryPrototype(projectile_prototype:ProjectilePrototype):void {

		if (projectile_prototype.state == StateTable.disabled)
			return;

		if (core.inBound(current_boundary, projectile_prototype
			.current_boundary)) {

		projectile_prototype.state = StateTable.disabled;
		if (!(state == StateTable.damage)) {

			rebound_direction = projectile_prototype.direction;
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
		}

		case ProjectileTable.prototype: {

			inBoundaryPrototype(projectile_manager
				.projectile_prototype[count]);
			break;
		}}}

		return;
	}

	public function updateRebound():Boolean {

		switch (rebound_direction) { case DirectionTable.left: {

			if (x < rebound_boundary.x-10)
				return false;

			x-= velocity; break;
		}

		case DirectionTable.right: {

			if (x > rebound_boundary.x+10)
				return false;

			x+= velocity; break;
		}

		case DirectionTable.up: {

			if (y < surface_boundary.y)
				return false;
			if (y < rebound_boundary.y-10)
				return false;

			y-= velocity; break;
		}

		case DirectionTable.down: {

			if (y > rebound_boundary.y+10)
				return false;

			y+= velocity; break;
			
		}}

		current_boundary.x = current.x+(width-boundary_width)/2;
		current_boundary.y = current.y+(height-boundary_height)/2;

		blitz_boundary.x = x+(width-blitz_boundary.width)/2;
		blitz_boundary.y = y+(height-blitz_boundary.height)/2;

		return true;
	}

	public function updateState():Boolean {

		if (state == StateTable.disabled)
			return true;

		switch (state) { case StateTable.damage: {

			if (core.updateDelayable(delay_damage) == false)
				state = StateTable.active;

			switch (phase) { case PhaseTable.rebound: {

				if (updateRebound() == false)
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
		
		if (updateBlitz() == false) {

			updatePoint();
			updateFrame();
		}

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;

		blitz_boundary.x = x+(width-blitz_boundary.width)/2;
		blitz_boundary.y = y+(height-blitz_boundary.height)/2;

		return;
	}

	public function drawHealthBar():void {

		if (flag_healthbar == false)
			return;

		var index:uint = 6*(health/total_health);
		index = uint(index);

		var relative:Rectangle = core.viewport_manager
		.TranslateToViewport(new Rectangle(x, y-width/2, width, height));

		core.display_manager.Draw(resource_manager.handle[ResourceTable
			.targethealth_001+index], relative.x, relative.y);

		return;
	}

	public function Draw():void {

		if (state == StateTable.disabled)
			return;

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
			.TranslateToViewport(Rectangle(this));

		core.display_manager.Draw(resource_manager.handle[start_index+index],
			relative.x, relative.y);

		return;
	}
}}
