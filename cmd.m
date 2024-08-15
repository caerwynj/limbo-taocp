
include "sys.m";
sys: Sys;
print, sprint: import sys;
include "draw.m";
include "math.m";
math: Math;
ceil, fabs, floor, Infinity, log10, pow10, pow, sqrt, exp: import math;
dot, gemm, iamax: import math;
include "string.m";
str: String;
tobig, toint, toreal, tolower, toupper: import str;
include "bufio.m";
bufio: Bufio;
Iobuf: import bufio;

false, true: con iota;
bool: type int;

Command:module
{ 
	init:fn(ctxt: ref Draw->Context, argv: list of string); 
};

init(nil: ref Draw->Context, argv: list of string)
{
	sys = load Sys Sys->PATH;
	math = load Math Math->PATH;
	str = load String String->PATH;
	bufio = load Bufio Bufio->PATH;
	main(argv);
}
