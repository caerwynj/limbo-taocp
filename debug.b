implement Command;
include "cmd.m";
include "debug.m";
debug: Debug;
Prog, Exp, Module, Sym: import debug;

main(argv: list of string)
{
	line: string;
	prog: ref Prog;
	s: string;
	last: list of string;
	exp: array of ref Exp;
	sym: ref Sym;

	debug = load Debug Debug->PATH;
	debug->init();

	in := bufio->fopen(sys->fildes(0), Bufio->OREAD);
	print("> ");
	while ((line = in.gets('\n')) != nil) {
		(n, l) := sys->tokenize(line, " \n\r\t");
		if (len l == 0)
			l = last;
		case hd l {
		"q" =>
			exit;
		"run" =>
			(prog, s) = debug->startprog(hd tl l, ".", nil, tl tl l);
			if(prog == nil)
				print("error %s\n", s);
		"c" =>
			s = prog.cont();
			if(s != nil)
				print("%s\n", s);
		"step"  =>
			s = prog.step(Debug->StepStmt);
			if(s != nil)
				print("%s\n", s);
		"start" =>
			s = prog.start();
			if(s != nil)
				print("%s\n", s);
		"stop" =>
			s = prog.stop();
			if(s != nil)
				print("%s\n", s);
		"unstop" =>
			s = prog.unstop();
			if(s != nil)
				print("%s\n", s);
		"kill" =>
			s = prog.kill();
			if(s != nil)
				print("%s\n", s);
		"status" =>
               		(pgrp, user, state, mod) := prog.status();
			print("%d %s %s %s\n", pgrp, user, state, mod);
		"stack" =>
			(exp, s) = prog.stack();
			if(s != nil) 
				print("%s\n", s);
			for(i:=0; i < len exp; i++) {
				exp[i].m.stdsym();
				exp[i].findsym();
				print("sbl %s \n", exp[i].m.sbl());
				print("dis %s \n", exp[i].m.dis());
				print("%s %s\n", exp[i].name, exp[i].srcstr());
			}
		"sym" =>
			(sym, s) = debug->sym(hd tl l);
			if(s != nil){
				print("err %s\n", s);
				continue;
			}
			(exp, s) = prog.stack();
			if(s != nil) 
				print("%s\n", s);
			for(i:=0; i < len exp; i++) {
				exp[i].m.addsym(sym);
				print("sbl %s \n", exp[i].m.sbl());
				print("dis %s \n", exp[i].m.dis());
				print("%s %s\n", exp[i].name, exp[i].srcstr());
			}
		"pc" =>
			src := sym.pctosrc(int(hd tl l));
			if(src != nil){
				print("%s:%d#%d\n", src.start.file, src.start.line, src.start.pos);
			}
		"b" =>
			l = tl l;
			if(len l < 2){
				print("err b file.dis pc\n");
				continue;
			}
			s = prog.setbpt(hd l, int(hd tl l));
			if(s != nil)
				print("%s\n", s);
		}
		last = l;
		print("> ");
	}
}

