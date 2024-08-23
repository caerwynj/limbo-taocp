implement Command;
include "cmd.m";
include "xcc.m";
xcc : Xcc;
read_input: import xcc;

main(argv :list of string)
{
	xcc = load Xcc "xccm.dis";

	argv = tl argv;
	print("hello\n");
	xcc->init();
	(a, b) := read_input(hd argv);
	print("%d\n", len a);
}
