package haxe.macro {
	public final class Constant extends enum {
	public static const __isenum : Boolean = true;
	public function Constant( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static function CFloat(f : String) : Constant { return new Constant("CFloat",1,[f]); }
	public static function CIdent(s : String) : Constant { return new Constant("CIdent",3,[s]); }
	public static function CInt(v : String) : Constant { return new Constant("CInt",0,[v]); }
	public static function CRegexp(r : String, opt : String) : Constant { return new Constant("CRegexp",4,[r,opt]); }
	public static function CString(s : String) : Constant { return new Constant("CString",2,[s]); }
	public static var __constructs__ : Array = ["CInt","CFloat","CString","CIdent","CRegexp"];
}
