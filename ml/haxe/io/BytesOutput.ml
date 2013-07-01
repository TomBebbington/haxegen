package haxe.io {
	import haxe.io.Bytes;
	import haxe.io.Output;
	import haxe.io.BytesBuffer;
	import haxe.io._Error;
	import flash.Boot;
class BytesOutputextends haxe.io.Output  =;
	object;
		public function BytesOutput() : unit ( if( !flash.Boot.skip_constructor ) {
			this.b = new haxe.io.BytesBuffer();
		});
		
		public function getBytes() : haxe.io.Bytes (;
			return this.b.getBytes();
		);
		
		public override function writeBytes(buf : haxe.io.Bytes,pos : int32,len : int32) : int32 (;
			(;
				let _this : haxe.io.BytesBuffer = this.b in;
				if(pos < 0 || len < 0 || pos + len > buf.length) throw haxe.io._Error.OutsideBounds;
				let b1 : List = _this.b in;
				let b2 : List = buf.b in;
				(;
					let _g1 : int32 = pos in;
					let _g : int32 = pos + len in;
					while(_g1 < _g) (;
						let i : int32 = _g1++ in;
						_this.b.push(b2[i]);
					);
				);
			);
			return len;
		);
		
		public override function writeByte(c : int32) : unit (;
			this.b.b.push(c);
		);
		
		protected var b : haxe.io.BytesBuffer;
end;
	