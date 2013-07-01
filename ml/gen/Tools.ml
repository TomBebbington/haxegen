package gen {
class Tools =;
	object;
		static public function id(x : int32) : String (;
			if(x < 26) return String.fromCharCode(97 + x);
			else if(x < 52) return String.fromCharCode(65 + x - 26);
			else (;
				let avail : int32 = 52 in;
				let s : String = "" in;
				while(x > 0) (;
					s = gen.Tools.id(x % avail) + s;
					x = Std._int(x / avail);
				);
				return s;
			);
		);
		
		static public function resolveType(p : *,h : String) : * (;
			(;
				let _g : int32 = 0 in;
				let _g1 : List = p.types in;
				while(_g < _g1.length) (;
					let t : * = _g1[_g] in;
					++_g;
					if(t.name == h) return t;
				);
			);
			return null;
		);
		
		static public function matches(s : String,r : EReg,ms : int32) : List (;
			let a : List = [] in;
			let pos : int32 = 0 in;
			while(r.matchSub(s,pos,null)) (;
				let cpos : * = r.matchedPos() in;
				let ma : List = () in;
				(;
					let _g : List = [] in;
					(;
						let _g2 : int32 = 1 in;
						let _g1 : int32 = ms + 1 in;
						while(_g2 < _g1) (;
							let i : int32 = _g2++ in;
							_g.push(r.matched(i));
						);
					);
					ma = _g;
				);
				a.push(ma);
				pos = cpos.pos + cpos.len;
			);
			return a;
		);
		
end;
	