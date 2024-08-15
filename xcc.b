implement Command;
include "cmd.m";

Item : adt {
	NAME: string;
	LLINK,RLINK: int;
};
Node : adt {
	LEN,TOP,ULINK,DLINK: int;
};
items := array[10] of Item;
nodes := array[32] of Node;
l := 0;
n := 4;
N: int;
Z: int;
X := array[32] of int;
solutions := 0;

main(argv: list of string)
{
	argv = tl argv;
	if (len argv) n = int hd argv;
	print("xcc 7.2.2.1X n=%d\n", n);
	xcc();
	print("%d solutions\n", solutions);
}

cover(i: int)
{
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
	q := p + 1;
	while (q != p) {
		x := nodes[q].TOP;
		u := nodes[q].ULINK;
		d := nodes[q].DLINK;
		if (x <= 0) 
			q = u;
		else {
			nodes[u].DLINK = u;
			nodes[d].ULINK = u;
			nodes[x].LEN--;
			q++;
		}
	}
}

uncover(i: int)
{
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
	return;
	for(i := 1; i <= n; i++) {
		print("%d", X[i]);
	}
	print("\n");
}

choose(): int
{
	return 0;
}

xcc()
{
	backtrack := 0;
	p, i, j: int;
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
					p = X[l] - 1;
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

