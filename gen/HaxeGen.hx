package gen;
import sys.io.File;
import sys.FileSystem;
using StringTools;
import gen.data.*;
class HaxeGen {
	var d:Project;
	var b:StringBuf;
	var idc:Int;
	public function new(d:Project) {
		this.d = d;
		idc = 0;
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
	inline function genId(x:Int=-1):String {
		return Tools.id(x == -1 ? idc++ : x); 
	}
	public function generateMethod(m:MethodData) {
		if(m.isStatic == null)
			m.isStatic = false;
		if(m.name == "new")
			m.ret = "Void";
		else if(m.ret == null)
			m.ret = "Dynamic";
		if(m.args == null) m.args = [];
		b.add('\tpublic inline function ${m.name}(');
		var argIds = [for(i in 0...m.args.length) Tools.id(i)];
		b.add([for(i in 0...m.args.length) argIds[i] + ":" + m.args[i]].join(", "));
		b.add(")");
		if(m.ret != null) {
			b.add(":");
			b.add(m.ret);
		}
		b.add(" {\n\t\t");
		if(m.name == "new")
			b.add("this = ");
		else if(m.ret != null && m.ret != "Void")
			b.add("return ");
		b.add(CppGen.getName(m));
		b.add("(");
		var arguments = argIds.copy();
		if(!m.isStatic && m.name != "new")
			arguments.insert(0, "this");
		b.add(arguments.join(", "));
		b.add(")");
		b.add(";\n\t}");
		b.add("\n");
	}
	public function generateField(f:FieldData) {
		if(f.isStatic == null)
			f.isStatic = false;
		if(f.type == null)
			f.type = "Dynamic";
		generateMethod({
			ret: f.type,
			name: 'get_${f.name}',
			args: [],
			isStatic: f.isStatic
		});
		var s = f.isStatic ? "static " : "";
		b.add('public ${s}var ${f.name}(get, never):${f.type}');
	}
	public function generateFuncType(f:FieldData, t:TypeData) {
		if(untyped f.ret != null || untyped f.args != null || f.name == "new") {
			var m:gen.data.MethodData = cast f;
			if(m.args.length == 0)
				b.add("Void");
			else {
				var args = m.args.copy();
				if(!m.isStatic)
					args.insert(0, t.name);
				b.add([for(a in args)
					if(a == null) "Void"
					else if(a.isBuiltin()) a
					else "Dynamic"
				].join(" -> "));
			}
			b.add(' -> ${m.name == "new" ? t.name : m.ret}');
		} else {
			var type = if(f.type == null) "Void"
			else if(f.type.isBuiltin()) f.type
			else "Dynamic";
			b.add('Void -> ${f.type == null ? "Void" : f.type}');
		}
	}
	public function generateExtern(f:FieldData, t:TypeData) {
		var ps = untyped (f.args == null ? 0 : f.args);
		var name = CppGen.getName(f);
		b.add('\tstatic var $name:');
		generateFuncType(f, t);
		b.add(' = load("${d.library}", "$name", ps);');
		b.add("\n");
	}
	public function generateType(t:TypeData):String {
		var parts = t.name.split(".");
		var name = parts[parts.length-1];
		b = new StringBuf();
		if(parts.length > 0)
			b.add("package "+parts.slice(0, parts.length-1).join(".")+";\n");
		if(t.type == null)
			t.type = t.values != null ? "enum" : "class";
		if(t.type == "class")
			b.add("#if cpp\n\timport cpp.Lib.load;\n#else\n\timport neko.Lib.load;\n#end\n");
		switch(t.type) {
			case "enum":
				b.add('enum $name {\n');
				for(v in t.values)
					b.add('\t$v;\n');
				b.add("}");
			case "class":
				b.add('abstract $name(Dynamic) {\n');
				if(t.extend != null) {
					b.add('\t@:from static inline function from${t.extend.name}(o:${t.extend}):${t.name} return cast o;\n');
					b.add('\t@:to inline function to${t.extend.name}():${t.extend} return cast this;\n');
				}
				var all:Array<FieldData> = [];
				if(t.fields != null) {
					all = all.concat(t.fields);
					for(f in t.fields)
						generateField(f);
				}
				if(t.methods != null) {
					all = all.concat(cast t.methods);
					for(m in t.methods)
						generateMethod(m);
				}
				for(a in all)
					generateExtern(a, t);
				b.add("}");
		}
		b.add("\n");
		return b.toString();
	}
}