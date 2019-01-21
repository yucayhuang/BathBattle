package com.feiyu.bathBattle.util
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	/**
	 * 存储一些比较常用的 滤镜 
	 */
	public class Filter
	{
		/**
		 *拖动的时候格子变灰的滤镜 [1,0,0,0,0,  0,1,0,0,0,  0,0,1,0,0,  0,0,0,0.5,0]
		 */
		public static var filter1:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.3,0.3,0,0,  0.3,0.3,0.3,0,0,  0.3,0.3,0.3,0,0,  0,0,0,1,1]);
		
		public static var filter:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.3,0.3,0.12,0.12,  0.3,0.3,0.3,0.12,0.12,  0.3,0.3,0.3,0.12,0.12,  0,0,0,1,1]);
		
		// 
		/**
		 *字体 增加黑色的边框 
		 */
		public static var filter2:GlowFilter = new GlowFilter(0, 1, 2, 2, 4, 1); 
		
		// 
		/**
		 *阴影滤镜 tips使用 
		 */
		public static var filter3:DropShadowFilter = new DropShadowFilter(4) ;

		// 字体 npc 高亮
		public static var filter6:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 45,   0, 1, 0, 0, 45,   0, 0, 1, 0, 45,   0, 0, 0, 1, 0]); 
		
		//字体 阴影
		public static var dropFilter : DropShadowFilter = new DropShadowFilter(0, 45, 0, 1, 2, 2, 10);
		
		// 描黑边
		public static var stroke : GlowFilter = new GlowFilter(0x000000, 0.7, 2, 2, 17, 1, false, false);
	}
}