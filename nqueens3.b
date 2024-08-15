implement Command;
include "cmd.m";

x := array[32] of { * => 0};
s := array[32] of { * => 0};
l := 1;
n := 4;
solutions := 0;
lcnt := array[32] of { * => 0};
t := 1;
a := big 0;
b := big 0;
c := big 0;

main(argv: list of string)
{
	argv = tl argv;
	if (len argv > 0)
		n = int hd argv;
	print("nqueens 7.2.2W n=%d\n", n);
	nqueens();
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
	return;
	for(i := 1; i <= n; i++) {
		print("%d", x[i]);
	}
	print("\n");
}

pass(): int
{
	if ((a & big (1<<t)) > big 0)
		return 0;
	if ((b & big (1<<(t+l-1))) > big 0)
		return 0;
	if ((c & big (1<<(t-l+n))) > big 0)
		return 0;
	a |= big 1<<t;
	b |= big 1<<(t+l-1);
	c |= big 1<<(t-l+n);
	x[l] = t;
	if(0)print("l=%d,x=%d,t=%d\n", l,x[l],t);
	l++;
	return 1;
}

nqueens()
{
	backtrack := 0;
	b2: for(;;) {
		if(0)print("b2: l=%d x=%d t=%d\n", l, x[l], t);
		if (l > n) {
			visit();
			backtrack = 1;
		} else {
			t = 1;
		}
		lcnt[l]++;

		b3: for(;;) {
			if(0)print("b3: l=%d x=%d t=%d\n", l, x[l], t);
			if (!backtrack) {
				bp := pass();
				if (bp) {
					continue b2;
				}
			}
			b4: for(;;) {
				if(0)print("b4:l=%d x=%d t=%d\n", l, x[l], t);
				if (!backtrack) {
					if (t < n) {
						t++;
						continue b3;
					}
				}
				# backtrack
				if(0)print("backtrack\n");
				backtrack = 0;
				l--;
				if (l > 0) {
					t = x[l];
					c &= big 16rFFFFFFFF ^ big (1<<t-l+n);
					b &= big 16rFFFFFFFF ^ big (1<<t+l-1);
					a &= big 16rFFFFFFFF ^ big (1<<t);
					continue b4;
				} else
					return;
			}
		}
	}
}

