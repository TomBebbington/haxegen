package gen;
import gen.data.*;
import haxe.macro.Expr;
using haxe.macro.Context;
using haxe.macro.ExprTools;
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
import haxe.macro.Type;
import haxe.macro.Printer;
using StringTools;
using Lambda;
class Tools {
	public static function typeExpr(c:ComplexType):Expr {
		return c.toString().parse(Context.currentPos());
	}
	public static function isPrimitive(c:ComplexType):Bool {
		return switch(c) {
			case TPath({pack: [], name: "Int"|"Float"|"Single"|"UInt"|"Bool"|"String"}): true;
			case TPath({pack: [], name: "Array", params: [TypeParam.TPType(t)]}): isPrimitive(t);
			default: false;
		}
	}
	public static function signature(f:Function):ComplexType {
		return ComplexType.TFunction([for(a in f.args) a.type], f.ret);
	}
	public static function csignature(c:ComplexType, fl:Field, f:Function):ComplexType {
		var args = [for(a in f.args) macro:Dynamic];
		if(!fl.access.has(AStatic) && fl.name != "new")
			args.insert(0, macro:Dynamic);
		var ret = f.ret;
		if(fl.name == "new")
			ret = c;
		if(ret.toString() != "Void")
			ret = macro:Dynamic;
		return ComplexType.TFunction(args, ret);
	}
	public static function findProjectPath(name:String):String {
		var p = new sys.io.Process("haxelib", ["path", name]);
		var l = p.stdout.readLine();
		while(l.endsWith("ndll/"))
			l = l.substr(0, l.length-5);
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