
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.ui.*;
import flash.utils.*;

public class agartha extends Sprite {

	private var core:Core;
	private var playable_dolphin:PlayableDolphin;

	private var thread:Timer;

	private var level901:Level901;
	private var level001:Level001;

	public function agartha():void {

		core = new Core(this);

		playable_dolphin = core.playable_dolphin;
		playable_dolphin.current_level = 900;

		level901 = new Level901(core);
		level001 = new Level001(core);

		thread = new Timer(18, 0);
		thread.addEventListener(TimerEvent.TIMER, Process);
		thread.start();

		return;
	}

	public function Loading():void {

		core.level900.current = (core.resource_manager.index+core.sound_manager.index);
		core.level900.total = (core.resource_manager.total+core.sound_manager.total);

		if (core.level900.current >= core.level900.total) {

			playable_dolphin.current_level = 901;
			core.level900.Destroy();
			return;
		}

		if (core.resource_manager.index < core.resource_manager.total)
			core.resource_manager.getResource();
		if (core.sound_manager.index < core.sound_manager.total)
			core.sound_manager.getResource();

		core.level900.Process();
		return;
	}

	public function Process(event:TimerEvent):void {

		switch (playable_dolphin.current_level) { case 900: {
			Loading(); break; }

 		case 901: { level901.Process(); break; }
		case 001: { level001.Process(); break; }}

		return;
	}
}}
