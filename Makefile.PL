use strict;
use warnings;
use inc::Module::Install;

name 'MRO-Define';
all_from 'lib/MRO/Define.pm';

requires 'perl', '5.010001';
requires 'XSLoader';
test_requires 'Variable::Magic';

WriteAll;
