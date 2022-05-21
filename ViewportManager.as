
package agartha {

import flash.geom.*;

public class ViewportManager extends Rectangle {

	public var core:Core;
	public var playable_dolphin:PlayableDolphin;

	public var WorldWidth:int, WorldHeight:int;
	public var previous:Point;
	public var current:Rectangle;

	public function setPoint(x:int, y:int):void { this.x = x; this.y = y; return; }

	public function ViewportManager(source:Core):void {
	
		core = source;
		playable_dolphin = core.playable_dolphin;

		x = 0; y = 0;
		width = 320; height = 240;

		WorldWidth = 0; WorldHeight = 0;
		previous = new Point(0, 0);
		current = new Rectangle(x, y, width, height);

		return;
	}

	public function setWorldSize(w:int, h:int):void {
		
		WorldWidth = w;
		WorldHeight = h;

		return;
	}

	public function xUpdate():void {

		var Center:int = x+(width/2);
		trace(x);
		if (playable_dolphin.x < previous.x) {
			if ((x > 0) && (playable_dolphin.x+playable_dolphin.width <= Center))
				x+= (playable_dolphin.x-previous.x);

		} else if (playable_dolphin.x > previous.x)
			if ((x+width < WorldWidth) && (playable_dolphin.x >= Center))
				x+= (playable_dolphin.x-previous.x);
		
		if (x < 0) x = 0;
		else if (x+width > WorldWidth)
			x = WorldWidth-width;

		previous.x = playable_dolphin.x;
		return;
	}

	public function yUpdate():void {

		var Center:int = y+(height/2);

		if (playable_dolphin.y < previous.y) {
			if ((y > 0) && ((playable_dolphin.y+playable_dolphin.height) <= Center))
				y+= (playable_dolphin.y-previous.y);

		} else if (playable_dolphin.y > previous.y)
			if ((y+height < WorldHeight) && (playable_dolphin.y >= Center))
				y+= (playable_dolphin.y-previous.y);
		
		if (y < 0) y = 0;
		else if (y+height > WorldHeight)
			y = WorldHeight-height;

		previous.y = playable_dolphin.y;
		return;
	}

	public function Update():void {

		xUpdate();
		yUpdate();

		current.x = x;
		current.y = y;
		return;
	}

	public function TranslateToViewport(current:Rectangle):Rectangle {

		return (new Rectangle(current.x-x, current.y-y,
			current.width, current.height));
	}
}}
