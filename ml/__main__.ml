package  {
	import gen.Generator;
	import flash.Boot;
	import flash.Lib;
public class __main__ extends flash.Boot {
	public function __main__() {
		super();
		flash.Lib.current = this;
		(;
			Math.__name__ = ["Math"];
			Math["NaN"] = Number["NaN"];
			Math["NEGATIVE_INFINITY"] = Number["NEGATIVE_INFINITY"];
			Math["POSITIVE_INFINITY"] = Number["POSITIVE_INFINITY"];
			Math["isFinite"] = function(i : float) : bool (;
				return false;
			);
			Math["isNaN"] = function(i : float) : bool (;
				return false;
			);
		);
		gen.Generator.main();
	}
}
