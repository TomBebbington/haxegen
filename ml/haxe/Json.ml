package haxe {
	import haxe.ds.StringMap;
class Json =;
	object;
		public function Json() : unit (;
		);
		
		protected function invalidNumber(start : int32) : unit (;
			throw "Invalid number at position " + start + ": " + this.str.substr(start,this.pos - start);
		);
		
		protected function parseString() : String (;
			let start : int32 = this.pos in;
			let buf : StringBuf = new StringBuf() in;
			while(true) (;
				let c : int32 = this.str.charCodeAt(this.pos++) in;
				if(c == 34) break;
				if(c == 92) (;
					(;
						let s : String = this.str in;
						let len : * = this.pos - start - 1 in;
						buf.b += ((len == null)?s.substr(start,null):s.substr(start,len));
					);
					c = this.str.charCodeAt(this.pos++);
					switch(c) {
					case 114:
					buf.b += "\r";
					break;
					case 110:
					buf.b += "\n";
					break;
					case 116:
					buf.b += "\t";
					break;
					case 98:
					buf.b += "\x08";
					break;
					case 102:
					buf.b += "\x0C";
					break;
					case 47:case 92:case 34:
					buf.b += String.fromCharCode(c);
					break;
					case 117:
					(;
						let uc : * = Std._parseInt("0x" + this.str.substr(this.pos,4)) in;
						this.pos += 4;
						(;
							let c1 : int32 = uc in;
							buf.b += String.fromCharCode(c1);
						);
					);
					break;
					default:
					throw "Invalid escape sequence \\" + String.fromCharCode(c) + " at position " + (this.pos - 1);
					break;
					};
					start = this.pos;
				);
				else (;
				);
			);
			(;
				let s : String = this.str in;
				let len : * = this.pos - start - 1 in;
				buf.b += ((len == null)?s.substr(start,null):s.substr(start,len));
			);
			return buf.b;
		);
		
		protected function parseRec() : * (;
			while(true) (;
				let c : int32 = this.str.charCodeAt(this.pos++) in;
				switch(c) {
				case 32:case 13:case 10:case 9:
				break;
				case 123:
				(;
					let obj : * = { } in;
					let field : String = null in;
					let comma : * = null in;
					while(true) (;
						let c1 : int32 = this.str.charCodeAt(this.pos++) in;
						switch(c1) {
						case 32:case 13:case 10:case 9:
						break;
						case 125:
						(;
							if(field != null || comma == false) this.invalidChar();
							return obj;
						);
						break;
						case 58:
						(;
							if(field == null) this.invalidChar();
							Reflect.setField(obj,field,this.parseRec());
							field = null;
							comma = true;
						);
						break;
						case 44:
						if(comma) comma = false;
						else this.invalidChar();
						break;
						case 34:
						(;
							if(comma) this.invalidChar();
							field = this.parseString();
						);
						break;
						default:
						this.invalidChar();
						break;
						}
					);
				);
				break;
				case 91:
				(;
					let arr : List = [] in;
					let comma : * = null in;
					while(true) (;
						let c1 : int32 = this.str.charCodeAt(this.pos++) in;
						switch(c1) {
						case 32:case 13:case 10:case 9:
						break;
						case 93:
						(;
							if(comma == false) this.invalidChar();
							return arr;
						);
						break;
						case 44:
						if(comma) comma = false;
						else this.invalidChar();
						break;
						default:
						(;
							if(comma) this.invalidChar();
							this.pos--;
							arr.push(this.parseRec());
							comma = true;
						);
						break;
						}
					);
				);
				break;
				case 116:
				(;
					let save : int32 = this.pos in;
					if(this.str.charCodeAt(this.pos++) != 114 || this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 101) (;
						this.pos = save;
						this.invalidChar();
					);
					return true;
				);
				break;
				case 102:
				(;
					let save : int32 = this.pos in;
					if(this.str.charCodeAt(this.pos++) != 97 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 115 || this.str.charCodeAt(this.pos++) != 101) (;
						this.pos = save;
						this.invalidChar();
					);
					return false;
				);
				break;
				case 110:
				(;
					let save : int32 = this.pos in;
					if(this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 108) (;
						this.pos = save;
						this.invalidChar();
					);
					return null;
				);
				break;
				case 34:
				return this.parseString();
				break;
				case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 45:
				(;
					let c1 : int32 = c in;
					let start : int32 = this.pos - 1 in;
					let minus : bool = c1 == 45 in;
					let digit : bool = !minus in;
					let zero : bool = c1 == 48 in;
					let point : bool = false in;
					let e : bool = false in;
					let pm : bool = false in;
					let end : bool = false in;
					while(true) (;
						c1 = this.str.charCodeAt(this.pos++);
						switch(c1) {
						case 48:
						(;
							if(zero && !point) this.invalidNumber(start);
							if(minus) (;
								minus = false;
								zero = true;
							);
							digit = true;
						);
						break;
						case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:
						(;
							if(zero && !point) this.invalidNumber(start);
							if(minus) minus = false;
							digit = true;
							zero = false;
						);
						break;
						case 46:
						(;
							if(minus || point) this.invalidNumber(start);
							digit = false;
							point = true;
						);
						break;
						case 101:case 69:
						(;
							if(minus || zero || e) this.invalidNumber(start);
							digit = false;
							e = true;
						);
						break;
						case 43:case 45:
						(;
							if(!e || pm) this.invalidNumber(start);
							digit = false;
							pm = true;
						);
						break;
						default:
						(;
							if(!digit) this.invalidNumber(start);
							this.pos--;
							end = true;
						);
						break;
						};
						if(end) break;
					);
					let f : float = Std._parseFloat(this.str.substr(start,this.pos - start)) in;
					let i : int32 = Std._int(f) in;
					if(i == f) return i;
					else return f;
				);
				break;
				default:
				this.invalidChar();
				break;
				}
			);
		);
		
		protected function invalidChar() : unit (;
			this.pos--;
			throw "Invalid char " + this.str.charCodeAt(this.pos) + " at position " + this.pos;
		);
		
		protected function doParse(str : String) : * (;
			this.str = str;
			this.pos = 0;
			return this.parseRec();
		);
		
		protected function quote(s : String) : unit (;
			this.buf.b += "\"";
			let i : int32 = 0 in;
			while(true) (;
				let c : int32 = s.charCodeAt(i++) in;
				switch(c) {
				case 34:
				this.buf.b += "\\\"";
				break;
				case 92:
				this.buf.b += "\\\\";
				break;
				case 10:
				this.buf.b += "\\n";
				break;
				case 13:
				this.buf.b += "\\r";
				break;
				case 9:
				this.buf.b += "\\t";
				break;
				case 8:
				this.buf.b += "\\b";
				break;
				case 12:
				this.buf.b += "\\f";
				break;
				default:
				this.buf.b += String.fromCharCode(c);
				break;
				}
			);
			this.buf.b += "\"";
		);
		
		protected function toStringRec(k : *,v : *) : unit (;
			if(this.replacer != null) v = (this.replacer)(k,v);
			(;
				let _g : ValueType = Type._typeof(v) in;
				switch(Type.enumIndex(_g)) {
				case 8:
				this.buf.b += "\"???\"";
				break;
				case 4:
				this.objString(v);
				break;
				case 1:
				(;
					let v1 : String = v in;
					this.buf.b += Std.string(v1);
				);
				break;
				case 2:
				this.buf.b += Std.string(((Math["isFinite"](v))?v:"null"));
				break;
				case 5:
				this.buf.b += "\"<fun>\"";
				break;
				case 6:
				(;
					let c : Class = _g.params[0] in;
					if(c == String) this.quote(v);
					else if(c == List) (;
						let v1 : List = v in;
						this.buf.b += "[";
						let len : int32 = v1.length in;
						if(len > 0) (;
							this.toStringRec(0,v1[0]);
							let i : int32 = 1 in;
							while(i < len) (;
								this.buf.b += ",";
								this.toStringRec(i,v1[i++]);
							);
						);
						this.buf.b += "]";
					);
					else if(c == haxe.ds.StringMap) (;
						let v1 : haxe.ds.StringMap = v in;
						let o : * = { } in;
						{ var $it : * = v1.keys();
						while( $it.hasNext() ) { var k1 : String = $it.next();
						Reflect.setField(o,k1,v1.get(k1));
						}};
						this.objString(o);
					);
					else this.objString(v);
				);
				break;
				case 7:
				(;
					let i : * = Type.enumIndex(v) in;
					(;
						let v1 : String = i in;
						this.buf.b += Std.string(v1);
					);
				);
				break;
				case 3:
				(;
					let v1 : String = v in;
					this.buf.b += Std.string(v1);
				);
				break;
				case 0:
				this.buf.b += "null";
				break;
				}
			);
		);
		
		protected function objString(v : *) : unit (;
			this.fieldsString(v,Reflect.fields(v));
		);
		
		protected function fieldsString(v : *,fields : List) : unit (;
			let first : bool = true in;
			this.buf.b += "{";
			(;
				let _g : int32 = 0 in;
				while(_g < fields.length) (;
					let f : String = fields[_g] in;
					++_g;
					let value : * = Reflect.field(v,f) in;
					if(Reflect.isFunction(value)) continue;
					if(first) first = false;
					else this.buf.b += ",";
					this.quote(f);
					this.buf.b += ":";
					this.toStringRec(f,value);
				);
			);
			this.buf.b += "}";
		);
		
		protected function toString(v : *,replacer : * -> * -> * = null) : String (;
			this.buf = new StringBuf();
			this.replacer = replacer;
			this.toStringRec("",v);
			return this.buf.b;
		);
		
		protected var replacer : * -> * -> *;
		protected var pos : int32;
		protected var str : String;
		protected var buf : StringBuf;
		static public function parse(text : String) : * (;
			return new haxe.Json().doParse(text);
		);
		
		static public function stringify(value : *,replacer : * -> * -> * = null) : String (;
			return new haxe.Json().toString(value,replacer);
		);
		
end;
	