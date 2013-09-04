use strict;
use warnings;
use ExtUtils::MakeMaker;


WriteMakefile(
    NAME     => 'MRO::Define',
    NORECURS => 1,
    CCFLAGS  => '-Wall -Wextra -Wdeclaration-after-statement',
);
