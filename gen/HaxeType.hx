package gen;
using StringTools;
import haxe.macro.Type;
import haxe.macro.Expr;
abstract HaxeType(String) from String to String {
	static var linkWrap = ~/<a class="el" href=".*">(.*?)<\/a>/;
	public static var kinds = new Map<String, String>();
	static var kid = 0;
	public var isPointer(get, set):Bool;
	public var kind(get, never):String;
	public var defaultNative(get, never):String;
	public var name(get, never):String;
	public var parts(get, never):Array<String>;
	public var haxe(get, never):String;
	@:to public inline function toComplexType():ComplexType {
		return TPath({
			params: [],
			pack: {
				var ps = get_parts();
				ps.slice(0, ps.length-1);
			},
			name: new HaxeType(get_haxe()).name
		});
	}
	inline function get_haxe() {
		var s = this;
		while(s.endsWith("*") || s.endsWith("&"))
			s = s.substr(0, s.length-1);
		return s;
	}
	inline function get_parts() return this.split(".");
	inline function get_name():String {
		var s = this.split(".");
		return s[s.length-1];
	}
	public inline function new(s:String) this = s;
	inline function get_kind():String {
		var isP = get_isPointer();
		var full = isP ? this.substr(0, this.length-1) : this;
		return if(kinds.exists(full))
			kinds.get(full);
		else {
			var id = "k_"+Tools.id(kid++);
			kinds.set(full, id);
			id;
		}
	}
	inline function get_defaultNative():String {
		return this.replace(".", "::");
	}
	inline function get_isPointer():Bool {
		return this.endsWith("*");
	}
	inline function set_isPointer(v:Bool) {
		if(get_isPointer() != v && v) this = '$this*'
		else if(get_isPointer() != v && !v) this = this.substr(0, this.length-1);
		return v;
	}
	public inline function isBuiltin():Bool {
		return switch(this) {
			case "Int", "Float", "String", "Single", "Bool", "Void": true;
			default: false;
		}
	}
	public inline function isArray():Bool {
		return this.startsWith("Array<") && this.endsWith(">");
	}
	public static function fromNativeName(s:String):String {
		s = s.replace("::", ".");
		if(s.indexOf("_") != -1)
			s = [for(p in s.split("_")) toProperCase(p)].join("");
		if(s.indexOf(".") != -1) {
			var parts = s.split(".");
			parts.push(toProperCase(parts.pop(), false));
			s = [for(i in 0...parts.length) i == parts.length - 1 ? parts[i] : parts[i].toLowerCase()].join(".");
		}
		return s;
	}
	static function toProperCase(s:String, strong:Bool=false):String
		return s.substring(0, 1).toUpperCase() + (strong ? s.substring(1).toLowerCase() : s.substring(1));
	public function arrayType():HaxeType {
		return this.substring(6, this.length-1);
	}
	public function toNative():String {
		var s:HaxeType = this;
		var ss:String = s;
		var isP = s.isPointer;
		if(isP)
			s = ss.substr(0, ss.length-1);
		return (switch(s) {
			case "Int": "int";
			case "UInt": "uint";
			case "haxe.Int64": "int64";
			case "Single": "float";
			case "Float": "double";
			case "Void": "void";
			case "Bool": "bool";
			case "String": "std::string";
			default: "???";
		}) + (isP ? "*" : "");
	}
	public static function ofNative(s:String):HaxeType {
		s = s.replace("const ", "").replace("virtual ", "").replace("&#160;", "");
		if(linkWrap.match(s))
			s = linkWrap.matched(1);
		if(s.indexOf(" ") == s.lastIndexOf(" ") && s.indexOf(" ") != -1)
			s = s.substr(0, s.indexOf(" "));
		var pointer = s.endsWith("*");
		if(pointer)
			s = s.substr(0, s.length-1);
		var s = switch(s) {
			case "bool": "Bool";
			case _ if(s.endsWith("[]")): 'Array<${ofNative(s.substring(0, s.length-2))}>';
			case _ if(s.startsWith("[") && s.endsWith("]")): 'Array<${ofNative(s.substring(1, s.length-1))}>';
			case "unsigned", "char", "int", "uint", "int8", "uint8", "int16", "uint16", "int32", "uint32": "Int";
			case _ if(s.indexOf("int64") != -1): "Int64";
			case "double": "Float";
			case "float": "Single";
			case "std::string", "string": "String";
			case "void": "Void";
			default: fromNativeName(s);
		}
		if(pointer)
			s += "*";
		return s;
	}
}