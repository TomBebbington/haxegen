package gen.parser;
import gen.data.*;
using StringTools;
class DoxygenParser {
	static var classx = ~/<!-- doxytag: class="(.*?)" -->/;
	static var inheritx = ~/<!-- doxytag: inherits="(.*?)" -->/;
	static var memberx = ~/<!-- doxytag: member="(.*?)" ref="(.*?)" args="(.*?)" -->/;
	static var retx = ~/<td class="memItemLeft" align="right" valign="top">(.*?)<\/td><td class="memItemRight" valign="bottom"><a class="el" href=".*?">(.*?)<\/a>/;
	static var typex = ~/href="(class.*?)"/;
	static function fullURL(url:String, relTo:String):String {
		var dom = relTo;
		if(dom.indexOf("/") != -1)
			dom = dom.substr(0, dom.indexOf("/"));
		var loc = relTo;
		if(loc.indexOf("/") != -1)
			loc = loc.substr(0, loc.lastIndexOf("/"));
		return switch(url.indexOf("/")) {
			case -1: '$loc/$url';
			case 0: '$dom/$url';
			case all: url;
		}
	}
	static function parseClass(url:String, cb:TypeData -> Void):Void {
		var h = new haxe.Http(url);
		h.onData = function(cont:String) {
			//sys.io.File.saveContent("cont.html", cont);
			var td:TypeData = cast {};
			td.native = classx.match(cont) ? classx.matched(1) : throw 'Could not parse $url';
			td.name = HaxeType.ofNative(td.native);
			var nativeNames = td.native.split("::");
			var nativeName = nativeNames[nativeNames.length-1];
			var rets = Tools.matches(cont, retx, 2);
			var retMap = new Map<String, HaxeType>();
			for(r in rets) {
				if(r[0].trim().length > 0 && r[1].trim().length > 0)
					[retMap[r[1]] = HaxeType.ofNative(r[0])];
			}
			td.extend = inheritx.match(cont) ? HaxeType.ofNative(inheritx.matched(1).htmlUnescape()) : null;
			var members = Tools.matches(cont, memberx, 3);
			td.fields = [];
			td.methods = [];
			for(m in members) {
				m[2] = m[2].trim().htmlUnescape();
				if(m[2].length > 0 && m[2].charAt(0) == "(") {
					var args = m[2].substring(1, m[2].lastIndexOf(")"));
					var nameps = m[0].split("::");
					var name = nameps[nameps.length-1];
					var ret = retMap.exists(name) ? retMap.get(name) : null;
					if(name == nativeName || (name.substr(1) == nativeName && (name.charAt(0) == "~")))
						name = "new";
					td.methods.push({
						name: name,
						args: [for(a in args.split(", ")) if(a.length > 0) HaxeType.ofNative(a)],
						ret: ret
					});
				}
			}
			cb(td);
		};
		h.request(false);
	}
	public static function parseURL(url:String, library:String, cb:Project->Void):Void {
		var p:Project = {types: [], library: library, cffi: "project/common/ExternalInterface.cpp"};
		var cont = haxe.Http.requestUrl(url);
		sys.io.File.saveContent("cont.html", cont);
		var urls:Array<String> = [for(m in Tools.matches(cont, typex, 1)) if(m[0] != "classes.html") fullURL(m[0], url)];
		for(u in urls)
			parseClass(u, function(t:TypeData) {
				Sys.println('Parsed ${t.name}');
				p.types.push(t);
				cb(p);
			});
		while(p.types.length < urls.length) Sys.sleep(0.1);
	}
}