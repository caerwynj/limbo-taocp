implement Command;
include "cmd.m";
include "xcc.m";
xccm : Xcc;
Item, Node, read_input: import xccm;

l := 0;
N: int;
Z: int;
X := array[32] of int;
solutions := 0;
items: array of Item;
nodes: array of Node;

main(argv: list of string)
{
	xccm = load Xcc "./xccm.dis";
	xccm->minit();
	argv = tl argv;
	print("xcc 7.2.2.1X\n");
	(items, nodes) = read_input(hd argv);
	N = len items -1;
	Z = len nodes -1;
	#print_items();
	#print_nodes();
	xcc();
	print("%d solutions\n", solutions);
}

print_items()
{
	for(i:=0;i<len items; i++) {
		c := items[i];
		print("%d: %s,%d,%d\n", i, c.NAME, c.LLINK, c.RLINK);
	}
}

print_nodes()
{
	for(i:=0;i<len nodes;i++) {
		c := nodes[i];
		print("%d:%d,%d,%d,%d\n", i, c.LEN,c.TOP,c.ULINK,c.DLINK);
	}
}

cover(i: int)
{
	print("cover %d\n", i);
	p := nodes[i].DLINK;
	while (p != i) {
		hide(p);
		p = nodes[p].DLINK;
	}
	ll := items[i].LLINK;
	rl := items[i].RLINK;
	items[ll].RLINK = rl;
	items[rl].LLINK = ll;
}

hide(p: int)
{
	print("hide %d\n", p);
	q := p + 1;
	while (q != p) {
		x := nodes[q].TOP;
		u := nodes[q].ULINK;
		d := nodes[q].DLINK;
		if (x <= 0) 
			q = u;
		else {
			nodes[u].DLINK = d;
			nodes[d].ULINK = u;
			nodes[x].LEN--;
			q++;
		}
	}
}

uncover(i: int)
{
	print("uncover %d\n", i);
	ll := items[i].LLINK;
	rl := items[i].RLINK;
	items[ll].RLINK = i;
	items[rl].LLINK = i;
	p := nodes[i].ULINK;
	while (p != i) {
		unhide(p);
		p = nodes[p].ULINK;
	}
}

unhide(p: int)
{
	print("unhide %d\n", p);
	q := p - 1;
	while (q != p) {
		x := nodes[q].TOP;
		u := nodes[q].ULINK;
		d := nodes[q].DLINK;
		if (x <= 0) {
			q = d;
		} else {
			nodes[u].DLINK = q;
			nodes[d].ULINK = q;
			nodes[x].LEN++;
			q--;
		}
	}	
}

visit()
{
	solutions++;
	for(i := 1; i <= N; i++) {
		print("%d", X[i]);
	}
	print("\n");
}

choose(): int
{
	theta := 100000;
	i, p, ln: int;

	p = items[0].RLINK;
	#print("choose: %d len %d\n", p, nodes[p].LEN);
	while (p != 0) {
		ln = nodes[p].LEN;
		if (ln < theta) {
			theta = ln; 	
			i = p;
		}
		if (ln  == 0)
			break;
		p = items[p].RLINK;
		#print("choose: %d len %d\n", p, nodes[p].LEN);
	}
	print("choose: %d len %d\n", i, nodes[i].LEN);
	return i;
}

xcc()
{
	backtrack := 0;
	p, i, j: int;

	print("starting xcc\n");
	l = 0;
	b2: for(;;) {
		if (items[0].RLINK == 0) {
			visit();
			backtrack = 2;
		} 
		i = choose();
		cover(i);
		X[l] = nodes[i].DLINK;

		b3: for(;;) {
			if (!backtrack) {
				if (X[l] == i) {
					backtrack = 1;
				}else{
					p = X[l] + 1;
					while (p != X[l]) {
						j = nodes[p].TOP;
						if (j <= 0){
							p = nodes[p].ULINK;
						} else {
							cover(j);
							p++;
						}
					}
					l++;
					continue b2;
				}
			}
			b4: for(;;) {
				if (!backtrack) {
					p = X[l] - 1;
					while (p != X[l]) {
						j = nodes[p].TOP;
						if (j <= 0) {
							p = nodes[p].DLINK;
						} else {
							uncover(j);
							p--;
						}
					}
					i = nodes[X[l]].TOP;
					X[l] = nodes[X[l]].DLINK;
					continue b3;
				}

				# backtrack
				if (backtrack  != 2)
					uncover(i);
				backtrack = 0;

				# X6: leave level l
				if (l > 0) {
					l--;
					continue b4;
				} else
					return;
			}
		}
	}
}

