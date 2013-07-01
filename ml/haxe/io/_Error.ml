package haxe.io {
	public final class _Error extends enum {
	public static const __isenum : Boolean = true;
	public function _Error( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static var Blocked : _Error = new _Error("Blocked",0);
	public static function Custom(e : *) : _Error { return new _Error("Custom",3,[e]); }
	public static var OutsideBounds : _Error = new _Error("OutsideBounds",2);
	public static var Overflow : _Error = new _Error("Overflow",1);
	public static var __constructs__ : Array = ["Blocked","Overflow","OutsideBounds","Custom"];
}
