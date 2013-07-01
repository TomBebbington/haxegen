package haxe.macro {
	import haxe.macro.ComplexType;
	public final class TypeParam extends enum {
	public static const __isenum : Boolean = true;
	public function TypeParam( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static function TPExpr(e : *) : TypeParam { return new TypeParam("TPExpr",1,[e]); }
	public static function TPType(t : haxe.macro.ComplexType) : TypeParam { return new TypeParam("TPType",0,[t]); }
	public static var __constructs__ : Array = ["TPType","TPExpr"];
}
