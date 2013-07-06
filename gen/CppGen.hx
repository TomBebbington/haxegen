package gen;
import gen.data.*;
using sys.io.File;
class CppGen {
	var d:Project;
	public static var names = new Map<FieldData, String>();
	static var fc = 0;
	var b:StringBuf;
	public function new(d:Project) {
		this.d = d;
	}
	public function generate() {
		b = new StringBuf();
		b.add("#ifndef IPHONE\n#define IMPLEMENT_API\n#endif\n#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)\n#define NEKO_COMPATIBLE\n#endif\n");
		generateHeaders();
		for(t in d.types)
			generateType(t);
		if(d.library == "llvm")
			b.add("extern \"C\" int llvm_register_prims() { return 0; }\n");
		d.cffi.saveContent(b.toString());
	}
	public function generateType(t:TypeData) {
		var ht:HaxeType = t.name;
		if(t.native == null)
			t.native = ht.defaultNative;
		b.add('DEFINE_KIND(${ht.kind}); //${t.name}\n');
		var methods = [];
		if(t.methods != null)
			methods = methods.concat(t.methods);
		if(t.fields != null)
			for(f in t.fields)
				methods.push({
					ret: f.type,
					name: 'get_${f.name}',
					args: [],
					isStatic: f.isStatic
				});
		for(m in methods)
			switch(m.name) {
				case "new": generateConstructor(m, t);
				default: generateMethod(m, t);
			}
	}
	public function lookupNative(s:HaxeType) {
		var isP = s.isPointer;
		if(isP)
			s.isPointer = false;
		var typ:TypeData = null;
		for(t in d.types) {
			if(t.name == s || t.native == s.defaultNative) {
				typ = t;
				break;
			}
		}
		if(typ == null)
			throw 'Could not find type $s';
		var ntv = typ.native;
		if(isP)
			s.isPointer = true;
		return ntv == null ? s.defaultNative : (ntv + (isP ? "*" : ""));
	}
	inline function toNative(s:HaxeType) {
		var n = s.toNative();
		var ss = n == null || n.indexOf("???") != -1 ? lookupNative(s) : n;
		return ss;
	}
	public function generateConversionFrom(name:String, typ:HaxeType) {
		return switch(typ) {
			case "Int", "Uint", "Int64", "haxe.Int64": 'val_int($name)';
			case "String": 'val_string($name)';
			case "Float", "Single": 'val_float($name)';
			case "Bool": 'val_bool($name)';
			case _ if(typ.isPointer && typ.isBuiltin()):
				trace(typ);
				var ts = Std.string(typ);
				var conv = generateConversionFrom(name, ts.substr(0, ts.length-1));
				'&$conv';
			case _ if(!typ.isPointer): '(*((${toNative(typ)}*) val_data($name)))';
			case _ if(typ.isPointer): '((${toNative(typ)}) val_data($name))';
		};
	}
	public function generateConversionTo(name:String, typ:HaxeType) {
		return switch(typ) {
			case _ if(typ.isPointer && typ.isBuiltin()):
				var t:String = typ;
				var ty:HaxeType = t;
				ty.isPointer = false;
				generateConversionTo('*$name', ty);
			case "Int", "Uint", "Int64", "haxe.Int64": 'alloc_int($name)';
			case "String*": 'alloc_string($name -> c_str())';
			case "String": 'alloc_string($name.c_str())';
			case "Float", "Single": 'alloc_float($name)';
			case "Bool": 'alloc_bool($name)';
			case "Dynamic": 'alloc_object($name)';
			case _ if(!typ.isPointer): 'alloc_abstract(${typ.kind},&$name)';
			case _: 'alloc_abstract(${typ.kind},$name)';
		};
	}
	public function generateConstructor(m:MethodData, t:TypeData) {
		var id = getName(m);
		if(m.ret == null) m.ret = "Dynamic";
		if(m.args == null) m.args = [];
		var argIds = [for(i in 0...m.args.length) Tools.id(i)];
		b.add('value $id(');
		b.add([for(a in argIds) 'value $a'].join(", "));
		var native = '${t.native}*';
		if(m.isConst)
			native = 'const $native';
		b.add(") {");
		b.add('// constructor');
		b.add('\n\t$native v = ');
		b.add(m.name);
		b.add(" ");
		b.add(t.native);
		b.add("(");
		var arguments = argIds.copy();
		b.add(arguments.join(", "));
		b.add(");\n\treturn ");
		b.add('alloc_abstract(${t.name.kind}, v)');
		b.add(';\n}\nDEFINE_PRIM($id,${argIds.length});\n');
	}
	public function generateMethod(m:MethodData, t:TypeData) {
		var id = getName(m);
		if(m.ret == null) m.ret = "Dynamic";
		if(m.args == null) m.args = [];
		var isVoid = m.ret == "Void";
		var argOff = m.isStatic ? 0 : 1;
		var argIds = [for(i in 0...argOff + m.args.length) Tools.id(i)];
		b.add(m.ret == "Void" ? "void" : "value");
		b.add(' $id(');
		b.add([for(a in argIds) 'value $a'].join(", "));
		b.add(") ");
		if(m.code != null && m.code.charAt(0) == "{") {
			var code = m.code;
			var ntabs = ~/\t(\t*)/;
			ntabs.match(code);
			var tabs = ntabs.matched(1);
			code = StringTools.replace(code, '\n$tabs', "\n\t");
			b.add(code);
			b.add("\n");
		} else {
			b.add('{ // ${m.name} \n\t');
			if(!isVoid) {
				var native = toNative(m.ret);
				if(m.isConst)
					native = 'const $native';
				b.add('$native v = ');
			}
			var callStr = "";
			if(m.native != null && m.native.indexOf("::") != -1)
				callStr += m.native;
			else if(m.isStatic)
				callStr += (t.native == null ? t.name.defaultNative : t.native) + '::${m.name}';
			else
				callStr += generateConversionFrom(argIds[0], t.name) + '.${m.name}';
			var args = [for(i in 0...m.args.length) generateConversionFrom(argIds[i + argOff], m.args[i])].join(", ");
			callStr += '($args)';
			if(m.code == null)
				b.add(callStr);
			else
				b.add(StringTools.replace(m.code, "$", callStr));
			b.add(";\n");
			if(!isVoid) {
				b.add("\treturn ");
				b.add(generateConversionTo("v", m.ret));
				b.add(";\n");
			}
			b.add("}\n");
		}
		b.add('DEFINE_PRIM($id,${argIds.length});\n');
	}
	public function generateHeaders() {
		var headers = ["<hx/CFFI.h>", "<string.h>"];
		for(t in d.types) {
			if(t.headers != null && t.headers.length > 0)
				for(h in t.headers) {
					if(Lambda.indexOf(headers, h) == -1)
						headers.push(h);
				}
		}
		for(h in headers) {
			var name = h.charAt(0) == "<" ? h : '"$h"';
			b.add('#include $name\n');
		}
	}
	public static function getName(f:FieldData):String {
		return if(names.exists(f))
			names[f];
		else {
			var id = "_" + Tools.id(fc++);
			names[f] = id;
			id;
		}
	}
}