package com.feiyu.bathBattle.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * @author Halley
	 */
	public class Verison
	{
		public static var dic:Dictionary = new Dictionary();//每个文件的目录
		public static var dirDic:Dictionary = new Dictionary();//实际目录列表 从页面获取数据
		public static var cdnRoot:String;
		private static var _dirPathDic:Dictionary = new Dictionary();
		private static var _sha1:SHA1;
		private static var _tmpVer:String = "";
		
		public static function init( cdn:String,dirDicPath:String,dicPath:String,callBack:Function,ver:String="defaullt"):void
		{
			if(!_sha1)
			{
				_sha1 = new SHA1();
			}
			if(_tmpVer == ver)
			{
				callBack();
				return;
			}
			_tmpVer = ver;
			
			cdnRoot = cdn;
			dic	= new Dictionary();
			dirDic = new Dictionary();
			_dirPathDic = new Dictionary();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(new URLRequest(dirDicPath));
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function (e:IOErrorEvent):void{callBack(false)});
			
			urlLoader.addEventListener(Event.COMPLETE,function (e:Event):void
			{
				parse(urlLoader.data,false);
				if(countDirDic < 100)
				{
					callBack(false);
					return ;
				} 
				loadEveryChange();
			});
			///
			
			var loadEveryChange:Function = function ():void
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.load(new URLRequest(dicPath));
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function (e:IOErrorEvent):void{callBack(false)});
				urlLoader.addEventListener(Event.COMPLETE,function (e:Event):void
				{
					parse(urlLoader.data,true);
					callBack();
				});
			}
		}
		
		private static function get countDirDic():int
		{
			var num:int = 0;
			for(var str:String in dirDic)
			{
				num ++;
			}
			return num;
		}
		private static function loadErr(e:IOErrorEvent):void
		{
			
		}
		
		public static function parse( bytes:ByteArray, isDiff:Boolean = false ):void
		{
			var index:int = 0;
			var key:String = "";
			var value:String = "";
			var currentDic:Dictionary = isDiff ? dic : dirDic;
			while (bytes.bytesAvailable)
			{
				index++;
				var temp:int = bytes.readUnsignedByte();
				if (index <= 5)
				{
					if (temp < 16)
						key = key + '0' + temp.toString( 16 );
					else
						key += temp.toString( 16 );
				}
				else
				{
					if (temp < 16)
						value = value + '0' + temp.toString( 16 );
					else
						value += temp.toString( 16 );
				}
				
				if (index == 25)
				{
					index = 0;
					currentDic[key] = value;
					key = "";
					value = "";
				}
			}
		}
		
		
		private static function getFromDirDic( url:String,hasCdn:Boolean = true ):String
		{
			var tempCdn:String = hasCdn ? "" : cdnRoot;
			
			var cdnLen:int = hasCdn ? cdnRoot.length : 0;
			
			var lastIndexOf:int = url.lastIndexOf( "/" );
			var path:String = url.substring( cdnLen, lastIndexOf );
			path = lastIndexOf <= 0 ? "." : path;
			
			if (_dirPathDic[path]) return  cdnRoot + "tree/" + _dirPathDic[path] + "/" + url.substring( lastIndexOf + 1 );
			_dirPathDic[path] = _sha1.hashString( path ).substr( 0, 10 );
			_dirPathDic[path] = dirDic[_dirPathDic[path]];
			if (!_dirPathDic[path])
			{
				trace( "error  url=" + url, "  _sha1.hashString=" + _sha1.hashString( path ).substr( 0, 10 ) );
				if (url == "Game.swf" && tempCdn == "../")
					return  url;
				else
					return tempCdn + url;
			}
			return cdnRoot + "tree/" + _dirPathDic[path] + "/" + url.substring( lastIndexOf + 1 );
		}
		
		public static function getVersionUrl( url:String ,hasCdn:Boolean = true):String
		{
			if(!_sha1)	
				return url;
			//去后缀
			var endIdx:int = url.indexOf("?",1);
			var endStr:String = "";
			if(endIdx > 0)
			{
				endStr = url.substr(endIdx);
				url = url.substr(0,endIdx);
			}
			endIdx = url.indexOf("&",1);
			if(endIdx > 0)
			{
				url = url.substr(0,endIdx);
			}
			
			//var t1:int = getTimer();
			var tmpUrl:String = url;
			if(hasCdn)
			{
				tmpUrl = url.substr(cdnRoot.length);
			}
			var dicPath:String = dic[_sha1.hashString( tmpUrl ).substr( 0, 10 )];
			//trace(getTimer()-t1);
			if (!dicPath) return getFromDirDic( url+endStr,hasCdn );
			var url:String = "file/" + dicPath + "/" + url.substr( url.lastIndexOf( "/" ) + 1 );
			return cdnRoot + url + endStr;
		}
	}
}
