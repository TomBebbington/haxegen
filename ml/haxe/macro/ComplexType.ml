package haxe.macro {
	public final class ComplexType extends enum {
	public static const __isenum : Boolean = true;
	public function ComplexType( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static function TAnonymous(fields : List) : ComplexType { return new ComplexType("TAnonymous",2,[fields]); }
	public static function TExtend(p : *, fields : List) : ComplexType { return new ComplexType("TExtend",4,[p,fields]); }
	public static function TFunction(args : List, ret : haxe.macro.ComplexType) : ComplexType { return new ComplexType("TFunction",1,[args,ret]); }
	public static function TOptional(t : haxe.macro.ComplexType) : ComplexType { return new ComplexType("TOptional",5,[t]); }
	public static function TParent(t : haxe.macro.ComplexType) : ComplexType { return new ComplexType("TParent",3,[t]); }
	public static function TPath(p : *) : ComplexType { return new ComplexType("TPath",0,[p]); }
	public static var __constructs__ : Array = ["TPath","TFunction","TAnonymous","TParent","TExtend","TOptional"];
}
