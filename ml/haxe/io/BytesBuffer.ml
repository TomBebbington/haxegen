package haxe.io {
	import haxe.io.Bytes;
	import flash.Boot;
class BytesBuffer =;
	object;
		public function BytesBuffer() : unit ( if( !flash.Boot.skip_constructor ) {
			this.b = new List();
		});
		
		public function getBytes() : haxe.io.Bytes (;
			let bytes : haxe.io.Bytes = new haxe.io.Bytes(this.b.length,this.b) in;
			this.b = null;
			return bytes;
		);
		
		protected var b : List;
end;
	