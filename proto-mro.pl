use strict;
use warnings;

{
    package ProtoMRO;

    use mro;
    use MRO::Define;
    use Variable::Magic qw/wizard cast/;

    BEGIN {
        MRO::Define::register_mro(q/proto/, sub {
            return [qw/Dummy ProtoMRO/];
        });
    }

    my $method_name;

    sub invoke_method {
        warn qq{invoking ${method_name}};
    }

    my $wiz = wizard
        data  => sub { \$method_name },
        fetch => sub {
            ${ $_[1] } = $_[2];
            $_[2] = 'invoke_method';
            ();
        };

    cast %::ProtoMRO::, $wiz;
}

{
    package Bar;
    use mro 'proto';
}

Bar->moo
