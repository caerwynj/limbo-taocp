implement Command;
include "cmd.m";

x := array[32] of { * => 0};
di := array[32] of { * => 1};
l := 1;
n := 4;
solutions := 0;
lcnt := array[32] of { * => 0};

main(argv: list of string)
{
	argv = tl argv;
	if (len argv) n = int hd argv;
	print("nqueens 7.2.2B n=%d\n", n);
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

updated(): int
{
	if(di[l] < n) {
		di[l] = di[l] + 1;
		x[l] = di[l];
		return 0;
	} else {
		return 1;
	}
}

pass(): int
{
	for(j:=1; j <= l; j++) {
		for(k:=j+1; k <= l; k++) {
			z := x[k] - x[j];
			if (z < 0) z = -z;
			if ((x[j] == x[k]) || (z == k-j))
				return 0;
		}
	}
	return 1;
}

nqueens()
{
	backtrack := 0;
	b2: for(;;) {
		if (l > n) {
			visit();
			backtrack = 1;
		} else {
			x[l] = 1;
		}
		if(0)print("l=%d x=%d\n", l, x[l]);
		lcnt[l]++;

		b3: for(;;) {
			if (!backtrack) {
				b := pass();
				if(0)print("pass %d\n", b);
				if (b) {
					l++;
					continue b2;
				}
			}
			b4: for(;;) {
				if (!backtrack) {
					ismax := updated();
					if(0)print("ismax %d, x[%d]=%d\n", ismax, l, x[l]);
					if (!ismax)
						continue b3;
				}
				# backtrack
				if(0)print("backtrack\n");
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

