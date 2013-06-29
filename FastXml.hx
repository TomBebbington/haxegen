abstract FastXml(Xml) from Xml to Xml {
	public inline function new(nodeName:String) this = Xml.createElement(nodeName);
	@:arrayAccess public inline function get(attr:String):String return this.get(attr);
	@:arrayAccess public inline function set(attr:String, v:String):Void this.set(attr, v);
	@:from public static inline function parse(c:String):FastXml return Xml.parse(c);
}