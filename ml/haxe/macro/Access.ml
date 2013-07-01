package haxe.macro {
	public final class Access extends enum {
	public static const __isenum : Boolean = true;
	public function Access( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
	public static var ADynamic : Access = new Access("ADynamic",4);
	public static var AInline : Access = new Access("AInline",5);
	public static var AMacro : Access = new Access("AMacro",6);
	public static var AOverride : Access = new Access("AOverride",3);
	public static var APrivate : Access = new Access("APrivate",1);
	public static var APublic : Access = new Access("APublic",0);
	public static var AStatic : Access = new Access("AStatic",2);
	public static var __constructs__ : Array = ["APublic","APrivate","AStatic","AOverride","ADynamic","AInline","AMacro"];
}
