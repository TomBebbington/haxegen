package gen.data;
import gen.HaxeType;
typedef FieldData = {
	var name:String;
	@:optional var rename:String;
	@:optional var type:HaxeType;
	@:optional var isStatic:Bool;
	@:optional var isConst:Bool;
}