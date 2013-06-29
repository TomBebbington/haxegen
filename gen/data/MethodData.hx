package gen.data;
import gen.HaxeType;
typedef MethodData = {>FieldData,
	@:optional var args:Array<HaxeType>;
	@:optional var ret:HaxeType;
}