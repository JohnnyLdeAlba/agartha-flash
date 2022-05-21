
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.ui.*;

internal class SoundManager {

	public var previous_index:int, index:int;
	public var total:uint;

	public var SoundTable:Object;
	public var urlRequest:Array, handle:Array;
	public var soundLoader:Sound;

	public var soundchannel:Array;

	public function SoundManager():void {

		loadSoundTable();
		loadUrlRequest();

		previous_index = -1; index = 0;
		handle = new Array(total);
	
		soundchannel = new Array(2);
		soundchannel[0] = new SoundChannel();
		soundchannel[1] = new SoundChannel();

		return;
	}

	public function loadSoundTable():void {

		var index:int = 0;

		SoundTable = new Object();
		SoundTable = {

			beep_001: index,
			bubble_001: ++index,
			burst_001: ++index,
			cast_001: ++index,
			cast_002: ++index,
			crystal_001: ++index,
			damage_001: ++index,
			damage_002: ++index,
			glob_001: ++index,
			laser_001: ++index,
			sonar_001: ++index,
			track_001: ++index
		}

		total = ++index;
		return;
	}

	public function loadUrlRequest():void {

		urlRequest = new Array(total);

		urlRequest[SoundTable.beep_001] = new URLRequest('data/soundfx-beepsimple-01.mp3');
		urlRequest[SoundTable.bubble_001] = new URLRequest('data/waterbubblelite-03.mp3');
		urlRequest[SoundTable.burst_001] = new URLRequest('data/soundfx-gun357mag-16.mp3');
		urlRequest[SoundTable.cast_001] = new URLRequest('data/soundfx-tinklehighlight-09.mp3');
		urlRequest[SoundTable.cast_002] = new URLRequest('data/soundfx-tinklehighlight-01.mp3');
		urlRequest[SoundTable.crystal_001] = new URLRequest('data/soundfx-spaceagenav-21.mp3');
		urlRequest[SoundTable.damage_001] = new URLRequest('data/soundfx-tapir-04.mp3');
		urlRequest[SoundTable.damage_002] = new URLRequest('data/soundfx-bling-01.mp3');
		urlRequest[SoundTable.glob_001] = new URLRequest('data/soundfx-goop19.mp3');
		urlRequest[SoundTable.laser_001] = new URLRequest('data/soundfx-scifigeneral-53.mp3');
		urlRequest[SoundTable.sonar_001] = new URLRequest('data/soundfx-raccoonquestion-short-02.mp3');
		urlRequest[SoundTable.track_001] = new URLRequest('data/crestoe-sea-of-peril.mp3');

		return;
	}

	public function play(index:uint, channel:uint = 0):void {
	
		switch (channel) { case 0: { handle[index].play();
			break; }

		case 1: { soundchannel[0].stop();
			soundchannel[0] = handle[index].play();
			break; }}
	
		return;
	}

	public function getResource():void {

		if (previous_index == index)
			return;

		previous_index = index;

		soundLoader = new Sound();
		soundLoader.load(urlRequest[index]);
		soundLoader.addEventListener(Event.COMPLETE,
			loaderComplete);
		return;
	}

	public function loaderComplete(event:Event):void {

		handle[index] = soundLoader;
		++index; return;
	}

	public function getTrack001():Sound { return handle[SoundTable.track_001]; }
}}
