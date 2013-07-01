package gen;
import sys.io.File;
import sys.FileSystem;
using StringTools;
import gen.data.*;
import haxe.macro.*;
import haxe.macro.Type;
import haxe.macro.Expr;
class HaxeGen {
	var d:Project;
	public function new(d:Project) {
		this.d = d;
	}
	public function generate() {
		for(t in d.types) {
			var path:String = resolvePath(t.name);
			var dirs = path.split("/");
			dirs.pop();
			var cdir = FileSystem.fullPath(Sys.getCwd());
			if(cdir.endsWith("/"))
				cdir = cdir.substr(0, cdir.length-1);
			for(d in dirs) {
				cdir = '$cdir/$d';
				if(!FileSystem.exists(cdir))
					FileSystem.createDirectory(cdir);
			}
			File.saveContent(path, generateType(t));
		}
	}
	static function resolvePath(n:String) {
		return n.replace(".", "/") + ".hx";
	}
	public function generateMethod(m:MethodData, t:TypeData):Field {
		if(m.args == null)
			m.args = [];
		var argIds:Map<String, String> = new Map();
		for(i in 0...m.args.length)
			argIds[cast(m.args[i], String)] = Tools.id(i);
		var f:Field = generateField(m);
		f.access.push(Access.AInline);
		var name = CppGen.getName(m);
		var args = m.isStatic || m.name == "new" ? m.args : [t.name].concat(m.args);
		var cexpr:Expr = {
			expr: ECall({
				expr: EConst(CIdent(name)),
				pos: null
			}, [for(a in args) {
				{expr: EConst(CIdent(argIds.exists(a) ? argIds.get(a) : "this")), pos: null};
			}]),
			pos: null
		};
		f.kind = FieldType.FFun({
			ret: m.ret,
			params: [],
			args: [for(a in m.args) {type: a, name: argIds.get(a), opt: false}],
			expr: if(m.name == "new")
				macro this = $cexpr
			else if(m.ret != null && m.ret.name != "Void")
				macro return $cexpr
			else
				cexpr
		});
		return f;
	}
	public function generateNativeMethod(m:MethodData, t:TypeData):Field {
		if(m.args == null)
			m.args = [];
		var argIds:haxe.ds.StringMap<String> = [for(i in 0...m.args.length) cast (m.args[i], String) => Tools.id(i)];
		var f:Field = generateField(m);
		f.access.push(Access.AStatic);
		f.access.remove(Access.APublic);
		f.access.push(Access.APrivate);
		f.name = CppGen.getName(m);
		var librarye:Expr = {
			expr: EConst(CString(d.library)),
			pos: null
		}, name:Expr = {
			expr: EConst(CString(CppGen.getName(m))),
			pos: null
		}, arglen:Expr = {
			expr: EConst(CInt(Std.string(m.args.length + (m.isStatic || m.name == "new" ? 0 : 1)))),
			pos: null
		};
		f.kind = FieldType.FVar(generateFuncType(m, t), macro cpp.Lib.load($librarye, $name, $arglen));
		return f;
	}
	public function generateField(f:FieldData):Field {
		return {
			pos: null,
			name: f.rename == null ? f.name : f.rename,
			kind: f.type == null ? null : FieldType.FProp("get", "never", f.type),
			access: {
				var a = [];
				if(f.isStatic)
					a.push(AStatic);
				a.push(APublic);
				a;
			}
		};
	}
	public function generateProperty(p:PropData):Field {
		return {
			pos: null,
			name: p.name,
			kind: FieldType.FProp("get", "set", p.type),
			access: {
				var a = [];
				if(p.isStatic)
					a.push(AStatic);
				a.push(APublic);
				a;
			}
		};
	}
	public function generateFuncType(f:FieldData, t:TypeData):ComplexType {
		var method:MethodData = (untyped f.ret != null || untyped f.args != null || f.name == "new") ? cast f : null;
		if(method.args == null)
			method.args = [];
		var args:Array<HaxeType> = [], ret:HaxeType = null;
		if(method != null) {
			ret = method.ret;
			args = if(method.isStatic)
				method.args
			else {
				var cargs = method.args.copy();
				cargs.insert(0, t.name);
				cargs;
			}
		} else {
			ret = f.type;
			if(!f.isStatic)
				args.push(t.name);
		}
		return ComplexType.TFunction([for(a in args) (a.isBuiltin() ? a : macro:Dynamic)], ret);
	}
	public function generateType(t:TypeData):String {
		var parts = t.name.parts;
		var name = t.name.name;
		var type:TypeDefinition = {
			pos: null,
			pack: parts.slice(0, parts.length-1),
			params: [],
			name: t.name.name,
			meta: [],
			isExtern: false,
			kind: switch(t.type) {
				case "enum": TypeDefKind.TDEnum;
				default: TypeDefKind.TDAbstract(macro:Dynamic, [], []);
			},
			fields: switch(t.type) {
				case "enum": [for(v in t.values) {
					pos: null,
					name: v,
					kind: FieldType.FVar(null, null)
				}];
				default: 
					var fields:Array<Field> = [];
					if(t.extend != null) {
						fields.push({
							pos: null,
							name: 'to${t.extend.name}',
							kind: FieldType.FFun({
								ret: t.extend,
								params: [],
								expr: macro return cast this,
								args: []
							}),
							access: [APublic, AInline],
							meta: [{
								pos: null,
								params: [],
								name: ":to"
							}]
						});
						fields.push({
							pos: null,
							name: 'from${t.extend.name}',
							kind: FieldType.FFun({
								ret: t.extend,
								params: [],
								expr: macro return cast o,
								args: [{type: t.extend, opt: false, name:"o"}]
							}),
							access: [APublic, AStatic, AInline],
							meta: [{
								pos: null,
								params: [],
								name: ":from"
							}]
						});
					}
					fields = fields.concat([for(p in t.properties) generateProperty(p)]);
					fields = fields.concat([for(f in t.fields) generateField(f)]);
					fields = fields.concat([for(m in t.methods) generateMethod(m, t)]);
					fields = fields.concat([for(m in t.methods) generateNativeMethod(m, t)]);
					fields;
			}
		};
		return new Printer().printTypeDefinition(type);
	}
}