package  {
class Lambda =;
	object;
		static public function indexOf(it : *,v : *) : int32 (;
			let i : int32 = 0 in;
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var v2 : * = $it.next();
			(;
				if(v == v2) return i;
				i++;
			);
			}};
			return -1;
		);
		
end;
	