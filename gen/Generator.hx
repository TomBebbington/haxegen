package gen;
using sys.io.File;
using sys.FileSystem;
using StringTools;
import gen.data.*;
class Generator {
	public static function main() {
		var args = Sys.args();
		Sys.setCwd(args[args.length-1]);
		args = args.slice(0, args.length-1);
		switch(args) {
			case ["doxygen", url]:
				throw "Library name required";
			case ["doxygen", url, libName]:
				gen.parser.DoxygenParser.parseURL(url, libName, function(data) "build.json".saveContent(haxe.Json.stringify(data)));
			case ["filter", path, regex]:
				if(!path.exists()) throw 'File $path does not exist';
				else if(!path.endsWith(".json")) throw "Incorrect file format";
				var data:gen.data.Project = haxe.Json.parse(path.getContent());
				var regex = new EReg(regex.exists() ? regex.getContent() : regex, "");
				data.types = [for(t in data.types) if(regex.match(t.name) && regex.matchedRight().length <= 0) t];
				path.saveContent(haxe.Json.stringify(data));
			case [path]:
				if(!path.exists()) throw 'File $path does not exist';
				else if(!path.endsWith(".json")) throw "Incorrect file format";
				var data = preprocess(haxe.Json.parse(path.getContent()));
				new HaxeGen(data).generate();
				new CppGen(data).generate();
			case all: throw 'Unrecognised command $all';
		}
	}
	static function preprocess(p:Project):Project {
		if(p.cffi == null)
			p.cffi = "project/common/ExternalInterface.cpp";
		for(t in p.types) {
			if(t.native == null)
				t.native = t.name.defaultNative;
			else if(t.name == null)
				t.name = HaxeType.fromNativeName(t.native);
			if(t.type == null)
				t.type = t.values != null ? "enum" : "class";
			if(t.properties == null)
				t.properties = [];
			if(t.fields == null)
				t.fields = [];
			if(t.methods == null)
				t.methods = [];
			for(prop in t.properties) {
				var upped = prop.name.charAt(0).toUpperCase() + prop.name.substr(1);
				if(prop.getter == null) prop.getter = 'get$upped';
				if(prop.setter == null) prop.setter = 'set$upped';
				t.methods.push({
					name: prop.getter,
					ret: prop.type,
					rename: 'get_${prop.name}',
					isStatic: prop.isStatic,
					isConst: prop.isConst
				});
				t.methods.push({
					name: prop.setter,
					args: [prop.type],
					ret: "Void",
					rename: 'set_${prop.name}',
					isStatic: prop.isStatic,
					isConst: prop.isConst
				});
			}
			for(m in t.methods) {
				if(m.ret == null)
					m.ret = "Dynamic";
			}
		}
		return p;
	}
}