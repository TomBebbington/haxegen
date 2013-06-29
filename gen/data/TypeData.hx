package gen.data;
typedef TypeData = {
	var name:String;
	var native:String;
	@:optional var type:String;
	@:optional var extend:gen.HaxeType;
	@:optional var headers:Array<String>;
	@:optional var fields:Array<FieldData>;
	@:optional var methods:Array<MethodData>;
	@:optional var values:Array<String>;
}