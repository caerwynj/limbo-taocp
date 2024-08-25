Xcc: module {
	Item : adt {
		NAME: string;
		LLINK,RLINK: int;
	};
	Node : adt {
		LEN,TOP,ULINK,DLINK,COLOR: int;
	};

	init:fn();
	read_input: fn(filename: string): (array of Item, array of Node);
	print_items: fn(items: array of Item);
	print_nodes: fn(nodes: array of Node);
};
