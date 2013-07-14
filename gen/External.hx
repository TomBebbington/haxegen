package gen;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.*;
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using haxe.macro.ExprTools;
using Lambda;
class External {
	static var externs:Array<External> = [];
	public var headers:Array<String>;
	public var native:String;
	public var fields:Array<Field>;
	public var type:Type;
	public function new(c:ClassType, fields:Array<Field>) {
		type = Context.getLocalType();
		headers = [];
		native = null;
		this.fields = fields;
		var meta = c.meta.get();
		for(m in meta) {
			switch(m.name) {
				case ":native", "native": native = resolve(m.params[0]);
				case ":header", "header": headers.push(resolve(m.params[0]));
			}
		}
		for(fd in fields) {
			if(!fd.access.has(APublic)) fd.access.push(APublic);
			switch(fd.kind) {
				case FieldType.FFun(f) if(f.expr == null):
					f.expr = switch(f.ret) {
						case _ if(fd.name == "new" && c.superClass != null && c.superClass.t.get().constructor != null): macro super();
						case TPath(p) if(p.name == "Void"): macro {};
						case TPath(p) if(p.name == "Bool"): macro return true;
						case TPath(p) if(p.name == "Int"): macro return 1;
						case TPath(p) if(p.name == "Float"): macro return 1.0;
						case _ if(f.ret == null): macro {};
						case _: macro return null;
					};
					trace('${c.name}.${fd.name} {${f.expr.toString()}} - ${c.superClass}');
				default: 
			}
		}
		if(externs.length <= 0) {
			Context.onGenerate(function(ts) new CppGen(externs).save());
		}
	}
	static function resolve(e:Expr):Dynamic {
		return switch(e.expr) {
			case EConst(CString(s)): s;
			case EConst(CInt(i)): i;
			case EConst(CFloat(s)): Std.parseFloat(s);
			default: null;
		}
	}
	public static macro function build():Array<Field> {
		var fs = Context.getBuildFields();
		var e = new External(Context.getLocalClass().get(), fs);
		externs.push(e);
		return e.fields;
	}
}