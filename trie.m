Triem: module {
	Trie : adt {
		root: ref Node;
		search: fn(h: self Trie, key: string): int
		insert: fn(h: self Trie, key: string);
	};
	Node : adt {
		s: string;
		link: array of ref Node;
	};
	init: fn(): ref Trie;
};
