package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.ui.*;

public class HUDManager {

	public var core:Core;
	public var ConsumableTable:Object;

	public var sound_manager:SoundManager;
	public var resource_manager:ResourceManager;
	public var playable_dolphin:PlayableDolphin;
	public var display_manager:DisplayManager;

	public var StateTable:Object;
	public var KeyTable:Object;

	public var SoundTable:Object;
	public var ResourceTable:Object;

	public var inventory:Array;
	public var total:uint, selected_consumable:int;

	public var dialog_index:int;
	public var dialog_text:Array;
	public var delay_dialog:Object;

	public var blink_airmeter:Boolean;
	public var delay_airmeter:Object;

	public function HUDManager(source:Core):void {

		core = source;
		ConsumableTable = core.ConsumableTable;

		sound_manager = core.sound_manager;
		resource_manager = core.resource_manager;
		playable_dolphin = core.playable_dolphin;
		display_manager = core.display_manager;

		StateTable = core.StateTable;
		KeyTable = core.KeyTable;

		SoundTable = core.sound_manager.SoundTable;
		ResourceTable = core.resource_manager.ResourceTable;

		total = 8; inventory = new Array(total);
		for (var count:uint = 0; count < inventory.length; count++)
			inventory[count] = 1;

		setSelectedConsumable(ConsumableTable.airjar);

		dialog_index = 0;
		delay_dialog = core.getDelayable(0, 800);

		blink_airmeter = false;
		delay_airmeter = core.getDelayable(0, 30);
		return;
	}

	public function setSelectedConsumable(id:int):void {

		if (id >= total) id = ConsumableTable.airjar;

		for (var count:uint = id; count < total; count++) {

			if (inventory[count] > 0) {

				selected_consumable = count;
				return;
			}
		}

		selected_consumable = ConsumableTable.none;
		return; 
	}

	public function setConsumable(id:int, count:uint):void {

		if (count > 0) return;

		if ((count < 0) && (inventory[id] <= 0))
			return;

		inventory[id]+= count;
		setSelectedConsumable(id);
		return;
	}

	public function getCharacter(character:String):int {

		if (character == '\n') return -2;
		if (character == '0') return 23;

		var table:String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\'>"
		var index:int = table.indexOf(character.charAt(0));

		return index;
	}

	public function dispatchMessage(text:Array):void {

		dialog_index = 1;
		dialog_text = text;
		delay_dialog.count = 0;

		return;
	}

	public function displayMessage(caption:String, text:String):void {

		display_manager.Draw(resource_manager
		.handle[ResourceTable.window_001], 24, 30);

		var index:int;
		for (var count:uint = 0; count < caption.length; count++) {

			index = getCharacter(caption.charAt(count));

			if (index >= 0) display_manager
			.Draw(resource_manager.handle[ResourceTable.alpha_1+index],
				(24+8)+(8*count), 32);
		}

		var position:uint = 0; var line:uint = 0;		
		display_manager.Draw(resource_manager
		.handle[ResourceTable.window_002], 24, 42);

		for (count = 0; count < text.length; count++) {
			index = getCharacter(text.charAt(count));

			if (index >= 0) { display_manager
				.Draw(resource_manager.handle[ResourceTable.alpha_1+index],
					(24+8)+(8*position), 43+(10*line));
				position++; }

			else if (index == -2) { display_manager
				.Draw(resource_manager.handle[ResourceTable.window_002],
					24, 42+(10*(++line)));
				position = 0; }

			else position++;

		}

		display_manager.Draw(resource_manager
		.handle[ResourceTable.window_003], 24, 42+(10*(++line)));
		return;
	}

	public function updateMessage():void {

		if (dialog_text == null) return;
		
		if (core.updateDelayable(delay_dialog)) {

			if ((core.keydown[core.KeyTable.j] == true) &&
				(core.keyhold[core.KeyTable.j] == false)) {

				dialog_index++;
				delay_dialog.count = 0;
				core.keyhold[core.KeyTable.j] = true;
			}

			if ((core.keydown[core.KeyTable.j] == false) &&
				(core.keyhold[core.KeyTable.j] == true))
					core.keyhold[core.KeyTable.j] = false;

		} else dialog_index++;

		if (dialog_index >= dialog_text.length) {

			dialog_index = 0;
			dialog_text = null;
			delay_dialog.count = 0;
		}

		return;
	}

	public function Process():void {

		if (playable_dolphin.air <= 0) {

		if (core.updateDelayable(delay_airmeter) == false) {

			if (blink_airmeter == true)
				blink_airmeter = false;
			else {

				blink_airmeter = true;
				sound_manager.play(SoundTable.beep_001);
			}
		}}

		updateMessage();
		return;
	}

	public function drawDialog():void {

		if (dialog_text == null) return;
		displayMessage(dialog_text[0], dialog_text[dialog_index]);
		return;
	}

	public function drawSelector():void {

		if (!(selected_consumable == ConsumableTable.none)) {

			var index:uint = selected_consumable;
			display_manager.Draw(resource_manager
			.handle[ResourceTable.consumable_airjar+index],
				(320-24)/2, 2);
		}

		display_manager.Draw(resource_manager
		.handle[ResourceTable.consumable_selector],
			(320-24)/2, 2);
		return;
	}

	public function drawAirMeter():void {

		var index:int = 0;

		if ((playable_dolphin.state == StateTable.disabled) ||
			(playable_dolphin.air > 0)) {

			display_manager.Draw(resource_manager
			.handle[ResourceTable.sourceair_001],
				320-102, 0);

			return;
		}
 
		if (blink_airmeter == true) index = 0;
			else index = 1;

		display_manager.Draw(resource_manager
		.handle[ResourceTable.sourceair_001+index],
			320-102, 0);
		return;
	}

	public function drawHealthBar():void {

		var index:int = 0;

		if (playable_dolphin.health > 0 && playable_dolphin.health < 6)
			index+= playable_dolphin.health;
		else if (playable_dolphin.health >= 6) index+= 6;

		display_manager.Draw(resource_manager
		.handle[ResourceTable.sourcehealth_001+index],
			320-82, 10);
		return;
	}

	public function Draw():void {

		drawAirMeter();
		drawHealthBar();
		drawSelector()
		drawDialog();

		return;
	}
}}
