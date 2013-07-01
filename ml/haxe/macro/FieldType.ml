package haxe.macro {
	import haxe.macro.ComplexType;
	public final class FieldType extends enum {
	public static const __isenum : Boolean = true;
	public function FieldType( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static function FFun(f : *) : FieldType { return new FieldType("FFun",1,[f]); }
	public static function FProp(get : String, set : String, t : haxe.macro.ComplexType = null, e : * = null) : FieldType { return new FieldType("FProp",2,[get,set,t,e]); }
	public static function FVar(t : haxe.macro.ComplexType, e : * = null) : FieldType { return new FieldType("FVar",0,[t,e]); }
	public static var __constructs__ : Array = ["FVar","FFun","FProp"];
}
