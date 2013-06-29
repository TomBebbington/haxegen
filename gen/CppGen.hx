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
	public function toNative(s:HaxeType) {
		var isP = s.isPointer;
		if(isP)
			 s = s.toString().substr(0, s.toString().length-1);
		return (switch(s) {
			case "Int": "int";
			case "UInt": "uint";
			case "haxe.Int64": "int64";
			case "Single": "float";
			case "Float": "double";
			case "Dynamic": "void*";
			case "Void": "void";
			case "Bool": "bool";
			case "String": "string";
			default:
				var ntv = null;
				for(t in d.types) {
					if(t.name == s || t.native == s.defaultNative) {
						ntv = t.native;
						break;
					}
				}
				ntv == null ? s.defaultNative : ntv;
		}) + (isP ? "*" : "");
	}
	public function generateConversionFrom(name:String, typ:HaxeType) {
		return switch(typ) {
			case "Int", "Uint", "Int64", "haxe.Int64": 'val_int($name)';
			case "String": 'val_string($name)';
			case "Float", "Single": 'val_float($name)';
			case "Bool": 'val_bool($name)';
			default: '((${toNative(typ)}*) val_kind(${typ.kind},$name))';
		};
	}
	public function generateConversionTo(name:String, typ:HaxeType) {
		return switch(typ) {
			case "Int", "Uint", "Int64", "haxe.Int64": 'alloc_int($name)';
			case "String": 'alloc_string($name)';
			case "Float", "Single": 'alloc_float($name)';
			case "Bool": 'alloc_bool($name)';
			case "Dynamic": 'alloc_object($name)';
			default: 'alloc_abstract(${typ.kind},$name)';
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
		b.add(generateConversionTo("v", t.name));
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
		b.add(') { // ${m.name} \n\t');
		if(!isVoid) {
			var native = toNative(m.ret);
			b.add('$native v = ');
		}
		if(m.isStatic) {
			var ht:HaxeType = t.name;
			b.add(t.native == null ? ht.defaultNative : t.native);
			b.add("::");
		} else {
			b.add(generateConversionFrom(argIds[0], t.name));
			b.add(" -> ");
		}
		if(m.ret.isPointer)
			b.add("&");
		b.add(m.name);
		b.add("(");
		var arguments = [for(a in 0...m.args.length) {
			generateConversionFrom(argIds[a + argOff], m.args[a]);
		}];
		if(!m.isStatic)
			arguments = arguments.slice(1);
		b.add(arguments.join(", "));
		b.add(");\n");
		if(!isVoid) {
			b.add("\treturn ");
			b.add(generateConversionTo("v", m.ret));
			b.add(";\n");
		}
		b.add("}\n");
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