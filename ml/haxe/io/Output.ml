package haxe.io {
	import haxe.io.Bytes;
	import haxe.io._Error;
class Output =;
	object;
		public function prepare(nbytes : int32) : unit (;
		);
		
		public function writeFullBytes(s : haxe.io.Bytes,pos : int32,len : int32) : unit (;
			while(len > 0) (;
				let k : int32 = this.writeBytes(s,pos,len) in;
				pos += k;
				len -= k;
			);
		);
		
		public function close() : unit (;
		);
		
		public function writeBytes(s : haxe.io.Bytes,pos : int32,len : int32) : int32 (;
			let k : int32 = len in;
			let b : List = s.b in;
			if(pos < 0 || len < 0 || pos + len > s.length) throw haxe.io._Error.OutsideBounds;
			while(k > 0) (;
				this.writeByte(b[pos]);
				pos++;
				k--;
			);
			return len;
		);
		
		public function writeByte(c : int32) : unit (;
			throw "Not implemented";
		);
		
end;
	