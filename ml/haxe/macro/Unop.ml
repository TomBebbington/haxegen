package haxe.macro {
	public final class Unop extends enum {
	public static const __isenum : Boolean = true;
	public function Unop( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static var OpDecrement : Unop = new Unop("OpDecrement",1);
	public static var OpIncrement : Unop = new Unop("OpIncrement",0);
	public static var OpNeg : Unop = new Unop("OpNeg",3);
	public static var OpNegBits : Unop = new Unop("OpNegBits",4);
	public static var OpNot : Unop = new Unop("OpNot",2);
	public static var __constructs__ : Array = ["OpIncrement","OpDecrement","OpNot","OpNeg","OpNegBits"];
}
