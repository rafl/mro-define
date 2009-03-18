use strict;
use warnings;
use inc::Module::Install;

require 5.011;

name 'MRO-Define';
all_from 'lib/MRO/Define.pm';

test_requires 'Variable::Magic';

WriteAll;
