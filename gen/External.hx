package gen;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.*;
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using haxe.macro.ExprTools;
using Lambda;
using StringTools;
class External {
	static var externs:Array<External> = [];
	public var headers:Array<String>;
	public var native:String;
	public var fields:Array<Field>;
	var cffiFields:Array<Field>;
	public var type:Type;
	public var projectName:String;
	public function new(c:ClassType, fields:Array<Field>) {
		projectName = c.pack[0];
		type = Context.getLocalType();
		headers = [];
		native = null;
		this.fields = fields;
		cffiFields = [];
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
					var nativeName = Tools.methodName(type.toComplexType(), fd);
					var nativeNameE:Expr = {expr: EConst(CIdent(nativeName)), pos: fd.pos};
					var nargs = f.args.length + (fd.access.has(AStatic) || fd.name == "new" ? 0 : 1);
					var callArgs:Array<Expr> = [for(a in f.args) {
						var e:Expr = {expr: EConst(CIdent(a.name)), pos: fd.pos};
						if(!Tools.isPrimitive(a.type))
							e = macro $e._;
						e;
					}];
					if(fd.name != "new" && !fd.access.has(AStatic))
						callArgs.push(macro this._);
					var callE:Expr = {expr: ECall(nativeNameE, callArgs), pos: fd.pos};
					var localExpr = Tools.typeExpr(type.toComplexType());
					if(!Tools.isPrimitive(f.ret) && f.ret.toString() != "Void") callE = macro gen.BackendTools.create($localExpr, $callE);
					fields.push({
						pos: fd.pos,
						name: nativeName, 
						kind: FieldType.FVar(Tools.csignature(type.toComplexType(), fd, f), macro #if neko neko.Lib #elseif cpp cpp.Lib #end.load($v{projectName}, $v{nativeName}, $v{nargs})),
						access: [AStatic]
					});
					f.expr = switch(f.ret) {
						case _ if(fd.name == "new" && c.superClass != null && c.superClass.t.get().constructor != null): macro super();
						case _ if(fd.name == "new"): macro this._ = $callE;
						case TPath(p) if(p.name == "Void"): macro $callE;
						case _ if(f.ret == null): macro $callE;
						case TPath(p): macro return $callE;
						case _: macro return null;
					};
				default: 
			}
		}
		if(externs.length <= 0) {
			Context.onGenerate(function(ts) {
				new CppGen(externs).save();
			});
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