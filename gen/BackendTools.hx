package gen;

class BackendTools {
	public static function create<T:Extern>(c:Class<T>, v:Dynamic) {
		var i:T = Type.createEmptyInstance(c);
		i._ = v;
		return i;
	} 
}