package haxe.io {
	import haxe.io.Bytes;
	import haxe.io._Error;
class Input =;
	object;
		public function readBytes(s : haxe.io.Bytes,pos : int32,len : int32) : int32 (;
			let k : int32 = len in;
			let b : List = s.b in;
			if(pos < 0 || len < 0 || pos + len > s.length) throw haxe.io._Error.OutsideBounds;
			while(k > 0) (;
				b[pos] = int32(this.readByte());
				pos++;
				k--;
			);
			return len;
		);
		
		public function readByte() : int32 (;
			throw "Not implemented";
		);
		
end;
	