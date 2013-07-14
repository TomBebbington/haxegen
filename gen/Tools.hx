package gen;
import gen.data.*;
import haxe.macro.Expr;
using haxe.macro.ExprTools;
using haxe.macro.ComplexTypeTools;
using StringTools;
class Tools {
	public static function findProjectPath(name:String):String {
		var p = new sys.io.Process("haxelib", ["path", name]);
		return p.stdout.readLine();
	}
	public static function resolveString(e:ExprOf<String>):String {
		return switch(e.expr) {
			case EConst(CString(s)): s;
			default: throw 'Invalid value ${e.toString()}';
		}
	}
	public static function methodName(t:ComplexType, f:Field):String {
		var fullName = t.toString();
		var name = fullName.replace(".", "_").toLowerCase();
		return '${name}_${f.name}';
	} 
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