package  {
	import flash.Boot;
class StringBuf =;
	object;
		public function StringBuf() : unit ( if( !flash.Boot.skip_constructor ) {
			this.b = "";
		});
		
		protected var b : String;
end;
	