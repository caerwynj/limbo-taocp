implement Command;
include "cmd.m";

DEBUG: con 0;

# Trie search from Sedgewick, Algorithms in C, 1998, pg 614-618.
Node : adt {
	s: string;
	link: array of ref Node;
};

root: ref Node;

split(p,q: ref Node, w: int): ref Node
{
	t := ref Node(nil, nil);
	t.link = array[26] of ref Node;
	c := p.s[w] - int('a');
	d := q.s[w] - 'a';
	if(DEBUG)print("split: %c%d %c%d\n", p.s[w], c, q.s[w], d);
	if (c == d)
		t.link[c] = split(p, q, w+1);
	else {
		t.link[c] = p;	
		t.link[d] = q;
	}
	return t;
}

insertR(n: ref Node, st: string, w: int): ref Node
{
	if (n == nil) return ref Node(st, nil);
	if (n.link == nil){
		return split(ref Node(st, nil), n, w);
	}
	c := st[w] - 'a';
	n.link[c] = insertR(n.link[c], st, w+1);
	return n;
}

insert(key: string)
{
	root = insertR(root, key, 0);
}

searchR(n: ref Node, st: string, w: int): string
{
	if(n == nil) return nil;
	# if leaf node
	if (n.link == nil) {
		if(st == n.s)
			return n.s;
		else
			return nil;
	}
	# choose a branch
	c := st[w] - 'a';
	return searchR(n.link[c], st, w+1);
}

search(key: string): string
{
	return searchR(root, key, 0);
}

ptree(n: ref Node)
{
	if(n == nil){
		return;
	}
	if (n.link == nil && n.s != nil) {
		print("leaf node: %s\n", n.s);
		return;
	}
	print("branch node \n");
	for (i:=0; i< len n.link; i++) {
		if(n.link[i] != nil) {
			print("   %c \n", 'a'+i);
			ptree(n.link[i]);
		}
	}
}


main(nil:list of string)
{
	readfile();
}

test()
{
	root = insertR(root, "sam", 0);
	root = insertR(root, "sal", 0);
	root = insertR(root, "arg", 0);
	ptree(root);
}

readfile()
{
	print("TAOCP 7.2.2-24\n");
	f := bufio->open("sgb-words.txt", Bufio->OREAD);
	if(f == nil)
		raise "error";
	line := f.gets('\n');
	cnt := 1;
	while(line != nil && cnt < 5) {
		insert(line[0:5]);
		line = f.gets('\n');
		cnt++;
	}
	p := search("which");
	if (p != nil)
		print("%s\n", p);
	p = search("zzzzz");
	if (p == nil)
		print("zzzzz not found\n");
}

