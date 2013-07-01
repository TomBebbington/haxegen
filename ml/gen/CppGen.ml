package gen {
	import sys.io.File;
	import gen._HaxeType.HaxeType_Impl_;
	import gen.Tools;
	import haxe.ds.ObjectMap;
	import flash.Boot;
class CppGen =;
	object;
		public function CppGen(d : * = null) : unit ( if( !flash.Boot.skip_constructor ) {
			this.d = d;
		});
		
		public function generateHeaders() : unit (;
			let headers : List = ["<hx/CFFI.h>","<string.h>"] in;
			(;
				let _g : int32 = 0 in;
				let _g1 : List = this.d.types in;
				while(_g < _g1.length) (;
					let t : * = _g1[_g] in;
					++_g;
					if(t.headers != null && t.headers.length > 0) (;
						let _g2 : int32 = 0 in;
						let _g3 : List = t.headers in;
						while(_g2 < _g3.length) (;
							let h : String = _g3[_g2] in;
							++_g2;
							if(Lambda.indexOf(headers,h) == -1) headers.push(h);
						);
					);
				);
			);
			(;
				let _g : int32 = 0 in;
				while(_g < headers.length) (;
					let h : String = headers[_g] in;
					++_g;
					let name : String = () in;
					if(h.charAt(0) == "<") name = h;
					else name = "\"" + h + "\"";
					this.b.b += Std.string("#include " + name + "\n");
				);
			);
		);
		
		public function generateMethod(m : *,t : *) : unit (;
			let id : String = gen.CppGen.getName(m) in;
			if(m.ret == null) m.ret = "Dynamic";
			if(m.args == null) m.args = [];
			let isVoid : bool = m.ret == "Void" in;
			let argOff : int32 = () in;
			if(m.isStatic) argOff = 0;
			else argOff = 1;
			let argIds : List = () in;
			(;
				let _g : List = [] in;
				(;
					let _g2 : int32 = 0 in;
					let _g1 : int32 = argOff + m.args.length in;
					while(_g2 < _g1) (;
						let i : int32 = _g2++ in;
						_g.push(gen.Tools.id(i));
					);
				);
				argIds = _g;
			);
			this.b.b += Std.string(((m.ret == "Void")?"void":"value"));
			this.b.b += Std.string(" " + id + "(");
			this.b.b += Std.string(((function($this:CppGen) : List {
				var $r : List;
				let _g1 : List = [] in;
				(;
					let _g2 : int32 = 0 in;
					while(_g2 < argIds.length) (;
						let a : String = argIds[_g2] in;
						++_g2;
						_g1.push("value " + a);
					);
				);
				$r = _g1;
				return $r;
			}(this))).join(", "));
			this.b.b += Std.string(") { // " + m.name + " \n\t");
			if(!isVoid) (;
				let _native : String = () in;
				(;
					let s : String = m.ret in;
					let n : String = gen._HaxeType.HaxeType_Impl_.toNative(s) in;
					if(n == null || n.indexOf("???",null) != -1) _native = this.lookupNative(s);
					else _native = n;
				);
				if(m.isConst) _native = "const " + _native;
				this.b.b += Std.string("" + _native + " v = ");
			);
			let callStr : String = "" in;
			if(m.isStatic) callStr += (((t._native == null)?StringTools.replace(t.name,".","::"):t._native)) + "::";
			else callStr += this.generateConversionFrom(argIds[0],t.name) + " -> ";
			let args : String = ((function($this:CppGen) : List {
				var $r2 : List;
				let _g2 : List = [] in;
				(;
					let _g4 : int32 = 0 in;
					let _g3 : int32 = m.args.length in;
					while(_g4 < _g3) (;
						let i : int32 = _g4++ in;
						_g2.push($this.generateConversionFrom(argIds[i + argOff],m.args[i]));
					);
				);
				$r2 = _g2;
				return $r2;
			}(this))).join(", ") in;
			callStr += "" + m.name + "(" + args + ")";
			if(m.code == null) this.b.b += Std.string(callStr);
			else this.b.b += Std.string(StringTools.replace(m.code,"$",callStr));
			this.b.b += ";\n";
			if(!isVoid) (;
				if(!StringTools.endsWith(m.ret,"*")) (;
					this.b.b += "\t";
					let ntv : String = () in;
					ntv = (function($this:CppGen) : String {
						var $r3 : String;
						let s : String = m.ret in;
						let n : String = gen._HaxeType.HaxeType_Impl_.toNative(s) in;
						$r3 = ((n == null || n.indexOf("???",null) != -1)?$this.lookupNative(s):n);
						return $r3;
					}(this)) + "*";
					if(m.isConst) ntv = "const " + ntv;
					this.b.b += Std.string("" + ntv + " bv = &v;\n");
				);
				this.b.b += "\treturn ";
				this.b.b += Std.string(this.generateConversionTo(((StringTools.endsWith(m.ret,"*"))?"v":"bv"),m.ret));
				this.b.b += ";\n";
			);
			this.b.b += "}\n";
			this.b.b += Std.string("DEFINE_PRIM(" + id + "," + argIds.length + ");\n");
		);
		
		public function generateConstructor(m : *,t : *) : unit (;
			let id : String = gen.CppGen.getName(m) in;
			if(m.ret == null) m.ret = "Dynamic";
			if(m.args == null) m.args = [];
			let argIds : List = () in;
			(;
				let _g : List = [] in;
				(;
					let _g2 : int32 = 0 in;
					let _g1 : int32 = m.args.length in;
					while(_g2 < _g1) (;
						let i : int32 = _g2++ in;
						_g.push(gen.Tools.id(i));
					);
				);
				argIds = _g;
			);
			this.b.b += Std.string("value " + id + "(");
			this.b.b += Std.string(((function($this:CppGen) : List {
				var $r : List;
				let _g1 : List = [] in;
				(;
					let _g2 : int32 = 0 in;
					while(_g2 < argIds.length) (;
						let a : String = argIds[_g2] in;
						++_g2;
						_g1.push("value " + a);
					);
				);
				$r = _g1;
				return $r;
			}(this))).join(", "));
			let _native : String = "" + t._native + "*" in;
			if(m.isConst) _native = "const " + _native;
			this.b.b += ") {";
			this.b.b += "// constructor";
			this.b.b += Std.string("\n\t" + _native + " v = ");
			this.b.b += Std.string(m.name);
			this.b.b += " ";
			this.b.b += Std.string(t._native);
			this.b.b += "(";
			let arguments : List = argIds.copy() in;
			this.b.b += Std.string(arguments.join(", "));
			this.b.b += ");\n\treturn ";
			this.b.b += Std.string(this.generateConversionTo("v",t.name));
			this.b.b += Std.string(";\n}\nDEFINE_PRIM(" + id + "," + argIds.length + ");\n");
		);
		
		public function generateConversionTo(name : String,typ : String) : String (;
			switch(typ) {
			case "Int":case "Uint":case "Int64":case "haxe.Int64":
			return "alloc_int(" + name + ")";
			break;
			case "String":
			return "alloc_string(" + name + " -> c_str())";
			break;
			case "Float":case "Single":
			return "alloc_float(" + name + ")";
			break;
			case "Bool":
			return "alloc_bool(" + name + ")";
			break;
			case "Dynamic":
			return "alloc_object(" + name + ")";
			break;
			default:
			return "alloc_abstract(" + (function($this:CppGen) : String {
				var $r : String;
				let isP : bool = StringTools.endsWith(typ,"*") in;
				let full : String = () in;
				if(isP) full = typ.substr(0,typ.length - 1);
				else full = typ;
				$r = ((gen._HaxeType.HaxeType_Impl_.kinds.exists(full))?gen._HaxeType.HaxeType_Impl_.kinds.get(full):(function($this:CppGen) : String {
					var $r2 : String;
					let id : String = "k_" + gen.Tools.id(gen._HaxeType.HaxeType_Impl_.kid++) in;
					gen._HaxeType.HaxeType_Impl_.kinds.set(full,id);
					$r2 = id;
					return $r2;
				}($this)));
				return $r;
			}(this)) + "," + (((StringTools.endsWith(typ,"*"))?"":"&")) + name + ")";
			break;
			}
		);
		
		public function generateConversionFrom(name : String,typ : String) : String (;
			switch(typ) {
			case "Int":case "Uint":case "Int64":case "haxe.Int64":
			return "val_int(" + name + ")";
			break;
			case "String":
			return "val_string(" + name + ")";
			break;
			case "Float":case "Single":
			return "val_float(" + name + ")";
			break;
			case "Bool":
			return "val_bool(" + name + ")";
			break;
			default:
			return "((" + ((function($this:CppGen) : String {
				var $r : String;
				let n : String = gen._HaxeType.HaxeType_Impl_.toNative(typ) in;
				$r = ((n == null || n.indexOf("???",null) != -1)?$this.lookupNative(typ):n);
				return $r;
			}(this)) + (((StringTools.endsWith(typ,"*"))?"":"*"))) + ") val_kind(" + name + "))";
			break;
			}
		);
		
		protected function toNative(s : String) : String (;
			let n : String = gen._HaxeType.HaxeType_Impl_.toNative(s) in;
			if(n == null || n.indexOf("???",null) != -1) return this.lookupNative(s);
			else return n;
		);
		
		public function lookupNative(s : String) : String (;
			let isP : bool = StringTools.endsWith(s,"*") in;
			if(isP) (;
				if(StringTools.endsWith(s,"*") != false && false) s = "" + s + "*";
				else if(StringTools.endsWith(s,"*") != false) s = s.substr(0,s.length - 1);
				false;
			);
			let ntv : String = null in;
			(;
				let _g : int32 = 0 in;
				let _g1 : List = this.d.types in;
				while(_g < _g1.length) (;
					let t : * = _g1[_g] in;
					++_g;
					if(t.name == s || t._native == StringTools.replace(s,".","::")) (;
						ntv = t._native;
						break;
					);
				);
			);
			if(ntv == null) throw "Could not find type " + Std.string(s);
			if(isP) (;
				if(StringTools.endsWith(s,"*") != true) s = "" + s + "*";
				else if(StringTools.endsWith(s,"*") != true && false) s = s.substr(0,s.length - 1);
				true;
			);
			if(ntv == null) return StringTools.replace(s,".","::");
			else return ntv + (((isP)?"*":""));
		);
		
		public function generateType(t : *) : unit (;
			let ht : String = t.name in;
			if(t._native == null) t._native = StringTools.replace(ht,".","::");
			this.b.b += Std.string("DEFINE_KIND(" + (function($this:CppGen) : String {
				var $r : String;
				let isP : bool = StringTools.endsWith(ht,"*") in;
				let full : String = () in;
				if(isP) full = ht.substr(0,ht.length - 1);
				else full = ht;
				$r = ((gen._HaxeType.HaxeType_Impl_.kinds.exists(full))?gen._HaxeType.HaxeType_Impl_.kinds.get(full):(function($this:CppGen) : String {
					var $r2 : String;
					let id : String = "k_" + gen.Tools.id(gen._HaxeType.HaxeType_Impl_.kid++) in;
					gen._HaxeType.HaxeType_Impl_.kinds.set(full,id);
					$r2 = id;
					return $r2;
				}($this)));
				return $r;
			}(this)) + "); //" + Std.string(t.name) + "\n");
			let methods : List = [] in;
			if(t.methods != null) methods = methods.concat(t.methods);
			if(t.fields != null) (;
				let _g : int32 = 0 in;
				let _g1 : List = t.fields in;
				while(_g < _g1.length) (;
					let f : * = _g1[_g] in;
					++_g;
					methods.push({ ret : f.type, name : "get_" + f.name, args : [], isStatic : f.isStatic});
				);
			);
			(;
				let _g : int32 = 0 in;
				while(_g < methods.length) (;
					let m : * = methods[_g] in;
					++_g;
					switch(m.name) {
					case "new":
					this.generateConstructor(m,t);
					break;
					default:
					this.generateMethod(m,t);
					break;
					}
				);
			);
		);
		
		public function generate() : unit (;
			this.b = new StringBuf();
			this.b.b += "#ifndef IPHONE\n#define IMPLEMENT_API\n#endif\n#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)\n#define NEKO_COMPATIBLE\n#endif\n";
			this.generateHeaders();
			(;
				let _g : int32 = 0 in;
				let _g1 : List = this.d.types in;
				while(_g < _g1.length) (;
					let t : * = _g1[_g] in;
					++_g;
					this.generateType(t);
				);
			);
			if(this.d.library == "llvm") this.b.b += "extern \"C\" int llvm_register_prims() { return 0; }\n";
			sys.io.File.saveContent(this.d.cffi,this.b.b);
		);
		
		protected var b : StringBuf;
		protected var d : *;
		static public var names : IMap = new haxe.ds.ObjectMap();
		static protected var fc : int32 = 0;
		static public function getName(f : *) : String (;
			if(gen.CppGen.names.exists(f)) return gen.CppGen.names.get(f);
			else (;
				let id : String = "_" + gen.Tools.id(gen.CppGen.fc++) in;
				(;
					gen.CppGen.names.set(f,id);
					id;
				);
				return id;
			);
		);
		
end;
	