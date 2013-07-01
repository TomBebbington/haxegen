package gen {
	import haxe.macro.TypeDefKind;
	import gen.Tools;
	import sys.FileSystem;
	import sys.io.File;
	import haxe.macro.FieldType;
	import gen.CppGen;
	import haxe.ds.StringMap;
	import flash.Boot;
	import haxe.macro.ComplexType;
	import haxe.macro.Access;
	import haxe.macro.Printer;
	import haxe.macro.Constant;
	import haxe.macro.Binop;
	import haxe.macro.ExprDef;
class HaxeGen =;
	object;
		public function HaxeGen(d : * = null) : unit ( if( !flash.Boot.skip_constructor ) {
			this.d = d;
		});
		
		public function generateType(t : *) : String (;
			let parts : List = t.name.split(".") in;
			let name : String = () in;
			(;
				let s : List = t.name.split(".") in;
				name = s[s.length - 1];
			);
			let type : * = { pos : null, pack : parts.slice(0,parts.length - 1), params : [], name : (function($this:HaxeGen) : String {
				var $r : String;
				let s : List = t.name.split(".") in;
				$r = s[s.length - 1];
				return $r;
			}(this)), meta : [], isExtern : false, kind : (function($this:HaxeGen) : haxe.macro.TypeDefKind {
				var $r2 : haxe.macro.TypeDefKind;
				switch(t.type) {
				case "enum":
				$r2 = haxe.macro.TypeDefKind.TDEnum;
				break;
				default:
				$r2 = haxe.macro.TypeDefKind.TDAbstract(haxe.macro.ComplexType(haxe.macro.ComplexType.TPath({ pack : [], name : "Dynamic", params : []})),[],[]);
				break;
				}
				return $r2;
			}(this)), fields : (function($this:HaxeGen) : List {
				var $r3 : List;
				switch(t.type) {
				case "enum":
				$r3 = (function($this:HaxeGen) : List {
					var $r4 : List;
					let _g : List = [] in;
					(;
						let _g1 : int32 = 0 in;
						let _g2 : List = t.values in;
						while(_g1 < _g2.length) (;
							let v : String = _g2[_g1] in;
							++_g1;
							_g.push({ pos : null, name : v, kind : haxe.macro.FieldType.FVar(null,null)});
						);
					);
					$r4 = _g;
					return $r4;
				}($this));
				break;
				default:
				$r3 = (function($this:HaxeGen) : List {
					var $r5 : List;
					let fields : List = [] in;
					if(t.extend != null) (;
						fields.push({ pos : null, name : "to" + (function($this:HaxeGen) : String {
							var $r6 : String;
							let s : List = t.extend.split(".") in;
							$r6 = s[s.length - 1];
							return $r6;
						}($this)), kind : haxe.macro.FieldType.FFun({ ret : haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
							var $r7 : List;
							let ps : List = t.extend.split(".") in;
							$r7 = ps.slice(0,ps.length - 1);
							return $r7;
						}($this)), name : (function($this:HaxeGen) : String {
							var $r8 : String;
							let s : List = (String((function($this:HaxeGen) : String {
								var $r9 : String;
								let s : String = t.extend in;
								while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
								$r9 = s;
								return $r9;
							}($this)))).split(".") in;
							$r8 = s[s.length - 1];
							return $r8;
						}($this))}), params : [], expr : { expr : haxe.macro.ExprDef.EReturn({ expr : haxe.macro.ExprDef.ECast({ expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CIdent("this")), pos : { file : "./gen/HaxeGen.hx", min : 4443, max : 4447}},null), pos : { file : "./gen/HaxeGen.hx", min : 4438, max : 4447}}), pos : { file : "./gen/HaxeGen.hx", min : 4431, max : 4447}}, args : []}), access : [haxe.macro.Access.APublic,haxe.macro.Access.AInline], meta : [{ pos : null, params : [], name : ":to"}]});
						fields.push({ pos : null, name : "from" + (function($this:HaxeGen) : String {
							var $r10 : String;
							let s : List = t.extend.split(".") in;
							$r10 = s[s.length - 1];
							return $r10;
						}($this)), kind : haxe.macro.FieldType.FFun({ ret : haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
							var $r11 : List;
							let ps : List = t.extend.split(".") in;
							$r11 = ps.slice(0,ps.length - 1);
							return $r11;
						}($this)), name : (function($this:HaxeGen) : String {
							var $r12 : String;
							let s : List = (String((function($this:HaxeGen) : String {
								var $r13 : String;
								let s : String = t.extend in;
								while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
								$r13 = s;
								return $r13;
							}($this)))).split(".") in;
							$r12 = s[s.length - 1];
							return $r12;
						}($this))}), params : [], expr : { expr : haxe.macro.ExprDef.EReturn({ expr : haxe.macro.ExprDef.ECast({ expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CIdent("o")), pos : { file : "./gen/HaxeGen.hx", min : 4787, max : 4788}},null), pos : { file : "./gen/HaxeGen.hx", min : 4782, max : 4788}}), pos : { file : "./gen/HaxeGen.hx", min : 4775, max : 4788}}, args : [{ type : haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
							var $r14 : List;
							let ps : List = t.extend.split(".") in;
							$r14 = ps.slice(0,ps.length - 1);
							return $r14;
						}($this)), name : (function($this:HaxeGen) : String {
							var $r15 : String;
							let s : List = (String((function($this:HaxeGen) : String {
								var $r16 : String;
								let s : String = t.extend in;
								while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
								$r16 = s;
								return $r16;
							}($this)))).split(".") in;
							$r15 = s[s.length - 1];
							return $r15;
						}($this))}), opt : false, name : "o"}]}), access : [haxe.macro.Access.APublic,haxe.macro.Access.AStatic,haxe.macro.Access.AInline], meta : [{ pos : null, params : [], name : ":from"}]});
					);
					fields = fields.concat((function($this:HaxeGen) : List {
						var $r17 : List;
						let _g : List = [] in;
						(;
							let _g1 : int32 = 0 in;
							let _g2 : List = t.properties in;
							while(_g1 < _g2.length) (;
								let p : * = _g2[_g1] in;
								++_g1;
								_g.push($this.generateProperty(p));
							);
						);
						$r17 = _g;
						return $r17;
					}($this)));
					fields = fields.concat((function($this:HaxeGen) : List {
						var $r18 : List;
						let _g1 : List = [] in;
						(;
							let _g2 : int32 = 0 in;
							let _g3 : List = t.fields in;
							while(_g2 < _g3.length) (;
								let f : * = _g3[_g2] in;
								++_g2;
								_g1.push($this.generateField(f));
							);
						);
						$r18 = _g1;
						return $r18;
					}($this)));
					fields = fields.concat((function($this:HaxeGen) : List {
						var $r19 : List;
						let _g2 : List = [] in;
						(;
							let _g3 : int32 = 0 in;
							let _g4 : List = t.methods in;
							while(_g3 < _g4.length) (;
								let m : * = _g4[_g3] in;
								++_g3;
								_g2.push($this.generateMethod(m,t));
							);
						);
						$r19 = _g2;
						return $r19;
					}($this)));
					fields = fields.concat((function($this:HaxeGen) : List {
						var $r20 : List;
						let _g3 : List = [] in;
						(;
							let _g4 : int32 = 0 in;
							let _g5 : List = t.methods in;
							while(_g4 < _g5.length) (;
								let m : * = _g5[_g4] in;
								++_g4;
								_g3.push($this.generateNativeMethod(m,t));
							);
						);
						$r20 = _g3;
						return $r20;
					}($this)));
					$r5 = fields;
					return $r5;
				}($this));
				break;
				}
				return $r3;
			}(this))} in;
			return new haxe.macro.Printer(null).printTypeDefinition(type,null);
		);
		
		public function generateFuncType(f : *,t : *) : haxe.macro.ComplexType (;
			let method : * = () in;
			if(f.ret != null || (f.args != null || f.name == "new")) method = f;
			else method = null;
			if(method.args == null) method.args = [];
			let args : List = [] in;
			let ret : String = null in;
			if(method != null) (;
				ret = method.ret;
				if(method.isStatic) args = method.args;
				else (;
					let cargs : List = method.args.copy() in;
					cargs.insert(0,t.name);
					args = cargs;
				);
			);
			else (;
				ret = f.type;
				if(!f.isStatic) args.push(t.name);
			);
			return haxe.macro.ComplexType.TFunction((function($this:HaxeGen) : List {
				var $r : List;
				let _g : List = [] in;
				(;
					let _g1 : int32 = 0 in;
					while(_g1 < args.length) (;
						let a : String = args[_g1] in;
						++_g1;
						_g.push((((function($this:HaxeGen) : bool {
							var $r2 : bool;
							switch(a) {
							case "Int":case "Float":case "String":case "Single":case "Bool":case "Void":
							$r2 = true;
							break;
							default:
							$r2 = false;
							break;
							}
							return $r2;
						}($this)))?haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
							var $r3 : List;
							let ps : List = a.split(".") in;
							$r3 = ps.slice(0,ps.length - 1);
							return $r3;
						}($this)), name : (function($this:HaxeGen) : String {
							var $r4 : String;
							let s : List = (String((function($this:HaxeGen) : String {
								var $r5 : String;
								let s : String = a in;
								while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
								$r5 = s;
								return $r5;
							}($this)))).split(".") in;
							$r4 = s[s.length - 1];
							return $r4;
						}($this))}):haxe.macro.ComplexType(haxe.macro.ComplexType.TPath({ pack : [], name : "Dynamic", params : []}))));
					);
				);
				$r = _g;
				return $r;
			}(this)),haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
				var $r6 : List;
				let ps : List = ret.split(".") in;
				$r6 = ps.slice(0,ps.length - 1);
				return $r6;
			}(this)), name : (function($this:HaxeGen) : String {
				var $r7 : String;
				let s : List = (String((function($this:HaxeGen) : String {
					var $r8 : String;
					let s : String = ret in;
					while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
					$r8 = s;
					return $r8;
				}($this)))).split(".") in;
				$r7 = s[s.length - 1];
				return $r7;
			}(this))}));
		);
		
		public function generateProperty(p : *) : * (;
			return { pos : null, name : p.name, kind : haxe.macro.FieldType.FProp("get","set",haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
				var $r : List;
				let ps : List = p.type.split(".") in;
				$r = ps.slice(0,ps.length - 1);
				return $r;
			}(this)), name : (function($this:HaxeGen) : String {
				var $r2 : String;
				let s : List = (String((function($this:HaxeGen) : String {
					var $r3 : String;
					let s : String = p.type in;
					while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
					$r3 = s;
					return $r3;
				}($this)))).split(".") in;
				$r2 = s[s.length - 1];
				return $r2;
			}(this))}),null), access : (function($this:HaxeGen) : List {
				var $r4 : List;
				let a : List = [] in;
				if(p.isStatic) a.push(haxe.macro.Access.AStatic);
				a.push(haxe.macro.Access.APublic);
				$r4 = a;
				return $r4;
			}(this))}
		);
		
		public function generateField(f : *) : * (;
			return { pos : null, name : ((f.rename == null)?f.name:f.rename), kind : ((f.type == null)?null:haxe.macro.FieldType.FProp("get","never",haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
				var $r : List;
				let ps : List = f.type.split(".") in;
				$r = ps.slice(0,ps.length - 1);
				return $r;
			}(this)), name : (function($this:HaxeGen) : String {
				var $r2 : String;
				let s : List = (String((function($this:HaxeGen) : String {
					var $r3 : String;
					let s : String = f.type in;
					while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
					$r3 = s;
					return $r3;
				}($this)))).split(".") in;
				$r2 = s[s.length - 1];
				return $r2;
			}(this))}),null)), access : (function($this:HaxeGen) : List {
				var $r4 : List;
				let a : List = [] in;
				if(f.isStatic) a.push(haxe.macro.Access.AStatic);
				a.push(haxe.macro.Access.APublic);
				$r4 = a;
				return $r4;
			}(this))}
		);
		
		public function generateNativeMethod(m : *,t : *) : * (;
			if(m.args == null) m.args = [];
			let argIds : haxe.ds.StringMap = () in;
			(;
				let _g : IMap = new haxe.ds.StringMap() in;
				(;
					let _g2 : int32 = 0 in;
					let _g1 : int32 = m.args.length in;
					while(_g2 < _g1) (;
						let i : int32 = _g2++ in;
						_g.set((function($this:HaxeGen) : String {
							var $r : String;
							let $t : String = m.args[i] in;
							if(Std._is($t,String)) (($t) as String);
							else throw "Class cast error";
							$r = $t;
							return $r;
						}(this)),gen.Tools.id(i));
					);
				);
				argIds = _g;
			);
			let f : * = this.generateField(m) in;
			f.access.push(haxe.macro.Access.AStatic);
			f.access.remove(haxe.macro.Access.APublic);
			f.access.push(haxe.macro.Access.APrivate);
			f.name = gen.CppGen.getName(m);
			let librarye : * = { expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CString(this.d.library)), pos : null} in;
			let name : * = { expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CString(gen.CppGen.getName(m))), pos : null} in;
			let arglen : * = { expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CInt(Std.string(m.args.length + (((m.isStatic || m.name == "new")?0:1))))), pos : null} in;
			f.kind = haxe.macro.FieldType.FVar(this.generateFuncType(m,t),{ expr : haxe.macro.ExprDef.ECall({ expr : haxe.macro.ExprDef.EField({ expr : haxe.macro.ExprDef.EField({ expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CIdent("cpp")), pos : { file : "./gen/HaxeGen.hx", min : 2400, max : 2403}},"Lib"), pos : { file : "./gen/HaxeGen.hx", min : 2400, max : 2407}},"load"), pos : { file : "./gen/HaxeGen.hx", min : 2400, max : 2412}},[librarye,name,arglen]), pos : { file : "./gen/HaxeGen.hx", min : 2400, max : 2439}});
			return f;
		);
		
		public function generateMethod(m : *,t : *) : * (;
			if(m.args == null) m.args = [];
			let argIds : IMap = new haxe.ds.StringMap() in;
			(;
				let _g1 : int32 = 0 in;
				let _g : int32 = m.args.length in;
				while(_g1 < _g) (;
					let i : int32 = _g1++ in;
					let v : String = gen.Tools.id(i) in;
					argIds.set((function($this:HaxeGen) : String {
						var $r : String;
						let $t : String = m.args[i] in;
						if(Std._is($t,String)) (($t) as String);
						else throw "Class cast error";
						$r = $t;
						return $r;
					}(this)),v);
					v;
				);
			);
			let f : * = this.generateField(m) in;
			f.access.push(haxe.macro.Access.AInline);
			let name : String = gen.CppGen.getName(m) in;
			let args : List = () in;
			if(m.isStatic || m.name == "new") args = m.args;
			else args = ([t.name]).concat(m.args);
			let cexpr : * = { expr : haxe.macro.ExprDef.ECall({ expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CIdent(name)), pos : null},(function($this:HaxeGen) : List {
				var $r2 : List;
				let _g : List = [] in;
				(;
					let _g1 : int32 = 0 in;
					while(_g1 < args.length) (;
						let a : String = args[_g1] in;
						++_g1;
						_g.push({ expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CIdent(((argIds.exists(a))?argIds.get(a):"this"))), pos : null});
					);
				);
				$r2 = _g;
				return $r2;
			}(this))), pos : null} in;
			f.kind = haxe.macro.FieldType.FFun({ ret : haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
				var $r3 : List;
				let ps : List = m.ret.split(".") in;
				$r3 = ps.slice(0,ps.length - 1);
				return $r3;
			}(this)), name : (function($this:HaxeGen) : String {
				var $r4 : String;
				let s : List = (String((function($this:HaxeGen) : String {
					var $r5 : String;
					let s : String = m.ret in;
					while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
					$r5 = s;
					return $r5;
				}($this)))).split(".") in;
				$r4 = s[s.length - 1];
				return $r4;
			}(this))}), params : [], args : (function($this:HaxeGen) : List {
				var $r6 : List;
				let _g1 : List = [] in;
				(;
					let _g2 : int32 = 0 in;
					let _g3 : List = m.args in;
					while(_g2 < _g3.length) (;
						let a : String = _g3[_g2] in;
						++_g2;
						_g1.push({ type : haxe.macro.ComplexType.TPath({ params : [], pack : (function($this:HaxeGen) : List {
							var $r7 : List;
							let ps : List = a.split(".") in;
							$r7 = ps.slice(0,ps.length - 1);
							return $r7;
						}($this)), name : (function($this:HaxeGen) : String {
							var $r8 : String;
							let s : List = (String((function($this:HaxeGen) : String {
								var $r9 : String;
								let s : String = a in;
								while(StringTools.endsWith(s,"*") || StringTools.endsWith(s,"&")) s = s.substr(0,s.length - 1);
								$r9 = s;
								return $r9;
							}($this)))).split(".") in;
							$r8 = s[s.length - 1];
							return $r8;
						}($this))}), name : argIds.get(a), opt : false});
					);
				);
				$r6 = _g1;
				return $r6;
			}(this)), expr : ((m.name == "new")?{ expr : haxe.macro.ExprDef.EBinop(haxe.macro.Binop.OpAssign,{ expr : haxe.macro.ExprDef.EConst(haxe.macro.Constant.CIdent("this")), pos : { file : "./gen/HaxeGen.hx", min : 1548, max : 1552}},cexpr), pos : { file : "./gen/HaxeGen.hx", min : 1548, max : 1561}}:((m.ret != null && (function($this:HaxeGen) : String {
				var $r10 : String;
				let s : List = m.ret.split(".") in;
				$r10 = s[s.length - 1];
				return $r10;
			}(this)) != "Void")?{ expr : haxe.macro.ExprDef.EReturn(cexpr), pos : { file : "./gen/HaxeGen.hx", min : 1622, max : 1635}}:cexpr))});
			return f;
		);
		
		public function generate() : unit (;
			let _g : int32 = 0 in;
			let _g1 : List = this.d.types in;
			while(_g < _g1.length) (;
				let t : * = _g1[_g] in;
				++_g;
				let path : String = gen.HaxeGen.resolvePath(t.name) in;
				let dirs : List = path.split("/") in;
				dirs.pop();
				let cdir : String = sys.FileSystem.fullPath(Sys.getCwd()) in;
				if(StringTools.endsWith(cdir,"/")) cdir = cdir.substr(0,cdir.length - 1);
				(;
					let _g2 : int32 = 0 in;
					while(_g2 < dirs.length) (;
						let d : String = dirs[_g2] in;
						++_g2;
						cdir = "" + cdir + "/" + d;
						if(!sys.FileSystem.exists(cdir)) sys.FileSystem.createDirectory(cdir);
					);
				);
				sys.io.File.saveContent(path,this.generateType(t));
			);
		);
		
		protected var d : *;
		static protected function resolvePath(n : String) : String (;
			return StringTools.replace(n,".","/") + ".hx";
		);
		
end;
	