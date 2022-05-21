
package agartha {

public class ProjectileManager {

	public var core:Core;
	public var StateTable:Object;
	public var ProjectileTable:Object;

	public var total:int;
	public var handle:Array;

	public var projectile_bomb:Array;
	public var projectile_laser:Array;
	public var projectile_photon:Array;
	public var projectile_prototype:Array;

	public function ProjectileManager(source:Core):void {

		core = source;

		StateTable = core.StateTable;
		ProjectileTable = core.ProjectileTable;

		total = 4;
		handle = new Array(total);

		projectile_bomb = new Array(total);
		projectile_laser = new Array(total);
		projectile_photon = new Array(total);
		projectile_prototype = new Array(total);

		for (var count:uint = 0; count < total; count++) {

			handle[count] = ProjectileTable.none;

			projectile_bomb[count] = new ProjectileBomb(core);
			projectile_laser[count] = new ProjectileLaser(core);
			projectile_photon[count] = new ProjectilePhoton(core);
			projectile_prototype[count] = new ProjectilePrototype(core);		
		}

		return;
	}

	public function getProjectileTotal():int {

		var index:uint = 0;
		for (var count:uint = 0; count < total; count++)
			if (handle[count] == ProjectileTable.none)
				index++;
	
		return index;
	}

	public function getNextProjectile():int {

		for (var count:uint = 0; count < total; count++)
			if (handle[count] == ProjectileTable.none)
				return count;
	
		return -1;
	}

	public function Process():void {

		for (var count:uint = 0; count < total; count++) {

		switch (handle[count]) { case ProjectileTable.bomb: {

			projectile_bomb[count].Process();

			if (projectile_bomb[count].state == StateTable.disabled)
				handle[count] = ProjectileTable.none;

			break;
		}

		case ProjectileTable.laser: {

			projectile_laser[count].Process();

			if (projectile_laser[count].state == StateTable.disabled)
				handle[count] = ProjectileTable.none;

			break;
		}

		case ProjectileTable.photon: {

			projectile_photon[count].Process();

			if (projectile_photon[count].state == StateTable.disabled)
				handle[count] = ProjectileTable.none;

			break;
		}

		case ProjectileTable.prototype: {

			projectile_prototype[count].Process();

			if (projectile_prototype[count].state == StateTable.disabled)
				handle[count] = ProjectileTable.none;

			break;
		}}}

		return;
	}

	public function Draw():void {

		for (var count:uint = 0; count < total; count++) {

		switch (handle[count]) { case ProjectileTable.bomb: {

			projectile_bomb[count].Draw();
			break;
		}

		case ProjectileTable.laser: {

			projectile_laser[count].Draw();
			break;
		}

		case ProjectileTable.photon: {

			projectile_photon[count].Draw();
			break;
		}

		case ProjectileTable.prototype: {

			projectile_prototype[count].Draw();
			break;
		}}}

		return;
	}
}}
