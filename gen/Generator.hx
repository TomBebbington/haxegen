package gen;
using sys.io.File;
using sys.FileSystem;
using StringTools;
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
				var regex = new EReg(regex, "");
				data.types = [for(t in data.types) if(regex.match(t.name) && regex.matchedRight().length <= 0) t];
				path.saveContent(haxe.Json.stringify(data));
			case [path]:
				if(!path.exists()) throw 'File $path does not exist';
				else if(!path.endsWith(".json")) throw "Incorrect file format";
				var data:gen.data.Project = haxe.Json.parse(path.getContent());
				new HaxeGen(data).generate();
				new CppGen(data).generate();
			case all: throw 'Unrecognised command $all';
		}
	}
}