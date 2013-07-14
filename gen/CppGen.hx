package gen;
import gen.data.*;
import haxe.macro.*;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.ds.WeakMap;
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using sys.io.File;
using Lambda;
class CppGen {
	public static inline var PATH = "project/common/ExternalInterface.cpp";
	var d:Array<External>;
	public var types:Map<String, Type>;
	public var kinds:Map<Type, String>;
	public var projectName = null;
	public var fid:Int;
	var b:StringBuf;
	public function new(d:Array<External>) {
		fid = 0;
		projectName = d[0].native.split("::")[0];
		kinds = new Map<Type, String>();
		types = new Map<String, Type>();
		trace(projectName);
		this.d = d;
		this.b = null;
	}
	public function toNative(t:ComplexType) {
		return if(types.exists(t.toString())) switch(types.get(t.toString())) {
			case TInst(ct, ps) if(ct.get().meta.has(":native")): Tools.resolveString(ct.get().meta.get().filter(function(e) return e.name == ":native")[0].params[0]);
			case all: throw 'Unsupported type ${all}';
		} else switch(t) {
			case TPath({name: "Int"}): "int";
			case TPath({name: "UInt"}): "uint";
			case TPath({name: "Float"}): "float";
			case TPath({name: "Bool"}): "bool";
			case TPath({name: "Void"}): "void";
			case TPath({name: "String"}): "std::string";
			case TPath({name: "Pointer", pack: ["gen"], params: [TPType(t)]}): toNative(t) + "*";
			default: throw 'Unsupported type ${t.toString()}: $t';
		}
	}
	public function generateConversionTo(name:String, typ:ComplexType) {
		return switch(typ) {
			case TPath({name: "Int" | "UInt"}): 'alloc_int($name)';
			case TPath({name: "Bool"}): 'alloc_bool($name)';
			case TPath({name: "Float"}): 'alloc_float($name)';
			case TPath({name: "String"}): 'alloc_string($name)';
			case TPath({name: "Void"}): throw 'Cannot wrap $name - is void';
			case _ if(types.exists(typ.toString())):
				var kind = kinds.get(types.get(typ.toString()));
				'alloc_abstract($kind, *$name)';
			case TPath({name: "Pointer", pack: ["gen"], params: [TPType(t)]}) if(types.exists(t.toString())):
				var kind = kinds.get(types.get(t.toString()));
				'alloc_abstract($kind, $name)';
			default: throw 'Unsupported type ${typ.toString()} - $typ';
		}
	}
	public function generateConversionFrom(name:String, typ:ComplexType) {
		return switch(typ) {
			case TPath({name: "Int" | "UInt"}): 'val_int($name)';
			case TPath({name: "Float"}): 'val_float($name)';
			case TPath({name: "String"}): 'val_string($name)';
			case _ if(types.exists(typ.toString())): '(${toNative(typ)}*) val_data($name)';
			default: throw 'Cannot convert type $typ';
		};
	}
	function generateMethod(e:External, f:Field, func:Function) {
		if(f.access.has(AInline))
			return;
		var isVoid = f.name != "new" && func.ret.toString() == "Void", isConst = f.name == "new", isStatic = f.access.has(AStatic);
		b.add(isVoid ? "void " : "value ");
		var name = Tools.methodName(e.type.toComplexType(), f);
		var cargs = [for(a in func.args) a.name];
		var argoff = isStatic || isConst ? 0 : 1;
		if(argoff == 1)
			cargs.insert(0, "self");
		b.add('$name(');
		b.add([for(c in cargs) 'value $c'].join(", "));
		b.add(") ");
		var code = f.meta.filter(function(e) return e.name == ":code")[0];
		if(code != null) {
			var acode = Tools.resolveString(code.params[0]);
			var ntabs = ~/\t(\t*)/;
			ntabs.match(acode);
			var tabs = ntabs.matched(1);
			acode = StringTools.replace(acode, '\n$tabs', "\n");
			var wrap = ~/\$\((.*?)\)/;
			while(wrap.match(acode)) {
				var id = wrap.matched(1);
				var conv = generateConversionTo(id, func.ret);
				acode = wrap.matchedLeft() + conv + wrap.matchedRight();
			}
			b.add(acode);
			b.add("\n");
		} else  {
			b.add("{\n\t");
			var callStr = "";
			var fname = f.name;
			callStr += if(isConst)
				'new ${e.native}'
			else if(isStatic)
				'${e.native}::${f.name}';
			else {
				var conv = generateConversionFrom("self", e.type.toComplexType());
				'($conv) -> ${f.name}';
			}
			callStr += "(";
			callStr += [for(i in 0...func.args.length) generateConversionFrom(cargs[argoff + i], func.args[i].type)].join(", ");
			callStr += ")";
			if(isVoid)
				b.add('${callStr};');
			else {
				b.add(toNative(func.ret));
				b.add(" v = ");
				b.add(callStr);
				b.add(";\n\t");
				b.add('return ${generateConversionTo("v", isConst ? e.type.toComplexType() : func.ret)}');
			}
			b.add("\n}\n");
		}
		b.add('DEFINE_PRIM($name, ${cargs.length});\n');
	}
	function generateField(e:External, f:Field) {
		switch(f.kind) {
			case FFun(func): generateMethod(e, f, func);
			default:
		}
	}
	function generateType(e:External) {
		types.set(e.type.toComplexType().toString(), e.type);
		var ntv = toNative(e.type.toComplexType());
		b.add('DEFINE_KIND(${getKind(e.type)}); // $ntv\n');
		for(f in e.fields)
			generateField(e, f);
	}
	function generateHeaders() {
		b.add("#include <hx/CFFI.h>\n#include <string.h>\n");
		for(e in d)
			for(h in e.headers)
				b.add('$h\n');
	}
	public function generate():String {
		b = new StringBuf();
		b.add("#ifndef IPHONE\n#define IMPLEMENT_API\n#endif\n#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)\n#define NEKO_COMPATIBLE\n#endif\n");
		generateHeaders();
		for(t in d)
			generateType(t);
		if(projectName == "llvm")
			b.add("extern \"C\" int llvm_register_prims() { return 0; }\n");
		return b.toString();
	}
	public function save() {
		sys.io.File.saveContent('${Tools.findProjectPath(projectName)}/$PATH', generate());
	}
	public function getKind(f:Type):String {
		return if(kinds.exists(f))
			kinds.get(f);
		else {
			var id = "k_" + Tools.id(fid++);
			kinds.set(f, id);
			id;
		}
	}
}