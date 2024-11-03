implement Command;
include "cmd.m";

DEBUG: con 0;
NWORD: con 5757;
n := 6;
l := 1;
x := array[32] of { * => 0};
di := array[32] of { * => 1};
solutions := 0;
lcnt := array[32] of { * => 0};
words := array[8192] of string;
wordfile := "l6-words.txt";

# Trie search from Sedgewick, Algorithms in C, 1998, pg 614-618.
Node : adt {
	s: string;
	link: array of ref Node;
};

root: ref Node;
a := array[10] of {* => array[10] of ref Node};

split(p, q: ref Node, w: int): ref Node
{
	t := ref Node(nil, nil);
	t.link = array[26] of ref Node;
	c := p.s[w] - 'a';
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

readfile()
{
	line: string;
	cnt: int;

	cnt = 1;
	f := bufio->open("sgb-words.txt", Bufio->OREAD);
	if(f == nil) raise "error sgb";
	while ((line = f.gets('\n')) != nil) {
		words[cnt++] = line[0:5];
	}

	f = bufio->open(wordfile, Bufio->OREAD);
	if(f == nil) raise "error wordfile";
	while ((line = f.gets('\n')) != nil) {
		insert(line[0:6]);
	}
}

main(argv: list of string)
{
	argv = tl argv;
	if (len argv) {
		n = int hd argv;
		argv = tl argv;
	}
	if (len argv) {
		wordfile = hd argv;
	}
	print("word rectangle 7.2.2-24 n=%d\n", n);
	readfile();
	wordrect();
	print("%d solutions\n", solutions);
	print("profile (");
	for(i:=1;i<=n;i++){
		print("%d, ", lcnt[i]);
	}
	print("%d)\n", solutions);
}

visit()
{
	solutions++;
	#return;
	for(i := 1; i <= n; i++) {
		print("%d, ", x[i]);
		print("%s, ", words[x[i]]);
	}
	print("\n");
}

updated(): int
{
# Domain for each x_i is word list 1..5757.
# this function should return the next word for each level.

	if(di[l] < NWORD) {
		di[l] += 1;
		x[l] = di[l];
		return 0;
	} else {
		return 1;
	}
}

pass(): int
{
# for each row in the word rectangle x_1..x_l-1
#    Use l-1 ref Node. If None, use the root.
#    if the letter of the current word is not in the link return 0
#    if letter of the current word are ok store the ref Node of the link and return 1
	s := words[x[l]];
	for (i := 0; i < len s; i++) {
		# assert l >= 1
		p := a[i][l-1];
		if (p == nil)
			p = root;
		c := s[i] - 'a';
		if (p.link == nil || p.link[c] == nil)
			return 0;
		else
			a[i][l] = p.link[c];
	}
	return 1;
}

wordrect()
{
	backtrack := 0;
	b2: for(;;) {
		if (l > n) {
			visit();
			backtrack = 1;
		} else {
			x[l] = 1;
		}
		if(DEBUG)print("l=%d x=%d\n", l, x[l]);
		lcnt[l]++;

		b3: for(;;) {
			if (!backtrack) {
				b := pass();
				if(DEBUG)print("pass %d\n", b);
				if (b) {
					l++;
					continue b2;
				}
			}
			b4: for(;;) {
				if (!backtrack) {
					ismax := updated();
					if(DEBUG)print("ismax %d, x[%d]=%d\n", ismax, l, x[l]);
					if (!ismax)
						continue b3;
				}
				# backtrack
				if(DEBUG)print("backtrack\n");
				backtrack = 0;
				di[l] = 1;
				l--;
				if (l > 0)
					continue b4;
				else
					return;
			}
		}
	}
}

