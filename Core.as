
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.ui.*;

public class Core {

	public var stage:Stage;
	public var sprite:Sprite;

	public const StateTable:Object = {

		disabled:0,
		dispatch:1,
		standby:2,
		suspend:3,

		active:4,
		damage:5,
		burst:6,
		hologram:7,
		collectable:8 
	}

	public const DirectionTable:Object = {

		none:0, left:1, right:2,
		up:3, down:4
	}

	public const KeyTable:Object = {

		f10:0, w:1, a:2,
		s:3, d:4, j:5,
		k:6, l:7, i:8
	}

	public const ConsumableTable:Object = {

		none:-1, airjar:0, healthjar:1,
		bomb:2, megabomb:3, laser:4,
		shield:5, photon:6, prototype:7
	}

	public const ProjectileTable:Object = {

		none:0, bomb:1, laser:2, photon:3, prototype:4
	}

	public const NPCTable:Object = {

		none:0, fish:1, jellyfish:2, shark:3, lobster:4
	}

	public var keydown:Array;
	public var keyhold:Array;
	public var Click:Boolean;

	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;

	public var resource_projectile:Array;

	public var playable_dolphin:PlayableDolphin;
	public var display_manager:DisplayManager;

	public var viewport_manager:ViewportManager;
	public var hud_manager:HUDManager;

	public var level900:Level900;

	public function Core(source:Sprite):void {

		sprite = source;
		stage = source.stage;

		sound_manager = new SoundManager();
		resource_manager = new ResourceManager();

		resource_projectile = new ResourceProjectile().getResource();

		playable_dolphin = new PlayableDolphin(this);
		display_manager = new DisplayManager(sprite);
		viewport_manager = new ViewportManager(this);
		hud_manager = new HUDManager(this);

		keydown = new Array(8);
		keyhold = new Array(8);
		Click = false;

		for (var count:uint = 0; count < keydown.length; count++)
			keydown[count] = false;
		for (count = 0; count < keyhold.length; count++)
			keyhold[count] = false;

		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

		stage.mouseChildren = false;
		stage.addEventListener(MouseEvent.CLICK, onClick);

		level900 = new Level900(this);
		return;
	}

	private function onKeyDown(event:KeyboardEvent):void {

		switch (event.keyCode) { case Keyboard.F10: {
			keydown[KeyTable.f10] = true; break;
		}

		case 87: { keydown[KeyTable.w] = true; break; }
		case 65: { keydown[KeyTable.a] = true; break; }
		case 83: { keydown[KeyTable.s] = true; break; }
		case 68: { keydown[KeyTable.d] = true; break; }

		case 74: { keydown[KeyTable.j] = true; break; }
		case 75: { keydown[KeyTable.k] = true; break; }
		case 76: { keydown[KeyTable.l] = true; break; }
		case 73: { keydown[KeyTable.i] = true; break; }}

		return;
	}

	private function onKeyUp(event:KeyboardEvent):void {

		switch (event.keyCode) { case Keyboard.F10: {
			keydown[KeyTable.f10] = false; break;
		}

		case 87: { keydown[KeyTable.w] = false; break; }
		case 65: { keydown[KeyTable.a] = false; break; }
		case 83: { keydown[KeyTable.s] = false; break; }
		case 68: { keydown[KeyTable.d] = false; break; }

		case 74: { keydown[KeyTable.j] = false; break; }
		case 75: { keydown[KeyTable.k] = false; break; }
		case 76: { keydown[KeyTable.l] = false; break; }
		case 73: { keydown[KeyTable.i] = false; break; }}

		return;
	}

	private function onClick(event:MouseEvent):void {

		Click = true; return;
	}

	public function inBound(source:Rectangle, target:Rectangle):Boolean {

		if ((source.x+source.width <  target.x) ||
			(source.x > target.x+target.width))
				return false;

		else if ((source.y+source.height < target.y) ||
			(source.y > target.y+target.height))
				return false;

		return true;
	}

	public function inBoundX(current:Rectangle, next:Rectangle,
		target:Rectangle):Boolean {

		if ((next.x+next.width < target.x)
			|| (next.x > target.x+target.width)) 
				return false;
		else if ((current.y+current.height < target.y)
			|| (current.y > target.y+target.height)) 
				return false;
			
		return true;
	}
	
	public function inBoundY(current:Rectangle, next:Rectangle,
			target:Rectangle):Boolean {

		if ((next.y+next.height < target.y)
			|| (next.y > target.y+target.height)) 
				return false;
		else if ((current.x+current.width < target.x)
			|| (current.x > target.x+target.width)) 
				return false;
			
		return true;
	}

	public function getDelayable(count:uint, total:uint):Object {

		var source:Object = new Object();
		source.count = count;
		source.total = total;

		return source;
	}

	public function updateDelayable(source:Object):Boolean {

		if (source.count == source.total)
			source.count = 0;
		else { source.count++; return true; }

		return false;
	}
}}
