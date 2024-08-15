implement Command;
include "cmd.m";

x := array[32] of {* => 0};
y := array[32] of {* => 0}; 
p := array[32] of {* => 0};
l := 1;
n := 4;
j : int;
k : int;
solutions := 0;
lcnt := array[32] of { * => 0};

main(argv: list of string)
{
	argv = tl argv;
	if (len argv) n = int hd argv;
	print("langford pairs 7.2.2L n=%d\n", n);
	langford();
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
	for(i := 1; i <= (2*n); i++) {
		print("%d", x[i]);
	}
	print("\n");
}

langford()
{
	backtrack := 0;

	for(k=0;k<n;k++){
		p[k] = k+1;
	}
	p[n] = 0;
	l = 1;
	b2: for(;;) {
		k = p[0];
		if (k == 0) {
			visit();
			backtrack = 1;
		} else {
			j = 0;
			while(x[l] < 0)
				l++;
		}
		if(0)print("l=%d x=%d\n", l, x[l]);
		lcnt[l]++;

		b3: for(;;) {
			if (!backtrack) {
				o := l + k + 1;
				if (o > (2*n)) {
					backtrack = 1;
				} else if (x[o] == 0) {
					x[l] = k;
					x[o] = -k;
					y[l] = j;
					p[j] = p[k];
					l++;
					continue b2;
				}
			}
			b4: for(;;) {
				if (!backtrack) {
					j = k;
					k = p[j];
					if (k != 0)
						continue b3;
				}
				# backtrack
				if(0)print("backtrack\n");
				backtrack = 0;
				l--;
				if (l > 0) {
					while (x[l] < 0)
						l--;
					k = x[l];
					x[l] = 0;
					x[l+k+1] = 0;
					j = y[l];
					p[j] = k;
					continue b4;
				} else
					return;
			}
		}
	}
}

