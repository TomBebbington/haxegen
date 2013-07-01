package gen {
	import haxe.Json;
	import gen.CppGen;
	import sys.FileSystem;
	import gen._HaxeType.HaxeType_Impl_;
	import sys.io.File;
	import gen.parser.DoxygenParser;
	import gen.HaxeGen;
class Generator =;
	object;
		static public function main() : unit (;
			let args : List = Sys.args() in;
			Sys.setCwd(args[args.length - 1]);
			args = args.slice(0,args.length - 1);
			(;
				let all : List = args in;
				switch(args.length) {
				case 2:
				switch(args[0]) {
				case "doxygen":
				(;
					let url : String = args[1] in;
					throw "Library name required";
				);
				break;
				default:
				throw "Unrecognised command " + Std.string(all);
				break;
				}
				break;
				case 3:
				switch(args[0]) {
				case "doxygen":
				(;
					let libName : String = args[2] in;
					let url : String = args[1] in;
					gen.parser.DoxygenParser.parseURL(url,libName,function(data : *) : unit (;
						sys.io.File.saveContent("build.json",haxe.Json.stringify(data,null));
					));
				);
				break;
				case "filter":
				(;
					let regex : String = args[2] in;
					let path : String = args[1] in;
					(;
						if(!sys.FileSystem.exists(path)) throw "File " + path + " does not exist";
						else if(!StringTools.endsWith(path,".json")) throw "Incorrect file format";
						let data : * = haxe.Json.parse(sys.io.File.getContent(path)) in;
						let regex1 : EReg = new EReg(((sys.FileSystem.exists(regex))?sys.io.File.getContent(regex):regex),"") in;
						(;
							let _g : List = [] in;
							(;
								let _g1 : int32 = 0 in;
								let _g2 : List = data.types in;
								while(_g1 < _g2.length) (;
									let t : * = _g2[_g1] in;
									++_g1;
									if(regex1.match(t.name) && regex1.matchedRight().length <= 0) _g.push(t);
								);
							);
							data.types = _g;
						);
						sys.io.File.saveContent(path,haxe.Json.stringify(data,null));
					);
				);
				break;
				default:
				throw "Unrecognised command " + Std.string(all);
				break;
				}
				break;
				case 1:
				(;
					let path : String = args[0] in;
					(;
						if(!sys.FileSystem.exists(path)) throw "File " + path + " does not exist";
						else if(!StringTools.endsWith(path,".json")) throw "Incorrect file format";
						let data : * = gen.Generator.preprocess(haxe.Json.parse(sys.io.File.getContent(path))) in;
						new gen.HaxeGen(data).generate();
						new gen.CppGen(data).generate();
					);
				);
				break;
				default:
				throw "Unrecognised command " + Std.string(all);
				break;
				}
			);
		);
		
		static protected function preprocess(p : *) : * (;
			if(p.cffi == null) p.cffi = "project/common/ExternalInterface.cpp";
			(;
				let _g : int32 = 0 in;
				let _g1 : List = p.types in;
				while(_g < _g1.length) (;
					let t : * = _g1[_g] in;
					++_g;
					if(t._native == null) t._native = StringTools.replace(t.name,".","::");
					else if(t.name == null) t.name = gen._HaxeType.HaxeType_Impl_.fromNativeName(t._native);
					if(t.type == null) (;
						if(t.values != null) t.type = "enum";
						else t.type = "class";
					);
					if(t.properties == null) t.properties = [];
					if(t.fields == null) t.fields = [];
					if(t.methods == null) t.methods = [];
					(;
						let _g2 : int32 = 0 in;
						let _g3 : List = t.properties in;
						while(_g2 < _g3.length) (;
							let prop : * = _g3[_g2] in;
							++_g2;
							let upped : String = prop.name.charAt(0).toUpperCase() + prop.name.substr(1,null) in;
							if(prop.getter == null) prop.getter = "get" + upped;
							if(prop.setter == null) prop.setter = "set" + upped;
							t.methods.push({ name : prop.getter, ret : prop.type, rename : "get_" + prop.name, isStatic : prop.isStatic, isConst : prop.isConst});
							t.methods.push({ name : prop.setter, args : [prop.type], ret : String("Void"), rename : "set_" + prop.name, isStatic : prop.isStatic, isConst : prop.isConst});
						);
					);
				);
			);
			return p;
		);
		
end;
	