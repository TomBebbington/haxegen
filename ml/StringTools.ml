package  {
class StringTools =;
	object;
		static public function urlEncode(s : String) : String (;
			return null;
		);
		
		static public function htmlUnescape(s : String) : String (;
			return s.split("&gt;").join(">").split("&lt;").join("<").split("&quot;").join("\"").split("&#039;").join("'").split("&amp;").join("&");
		);
		
		static public function startsWith(s : String,start : String) : bool (;
			return s.length >= start.length && s.substr(0,start.length) == start;
		);
		
		static public function endsWith(s : String,end : String) : bool (;
			let elen : int32 = end.length in;
			let slen : int32 = s.length in;
			return slen >= elen && s.substr(slen - elen,elen) == end;
		);
		
		static public function isSpace(s : String,pos : int32) : bool (;
			let c : * = s["charCodeAtHX"](pos) in;
			return c > 8 && c < 14 || c == 32;
		);
		
		static public function ltrim(s : String) : String (;
			let l : int32 = s.length in;
			let r : int32 = 0 in;
			while(r < l && StringTools.isSpace(s,r)) r++;
			if(r > 0) return s.substr(r,l - r);
			else return s;
		);
		
		static public function rtrim(s : String) : String (;
			let l : int32 = s.length in;
			let r : int32 = 0 in;
			while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
			if(r > 0) return s.substr(0,l - r);
			else return s;
		);
		
		static public function trim(s : String) : String (;
			return StringTools.ltrim(StringTools.rtrim(s));
		);
		
		static public function replace(s : String,sub : String,by : String) : String (;
			return s.split(sub).join(by);
		);
		
end;
	