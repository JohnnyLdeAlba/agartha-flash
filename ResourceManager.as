package agartha {

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.net.*;
import flash.ui.*;

public class ResourceManager {

	public var core:Core;
	public var StateTable:Object;

	public var previous_index:int, index:int;
	public var total:uint;

	public var ResourceTable:Object;
	public var urlRequest:Array, handle:Array;
	public var bitmapLoader:Loader;
	
	public function ResourceManager():void {

		loadResourceTable();
		loadUrlRequest();

		previous_index = -1; index = 0;
		handle = new Array(total);

		bitmapLoader = new Loader();
		bitmapLoader.contentLoaderInfo
		.addEventListener(Event.COMPLETE, loaderComplete);
		
		return;
	}

	public function loadResourceTable():void {

		var index:int = 0;
		ResourceTable = new Object;

		ResourceTable = {

			alpha_1:index,
			alpha_2:++index,
			alpha_3:++index,
			alpha_4:++index,
			alpha_5:++index,
			alpha_6:++index,
			alpha_7:++index,
			alpha_8:++index,
			alpha_9:++index,

			alpha_a:++index,
			alpha_b:++index,
			alpha_c:++index,
			alpha_d:++index,
			alpha_e:++index,
			alpha_f:++index,
			alpha_g:++index,
			alpha_h:++index,
			alpha_i:++index,
			alpha_j:++index,
			alpha_k:++index,
			alpha_l:++index,
			alpha_m:++index,
			alpha_n:++index,
			alpha_o:++index,
			alpha_p:++index,
			alpha_q:++index,
			alpha_r:++index,
			alpha_s:++index,
			alpha_t:++index,
			alpha_u:++index,
			alpha_v:++index,
			alpha_w:++index,
			alpha_x:++index,
			alpha_y:++index,
			alpha_z:++index,

			alpha_period:++index,
			alpha_comma:++index,
			alpha_quote:++index,
			alpha_more:++index,

			window_001:++index,
			window_002:++index,
			window_003:++index,

			sourceair_001:++index,
			sourceair_002:++index,

			sourcehealth_001:++index,
			sourcehealth_002:++index,
			sourcehealth_003:++index,
			sourcehealth_004:++index,
			sourcehealth_005:++index,
			sourcehealth_006:++index,
			sourcehealth_007:++index,

			targethealth_001:++index,
			targethealth_002:++index,
			targethealth_003:++index,
			targethealth_004:++index,
			targethealth_005:++index,
			targethealth_006:++index,
			targethealth_007:++index,

			consumable_selector:++index,
			consumable_airjar:++index,
			consumable_healthjar:++index,
			consumable_bomb:++index,
			consumable_megabomb:++index,
			consumable_laser:++index,
			consumable_shield:++index,
			consumable_photon:++index,
			consumable_prototype:++index,

			bubble_001:++index,
			bubble_002:++index,

			burstable_001:++index,
			burstable_002:++index,
			burstable_003:++index,

			sonar_001:++index,
			sonar_002:++index,
			sonar_003:++index,
			sonar_004:++index,
			sonar_005:++index,
			sonar_006:++index,
			sonar_007:++index,
			sonar_008:++index,

			laser_001:++index,
			laser_002:++index,
			laser_003:++index,
			laser_004:++index,

			photon_001:++index,
			photon_002:++index,

			shielddevice_001:++index,
			shielddevice_002:++index,
			shield_001:++index,

			surface_001:++index,
			surface_002:++index,

			dolphin_001:++index,
			dolphin_002:++index,
			dolphin_003:++index,
			dolphin_004:++index,
			dolphin_005:++index,

			dolphin_006:++index,
			dolphin_007:++index,
			dolphin_008:++index,
			dolphin_009:++index,
			dolphin_010:++index,

			dolphin_011:++index,
			dolphin_012:++index,
			dolphin_013:++index,
			dolphin_014:++index,

			dolphin_015:++index,
			dolphin_016:++index,
			dolphin_017:++index,
			dolphin_018:++index,

			hercules_001:++index,
			hercules_002:++index,

			crystal_001:++index,

			coral_001:++index,
			coral_002:++index,

			fish_001:++index,
			fish_002:++index,

			jellyfish_001:++index,
			jellyfish_002:++index,
			jellyfish_003:++index,

			lionsmane_001:++index,
			lionsmane_002:++index,
			lionsmane_003:++index,

			shark_001:++index,
			shark_002:++index,
			shark_003:++index,
			shark_004:++index,
			shark_005:++index,
			shark_006:++index,
			shark_007:++index,
			shark_008:++index,

			reefshark_001:++index,
			reefshark_002:++index,
			reefshark_003:++index,
			reefshark_004:++index,
			reefshark_005:++index,
			reefshark_006:++index,
			reefshark_007:++index,
			reefshark_008:++index,

			blueray_001:++index,
			blueray_002:++index,
			blueray_003:++index,
			blueray_004:++index,
			blueray_005:++index,
			blueray_006:++index,

			brownray_001:++index,
			brownray_002:++index,
			brownray_003:++index,
			brownray_004:++index,
			brownray_005:++index,
			brownray_006:++index,

			lobster_001:++index,
			lobster_002:++index,
			lobster_003:++index,
			lobster_004:++index,
			lobster_005:++index,
			lobster_006:++index
		}

		total = ++index;
		return;
	}

	public function loadUrlRequest():void {

		urlRequest = new Array(total);

		urlRequest[ResourceTable.alpha_1] = new URLRequest('data/alpha-1.png');
		urlRequest[ResourceTable.alpha_2] = new URLRequest('data/alpha-2.png');
		urlRequest[ResourceTable.alpha_3] = new URLRequest('data/alpha-3.png');
		urlRequest[ResourceTable.alpha_4] = new URLRequest('data/alpha-4.png');
		urlRequest[ResourceTable.alpha_5] = new URLRequest('data/alpha-5.png');
		urlRequest[ResourceTable.alpha_6] = new URLRequest('data/alpha-6.png');
		urlRequest[ResourceTable.alpha_7] = new URLRequest('data/alpha-7.png');
		urlRequest[ResourceTable.alpha_8] = new URLRequest('data/alpha-8.png');
		urlRequest[ResourceTable.alpha_9] = new URLRequest('data/alpha-9.png');

		urlRequest[ResourceTable.alpha_a] = new URLRequest('data/alpha-a.png');
		urlRequest[ResourceTable.alpha_b] = new URLRequest('data/alpha-b.png');
		urlRequest[ResourceTable.alpha_c] = new URLRequest('data/alpha-c.png');
		urlRequest[ResourceTable.alpha_d] = new URLRequest('data/alpha-d.png');
		urlRequest[ResourceTable.alpha_e] = new URLRequest('data/alpha-e.png');
		urlRequest[ResourceTable.alpha_f] = new URLRequest('data/alpha-f.png');
		urlRequest[ResourceTable.alpha_g] = new URLRequest('data/alpha-g.png');
		urlRequest[ResourceTable.alpha_h] = new URLRequest('data/alpha-h.png');
		urlRequest[ResourceTable.alpha_i] = new URLRequest('data/alpha-i.png');
		urlRequest[ResourceTable.alpha_j] = new URLRequest('data/alpha-j.png');
		urlRequest[ResourceTable.alpha_k] = new URLRequest('data/alpha-k.png');
		urlRequest[ResourceTable.alpha_l] = new URLRequest('data/alpha-l.png');
		urlRequest[ResourceTable.alpha_m] = new URLRequest('data/alpha-m.png');
		urlRequest[ResourceTable.alpha_n] = new URLRequest('data/alpha-n.png');
		urlRequest[ResourceTable.alpha_o] = new URLRequest('data/alpha-o.png');
		urlRequest[ResourceTable.alpha_p] = new URLRequest('data/alpha-p.png');
		urlRequest[ResourceTable.alpha_q] = new URLRequest('data/alpha-q.png');
		urlRequest[ResourceTable.alpha_r] = new URLRequest('data/alpha-r.png');
		urlRequest[ResourceTable.alpha_s] = new URLRequest('data/alpha-s.png');
		urlRequest[ResourceTable.alpha_t] = new URLRequest('data/alpha-t.png');
		urlRequest[ResourceTable.alpha_u] = new URLRequest('data/alpha-u.png');
		urlRequest[ResourceTable.alpha_v] = new URLRequest('data/alpha-v.png');
		urlRequest[ResourceTable.alpha_w] = new URLRequest('data/alpha-w.png');
		urlRequest[ResourceTable.alpha_x] = new URLRequest('data/alpha-x.png');
		urlRequest[ResourceTable.alpha_y] = new URLRequest('data/alpha-y.png');
		urlRequest[ResourceTable.alpha_z] = new URLRequest('data/alpha-z.png');

		urlRequest[ResourceTable.alpha_period] = new URLRequest('data/alpha-period.png');
		urlRequest[ResourceTable.alpha_comma] = new URLRequest('data/alpha-comma.png');
		urlRequest[ResourceTable.alpha_quote] = new URLRequest('data/alpha-quote.png');
		urlRequest[ResourceTable.alpha_more] = new URLRequest('data/alpha-more.png');

		urlRequest[ResourceTable.window_001] = new URLRequest('data/window-001.png');
		urlRequest[ResourceTable.window_002] = new URLRequest('data/window-002.png');
		urlRequest[ResourceTable.window_003] = new URLRequest('data/window-003.png');

		urlRequest[ResourceTable.sourceair_001] = new URLRequest('data/sourceair-001.png');
		urlRequest[ResourceTable.sourceair_002] = new URLRequest('data/sourceair-002.png');

		urlRequest[ResourceTable.sourcehealth_001] = new URLRequest('data/sourcehealth-001.png');
		urlRequest[ResourceTable.sourcehealth_002] = new URLRequest('data/sourcehealth-002.png');
		urlRequest[ResourceTable.sourcehealth_003] = new URLRequest('data/sourcehealth-003.png');
		urlRequest[ResourceTable.sourcehealth_004] = new URLRequest('data/sourcehealth-004.png');
		urlRequest[ResourceTable.sourcehealth_005] = new URLRequest('data/sourcehealth-005.png');
		urlRequest[ResourceTable.sourcehealth_006] = new URLRequest('data/sourcehealth-006.png');
		urlRequest[ResourceTable.sourcehealth_007] = new URLRequest('data/sourcehealth-007.png');

		urlRequest[ResourceTable.targethealth_001] = new URLRequest('data/targethealth-001.png');
		urlRequest[ResourceTable.targethealth_002] = new URLRequest('data/targethealth-002.png');
		urlRequest[ResourceTable.targethealth_003] = new URLRequest('data/targethealth-003.png');
		urlRequest[ResourceTable.targethealth_004] = new URLRequest('data/targethealth-004.png');
		urlRequest[ResourceTable.targethealth_005] = new URLRequest('data/targethealth-005.png');
		urlRequest[ResourceTable.targethealth_006] = new URLRequest('data/targethealth-006.png');
		urlRequest[ResourceTable.targethealth_007] = new URLRequest('data/targethealth-007.png');

		urlRequest[ResourceTable.consumable_selector] = new URLRequest('data/consumable-selector.png');
		urlRequest[ResourceTable.consumable_airjar] = new URLRequest('data/consumable-airjar.png');
		urlRequest[ResourceTable.consumable_healthjar] = new URLRequest('data/consumable-healthjar.png');
		urlRequest[ResourceTable.consumable_bomb] = new URLRequest('data/consumable-bomb.png');
		urlRequest[ResourceTable.consumable_megabomb] = new URLRequest('data/consumable-megabomb.png');
		urlRequest[ResourceTable.consumable_laser] = new URLRequest('data/consumable-laser.png');
		urlRequest[ResourceTable.consumable_shield] = new URLRequest('data/consumable-shield.png');
		urlRequest[ResourceTable.consumable_photon] = new URLRequest('data/consumable-photon.png');
		urlRequest[ResourceTable.consumable_prototype] = new URLRequest('data/consumable-prototype.png');

		urlRequest[ResourceTable.bubble_001] = new URLRequest('data/bubble-001.png');
		urlRequest[ResourceTable.bubble_002] = new URLRequest('data/bubble-002.png');

		urlRequest[ResourceTable.burstable_001] = new URLRequest('data/burstable-001.png');
		urlRequest[ResourceTable.burstable_002] = new URLRequest('data/burstable-001.png');
		urlRequest[ResourceTable.burstable_003] = new URLRequest('data/burstable-001.png');

		urlRequest[ResourceTable.sonar_001] = new URLRequest('data/sonar-001.png');
		urlRequest[ResourceTable.sonar_002] = new URLRequest('data/sonar-002.png');
		urlRequest[ResourceTable.sonar_003] = new URLRequest('data/sonar-003.png');
		urlRequest[ResourceTable.sonar_004] = new URLRequest('data/sonar-004.png');
		urlRequest[ResourceTable.sonar_005] = new URLRequest('data/sonar-005.png');
		urlRequest[ResourceTable.sonar_006] = new URLRequest('data/sonar-006.png');
		urlRequest[ResourceTable.sonar_007] = new URLRequest('data/sonar-007.png');
		urlRequest[ResourceTable.sonar_008] = new URLRequest('data/sonar-008.png');

		urlRequest[ResourceTable.laser_001] = new URLRequest('data/laser-001.png');
		urlRequest[ResourceTable.laser_002] = new URLRequest('data/laser-002.png');
		urlRequest[ResourceTable.laser_003] = new URLRequest('data/laser-003.png');
		urlRequest[ResourceTable.laser_004] = new URLRequest('data/laser-004.png');

		urlRequest[ResourceTable.photon_001] = new URLRequest('data/photon-001.png');
		urlRequest[ResourceTable.photon_002] = new URLRequest('data/photon-002.png');

		urlRequest[ResourceTable.shielddevice_001] = new URLRequest('data/shielddevice-001.png');
		urlRequest[ResourceTable.shielddevice_002] = new URLRequest('data/shielddevice-001.png');
		urlRequest[ResourceTable.shield_001] = new URLRequest('data/shield-001.png');

		urlRequest[ResourceTable.surface_001] = new URLRequest('data/surface-001.png');
		urlRequest[ResourceTable.surface_002] = new URLRequest('data/surface-002.png');

		urlRequest[ResourceTable.dolphin_001] = new URLRequest('data/dolphin-001.png');
		urlRequest[ResourceTable.dolphin_002] = new URLRequest('data/dolphin-002.png');
		urlRequest[ResourceTable.dolphin_003] = new URLRequest('data/dolphin-003.png');
		urlRequest[ResourceTable.dolphin_004] = new URLRequest('data/dolphin-004.png');
		urlRequest[ResourceTable.dolphin_005] = new URLRequest('data/dolphin-005.png');

		urlRequest[ResourceTable.dolphin_006] = new URLRequest('data/dolphin-006.png');
		urlRequest[ResourceTable.dolphin_007] = new URLRequest('data/dolphin-007.png');
		urlRequest[ResourceTable.dolphin_008] = new URLRequest('data/dolphin-008.png');
		urlRequest[ResourceTable.dolphin_009] = new URLRequest('data/dolphin-009.png');
		urlRequest[ResourceTable.dolphin_010] = new URLRequest('data/dolphin-010.png');

		urlRequest[ResourceTable.dolphin_011] = new URLRequest('data/dolphin-011.png');
		urlRequest[ResourceTable.dolphin_012] = new URLRequest('data/dolphin-012.png');
		urlRequest[ResourceTable.dolphin_013] = new URLRequest('data/dolphin-013.png');
		urlRequest[ResourceTable.dolphin_014] = new URLRequest('data/dolphin-014.png');

		urlRequest[ResourceTable.dolphin_015] = new URLRequest('data/dolphin-015.png');
		urlRequest[ResourceTable.dolphin_016] = new URLRequest('data/dolphin-016.png');
		urlRequest[ResourceTable.dolphin_017] = new URLRequest('data/dolphin-017.png');
		urlRequest[ResourceTable.dolphin_018] = new URLRequest('data/dolphin-018.png');

		urlRequest[ResourceTable.hercules_001] = new URLRequest('data/hercules-001.png');
		urlRequest[ResourceTable.hercules_002] = new URLRequest('data/hercules-002.png');

		urlRequest[ResourceTable.crystal_001] = new URLRequest('data/crystal-001.png');

		urlRequest[ResourceTable.coral_001] = new URLRequest('data/coral-001.png');
		urlRequest[ResourceTable.coral_002] = new URLRequest('data/coral-002.png');

		urlRequest[ResourceTable.fish_001] = new URLRequest('data/fish-001.png');
		urlRequest[ResourceTable.fish_002] = new URLRequest('data/fish-002.png');

		urlRequest[ResourceTable.jellyfish_001] = new URLRequest('data/bluejelly-001.png');
		urlRequest[ResourceTable.jellyfish_002] = new URLRequest('data/bluejelly-002.png');
		urlRequest[ResourceTable.jellyfish_003] = new URLRequest('data/bluejelly-003.png');

		urlRequest[ResourceTable.lionsmane_001] = new URLRequest('data/lionsmane-001.png');
		urlRequest[ResourceTable.lionsmane_002] = new URLRequest('data/lionsmane-002.png');
		urlRequest[ResourceTable.lionsmane_003] = new URLRequest('data/lionsmane-003.png');

		urlRequest[ResourceTable.shark_001] = new URLRequest('data/blueshark-001.png');
		urlRequest[ResourceTable.shark_002] = new URLRequest('data/blueshark-002.png');
		urlRequest[ResourceTable.shark_003] = new URLRequest('data/blueshark-003.png');
		urlRequest[ResourceTable.shark_004] = new URLRequest('data/blueshark-004.png');
		urlRequest[ResourceTable.shark_005] = new URLRequest('data/blueshark-005.png');
		urlRequest[ResourceTable.shark_006] = new URLRequest('data/blueshark-006.png');
		urlRequest[ResourceTable.shark_007] = new URLRequest('data/blueshark-007.png');
		urlRequest[ResourceTable.shark_008] = new URLRequest('data/blueshark-008.png');

		urlRequest[ResourceTable.reefshark_001] = new URLRequest('data/reefshark-001.png');
		urlRequest[ResourceTable.reefshark_002] = new URLRequest('data/reefshark-002.png');
		urlRequest[ResourceTable.reefshark_003] = new URLRequest('data/reefshark-003.png');
		urlRequest[ResourceTable.reefshark_004] = new URLRequest('data/reefshark-004.png');
		urlRequest[ResourceTable.reefshark_005] = new URLRequest('data/reefshark-005.png');
		urlRequest[ResourceTable.reefshark_006] = new URLRequest('data/reefshark-006.png');
		urlRequest[ResourceTable.reefshark_007] = new URLRequest('data/reefshark-007.png');
		urlRequest[ResourceTable.reefshark_008] = new URLRequest('data/reefshark-008.png');

		urlRequest[ResourceTable.blueray_001] = new URLRequest('data/blueray-001.png');
		urlRequest[ResourceTable.blueray_002] = new URLRequest('data/blueray-002.png');
		urlRequest[ResourceTable.blueray_003] = new URLRequest('data/blueray-003.png');
		urlRequest[ResourceTable.blueray_004] = new URLRequest('data/blueray-004.png');
		urlRequest[ResourceTable.blueray_005] = new URLRequest('data/blueray-005.png');
		urlRequest[ResourceTable.blueray_006] = new URLRequest('data/blueray-006.png');

		urlRequest[ResourceTable.brownray_001] = new URLRequest('data/brownray-001.png');
		urlRequest[ResourceTable.brownray_002] = new URLRequest('data/brownray-002.png');
		urlRequest[ResourceTable.brownray_003] = new URLRequest('data/brownray-003.png');
		urlRequest[ResourceTable.brownray_004] = new URLRequest('data/brownray-004.png');
		urlRequest[ResourceTable.brownray_005] = new URLRequest('data/brownray-005.png');
		urlRequest[ResourceTable.brownray_006] = new URLRequest('data/brownray-006.png');

		urlRequest[ResourceTable.lobster_001] = new URLRequest('data/lobster-001.png');
		urlRequest[ResourceTable.lobster_002] = new URLRequest('data/lobster-002.png');
		urlRequest[ResourceTable.lobster_003] = new URLRequest('data/lobster-003.png');
		urlRequest[ResourceTable.lobster_004] = new URLRequest('data/lobster-004.png');
		urlRequest[ResourceTable.lobster_005] = new URLRequest('data/lobster-005.png');
		urlRequest[ResourceTable.lobster_006] = new URLRequest('data/lobster-006.png');

		return;
	}

	public function getResource():void {

		if (previous_index == index)
			return;

		previous_index = index;
		bitmapLoader.load(urlRequest[index]);
		return;
	}

	public function loaderComplete(event:Event):void {

		handle[index] = Bitmap(bitmapLoader.content).bitmapData;
		++index; return;
	}
}}
