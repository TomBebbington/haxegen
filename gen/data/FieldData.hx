package gen.data;
import gen.HaxeType;
typedef FieldData = {
	var name:String;
	@:optional var type:HaxeType;
	@:optional var isStatic:Bool;
}