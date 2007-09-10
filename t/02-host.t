use Test::More tests => 49;

BEGIN {
use_ok( 'Config::PlConfig');
use_ok( 'Config::PlConfig::Host::Local' );
use_ok( 'Config::PlConfig::Host::Global' );
}

diag( "Testing Config::PlConfig::Host::* $Config::PlConfig::VERSION" );

my @VALID_DOMAINS = qw(
    com.foo.org.aaaaaa.123_abla
    123.___.+1337.elite.0wnage
    net.0x61736b.modwheel
    com.perl.site
    org.cpan.testers 
    org.perl.cpants
    org.perl.tpf
);

my @INVALID_DOMAINS = (
    '!!.DAW(**$%_(!*)(&%_)(#',
    '_)AS(_D)(S+_F(+_)E(I_!(J%OJH#!%OIUh3',
    '-asd-sa-ds-d0s/a-d0sad',
    '............$!@',
);

my $localdir  = Config::PlConfig::Host::Local->new();
my $globaldir = Config::PlConfig::Host::Global->new();

ok( $localdir->confdir,  'local confdir:  '. $localdir->confdir  );
ok( $globaldir->confdir, 'global confdir: '. $globaldir->confdir );

for my $domain (@VALID_DOMAINS) {
    my $l = $localdir->file_for_domain($domain);
    my $g = $globaldir->file_for_domain($domain);
    ok( $localdir->check_domain($domain),  "local  check_domain: $domain" );
    ok( $globaldir->check_domain($domain), "global check_domain: $domain" );
    ok( $l, "local  file_for_domain: $l" );
    ok( $g, "global file_for_domain: $g" );
};

for my $domain (@INVALID_DOMAINS) {
    ok( ! $localdir->check_domain($domain),
        'local  check illegal domain: '. $domain
    );
    ok( ! $globaldir->check_domain($domain),
        'global check illegal domain: '. $domain
    );
    ok( ! $localdir->file_for_domain($domain),
        'local bail on illegal domain file_for_domain '. $domain
    );
    ok( ! $globaldir->file_for_domain($domain),
        'global bail on illegal domain file_for_domain '. $domain
    );
}

