package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class Level900 {

	[Embed(source='data/level900-001.png')] private var background_001:Class;
	[Embed(source='data/level901-001.png')] private var background_002:Class;
	[Embed(source='data/loading-001.png')] private var loading_001:Class;

	[Embed(source='data/targethealth-001.png')] private var targethealth_001:Class;
	[Embed(source='data/targethealth-002.png')] private var targethealth_002:Class;
	[Embed(source='data/targethealth-003.png')] private var targethealth_003:Class;
	[Embed(source='data/targethealth-004.png')] private var targethealth_004:Class;
	[Embed(source='data/targethealth-005.png')] private var targethealth_005:Class;
	[Embed(source='data/targethealth-006.png')] private var targethealth_006:Class;
	[Embed(source='data/targethealth-007.png')] private var targethealth_007:Class;

	public var core:Core;
	public var StateTable:Object;

	public var display_manager:DisplayManager;

	public var state:uint;
	public var background:BitmapData;

	public var loading:BitmapData;
	public var handle:Array;

	public var current:uint, total:uint;
	public var blink_loading:Boolean;
	public var delay_blink:Object;

	public function Level900(source:Core):void {
	
		core = source;
		display_manager = core.display_manager;

		StateTable = core.StateTable;

		current = 0; total = 1;
		loading = new loading_001().bitmapData;

		handle = new Array(7);

		handle[0] = new targethealth_001().bitmapData;
		handle[1] = new targethealth_002().bitmapData;
		handle[2] = new targethealth_003().bitmapData;
		handle[3] = new targethealth_004().bitmapData;
		handle[4] = new targethealth_005().bitmapData;
		handle[5] = new targethealth_006().bitmapData;
		handle[6] = new targethealth_007().bitmapData;

		blink_loading = false;
		delay_blink = core.getDelayable(0, 30);

		state = StateTable.disabled;
		setBackground(1);
		return;
	}

	public function setBackground(id:uint):void {

		if (id == 0) background = new background_001().bitmapData;
		else background = new background_002().bitmapData;

		return;
	}

	public function Dispatch():void {

		state = StateTable.active;
		core.sprite.addEventListener
			(Event.ENTER_FRAME, enterFrame);

		return;
	}

	public function Destroy():void {

		state = StateTable.disabled;
		core.sprite.removeEventListener
			(Event.ENTER_FRAME, enterFrame);

		current = 0; total = 1;
		return;
	}

	public function Process():void {

		if (state == StateTable.disabled) {

			Dispatch();
			return;
		}

		if (core.updateDelayable(delay_blink) == false) {

			if (blink_loading == true) blink_loading = false;
				else { blink_loading = true; }
		}

		return;
	}

	public function drawBackground():void {

		core.display_manager.Draw(background, 0, 0);

		if (blink_loading == false)
		core.display_manager.Draw(loading, 97, 160);

		return;
	}

	public function drawLoadingBar():void {

		var index:uint = uint(6*(current/total));
		display_manager.Draw(handle[index], 136, 120);

		return;
	}

	public function enterFrame(event:Event):void {

		drawBackground();
		drawLoadingBar();
		display_manager.Flip();
		return;
	}
}}
