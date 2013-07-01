package haxe.macro {
	import haxe.macro.ComplexType;
	public final class TypeDefKind extends enum {
	public static const __isenum : Boolean = true;
	public function TypeDefKind( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static function TDAbstract(tthis : haxe.macro.ComplexType, from : List = null, to : List = null) : TypeDefKind { return new TypeDefKind("TDAbstract",4,[tthis,from,to]); }
	public static function TDAlias(t : haxe.macro.ComplexType) : TypeDefKind { return new TypeDefKind("TDAlias",3,[t]); }
	public static function TDClass(superClass : * = null, interfaces : List = null, isInterface : * = null) : TypeDefKind { return new TypeDefKind("TDClass",2,[superClass,interfaces,isInterface]); }
	public static var TDEnum : TypeDefKind = new TypeDefKind("TDEnum",0);
	public static var TDStructure : TypeDefKind = new TypeDefKind("TDStructure",1);
	public static var __constructs__ : Array = ["TDEnum","TDStructure","TDClass","TDAlias","TDAbstract"];
}
