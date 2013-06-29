package gen;
import gen.data.*;
class Tools {
	public static function id(x:Int) {
		return if(x < 26)
				String.fromCharCode("a".code + x);
			else if(x < 52)
				String.fromCharCode("A".code + x - 26);
			else {
				var avail = 52;
				var s = "";
				while (x > 0) {
					s = id(x % avail) + s;
					x = Std.int(x / avail);
				}
				s;
			}
	}
	public static function resolveType(p:Project, h:HaxeType):TypeData {
		for(t in p.types)
			if(t.name == h)
				return t;
		return null;
	}
	public static function matches(s:String, r:EReg, ms:Int):Array<Array<String>> {
		var a = [];
		var pos = 0;
		while(r.matchSub(s, pos)) {
			var cpos = r.matchedPos();
			var ma = [for(i in 1...ms+1) r.matched(i)];
			a.push(ma);
			pos = cpos.pos + cpos.len;
		}
		return a;
	}
}