package com.feiyu.bathBattle.util
{
	
	/**
	 * 游戏参数 
	 * @author hyc
	 * 
	 */	
	public class GameUtil{
		
		//---------------------------- 屏幕属性 -------------------------//
		/**
		 * 屏幕宽度 
		 */		
		public static const screenWidth:Number = 1920;
		/**
		 * 屏幕高度 
		 */		
		public static const screenHeight:Number = 1080;
		/**
		 * 绳子绘制区域Y 
		 */		
		public static const ropeAreaY:int = 100;
		/**
		 * 浴缸平面高度
		 */		
		public static const bathTopY:int = 800;
		/**
		 * 左墙厚
		 */		
		public static const leftWallWidth:int = 20;
		/**
		 * 右墙厚
		 */		
		public static const rightWallWidth:int = 20;
		/**
		 * 中墙厚 
		 */		
		public static const midWallWidth:int = 30;
		/**
		 * 中墙最高位
		 */	
		public static const maxMidWallHeight:Number = 400;
		
		//---------------------------- 道具属性 -------------------------//
		/**
		 * 水球 小
		 */		
		public static const SmallWaterBall:int = 1;
		/**
		 * 水球 大
		 */		
		public static const BigWaterBall:int = 2;
		/**
		 * 毛巾变短
		 */		
		public static const RopeTurnShort:int = 3;
		/**
		 * 毛巾变软
		 */		
		public static const RopeTurnWeek:int = 4;
		/**
		 * 花洒开关
		 */		
		public static const WaterFallSwitch:int = 5;
		/**
		 * 道具球 掉落概率 
		 */		
		public static const BallFallRate:Array = [1, 1, 1, 1, 2, 2, 2, 3, 4, 5];
		/**
		 * 水球 掉落概率 
		 */		
		public static const WaterBallFallRate:Array = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2];
		/**
		 * 水球 小 飞行阻力
		 */		
		public static const SmallWaterBall_SR:Number = 0.5;
		/**
		 * 水球 大 飞行阻力
		 */		
		public static const BigWaterBall_SR:Number = 0.3;
		/**
		 * 毛巾变短 飞行阻力
		 */		
		public static const RopeTurnShort_SR:Number = 0.2;
		/**
		 * 毛巾变软 飞行阻力
		 */		
		public static const RopeTurnWeek_SR:Number = 0.2;
		/**
		 * 花洒开关 飞行阻力
		 */		
		public static const WaterFallSwitch_SR:Number = 0.2;
		/**
		 * 地心引力X
		 */		
		public static const gX:int = 1;
		/**
		 * 地心引力Y
		 */		
		public static const gY:int = 3;
		/**
		 * 掉落球 时间间隔 
		 */		
		public static const FallDelay:int = 3;
		/**
		 * 中间墙伸缩 时间间隔 
		 */		
		public static const MidWallDelay:int = 10;
		/**
		 * 屋顶刺 时间间隔
		 */		
		public static const StabDelay:int = 60;
		/**
		 * 中间墙强制降下，开始泼水  时间间隔 
		 */		
		public static const FirstMidWallDownDelay:int = 30;
		/**
		 * 泼水时间 
		 */		
		public static const MidWallDownCD:int = 8;
		/**
		 * 花洒泄水时间 
		 */		
		public static const WaterFallCD:int = 5;
		/**
		 * 绳子变短CD
		 */		
		public static const RopeShortCD:int = 10;
		/**
		 * 绳子变软CD
		 */		
		public static const RopeWeekCD:int = 10;
		/**
		 * 初始掉落速度X
		 */		
		public static const DefaultSpeedX:int = 30;
		/**
		 * 初始掉落速度Y
		 */		
		public static const DefaultSpeedY:int = 20;
		/**
		 * 小水球加水量 
		 */		
		public static const SmallWaterAddValue:int = 3;
		/**
		 * 大水球加水量 
		 */		
		public static const BigWaterAddValue:int = 6;
		/**
		 * 泼水 加水量
		 */		
		public static const PoShuiAddValue:int = 1;
		/**
		 * 花洒 加水量
		 */		
		public static const HuaSaAddValue:int = 1;
		
		/**
		 * 肥皂时效 
		 */		
		public static const SoapSkillEffCD:int = 3;
		/**
		 * 肥皂获得CD
		 */		
		public static const SoapSkillGetCD:int = 20;
		
		
		//---------------------------- 绳子属性 -------------------------//
		/**
		 * 绳子长度 
		 */	
		public static const ropeLen:int = 350;
		/**
		 * 短绳子长度
		 */	
		public static const shortRopeLen:int = 200;
		/**
		 * 绳子弹力
		 */	
		public static const ropeForce:Number = 2;
		/**
		 * 软绳子弹力
		 */	
		public static const weekRopeForce:Number = 0.2;
		/**
		 * 墙壁弹力 
		 */		
		public static const wallForce:Number = 0.3;
		
		//------------------------------ 水位 -----------------------------//
		/**
		 * 左边水位 
		 */		
		public static var leftWaterValue:Number = 0;
		/**
		 * 右边水位 
		 */		
		public static var rightWaterValue:Number = 0;
		/**
		 * 最大水位 
		 */		
		public static const MaxWaterValue:Number = 100;
		
		
		
	}
}