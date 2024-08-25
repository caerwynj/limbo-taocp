implement Xcc;
include "xcc.m";

include "sys.m";
sys: Sys;
print: import sys;
include "bufio.m";
bufio: Bufio;
Iobuf: import bufio;
include "string.m";
str: String;
splitl: import str;

init()
{
	sys = load Sys Sys->PATH;
	bufio = load Bufio Bufio->PATH;
	str = load String String->PATH;
}

read_input(filename: string): (array of Item, array of Node)
{
	line: string;
	l: list of string;
	N, N1, i, j, k, M, p, q, Z, n: int = 0;
	f: ref Iobuf;
	items := array[1024] of { * => Item(nil,0,0)};
	nodes := array[1024] of { * => Node(0,0,0,0,0) };

	N1 = -1;
	f = bufio->open(filename, Bufio->OREAD);
	line = f.gets('\n');
	(n, l) = sys->tokenize(line, " \t\r\n");
	for (; l != nil; l = tl l) {
		if (hd l == "|") {
			N1 = i;
			print("N1=%d\n", N1);
			continue;
		}
		i++;
		items[i].NAME = hd l;
		items[i].LLINK = i - 1;
		items[i-1].RLINK = i;
	}
	N = i;
	if (N1 < 0)
		N1 = N;
	items[N+1].LLINK = N;
	items[N+1].RLINK =  N1 + 1;
	items[N].RLINK = N + 1;
	items[N1+1].LLINK = N + 1;
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
			(ls, rs) := splitl(hd l, ":");
			i = lookup(ls, items);
			if (i == -1) {
				print("error not found %s\n", hd l);
				exit;
			} else {
				nodes[i].LEN++;
				q = nodes[i].ULINK;
				nodes[p+j].ULINK = q;
				nodes[q].DLINK = p+j;
				nodes[p+j].DLINK = i;
				nodes[i].ULINK = p+j;
				nodes[p+j].TOP = i;
				if(rs != nil && len rs >= 2) 
					nodes[p+j].COLOR = int(rs[1]);
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
	print("N %d Z %d N1 %d N2 %d\n", N, Z, N1, N - N1);
	return (items[:N+2], nodes[:Z+1]);
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

print_items(items: array of Item)
{
	for(i:=0;i<len items; i++) {
		c := items[i];
		print("%d: %s,%d,%d\n", i, c.NAME, c.LLINK, c.RLINK);
	}
}

print_nodes(nodes: array of Node)
{
	for(i:=0;i<len nodes;i++) {
		c := nodes[i];
		print("%d:%d,%d,%d,%d,%d\n", i, c.LEN,c.TOP,c.ULINK,c.DLINK,c.COLOR);
	}
}
