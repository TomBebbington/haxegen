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
				"build.json".saveContent(haxe.Json.stringify(gen.parser.DoxygenParser.parseURL(url, libName)));
			case [path]:
				if(!path.exists()) throw 'File $path does not exist';
				else if(!path.endsWith(".json")) throw 'Incorrect file format';
				var data:gen.data.Project = haxe.Json.parse(path.getContent());
				new HaxeGen(data).generate();
				new CppGen(data).generate();
			case all: throw 'Unrecognised command $all';
		}
	}
}