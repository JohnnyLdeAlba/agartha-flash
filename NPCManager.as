
package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.ui.*;

public class NPCManager {

	public var core:Core;
	public var playable_dolphin:PlayableDolphin;
	public var viewport_manager:ViewportManager;

	public var StateTable:Object;
	public var NPCTable:Object;

	public var total:int;
	public var handle:Array;

	public var index:int;
	public var next:Array;

	public var npc_fish:Array;
	public var npc_jellyfish:Array;
	public var npc_shark:Array;
	public var npc_lobster:Array;

	public function NPCManager(source:Core):void {

		core = source;
		playable_dolphin = core.playable_dolphin;
		viewport_manager = core.viewport_manager;

		StateTable = core.StateTable;
		NPCTable = core.NPCTable;

		total = 20;
		handle = new Array(total);

		index = 0;
		next = new Array(total);

		npc_fish = new Array(total);
		npc_jellyfish = new Array(total);
		npc_shark = new Array(total);
		npc_lobster = new Array(total);

		for (var count:uint = 0; count < total; count++) {

			handle[count] = NPCTable.none;
			next[count] = 0;

			npc_fish[count] = null;
			npc_jellyfish[count] = null;
			npc_shark[count] = null;
			npc_lobster[count] = null;	
		}

		return;
	}

	public function setNextHandleId(id:int):void {

		next[index] = id;
		index++;

		return;
	}

	public function getNextHandleId():int {

		if (index == 0) return -1;
		index--;
		return next[index];
	}

	public function updateHandle():void {

		for (var count:uint = 0; count < total; count++) {

			switch (handle[count]) { case NPCTable.fish: {

				if (!core.inBound(npc_fish[count].suspend_boundary,
					Rectangle(viewport_manager))) {

					if (!(npc_fish[count].state == StateTable.disabled))
						npc_fish[count].state = StateTable.suspend;
					handle[count] = NPCTable.none;
					setNextHandleId(count);
				}

				break;
			}

			case NPCTable.jellyfish: {

				if (!core.inBound(npc_jellyfish[count].primary_boundary,
					Rectangle(viewport_manager))) {

					npc_jellyfish[count].state = StateTable.suspend;
					handle[count] = NPCTable.none;
					setNextHandleId(count);
				}

				break;
			}

			case NPCTable.shark: {

				if (!core.inBound(npc_shark[count].suspend_boundary,
					Rectangle(viewport_manager))) {

					npc_shark[count].state = StateTable.suspend;
					handle[count] = NPCTable.none;
					setNextHandleId(count);
				}

				break;
			}

			case NPCTable.lobster: {

				if (!core.inBound(npc_lobster[count].primary_boundary,
					Rectangle(viewport_manager))) {

					npc_lobster[count].state = StateTable.suspend;
					handle[count] = NPCTable.none;
					setNextHandleId(count);
				}

				break;
			}

			case NPCTable.none: { setNextHandleId(count); break; }}
		}

		return;
	}

	public function dispatchBlock(block:LevelBlock):void {

		if (block == null) return;

		var count:uint = 0;
		var id:uint = 0;

		if (!(block.npc_fish == null))
		for (count = 0; count < block.npc_fish.length; count++) {

			id = getNextHandleId();
			if (id == -1) return;

			if (block.npc_fish[count].state == StateTable.suspend) {

			if (core.inBound(block.npc_fish[count].suspend_boundary,
				Rectangle(viewport_manager))) {

				handle[id] = NPCTable.fish;
				npc_fish[id] = block.npc_fish[count];
				npc_fish[id].state = StateTable.active;
			}}
		}

		if (!(block.npc_jellyfish == null))
		for (count = 0; count < block.npc_jellyfish.length; count++) {

			id = getNextHandleId();
			if (id == -1) return;

			if (block.npc_jellyfish[count].state == StateTable.suspend) {

			if (core.inBound(block.npc_jellyfish[count].primary_boundary,
				Rectangle(viewport_manager))) {

				handle[id] = NPCTable.jellyfish;
				npc_jellyfish[id] = block.npc_jellyfish[count];
				npc_jellyfish[id].state = StateTable.active;
			}}
		}

		if (!(block.npc_shark == null))
		for (count = 0; count < block.npc_shark.length; count++) {

			id = getNextHandleId();
			if (id == -1) return;

			if (block.npc_shark[count].state == StateTable.suspend) {

			if (core.inBound(block.npc_shark[count].suspend_boundary,
				Rectangle(viewport_manager))) {

				handle[id] = NPCTable.shark;
				npc_shark[id] = block.npc_shark[count];
				npc_shark[id].state = StateTable.active;
			}}
		}

		if (!(block.npc_lobster == null))
		for (count = 0; count < block.npc_lobster.length; count++) {

			id = getNextHandleId();
			if (id == -1) return;

			if (block.npc_lobster[count].state == StateTable.suspend) {

			if (core.inBound(block.npc_lobster[count].primary_boundary,
				Rectangle(viewport_manager))) {

				handle[id] = NPCTable.lobster;
				npc_lobster[id] = block.npc_lobster[count];
				npc_lobster[id].state = StateTable.active;
			}}
		}

		return;
	}

	public function dispatchQuadrant(quadrant:Array):void {

		updateHandle();
		for (var count:uint = 0; count < quadrant.length; count++)
			dispatchBlock(quadrant[count]);

		return;
	}

	public function processBlock(block:LevelBlock):void {

		if (block == null) return;

		var count:uint = 0;
		var id:uint = 0;

		if (!(block.npc_fish == null))
		for (count = 0; count < block.npc_fish.length; count++) {

			id = getNextHandleId();
			if (id == -1) return;

			if (block.npc_fish[count].state == StateTable.suspend) {

			if (core.inBound(block.npc_fish[count].suspend_boundary,
				Rectangle(viewport_manager))) {
			if (!core.inBound(Rectangle(block.npc_fish[count]),
				Rectangle(viewport_manager))) {

				handle[id] = NPCTable.fish;
				npc_fish[id] = block.npc_fish[count];
				npc_fish[id].state = StateTable.active;
			}}}
		}

		if (!(block.npc_jellyfish == null))
		for (count = 0; count < block.npc_jellyfish.length; count++) {

			id = getNextHandleId();
			if (id == -1) return;

			if (block.npc_jellyfish[count].state == StateTable.suspend) {

			if (core.inBound(block.npc_jellyfish[count].primary_boundary,
				Rectangle(viewport_manager))) {
			if (!core.inBound(block.npc_jellyfish[count].current,
				Rectangle(viewport_manager))) {

				handle[id] = NPCTable.jellyfish;
				npc_jellyfish[id] = block.npc_jellyfish[count];
				npc_jellyfish[id].state = StateTable.active;
			}}}
		}

		if (!(block.npc_shark == null))
		for (count = 0; count < block.npc_shark.length; count++) {

			id = getNextHandleId();
			if (id == -1) return;

			if (block.npc_shark[count].state == StateTable.suspend) {

			if (core.inBound(block.npc_shark[count].suspend_boundary,
				Rectangle(viewport_manager))) {
			if (!core.inBound(Rectangle(block.npc_shark[count]),
				Rectangle(viewport_manager))) {

				handle[id] = NPCTable.shark;
				npc_shark[id] = block.npc_shark[count];
				npc_shark[id].state = StateTable.active;
			}}}
		}

		if (!(block.npc_lobster == null))
		for (count = 0; count < block.npc_lobster.length; count++) {

			id = getNextHandleId();
			if (id == -1) return;

			if (block.npc_lobster[count].state == StateTable.suspend) {

			if (core.inBound(block.npc_lobster[count].primary_boundary,
				Rectangle(viewport_manager))) {
			if (!core.inBound(block.npc_lobster[count].current,
				Rectangle(viewport_manager))) {

				handle[id] = NPCTable.lobster;
				npc_lobster[id] = block.npc_lobster[count];
				npc_lobster[id].state = StateTable.active;
			}}}
		}

		return;
	}

	public function processQuadrant(quadrant:Array):void {

		updateHandle();
		for (var count:uint = 0; count < quadrant.length; count++)
			processBlock(quadrant[count]);

		return;
	}

	public function Process():void {

		for (var count:uint = 0; count < total; count++) {

		switch (handle[count]) { case NPCTable.fish: {

			npc_fish[count].Process();
			npc_fish[count].inBoundaryPlayable();

			break;
		}

		case NPCTable.jellyfish: {

			npc_jellyfish[count].Process();
			npc_jellyfish[count].inBoundaryPlayable();

			npc_jellyfish[count].inBoundarySonar();
			npc_jellyfish[count].inBoundaryProjectile();

			break;
		}

		case NPCTable.shark: {

			npc_shark[count].Process();
			npc_shark[count].inBoundaryPlayable();

			npc_shark[count].inBoundarySonar();
			npc_shark[count].inBoundaryProjectile();

			break;
		}

		case NPCTable.lobster: {

			npc_lobster[count].Process();
			npc_lobster[count].inBoundaryPlayable();

			npc_lobster[count].inBoundarySonar();
			npc_lobster[count].inBoundaryProjectile();

			break;
		}}}

		return;
	}

	public function Draw():void {

		for (var count:uint = 0; count < total; count++) {

		switch (handle[count]) { case NPCTable.fish: {

			npc_fish[count].Draw();
			break;
		}

		case NPCTable.jellyfish: {

			npc_jellyfish[count].Draw();
			break;
		}

		case NPCTable.shark: {

			npc_shark[count].Draw();
			break;
		}

		case NPCTable.lobster: {

			npc_lobster[count].Draw();
			break;
		}}}

		return;
	}
}}
