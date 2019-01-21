package com.feiyu.bathBattle.interfaces
{
	
	
	/**
	 * 澡堂大作战 入口 
	 * @author hyc
	 * 
	 */	
	public interface IMcBathBattleEntry{
		
		/**
		 * 进入 
		 * @param fun
		 * 
		 */		
		function set onEnter(fun : Function):void;
		
		/**
		 * 销毁 
		 * 
		 */		
		function destroy():void;
	}
}