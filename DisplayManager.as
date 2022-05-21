
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.ui.*;

public class DisplayManager {

	public var stage:Stage;
	public var sprite:Sprite;

	public var handle:Bitmap;
	public var physical_display:BitmapData;
	public var logical_display:BitmapData;

	public function DisplayManager(source:Sprite):void {

		sprite = source;
		stage = source.stage;

		physical_display = new BitmapData(320, 240, false, 0xFF000000);
		logical_display = new BitmapData(320, 240, false, 0xFF000000);

		handle = new Bitmap(physical_display);
		handle.scaleX = 2; handle.scaleY = 2;

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;

		sprite.addChild(handle);
		return;
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

	public function toggleFullScreen():void {

		if (stage.displayState == StageDisplayState.NORMAL) {

			stage.fullScreenSourceRect = new Rectangle(0, 0, 640,480);
			stage.displayState = StageDisplayState.FULL_SCREEN;

		} else stage.displayState = StageDisplayState.NORMAL;

		return;
	}

	public function drawRect(source:Rectangle, color:uint):void {

		var rectangle:Shape = new Shape();

		rectangle.graphics.lineStyle(1, color);
		rectangle.graphics.drawRect(source.x, source.y,
			source.width, source.height);

		logical_display.draw(rectangle);
		return;
	}

	public function Draw(source:BitmapData, x:Number, y:Number):void {

		logical_display.copyPixels(source, source.rect,
			new Point(x, y));
		return;
	}

	public function Flip():void {

		physical_display.copyPixels(logical_display,
			logical_display.rect, new Point(0, 0));
		logical_display.fillRect(logical_display.rect,
			0xFF000000);
		return;
	}
}}


