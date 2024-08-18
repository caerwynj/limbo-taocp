Xcc: module {
	Item : adt {
		NAME: string;
		LLINK,RLINK: int;
	};
	Node : adt {
		LEN,TOP,ULINK,DLINK: int;
	};

	init:fn();
	read_input: fn(filename: string): (array of Item, array of Node);
};
