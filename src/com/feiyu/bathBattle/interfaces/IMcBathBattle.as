package com.feiyu.bathBattle.interfaces
{
	
	/**
	 * 飞行侠 
	 * @author hyc
	 * 
	 */	
	public interface IMcBathBattle{
		
		/**
		 * 初始化 
		 * 
		 */		
		function init():void;
		
		/**
		 * 返回入口界面
		 */		
		function set onShowEntry(fun : Function):void;
			
		/**
		 * 销毁
		 * 
		 */		
		function destroy():void;
	}
}