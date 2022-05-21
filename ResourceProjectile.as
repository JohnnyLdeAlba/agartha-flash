
package agartha {

internal class ResourceProjectile {

	[Embed(source='data/burstable-001.png')] private var burstable_001:Class;
	[Embed(source='data/burstable-002.png')] private var burstable_002:Class;
	[Embed(source='data/burstable-003.png')] private var burstable_003:Class;

	[Embed(source='data/sonar-001.png')] private var sonar_001:Class;
	[Embed(source='data/sonar-002.png')] private var sonar_002:Class;
	[Embed(source='data/sonar-011.png')] private var sonar_011:Class;
	[Embed(source='data/sonar-012.png')] private var sonar_012:Class;
	[Embed(source='data/sonar-021.png')] private var sonar_021:Class;
	[Embed(source='data/sonar-022.png')] private var sonar_022:Class;
	[Embed(source='data/sonar-031.png')] private var sonar_031:Class;
	[Embed(source='data/sonar-032.png')] private var sonar_032:Class;

	[Embed(source='data/bubble-001.png')] private var bubble_001:Class;
	[Embed(source='data/bubble-002.png')] private var bubble_002:Class;

	[Embed(source='data/laser-001.png')] private var laser_001:Class;
	[Embed(source='data/laser-011.png')] private var laser_011:Class;
	[Embed(source='data/laser-021.png')] private var laser_021:Class;
	[Embed(source='data/laser-031.png')] private var laser_031:Class;

	[Embed(source='data/shielddevice-001.png')] private var shielddevice_001:Class;
	[Embed(source='data/shielddevice-002.png')] private var shielddevice_002:Class;
	[Embed(source='data/shield-001.png')] private var shield_001:Class;

	private var handle:Array;

	public function ResourceProjectile():void {

		handle = new Array(20);

		handle[0] = new burstable_001().bitmapData;
		handle[1] = new burstable_002().bitmapData;
		handle[2] = new burstable_003().bitmapData;

		handle[3] = new sonar_001().bitmapData;
		handle[4] = new sonar_002().bitmapData;
		handle[5] = new sonar_011().bitmapData;
		handle[6] = new sonar_012().bitmapData;
		handle[7] = new sonar_021().bitmapData;
		handle[8] = new sonar_022().bitmapData;
		handle[9] = new sonar_031().bitmapData;
		handle[10] = new sonar_032().bitmapData;

		handle[11] = new bubble_001().bitmapData;
		handle[12] = new bubble_002().bitmapData;

		handle[13] = new laser_001().bitmapData;
		handle[14] = new laser_011().bitmapData;
		handle[15] = new laser_021().bitmapData;
		handle[16] = new laser_031().bitmapData;

		handle[17] = new shielddevice_001().bitmapData;
		handle[18] = new shielddevice_002().bitmapData;
		handle[19] = new shield_001().bitmapData;

		return;
	}

	public function getResource():Array { return handle; }
}}
