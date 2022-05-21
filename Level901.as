package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class Level901 {

	[Embed(source='data/level901-001.png')] private var background_001:Class;
	[Embed(source='data/pressstart-001.png')] private var pressstart_001:Class;

	public var core:Core;
	public var StateTable:Object;

	public var sound_manager:SoundManager;
	public var display_manager:DisplayManager;

	public var state:uint;
	public var background:BitmapData;
	public var pressstart:BitmapData;

	public var blink_pressstart:Boolean;
	public var delay_blink:Object;

	public var soundtrack:Sound;
	public var soundchannel:SoundChannel;

	public function Level901(source:Core):void {
	
		core = source;
		StateTable = core.StateTable;

		sound_manager = core.sound_manager;
		display_manager = core.display_manager;

		background = new background_001().bitmapData;
		pressstart = new pressstart_001().bitmapData;

		blink_pressstart = false;
		delay_blink = core.getDelayable(0, 30);

		state = StateTable.disabled;
		return;
	}

	public function Dispatch():void {

		soundtrack = sound_manager.getTrack001();
		soundchannel = soundtrack.play();
		soundchannel.addEventListener(Event.SOUND_COMPLETE,
			soundComplete);

		state = StateTable.active;
		core.sprite.addEventListener(Event.ENTER_FRAME,
			enterFrame);
		return;
	}

	public function Destroy():void {

		soundchannel.stop();
		soundchannel.removeEventListener(Event.SOUND_COMPLETE,
			soundComplete);
		core.sprite.removeEventListener(Event.ENTER_FRAME,
			enterFrame);
		return;
	}

	public function Process():void {

		if (state == StateTable.disabled) {

			Dispatch();
			return;
		}

		if (core.Click == true) {

			core.Click = false;
			core.playable_dolphin.current_level = 001;

			Destroy();
			return;
		}

		if (core.updateDelayable(delay_blink) == false) {

			if (blink_pressstart == true) blink_pressstart = false;
			else { blink_pressstart = true; }
		}

		return;
	}

	public function drawBackground():void {

		core.display_manager.Draw(background, 0, 0);

		if (blink_pressstart == false)
		core.display_manager.Draw(pressstart, 115, 160);

		return;
	}

	public function soundComplete(event:Event):void {

		soundchannel = soundtrack.play();
		soundchannel.addEventListener(Event.SOUND_COMPLETE,
			soundComplete);

		return;
	}

	public function enterFrame(event:Event):void {

		drawBackground();
		display_manager.Flip();
		return;
	}
}}
