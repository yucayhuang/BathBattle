package 
{
	
	import com.feiyu.bathBattle.interfaces.IMcBathBattle;
	import com.feiyu.bathBattle.interfaces.IMcBathBattleEntry;
	import com.feiyu.bathBattle.util.File;
	import com.feiyu.bathBattle.util.GameUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	
	/**
	 * 澡堂大作战 
	 * @author hyc
	 * 
	 */	
	public class BathBattle extends Sprite{
		
		/**
		 * 入口swf 
		 */		
		private const EntryViewSwf:String = "./assets/swf/bath_battle_entry.swf";
		/**
		 * 游戏swf 
		 */		
		private const MainViewSwf:String = "./assets/swf/bath_battle.swf";
		/**
		 * 音乐
		 */		
		private const bgMp3:String = "./assets/mp3/bgMusic.mp3";
		
		public function BathBattle(){
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//背景音乐
			playBgMusic();
			//打开入口界面 
			showEntryView();
		}
		
		/**
		 * 播放背景音乐 
		 * 
		 */		
		private function playBgMusic():void{
			var soundct:SoundChannel=new SoundChannel();   
			var s:Sound = new Sound(new URLRequest(bgMp3));
			soundct = s.play();   
			soundct.addEventListener(Event.SOUND_COMPLETE, onComplete);   
			s.addEventListener(Event.SOUND_COMPLETE, onComplete);   
			function onComplete(eve:Event):void{   
				soundct=s.play();   
				soundct.addEventListener(Event.SOUND_COMPLETE,onComplete);   
			}   
		}
		
		/**
		 * 打开入口界面 
		 * 
		 */		
		private function showEntryView():void{
			//打开入口界面
			showView([EntryViewSwf], addEntryViewBack);
		}
		
		/**
		 * 添加入口视图成功
		 * @param fileList
		 * 
		 */		
		private var _entryView:IMcBathBattleEntry;
		private function addEntryViewBack(fileList : Array):void{
			var f:File = fileList[0];
			var fClazz:Class = f.getClassByName("bath_battle_entry_lib.McBathBattleEntry");
			_entryView = new fClazz() as IMcBathBattleEntry;
//			_entryView = new McBathBattleEntry() as IMcBathBattleEntry;
			_entryView.onEnter = showMainView;
			this.addChild(_entryView as MovieClip);
		}
		
		/**
		 * 打开主界面 
		 * 
		 */		
		private function showMainView():void{
			//打开主界面
			showView([MainViewSwf], addMainViewBack);
		}
		
		/**
		 * 添加主视图成功
		 * @param fileList
		 * 
		 */		
		private var _mainView:IMcBathBattle;
		private function addMainViewBack(fileList : Array):void{
			var f:File = fileList[0];
			var fClazz:Class = f.getClassByName("bath_battle_lib.McBathBattle");
			_mainView = new fClazz() as IMcBathBattle;
//			_mainView = new McBathBattle() as IMcBathBattle;
			_mainView.onShowEntry = showEntryView;
			this.addChild(_mainView as MovieClip);
			
			_mainView.init();
		}
		
		/**
		 * 添加视图 
		 * @param urls
		 * @param callBack
		 * 
		 */		
		private function showView(urls:Array, callBack:Function):void{
			File.loadList(urls, callBack);
		}
		
	}
}