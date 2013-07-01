package haxe.macro {
	public final class Binop extends enum {
	public static const __isenum : Boolean = true;
	public function Binop( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static var OpAdd : Binop = new Binop("OpAdd",0);
	public static var OpAnd : Binop = new Binop("OpAnd",11);
	public static var OpArrow : Binop = new Binop("OpArrow",22);
	public static var OpAssign : Binop = new Binop("OpAssign",4);
	public static function OpAssignOp(op : haxe.macro.Binop) : Binop { return new Binop("OpAssignOp",20,[op]); }
	public static var OpBoolAnd : Binop = new Binop("OpBoolAnd",14);
	public static var OpBoolOr : Binop = new Binop("OpBoolOr",15);
	public static var OpDiv : Binop = new Binop("OpDiv",2);
	public static var OpEq : Binop = new Binop("OpEq",5);
	public static var OpGt : Binop = new Binop("OpGt",7);
	public static var OpGte : Binop = new Binop("OpGte",8);
	public static var OpInterval : Binop = new Binop("OpInterval",21);
	public static var OpLt : Binop = new Binop("OpLt",9);
	public static var OpLte : Binop = new Binop("OpLte",10);
	public static var OpMod : Binop = new Binop("OpMod",19);
	public static var OpMult : Binop = new Binop("OpMult",1);
	public static var OpNotEq : Binop = new Binop("OpNotEq",6);
	public static var OpOr : Binop = new Binop("OpOr",12);
	public static var OpShl : Binop = new Binop("OpShl",16);
	public static var OpShr : Binop = new Binop("OpShr",17);
	public static var OpSub : Binop = new Binop("OpSub",3);
	public static var OpUShr : Binop = new Binop("OpUShr",18);
	public static var OpXor : Binop = new Binop("OpXor",13);
	public static var __constructs__ : Array = ["OpAdd","OpMult","OpDiv","OpSub","OpAssign","OpEq","OpNotEq","OpGt","OpGte","OpLt","OpLte","OpAnd","OpOr","OpXor","OpBoolAnd","OpBoolOr","OpShl","OpShr","OpUShr","OpMod","OpAssignOp","OpInterval","OpArrow"];
}
