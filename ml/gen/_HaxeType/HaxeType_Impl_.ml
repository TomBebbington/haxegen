package gen._HaxeType {
	import haxe.macro.ComplexType;
	import gen.Tools;
	import haxe.ds.StringMap;
class HaxeType_Impl_ =;
	object;
		static protected var linkWrap : EReg = new EReg("<a class=\"el\" href=\".*\">(.*?)</a>","");
		static public var kinds : IMap = new haxe.ds.StringMap();
		static protected var kid : int32 = 0;
		static public function get isPointer() : bool { return get_isPointer(); }
		static public function set isPointer( __v : bool ) : void { set_isPointer(__v); }
		static protected var $isPointer : bool;
		static public function get kind() : String { return get_kind(); }
		static public function set kind( __v : String ) : void { $kind = __v; }
		static protected var $kind : String;
		static public function get defaultNative() : String { return get_defaultNative(); }
		static public function set defaultNative( __v : String ) : void { $defaultNative = __v; }
		static protected var $defaultNative : String;
		static public function get name() : String { return get_name(); }
		static public function set name( __v : String ) : void { $name = __v; }
		static protected var $name : String;
		static public function get parts() : List { return get_parts(); }
		static public function set parts( __v : List ) : void { $parts = __v; }
		static protected var $parts : List;
		static public function get haxe() : String { return get_haxe(); }
		static public function set haxe( __v : String ) : void { $haxe = __v; }
		static protected var $haxe : String;
		static public function toComplexType(this1 : String) : haxe.macro.ComplexType (;
			return haxe.macro.ComplexType.TPath({ params : [], pack : function() : List {
				var $r : List;
				let ps : List = this1.split(".") in;
				$r = ps.slice(0,ps.length - 1);
				return $r;
			}(), name : function() : String {
				var $r2 : String;
				let s : List = (String(function() : String {
					var $r3 : String;
					let s : String = this1 in;
					while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
					$r3 = s;
					return $r3;
				}())).split(".") in;
				$r2 = s[s.length - 1];
				return $r2;
			}()});
		);
		
		static public function get_haxe(this1 : String) : String (;
			let s : String = this1 in;
			while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
			return s;
		);
		
		static public function get_parts(this1 : String) : List (;
			return this1.split(".");
		);
		
		static public function get_name(this1 : String) : String (;
			let s : List = this1.split(".") in;
			return s[s.length - 1];
		);
		
		static public function _new(s : String) : String (;
			return s;
		);
		
		static public function get_kind(this1 : String) : String (;
			let isP : bool = StringTools.endsWith(this1,"*") in;
			let full : String = () in;
			if(isP) full = this1.substr(0,this1.length - 1);
			else full = this1;
			if(gen._HaxeType.HaxeType_Impl_.kinds.exists(full)) return gen._HaxeType.HaxeType_Impl_.kinds.get(full);
			else (;
				let id : String = "k_" + gen.Tools.id(gen._HaxeType.HaxeType_Impl_.kid++) in;
				gen._HaxeType.HaxeType_Impl_.kinds.set(full,id);
				return id;
			);
		);
		
		static public function get_defaultNative(this1 : String) : String (;
			return StringTools.replace(this1,".","::");
		);
		
		static public function get_isPointer(this1 : String) : bool (;
			return StringTools.endsWith(this1,"*");
		);
		
		static public function set_isPointer(this1 : String,v : bool) : bool (;
			if(StringTools.endsWith(this1,"*") != v && v) this1 = "" + this1 + "*";
			else if(StringTools.endsWith(this1,"*") != v && !v) this1 = this1.substr(0,this1.length - 1);
			return v;
		);
		
		static public function isBuiltin(this1 : String) : bool (;
			switch(this1) {
			case "Int":case "Float":case "String":case "Single":case "Bool":case "Void":
			return true;
			break;
			default:
			return false;
			break;
			}
		);
		
		static public function fromNativeName(s : String) : String (;
			s = StringTools.replace(s,"::",".");
			if(s.indexOf("_",null) != -1) s = (function() : List {
				var $r : List;
				let _g : List = [] in;
				(;
					let _g1 : int32 = 0 in;
					let _g2 : List = s.split("_") in;
					while(_g1 < _g2.length) (;
						let p : String = _g2[_g1] in;
						++_g1;
						_g.push(gen._HaxeType.HaxeType_Impl_.toProperCase(p,null));
					);
				);
				$r = _g;
				return $r;
			}()).join("");
			if(s.indexOf(".",null) != -1) (;
				let parts : List = s.split(".") in;
				parts.push(gen._HaxeType.HaxeType_Impl_.toProperCase(parts.pop(),false));
				s = (function() : List {
					var $r2 : List;
					let _g1 : List = [] in;
					(;
						let _g3 : int32 = 0 in;
						let _g2 : int32 = parts.length in;
						while(_g3 < _g2) (;
							let i : int32 = _g3++ in;
							_g1.push(((i == parts.length - 1)?parts[i]:parts[i].toLowerCase()));
						);
					);
					$r2 = _g1;
					return $r2;
				}()).join(".");
			);
			return s;
		);
		
		static protected function toProperCase(s : String,strong : bool = false) : String (;
			return s.substring(0,1).toUpperCase() + (((strong)?s.substring(1,null).toLowerCase():s.substring(1,null)));
		);
		
		static public function toNative(this1 : String) : String (;
			let s : String = this1 in;
			let ss : String = s in;
			let isP : bool = StringTools.endsWith(s,"*") in;
			if(isP) s = ss.substr(0,ss.length - 1);
			return function() : String {
				var $r : String;
				switch(s) {
				case "Int":
				$r = "int";
				break;
				case "UInt":
				$r = "uint";
				break;
				case "haxe.Int64":
				$r = "int64";
				break;
				case "Single":
				$r = "float";
				break;
				case "Float":
				$r = "double";
				break;
				case "Void":
				$r = "void";
				break;
				case "Bool":
				$r = "bool";
				break;
				case "String":
				$r = "std::string";
				break;
				default:
				$r = "???";
				break;
				}
				return $r;
			}() + (((isP)?"*":""));
		);
		
		static public function ofNative(s : String) : String (;
			s = StringTools.replace(StringTools.replace(StringTools.replace(s,"const ",""),"virtual ",""),"&#160;","");
			if(gen._HaxeType.HaxeType_Impl_.linkWrap.match(s)) s = gen._HaxeType.HaxeType_Impl_.linkWrap.matched(1);
			if(s.indexOf(" ",null) == s.lastIndexOf(" ",null) && s.indexOf(" ",null) != -1) s = s.substr(0,s.indexOf(" ",null));
			let pointer : bool = StringTools.endsWith(s,"*") in;
			if(pointer) s = s.substr(0,s.length - 1);
			let s1 : String = () in;
			switch(s) {
			case "bool":
			s1 = "Bool";
			break;
			case "unsigned":
			if(StringTools.startsWith(s,"[") && StringTools.endsWith(s,"]")) s1 = "Array<" + Std.string(gen._HaxeType.HaxeType_Impl_.ofNative(s.substring(1,s.length - 1))) + ">";
			else s1 = "Int";
			break;
			case "char":case "int":case "uint":case "int8":case "uint8":case "int16":case "uint16":case "int32":case "uint32":
			if(StringTools.startsWith(s,"[") && StringTools.endsWith(s,"]")) s1 = "Array<" + Std.string(gen._HaxeType.HaxeType_Impl_.ofNative(s.substring(1,s.length - 1))) + ">";
			else s1 = "Int";
			break;
			case "double":
			if(StringTools.startsWith(s,"[") && StringTools.endsWith(s,"]")) s1 = "Array<" + Std.string(gen._HaxeType.HaxeType_Impl_.ofNative(s.substring(1,s.length - 1))) + ">";
			else if(s.indexOf("int64",null) != -1) s1 = "Int64";
			else s1 = "Float";
			break;
			case "float":
			if(StringTools.startsWith(s,"[") && StringTools.endsWith(s,"]")) s1 = "Array<" + Std.string(gen._HaxeType.HaxeType_Impl_.ofNative(s.substring(1,s.length - 1))) + ">";
			else if(s.indexOf("int64",null) != -1) s1 = "Int64";
			else s1 = "Single";
			break;
			case "std::string":case "string":
			if(StringTools.startsWith(s,"[") && StringTools.endsWith(s,"]")) s1 = "Array<" + Std.string(gen._HaxeType.HaxeType_Impl_.ofNative(s.substring(1,s.length - 1))) + ">";
			else if(s.indexOf("int64",null) != -1) s1 = "Int64";
			else s1 = "String";
			break;
			case "void":
			if(StringTools.startsWith(s,"[") && StringTools.endsWith(s,"]")) s1 = "Array<" + Std.string(gen._HaxeType.HaxeType_Impl_.ofNative(s.substring(1,s.length - 1))) + ">";
			else if(s.indexOf("int64",null) != -1) s1 = "Int64";
			else s1 = "Void";
			break;
			default:
			if(StringTools.startsWith(s,"[") && StringTools.endsWith(s,"]")) s1 = "Array<" + Std.string(gen._HaxeType.HaxeType_Impl_.ofNative(s.substring(1,s.length - 1))) + ">";
			else if(s.indexOf("int64",null) != -1) s1 = "Int64";
			else s1 = gen._HaxeType.HaxeType_Impl_.fromNativeName(s);
			break;
			};
			if(pointer) s1 += "*";
			return s1;
		);
		
end;
	