use strict;
use warnings;
use inc::Module::Install;

name 'MRO-Define';
all_from 'lib/MRO/Define.pm';

# ghetto hack by rjbs. normally we'd want to require 5.10.1, except the current
# maint-5.10 works as well, but says it's 5.10.0. so we check if this build of
# perl was created after the core switched to git. that should usually mean
# it's new enough for our purpose. if there's no git commit id, we simply
# require 5.10.1 as usual.

use Config;
unless ($Config{git_commit_id}) {
    perl_version '5.010001';
}

requires 'XSLoader';
test_requires 'Variable::Magic';

WriteAll;
