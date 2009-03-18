use strict;
use warnings;
use inc::Module::Install;

name 'MRO-Define';
all_from 'lib/MRO/Define.pm';

test_requires 'Variable::Magic';

WriteAll;
