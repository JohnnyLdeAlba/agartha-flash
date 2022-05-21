
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class PlayableDolphin extends Rectangle {

	public var PhaseTable:Object = { none:0, rebound:1, stunned:2 }

	public var core:Core;
	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;

	public var StateTable:Object;
	public var DirectionTable:Object;
	public var ProjectileTable:Object;

	public var ResourceTable:Object;
	public var SoundTable:Object;
	
	public var state:int, phase:int;
	public var start_index:uint, index:uint;

	public var health:int, air:int;
	public var current:Rectangle, next:Rectangle;
	public var rebound_boundary:Rectangle;

	public var direction:int, previous_direction:int;
	public var velocity:uint;

	public var current_boundary:Rectangle, next_boundary:Rectangle;
	public var boundary_x:Boolean, boundary_y:Boolean;
	public var boundary_width:int, boundary_height:int;

	public var delay_flip:Object;
	public var delay_stunned:Object;

	public var delay_blink:Object;
	public var delay_damage:Object;
	public var delay_air:Object;

	public var projectile_manager:ProjectileManager;
	public var projectile_burstable:ProjectileBurstable;
	public var projectile_megabomb:ProjectileBomb;
	public var projectile_shield:ProjectileShield;

	public var projectile_sonar:Array;

	public var current_level:uint;

	public function setPoint(x:int, y:int):void {

		this.x = x; this.y = y;
		current.x = x; current.y = y;
		current_boundary.x = x; current_boundary.y = y;

		return;
	}

	public function PlayableDolphin(source:Core):void {

		core = source;
		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;

		StateTable = core.StateTable;
		DirectionTable = core.DirectionTable;
		ProjectileTable = core.ProjectileTable;

		ResourceTable = core.resource_manager.ResourceTable;
		SoundTable = core.sound_manager.SoundTable;

		state = StateTable.active; phase = PhaseTable.none;
		start_index = ResourceTable.dolphin_001; index = 0;
		x = 0; y = 0; width = 48; height = 48;
		health = 6; air = 3;

		boundary_x = false; boundary_y = false;
		boundary_width = 9; boundary_height = 9;
		velocity = 3;

		next = new Rectangle(0, 0, width, height);
		current = Rectangle(this);
		rebound_boundary = new Rectangle(0, 0, width, height);

		next_boundary = new Rectangle(0, 0, boundary_width, boundary_height);
		current_boundary = new Rectangle(0, 0, boundary_width, boundary_height);

		direction = DirectionTable.right;
		previous_direction = DirectionTable.right;

		delay_flip = core.getDelayable(0, 8);
		delay_stunned = core.getDelayable(0, 30);

		delay_blink = core.getDelayable(0, 8);
		delay_damage = core.getDelayable(0, 60);
		delay_air = core.getDelayable(0, 1500);

		projectile_manager = new ProjectileManager(core);
		projectile_burstable = new ProjectileBurstable(core);
		projectile_megabomb = new ProjectileBomb(core);
		projectile_shield = new ProjectileShield(core);

		projectile_sonar = new Array(4);
		for (var count:uint = 0; count < projectile_sonar.length; count++)
			projectile_sonar[count] = new ProjectileSonar(core);

		projectile_megabomb.setIdentity('megabomb');

		current_level = 000;
		getDefaultFrame();
		return;
	}

	private function getDefaultFrame():void {

		switch (direction) { case DirectionTable.left:
			index = 0; break;

		case DirectionTable.right: index = 5; break;
		case DirectionTable.up: index = 10; break;
		case DirectionTable.down: index = 14; break; }

		return;
	}

	private function getStartFrame():void {

		switch (direction) { case DirectionTable.left:
			index = 1; break;

		case DirectionTable.right: index = 6; break;
		case DirectionTable.up: index = 11; break;
		case DirectionTable.down: index = 15; break; }

		return;
	}

	private function setNextFrame(start:uint, stop:uint):void {

		if ((index < start) || (index >= stop)) {
			index = start; return; }

		index++;
		return;
	}

	private function getNextFrame():void {

		if (core.updateDelayable(delay_flip) == true)
			return;

		switch (direction) { case DirectionTable.left:
			setNextFrame(1, 4); break;

		case DirectionTable.right: setNextFrame(6, 9); break;
		case DirectionTable.up: setNextFrame(11, 13); break;
		case DirectionTable.down: setNextFrame(15, 17); break; }

		return;
	}

	public function createSonar():void {

		var index:int = -1;
		for (var count:uint = 0; count < projectile_sonar.length; count++) {

		if (projectile_sonar[count].state == StateTable.disabled) {
			index = count; break;
		}}

		if (index == -1) return;

		projectile_sonar[index].setDirection(direction);
		
		switch (direction) { case DirectionTable.left: { projectile_sonar[index]
			.setPoint(x-projectile_sonar[index].width+16, y+16); break; }

		case DirectionTable.right: { projectile_sonar[index]
			.setPoint(x+width-16, y+16); break; }

		case DirectionTable.up: { projectile_sonar[index]
			.setPoint(x+14, y-projectile_sonar[index].height+16); break; }

		case DirectionTable.down: { projectile_sonar[index]
			.setPoint(x+14, y+height-16); break; }}

		sound_manager.play(SoundTable.sonar_001, 1);
		projectile_sonar[index].state = StateTable.active;
		core.keyhold[core.KeyTable.j] = true;

		return;
	}

	public function createBomb():void {

		var id:int = projectile_manager.getNextProjectile();

		if (id == -1) return;
		projectile_manager.handle[id] = ProjectileTable.bomb;

		var projectile_bomb:ProjectileBomb = projectile_manager
			.projectile_bomb[id];

		if (projectile_bomb.state == StateTable.active)
			return;
		
		projectile_bomb.direction = direction;

		switch (direction) { case DirectionTable.left: { projectile_bomb
			.setPoint(x-projectile_bomb.width+12, y+12); break; }

		case DirectionTable.right: { projectile_bomb
			.setPoint(x+width-12, y+12); break; }

		case DirectionTable.up: { projectile_bomb .setPoint(x+12,
			y-projectile_bomb.height+12); break; }

		case DirectionTable.down: { projectile_bomb
			.setPoint(x+12, y+height-12); break; }}

		projectile_bomb.state = StateTable.active;
		return;
	}

	public function createMegaBomb():void {

		if (projectile_megabomb.state == StateTable.active)
			return;
		
		projectile_megabomb.direction = direction;

		switch (direction) { case DirectionTable.left: {
			projectile_megabomb
			.setPoint(x-projectile_megabomb.width+12, y+12); break; }

		case DirectionTable.right: { projectile_megabomb
			.setPoint(x+width-12, y+12); break; }

		case DirectionTable.up: { projectile_megabomb
			.setPoint(x+12, y-projectile_megabomb.height+12); break; }

		case DirectionTable.down: { projectile_megabomb
			.setPoint(x+12, y+height-12); break; }}

		projectile_megabomb.current_boundary.x = core.viewport_manager.x;
		projectile_megabomb.current_boundary.y = core.viewport_manager.y;

		projectile_megabomb.current_boundary.width = core.viewport_manager.width;
		projectile_megabomb.current_boundary.height = core.viewport_manager.height;

		projectile_megabomb.state = StateTable.active;
		return;
	}

	public function createLaser():void {

		var id:int = projectile_manager.getNextProjectile();

		if (id == -1) return;
		projectile_manager.handle[id] = ProjectileTable.laser;

		var projectile_laser:ProjectileLaser = projectile_manager
			.projectile_laser[id];

		projectile_laser.setDirection(direction);
		
		switch (direction) { case DirectionTable.left: { projectile_laser
			.setPoint(x-projectile_laser.width+24, y); break; }

		case DirectionTable.right: { projectile_laser
			.setPoint(x+width-24, y); break; }

		case DirectionTable.up: { projectile_laser
			.setPoint(x, y-projectile_laser.height+24); break; }

		case DirectionTable.down: { projectile_laser
			.setPoint(x, y+height-24); break; }}

		sound_manager.play(SoundTable.laser_001);
		projectile_laser.state = StateTable.active;
		core.keyhold[core.KeyTable.j] = true;

		return;
	}

	public function createPrototype():void {

		var total:uint = projectile_manager.total;

		var id:uint = 0;
		var projectile_prototype:ProjectilePrototype = null;		
		
		id = projectile_manager.getProjectileTotal();
		if (id < total) { core.keyhold[core.KeyTable.j] = true;
			return; }

		for (var count:uint = 0; count < total; count++) {

			id = projectile_manager.getNextProjectile();

			projectile_manager.handle[id] = ProjectileTable.prototype;
			projectile_prototype = projectile_manager.projectile_prototype[id];

			projectile_prototype.setPoint(x+width/2, y+height/2);
			projectile_prototype.setDirection(direction);

			switch (direction) { case DirectionTable.left: {

				projectile_prototype.velocity_x = -6;
				projectile_prototype.velocity_y = count*2-2;
				break;
			}

			case DirectionTable.right: {

				projectile_prototype.velocity_x = 6;
				projectile_prototype.velocity_y = count*2-2;
				break;
			}

			case DirectionTable.up: {

				projectile_prototype.velocity_x = count*2-2;
				projectile_prototype.velocity_y = -6;
				break;
			}

			case DirectionTable.down: {

				projectile_prototype.velocity_x = count*2-2;
				projectile_prototype.velocity_y = 6;
				break;
			}}

			projectile_prototype.state = StateTable.active;
		}

		sound_manager.play(SoundTable.laser_001);
		core.keyhold[core.KeyTable.j] = true;

		return;
	}

	public function createAirJar():void {

		if (air >= 3) return;

		air = 3;
		state = StateTable.collectable;
		createBurstable();

		sound_manager.play(SoundTable.bubble_001);
		return;
	}

	public function createHealthJar():void {

		if (health >= 6) return;

		health++;
		state = StateTable.collectable;
		createBurstable();

		sound_manager.play(SoundTable.bubble_001);
		return;
	}

	public function createShield():void {

		if (!(projectile_shield.state == StateTable.disabled))
			return;

		air = 6;
		projectile_shield.health = 10;
		projectile_shield.state = StateTable.active;

		sound_manager.play(SoundTable.cast_001);
		return;
	}

	public function createPhoton():void {

		var id:int = projectile_manager.getNextProjectile();

		if (id == -1) return;
		projectile_manager.handle[id] = ProjectileTable.photon;

		var projectile_photon:ProjectilePhoton = projectile_manager
			.projectile_photon[id];

		projectile_photon.setDirection(direction);
		projectile_photon.setPoint(x+width/2, y+height/2);

		projectile_photon.state = StateTable.standby;
		core.keyhold[core.KeyTable.j] = true;

		return;
	}

	public function createConsumable():void {

		switch (core.hud_manager.selected_consumable) {

			case core.ConsumableTable.airjar: 
				createAirJar(); break;

			case core.ConsumableTable.healthjar: 
				createHealthJar(); break;

			case core.ConsumableTable.bomb: 
				createBomb(); break;

			case core.ConsumableTable.megabomb: 
				createMegaBomb(); break;

			case core.ConsumableTable.laser: 
				createLaser(); break;

			case core.ConsumableTable.shield: 
				createShield(); break;

			case core.ConsumableTable.photon: 
				createPhoton(); break;

			case core.ConsumableTable.prototype: 
				createPrototype(); break;
		}

		core.keyhold[core.KeyTable.l] = true;
		return;
	}

	public function createBurstable():void {

		projectile_burstable.state = StateTable.active;
		projectile_burstable.x = x+(width-projectile_burstable.width)/2;
		projectile_burstable.y = y+(height-projectile_burstable.height)/2;

		return;
	}

	public function inBoundaryMegaBomb():void {

		if (state == StateTable.damage)
			return;

		if (projectile_megabomb.state == StateTable.disabled)
			return;
		if (projectile_megabomb.state == StateTable.active)
			return;

		if (core.inBound(current_boundary, projectile_megabomb.current_boundary))
			setHealth(-1);

		return;
	}

	public function getDirection():Boolean {

		next.x = x; next.y = y;
		direction = DirectionTable.none;

		if (core.keydown[core.KeyTable.a] == true) {

			next.x-= velocity;
			direction = DirectionTable.left;
		}
		else if (core.keydown[core.KeyTable.d] == true) {

			next.x+= velocity;
			direction = DirectionTable.right;
		}

		if (core.keydown[core.KeyTable.w] == true) {

			next.y-= velocity;
			direction = DirectionTable.up;
		}
		else if (core.keydown[core.KeyTable.s] == true) {

			next.y+= velocity;
			direction = DirectionTable.down;
		}

		next_boundary.x = next.x+(width-boundary_width)/2;
		next_boundary.y = next.y+(height-boundary_height)/2;

		if (direction == previous_direction)
			return true;

		if (direction == DirectionTable.none) {

			direction = previous_direction;
			getDefaultFrame(); return false;

		} else getStartFrame();

		previous_direction = direction;
		return false;
	}

	public function getInput():void {

		if ((core.keydown[core.KeyTable.j] == true) &&
			(core.keyhold[core.KeyTable.j]== false))
				createSonar();

		if ((core.keydown[core.KeyTable.k] == true) &&
			(core.keyhold[core.KeyTable.k]== false)) {

			core.hud_manager.setSelectedConsumable(core.hud_manager
				.selected_consumable+1);
			core.keyhold[core.KeyTable.k] = true;
		}

		if ((core.keydown[core.KeyTable.l] == true) &&
			(core.keyhold[core.KeyTable.l]== false))
				createConsumable();

		if ((core.keydown[core.KeyTable.j] == false) &&
			(core.keyhold[core.KeyTable.j] == true))
				core.keyhold[core.KeyTable.j] = false;

		if ((core.keydown[core.KeyTable.k] == false) &&
			(core.keyhold[core.KeyTable.k] == true))
				core.keyhold[core.KeyTable.k] = false;

		if ((core.keydown[core.KeyTable.l] == false) &&
			(core.keyhold[core.KeyTable.l] == true))
				core.keyhold[core.KeyTable.l] = false;

		return;
	}

	public function setHealth(count:int):void {

		if (state == StateTable.damage)
			return;

		if (!(projectile_shield.state == StateTable.disabled) &&
			(projectile_shield.health > 0)) {

			projectile_shield.setHealth(-1);
			return;
		}

		health+= count;
		if (health > 0) {

			state = StateTable.damage;
			phase = PhaseTable.rebound;

			rebound_boundary.x = current.x;
			rebound_boundary.y = current.y;

			sound_manager.play(SoundTable.damage_001);
			return;
		} else health = 0;

		state = StateTable.burst;
		createBurstable();
		sound_manager.play(SoundTable.burst_001, 1);
		
		return;
	}

	public function updateAir():void {

		if (!(projectile_shield.state == StateTable.disabled) &&
			(projectile_shield.health > 0)) return;

		if (core.updateDelayable(delay_air) == true)
			return;
		if (air > 0) { air--; return; }

		setHealth(-1);
		return;
	}

	public function updateRebound():void {

		next.x = x; next.y = y;

		switch (previous_direction) { case DirectionTable.left: {

			if (next.x > rebound_boundary.x+10) {
				phase = PhaseTable.stunned;
				return;
			}

			next.x+= velocity; break;
		}

		case DirectionTable.right: {

			if (next.x < rebound_boundary.x-10) {
				phase = PhaseTable.stunned;
				return;
			}

			next.x-= velocity; break;
		}

		case DirectionTable.up: {

			if (next.y > rebound_boundary.y+10) {
				phase = PhaseTable.stunned;
				return;
			}

			next.y+= velocity; break;
		}

		case DirectionTable.down: {

			if (next.y < rebound_boundary.y-10) {
				phase = PhaseTable.stunned;
				return;
			}

			next.y-= velocity; break;
			
		}}

		next_boundary.x = next.x+(width-boundary_width)/2;
		next_boundary.y = next.y+(height-boundary_height)/2;

		direction = previous_direction;
		getDefaultFrame();

		return;
	}

	public function updateState():Boolean {

		if (state == StateTable.disabled)
			return true;

		switch (state) { case StateTable.damage: {

			if (core.updateDelayable(delay_damage) == false)
				state = StateTable.active;

			switch (phase) { case PhaseTable.rebound: {

				updateRebound();
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
				state = StateTable.disabled;
				return true;
			}

			projectile_burstable.updateFrame();
			return true;
		}

		case StateTable.collectable: {

			if (projectile_burstable.state == StateTable.disabled) {
				state = StateTable.active;
				return false;
			}

			projectile_burstable.updateFrame();
			break;
		}}

		
		return false;
	}

	public function updateProjectile():void {

		var count:uint = 0;

		projectile_manager.Process();
		projectile_megabomb.Process();

		projectile_shield.updateFrame();

		for (count = 0; count < projectile_sonar.length; count++)
			projectile_sonar[count].Process();

		return;
	}

	public function Process():void {

		updateProjectile();
		if (updateState() == true)
			return;
		updateAir();

		if (getDirection() == true)
			getNextFrame();
		getInput();

		inBoundaryMegaBomb();

		return;
	}

	public function Update():void {

		if (boundary_x == false) x = next.x;
		if (boundary_y == false) y = next.y;

		boundary_x = false; boundary_y = false;
		current.x = x; current.y = y;

		current_boundary.x = x+(width-boundary_width)/2;
		current_boundary.y = y+(height-boundary_height)/2;
		return;
	}

	public function Draw():void {

		var count:uint = 0;

		projectile_manager.Draw();
		projectile_megabomb.Draw();

		for (count = 0; count < projectile_sonar.length; count++)
			projectile_sonar[count].Draw();

		if (state == StateTable.disabled)
			return;
		
		switch (state) { case StateTable.damage: {

			if (core.updateDelayable(delay_blink) == true)
				return;
			break;
		}

		case StateTable.burst: {

			projectile_burstable.Draw();
			return;
		}}

		var relative:Rectangle = core.viewport_manager
			.TranslateToViewport(current);

		core.display_manager.Draw(resource_manager.handle[start_index+index],
			relative.x, relative.y);

		projectile_shield.setPoint(x, y);
		projectile_shield.Draw();

		if (state == StateTable.collectable)
			projectile_burstable.Draw();

		return;
	}
}}
