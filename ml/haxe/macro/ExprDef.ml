package haxe.macro {
	import haxe.macro.ComplexType;
	import haxe.macro.Binop;
	import haxe.macro.Unop;
	import haxe.macro.Constant;
	public final class ExprDef extends enum {
	public static const __isenum : Boolean = true;
	public function ExprDef( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static function EArray(e1 : *, e2 : *) : ExprDef { return new ExprDef("EArray",1,[e1,e2]); }
	public static function EArrayDecl(values : List) : ExprDef { return new ExprDef("EArrayDecl",6,[values]); }
	public static function EBinop(op : haxe.macro.Binop, e1 : *, e2 : *) : ExprDef { return new ExprDef("EBinop",2,[op,e1,e2]); }
	public static function EBlock(exprs : List) : ExprDef { return new ExprDef("EBlock",12,[exprs]); }
	public static var EBreak : ExprDef = new ExprDef("EBreak",20);
	public static function ECall(e : *, params : List) : ExprDef { return new ExprDef("ECall",7,[e,params]); }
	public static function ECast(e : *, t : haxe.macro.ComplexType) : ExprDef { return new ExprDef("ECast",24,[e,t]); }
	public static function ECheckType(e : *, t : haxe.macro.ComplexType) : ExprDef { return new ExprDef("ECheckType",28,[e,t]); }
	public static function EConst(c : haxe.macro.Constant) : ExprDef { return new ExprDef("EConst",0,[c]); }
	public static var EContinue : ExprDef = new ExprDef("EContinue",21);
	public static function EDisplay(e : *, isCall : bool) : ExprDef { return new ExprDef("EDisplay",25,[e,isCall]); }
	public static function EDisplayNew(t : *) : ExprDef { return new ExprDef("EDisplayNew",26,[t]); }
	public static function EField(e : *, field : String) : ExprDef { return new ExprDef("EField",3,[e,field]); }
	public static function EFor(it : *, expr : *) : ExprDef { return new ExprDef("EFor",13,[it,expr]); }
	public static function EFunction(name : String, f : *) : ExprDef { return new ExprDef("EFunction",11,[name,f]); }
	public static function EIf(econd : *, eif : *, eelse : *) : ExprDef { return new ExprDef("EIf",15,[econd,eif,eelse]); }
	public static function EIn(e1 : *, e2 : *) : ExprDef { return new ExprDef("EIn",14,[e1,e2]); }
	public static function EMeta(s : *, e : *) : ExprDef { return new ExprDef("EMeta",29,[s,e]); }
	public static function ENew(t : *, params : List) : ExprDef { return new ExprDef("ENew",8,[t,params]); }
	public static function EObjectDecl(fields : List) : ExprDef { return new ExprDef("EObjectDecl",5,[fields]); }
	public static function EParenthesis(e : *) : ExprDef { return new ExprDef("EParenthesis",4,[e]); }
	public static function EReturn(e : * = null) : ExprDef { return new ExprDef("EReturn",19,[e]); }
	public static function ESwitch(e : *, cases : List, edef : *) : ExprDef { return new ExprDef("ESwitch",17,[e,cases,edef]); }
	public static function ETernary(econd : *, eif : *, eelse : *) : ExprDef { return new ExprDef("ETernary",27,[econd,eif,eelse]); }
	public static function EThrow(e : *) : ExprDef { return new ExprDef("EThrow",23,[e]); }
	public static function ETry(e : *, catches : List) : ExprDef { return new ExprDef("ETry",18,[e,catches]); }
	public static function EUnop(op : haxe.macro.Unop, postFix : bool, e : *) : ExprDef { return new ExprDef("EUnop",9,[op,postFix,e]); }
	public static function EUntyped(e : *) : ExprDef { return new ExprDef("EUntyped",22,[e]); }
	public static function EVars(vars : List) : ExprDef { return new ExprDef("EVars",10,[vars]); }
	public static function EWhile(econd : *, e : *, normalWhile : bool) : ExprDef { return new ExprDef("EWhile",16,[econd,e,normalWhile]); }
	public static var __constructs__ : Array = ["EConst","EArray","EBinop","EField","EParenthesis","EObjectDecl","EArrayDecl","ECall","ENew","EUnop","EVars","EFunction","EBlock","EFor","EIn","EIf","EWhile","ESwitch","ETry","EReturn","EBreak","EContinue","EUntyped","EThrow","ECast","EDisplay","EDisplayNew","ETernary","ECheckType","EMeta"];
}
