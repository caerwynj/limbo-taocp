implement Command, Xcc;
include "cmd.m";
include "xcc.m";

main(argv: list of string)
{
	argv = tl argv;
	(it, no) := read_input(hd argv);
}

minit()
{
	sys = load Sys Sys->PATH;
	bufio = load Bufio Bufio->PATH;
}
read_input(filename: string): (array of Item, array of Node)
{
	line: string;
	l: list of string;
	N, N1, i, j, k, M, p, q, Z, n: int = 0;
	f: ref Iobuf;
	items := array[32] of Item;
	nodes := array[128] of Node;

	f = bufio->open(filename, Bufio->OREAD);
	line = f.gets('\n');
	(n, l) = sys->tokenize(line, " \t\r\n");
	for (; l != nil; l = tl l) {
		i++;
		items[i].NAME = hd l;
		items[i].LLINK = i - 1;
		items[i-1].RLINK = i;
	}
	N = i;
	N1 = N;
	items[N+1].LLINK = N;
	items[N].RLINK = N + 1;
	items[N1+1].LLINK = N + 1;
	items[N+1].RLINK =  N1 + 1;
	items[0].LLINK = N1;
	items[N1].RLINK = 0;
	#print("lookup node g %d\n", lookup("g", items));

	for(i=1; i<=N; i++) {
		nodes[i].LEN = 0;
		nodes[i].ULINK = i;
		nodes[i].DLINK = i;
	}
	M = 0; 
	p = N + 1; 
	nodes[p].TOP = 0;
	while ((line = f.gets('\n')) != nil) {
		(n, l) = sys->tokenize(line, " \t\r\n");
		k = len l;
		#print("line %s, %d toks\n", line, k);
		for (j=1; l != nil; l = tl l) {
			i = lookup(hd l, items);
			if (i == -1) {
				print("error not found %s\n", hd l);
			} else {
				nodes[i].LEN++;
				q = nodes[i].ULINK;
				nodes[p+j].ULINK = q;
				nodes[q].DLINK = p+j;
				nodes[p+j].DLINK = i;
				nodes[i].ULINK = p+j;
				nodes[p+j].TOP = i;
			}
			j++;
		}
		M++;
		nodes[p].DLINK = p+k;
		p += k+1;
		nodes[p].TOP = -M;
		nodes[p].ULINK = p-k;
	}
	Z = p;
	print("N %d Z %d\n", N, Z);
	return (items[:N+1], nodes[:Z+1]);
}

lookup(name:string, items: array of Item): int
{
	for(i := 1; i < len items; i++) {
		if (name == items[i].NAME) {
			return i;
		}
	}
	return -1;
}

