package haxe.macro {
	import haxe.macro.Unop;
	import haxe.macro.Binop;
	import haxe.macro.Constant;
	import haxe.macro.Access;
	import haxe.macro.ComplexType;
	import haxe.macro.TypeParam;
	import flash.Boot;
class Printer =;
	object;
		public function Printer(tabString : String = "\t") : unit ( if( !flash.Boot.skip_constructor ) {
			if(tabString==null) tabString="\t";
			this.tabs = "";
			this.tabString = tabString;
		});
		
		protected function opt(v : *,f : * -> String,prefix : String = "") : String (;
			if(prefix==null) prefix="";
			if(v == null) return "";
			else return prefix + f(v);
		);
		
		public function printTypeDefinition(t : *,printPackage : bool = true) : String (;
			let old : String = this.tabs in;
			this.tabs = this.tabString;
			let str : String = () in;
			if(t == null) str = "#NULL";
			else str = (((printPackage && t.pack.length > 0 && t.pack[0] != "")?"package " + t.pack.join(".") + ";\n":"")) + (((t.meta != null && t.meta.length > 0)?t.meta["mapHX"](this.printMetadata).join(" ") + " ":"")) + (((t.isExtern)?"extern ":"")) + (function($this:Printer) : String {
				var $r : String;
				switch(Type.enumIndex(t.kind)) {
				case 0:
				$r = "enum " + t.name + (((t.params.length > 0)?"<" + t.params["mapHX"]($this.printTypeParamDecl).join(", ") + ">":"")) + " {\n" + ((function($this:Printer) : List {
					var $r2 : List;
					let _g : List = [] in;
					(;
						let _g1 : int32 = 0 in;
						let _g2 : List = t.fields in;
						while(_g1 < _g2.length) (;
							let field : * = _g2[_g1] in;
							++_g1;
							_g.push($this.tabs + (((field.doc != null && field.doc != "")?"/**\n" + $this.tabs + $this.tabString + StringTools.replace(field.doc,"\n","\n" + $this.tabs + $this.tabString) + "\n" + $this.tabs + "**/\n" + $this.tabs:"")) + (((field.meta != null && field.meta.length > 0)?field.meta["mapHX"]($this.printMetadata).join(" ") + " ":"")) + (function($this:Printer) : String {
								var $r3 : String;
								switch(Type.enumIndex(field.kind)) {
								case 0:
								$r3 = field.name;
								break;
								case 2:
								$r3 = (function($this:Printer) : String {
									var $r4 : String;
									throw "FProp is invalid for TDEnum.";
									return $r4;
								}($this));
								break;
								case 1:
								$r3 = (function($this:Printer) : String {
									var $r5 : String;
									let func : * = field.kind.params[0] in;
									$r5 = field.name + $this.printFunction(func);
									return $r5;
								}($this));
								break;
								}
								return $r3;
							}($this)) + ";");
						);
					);
					$r2 = _g;
					return $r2;
				}($this))).join("\n") + "\n}";
				break;
				case 1:
				$r = "typedef " + t.name + (((t.params.length > 0)?"<" + t.params["mapHX"]($this.printTypeParamDecl).join(", ") + ">":"")) + " = {\n" + ((function($this:Printer) : List {
					var $r6 : List;
					let _g : List = [] in;
					(;
						let _g1 : int32 = 0 in;
						let _g2 : List = t.fields in;
						while(_g1 < _g2.length) (;
							let f : * = _g2[_g1] in;
							++_g1;
							_g.push($this.tabs + $this.printField(f) + ";");
						);
					);
					$r6 = _g;
					return $r6;
				}($this))).join("\n") + "\n}";
				break;
				case 2:
				$r = (function($this:Printer) : String {
					var $r7 : String;
					let isInterface : * = t.kind.params[2] in;
					let interfaces : List = t.kind.params[1] in;
					let superClass : * = t.kind.params[0] in;
					$r7 = (((isInterface)?"interface ":"class ")) + t.name + (((t.params.length > 0)?"<" + t.params["mapHX"]($this.printTypeParamDecl).join(", ") + ">":"")) + (((superClass != null)?" extends " + $this.printTypePath(superClass):"")) + (((interfaces != null)?(((isInterface)?(function($this:Printer) : List {
						var $r8 : List;
						let _g : List = [] in;
						(;
							let _g1 : int32 = 0 in;
							while(_g1 < interfaces.length) (;
								let tp : * = interfaces[_g1] in;
								++_g1;
								_g.push(" extends " + $this.printTypePath(tp));
							);
						);
						$r8 = _g;
						return $r8;
					}($this)):(function($this:Printer) : List {
						var $r9 : List;
						let _g1 : List = [] in;
						(;
							let _g2 : int32 = 0 in;
							while(_g2 < interfaces.length) (;
								let tp : * = interfaces[_g2] in;
								++_g2;
								_g1.push(" implements " + $this.printTypePath(tp));
							);
						);
						$r9 = _g1;
						return $r9;
					}($this)))).join(""):"")) + " {\n" + ((function($this:Printer) : List {
						var $r10 : List;
						let _g2 : List = [] in;
						(;
							let _g3 : int32 = 0 in;
							let _g4 : List = t.fields in;
							while(_g3 < _g4.length) (;
								let f : * = _g4[_g3] in;
								++_g3;
								_g2.push((function($this:Printer) : String {
									var $r11 : String;
									let fstr : String = $this.printField(f) in;
									$r11 = $this.tabs + fstr + (function($this:Printer) : String {
										var $r12 : String;
										switch(Type.enumIndex(f.kind)) {
										case 0:case 2:
										$r12 = ";";
										break;
										case 1:
										$r12 = (function($this:Printer) : String {
											var $r13 : String;
											let func : * = f.kind.params[0] in;
											$r13 = ((func.expr == null)?";":"");
											return $r13;
										}($this));
										break;
										default:
										$r12 = "";
										break;
										}
										return $r12;
									}($this));
									return $r11;
								}($this)));
							);
						);
						$r10 = _g2;
						return $r10;
					}($this))).join("\n") + "\n}";
					return $r7;
				}($this));
				break;
				case 3:
				$r = (function($this:Printer) : String {
					var $r14 : String;
					let ct : haxe.macro.ComplexType = t.kind.params[0] in;
					$r14 = "typedef " + t.name + (((t.params.length > 0)?"<" + t.params["mapHX"]($this.printTypeParamDecl).join(", ") + ">":"")) + " = " + $this.printComplexType(ct) + ";";
					return $r14;
				}($this));
				break;
				case 4:
				$r = (function($this:Printer) : String {
					var $r15 : String;
					let to : List = t.kind.params[2] in;
					let from : List = t.kind.params[1] in;
					let tthis : haxe.macro.ComplexType = t.kind.params[0] in;
					$r15 = "abstract " + t.name + (((tthis == null)?"":"(" + $this.printComplexType(tthis) + ")")) + (((t.params.length > 0)?"<" + t.params["mapHX"]($this.printTypeParamDecl).join(", ") + ">":"")) + (((from == null)?"":((function($this:Printer) : List {
						var $r16 : List;
						let _g : List = [] in;
						(;
							let _g1 : int32 = 0 in;
							while(_g1 < from.length) (;
								let f : haxe.macro.ComplexType = from[_g1] in;
								++_g1;
								_g.push(" from " + $this.printComplexType(f));
							);
						);
						$r16 = _g;
						return $r16;
					}($this))).join(""))) + (((to == null)?"":((function($this:Printer) : List {
						var $r17 : List;
						let _g1 : List = [] in;
						(;
							let _g2 : int32 = 0 in;
							while(_g2 < to.length) (;
								let t1 : haxe.macro.ComplexType = to[_g2] in;
								++_g2;
								_g1.push(" to " + $this.printComplexType(t1));
							);
						);
						$r17 = _g1;
						return $r17;
					}($this))).join(""))) + " {\n" + ((function($this:Printer) : List {
						var $r18 : List;
						let _g2 : List = [] in;
						(;
							let _g3 : int32 = 0 in;
							let _g4 : List = t.fields in;
							while(_g3 < _g4.length) (;
								let f : * = _g4[_g3] in;
								++_g3;
								_g2.push((function($this:Printer) : String {
									var $r19 : String;
									let fstr : String = $this.printField(f) in;
									$r19 = $this.tabs + fstr + (function($this:Printer) : String {
										var $r20 : String;
										switch(Type.enumIndex(f.kind)) {
										case 0:case 2:
										$r20 = ";";
										break;
										case 1:
										$r20 = (function($this:Printer) : String {
											var $r21 : String;
											let func : * = f.kind.params[0] in;
											$r21 = ((func.expr == null)?";":"");
											return $r21;
										}($this));
										break;
										default:
										$r20 = "";
										break;
										}
										return $r20;
									}($this));
									return $r19;
								}($this)));
							);
						);
						$r18 = _g2;
						return $r18;
					}($this))).join("\n") + "\n}";
					return $r15;
				}($this));
				break;
				}
				return $r;
			}(this));
			this.tabs = old;
			return str;
		);
		
		public function printExprs(el : List,sep : String) : String (;
			return el["mapHX"](this.printExpr).join(sep);
		);
		
		public function printExpr(e : *) : String (;
			let _g : haxe.macro.Printer = this in;
			if(e == null) return "#NULL";
			else switch(Type.enumIndex(e.expr)) {
			case 0:
			(;
				let c : haxe.macro.Constant = e.expr.params[0] in;
				return this.printConstant(c);
			);
			break;
			case 1:
			(;
				let e2 : * = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				return "" + this.printExpr(e1) + "[" + this.printExpr(e2) + "]";
			);
			break;
			case 2:
			(;
				let e2 : * = e.expr.params[2] in;
				let e1 : * = e.expr.params[1] in;
				let op : haxe.macro.Binop = e.expr.params[0] in;
				return "" + this.printExpr(e1) + " " + this.printBinop(op) + " " + this.printExpr(e2);
			);
			break;
			case 3:
			(;
				let n : String = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				return "" + this.printExpr(e1) + "." + n;
			);
			break;
			case 4:
			(;
				let e1 : * = e.expr.params[0] in;
				return "(" + this.printExpr(e1) + ")";
			);
			break;
			case 5:
			(;
				let fl : List = e.expr.params[0] in;
				return "{ " + fl["mapHX"](function(fld : *) : String (;
					return "" + fld.field + " : " + _g.printExpr(fld.expr) + " ";
				)).join(",") + "}";
			);
			break;
			case 6:
			(;
				let el : List = e.expr.params[0] in;
				return "[" + this.printExprs(el,", ") + "]";
			);
			break;
			case 7:
			(;
				let el : List = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				return "" + this.printExpr(e1) + "(" + this.printExprs(el,", ") + ")";
			);
			break;
			case 8:
			(;
				let el : List = e.expr.params[1] in;
				let tp : * = e.expr.params[0] in;
				return "new " + this.printTypePath(tp) + "(" + this.printExprs(el,", ") + ")";
			);
			break;
			case 9:
			switch(e.expr.params[1]) {
			case true:
			(;
				let e1 : * = e.expr.params[2] in;
				let op : haxe.macro.Unop = e.expr.params[0] in;
				return this.printExpr(e1) + this.printUnop(op);
			);
			break;
			case false:
			(;
				let e1 : * = e.expr.params[2] in;
				let op : haxe.macro.Unop = e.expr.params[0] in;
				return this.printUnop(op) + this.printExpr(e1);
			);
			break;
			}
			break;
			case 11:
			(;
				let func : * = e.expr.params[1] in;
				let no : String = e.expr.params[0] in;
				if(no != null) return "function " + no + this.printFunction(func);
				else (;
					let func1 : * = e.expr.params[1] in;
					return "function " + this.printFunction(func1);
				);
			);
			break;
			case 10:
			(;
				let vl : List = e.expr.params[0] in;
				return "var " + vl["mapHX"](this.printVar).join(", ");
			);
			break;
			case 12:
			(;
				let el : List = e.expr.params[0] in;
				switch(e.expr.params[0].length) {
				case 0:
				return "{\n" + this.tabs + "}";
				break;
				default:
				(;
					let old : String = this.tabs in;
					this.tabs += this.tabString;
					let s : String = "{\n" + this.tabs + this.printExprs(el,";\n" + this.tabs) in;
					this.tabs = old;
					return s + (";\n" + this.tabs + "}");
				);
				break;
				}
			);
			break;
			case 13:
			(;
				let e2 : * = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				return "for(" + this.printExpr(e1) + ") " + this.printExpr(e2);
			);
			break;
			case 14:
			(;
				let e2 : * = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				return "" + this.printExpr(e1) + " in " + this.printExpr(e2);
			);
			break;
			case 15:
			(;
				let eelse : * = e.expr.params[2] in;
				let eif : * = e.expr.params[1] in;
				let econd : * = e.expr.params[0] in;
				return "if(" + this.printExpr(econd) + ") " + this.printExpr(eif) + " " + this.opt(eelse,this.printExpr,"else ");
			);
			break;
			case 16:
			switch(e.expr.params[2]) {
			case true:
			(;
				let econd : * = e.expr.params[0] in;
				let e1 : * = e.expr.params[1] in;
				return "while(" + this.printExpr(econd) + ") " + this.printExpr(e1);
			);
			break;
			case false:
			(;
				let econd : * = e.expr.params[0] in;
				let e1 : * = e.expr.params[1] in;
				return "do " + this.printExpr(e1) + " while(" + this.printExpr(econd) + ")";
			);
			break;
			}
			break;
			case 17:
			(;
				let edef : * = e.expr.params[2] in;
				let cl : List = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				(;
					let old : String = this.tabs in;
					this.tabs += this.tabString;
					let s : String = "switch " + this.printExpr(e1) + " {\n" + this.tabs + cl["mapHX"](function(c : *) : String (;
						return "case " + _g.printExprs(c.values,", ") + (((c.guard != null)?" if(" + _g.printExpr(c.guard) + "): ":":")) + (((c.expr != null)?_g.opt(c.expr,_g.printExpr,null) + ";":""));
					)).join("\n" + this.tabs) in;
					if(edef != null) s += "\n" + this.tabs + "default: " + (((edef.expr == null)?"":this.printExpr(edef))) + ";";
					this.tabs = old;
					return s + ("\n" + this.tabs + "}");
				);
			);
			break;
			case 18:
			(;
				let cl : List = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				return "try " + this.printExpr(e1) + cl["mapHX"](function(c : *) : String (;
					return " catch(" + c.name + " : " + _g.printComplexType(c.type) + ") " + _g.printExpr(c.expr);
				)).join("");
			);
			break;
			case 19:
			(;
				let eo : * = e.expr.params[0] in;
				return "return" + this.opt(eo,this.printExpr," ");
			);
			break;
			case 20:
			return "break";
			break;
			case 21:
			return "continue";
			break;
			case 22:
			(;
				let e1 : * = e.expr.params[0] in;
				return "untyped " + this.printExpr(e1);
			);
			break;
			case 23:
			(;
				let e1 : * = e.expr.params[0] in;
				return "throw " + this.printExpr(e1);
			);
			break;
			case 24:
			(;
				let cto : haxe.macro.ComplexType = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				if(cto != null) return "cast(" + this.printExpr(e1) + ", " + this.printComplexType(cto) + ")";
				else (;
					let e11 : * = e.expr.params[0] in;
					return "cast " + this.printExpr(e11);
				);
			);
			break;
			case 25:
			(;
				let e1 : * = e.expr.params[0] in;
				return "#DISPLAY(" + this.printExpr(e1) + ")";
			);
			break;
			case 26:
			(;
				let tp : * = e.expr.params[0] in;
				return "#DISPLAY(" + this.printTypePath(tp) + ")";
			);
			break;
			case 27:
			(;
				let eelse : * = e.expr.params[2] in;
				let eif : * = e.expr.params[1] in;
				let econd : * = e.expr.params[0] in;
				return "" + this.printExpr(econd) + " ? " + this.printExpr(eif) + " : " + this.printExpr(eelse);
			);
			break;
			case 28:
			(;
				let ct : haxe.macro.ComplexType = e.expr.params[1] in;
				let e1 : * = e.expr.params[0] in;
				return "#CHECK_TYPE(" + this.printExpr(e1) + ", " + this.printComplexType(ct) + ")";
			);
			break;
			case 29:
			(;
				let e1 : * = e.expr.params[1] in;
				let meta : * = e.expr.params[0] in;
				return this.printMetadata(meta) + " " + this.printExpr(e1);
			);
			break;
			}
		);
		
		public function printVar(v : *) : String (;
			return v.name + this.opt(v.type,this.printComplexType," : ") + this.opt(v.expr,this.printExpr," = ");
		);
		
		public function printFunction(func : *) : String (;
			return (((func.params.length > 0)?"<" + func.params["mapHX"](this.printTypeParamDecl).join(", ") + ">":"")) + "( " + func.args["mapHX"](this.printFunctionArg).join(", ") + " )" + this.opt(func.ret,this.printComplexType," : ") + this.opt(func.expr,this.printExpr," ");
		);
		
		public function printFunctionArg(arg : *) : String (;
			return (((arg.opt)?"?":"")) + arg.name + this.opt(arg.type,this.printComplexType," : ") + this.opt(arg.value,this.printExpr," = ");
		);
		
		public function printTypeParamDecl(tpd : *) : String (;
			return tpd.name + (((tpd.params != null && tpd.params.length > 0)?"<" + tpd.params["mapHX"](this.printTypeParamDecl).join(", ") + ">":"")) + (((tpd.constraints != null && tpd.constraints.length > 0)?":(" + tpd.constraints["mapHX"](this.printComplexType).join(", ") + ")":""));
		);
		
		public function printField(field : *) : String (;
			return (((field.doc != null && field.doc != "")?"/**\n" + this.tabs + this.tabString + StringTools.replace(field.doc,"\n","\n" + this.tabs + this.tabString) + "\n" + this.tabs + "**/\n" + this.tabs:"")) + (((field.meta != null && field.meta.length > 0)?field.meta["mapHX"](this.printMetadata).join(" ") + " ":"")) + (((field.access != null && field.access.length > 0)?field.access["mapHX"](this.printAccess).join(" ") + " ":"")) + (function($this:Printer) : String {
				var $r : String;
				switch(Type.enumIndex(field.kind)) {
				case 0:
				$r = (function($this:Printer) : String {
					var $r2 : String;
					let eo : * = field.kind.params[1] in;
					let t : haxe.macro.ComplexType = field.kind.params[0] in;
					$r2 = "var " + field.name + $this.opt(t,$this.printComplexType," : ") + $this.opt(eo,$this.printExpr," = ");
					return $r2;
				}($this));
				break;
				case 2:
				$r = (function($this:Printer) : String {
					var $r3 : String;
					let eo : * = field.kind.params[3] in;
					let t : haxe.macro.ComplexType = field.kind.params[2] in;
					let set : String = field.kind.params[1] in;
					let get : String = field.kind.params[0] in;
					$r3 = "var " + field.name + "(" + get + ", " + set + ")" + $this.opt(t,$this.printComplexType," : ") + $this.opt(eo,$this.printExpr," = ");
					return $r3;
				}($this));
				break;
				case 1:
				$r = (function($this:Printer) : String {
					var $r4 : String;
					let func : * = field.kind.params[0] in;
					$r4 = "function " + field.name + $this.printFunction(func);
					return $r4;
				}($this));
				break;
				}
				return $r;
			}(this));
		);
		
		public function printAccess(access : haxe.macro.Access) : String (;
			switch(Type.enumIndex(access)) {
			case 2:
			return "static";
			break;
			case 0:
			return "public";
			break;
			case 1:
			return "private";
			break;
			case 3:
			return "override";
			break;
			case 5:
			return "inline";
			break;
			case 4:
			return "dynamic";
			break;
			case 6:
			return "macro";
			break;
			}
		);
		
		public function printMetadata(meta : *) : String (;
			return "@" + meta.name + (((meta.params.length > 0)?"(" + this.printExprs(meta.params,", ") + ")":""));
		);
		
		public function printComplexType(ct : haxe.macro.ComplexType) : String (;
			switch(Type.enumIndex(ct)) {
			case 0:
			(;
				let tp : * = ct.params[0] in;
				return this.printTypePath(tp);
			);
			break;
			case 1:
			(;
				let ret : haxe.macro.ComplexType = ct.params[1] in;
				let args : List = ct.params[0] in;
				return (((args.length > 0)?args["mapHX"](this.printComplexType).join(" -> "):"Void")) + " -> " + this.printComplexType(ret);
			);
			break;
			case 2:
			(;
				let fields : List = ct.params[0] in;
				return "{ " + ((function($this:Printer) : List {
					var $r : List;
					let _g : List = [] in;
					(;
						let _g1 : int32 = 0 in;
						while(_g1 < fields.length) (;
							let f : * = fields[_g1] in;
							++_g1;
							_g.push($this.printField(f) + "; ");
						);
					);
					$r = _g;
					return $r;
				}(this))).join("") + "}";
			);
			break;
			case 3:
			(;
				let ct1 : haxe.macro.ComplexType = ct.params[0] in;
				return "(" + this.printComplexType(ct1) + ")";
			);
			break;
			case 5:
			(;
				let ct1 : haxe.macro.ComplexType = ct.params[0] in;
				return "?" + this.printComplexType(ct1);
			);
			break;
			case 4:
			(;
				let fields : List = ct.params[1] in;
				let tp : * = ct.params[0] in;
				return "{" + this.printTypePath(tp) + " >, " + fields["mapHX"](this.printField).join(", ") + " }";
			);
			break;
			}
		);
		
		public function printTypePath(tp : *) : String (;
			return (((tp.pack.length > 0)?tp.pack.join(".") + ".":"")) + tp.name + (((tp.sub != null)?"." + tp.sub:"")) + (((tp.params.length > 0)?"<" + tp.params["mapHX"](this.printTypeParam).join(", ") + ">":""));
		);
		
		public function printTypeParam(param : haxe.macro.TypeParam) : String (;
			switch(Type.enumIndex(param)) {
			case 0:
			(;
				let ct : haxe.macro.ComplexType = param.params[0] in;
				return this.printComplexType(ct);
			);
			break;
			case 1:
			(;
				let e : * = param.params[0] in;
				return this.printExpr(e);
			);
			break;
			}
		);
		
		public function printConstant(c : haxe.macro.Constant) : String (;
			switch(Type.enumIndex(c)) {
			case 2:
			(;
				let s : String = c.params[0] in;
				return "\"" + s + "\"";
			);
			break;
			case 3:
			(;
				let s : String = c.params[0] in;
				return s;
			);
			break;
			case 0:
			(;
				let s : String = c.params[0] in;
				return s;
			);
			break;
			case 1:
			(;
				let s : String = c.params[0] in;
				return s;
			);
			break;
			case 4:
			(;
				let opt : String = c.params[1] in;
				let s : String = c.params[0] in;
				return "~/" + s + "/" + opt;
			);
			break;
			}
		);
		
		public function printBinop(op : haxe.macro.Binop) : String (;
			switch(Type.enumIndex(op)) {
			case 0:
			return "+";
			break;
			case 1:
			return "*";
			break;
			case 2:
			return "/";
			break;
			case 3:
			return "-";
			break;
			case 4:
			return "=";
			break;
			case 5:
			return "==";
			break;
			case 6:
			return "!=";
			break;
			case 7:
			return ">";
			break;
			case 8:
			return ">=";
			break;
			case 9:
			return "<";
			break;
			case 10:
			return "<=";
			break;
			case 11:
			return "&";
			break;
			case 12:
			return "|";
			break;
			case 13:
			return "^";
			break;
			case 14:
			return "&&";
			break;
			case 15:
			return "||";
			break;
			case 16:
			return "<<";
			break;
			case 17:
			return ">>";
			break;
			case 18:
			return ">>>";
			break;
			case 19:
			return "%";
			break;
			case 21:
			return "...";
			break;
			case 22:
			return "=>";
			break;
			case 20:
			(;
				let op1 : haxe.macro.Binop = op.params[0] in;
				return this.printBinop(op1) + "=";
			);
			break;
			}
		);
		
		public function printUnop(op : haxe.macro.Unop) : String (;
			switch(Type.enumIndex(op)) {
			case 0:
			return "++";
			break;
			case 1:
			return "--";
			break;
			case 2:
			return "!";
			break;
			case 3:
			return "-";
			break;
			case 4:
			return "~";
			break;
			}
		);
		
		protected var tabString : String;
		protected var tabs : String;
end;
	