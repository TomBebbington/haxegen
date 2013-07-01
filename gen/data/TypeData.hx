package gen.data;
import gen.*;
typedef TypeData = {
	var name:HaxeType;
	var native:String;
	@:optional var type:String;
	@:optional var extend:gen.HaxeType;
	@:optional var headers:Array<String>;
	@:optional var fields:Array<FieldData>;
	@:optional var methods:Array<MethodData>;
	@:optional var values:Array<String>;
	@:optional var properties:Array<PropData>;
}