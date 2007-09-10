use Test::More tests => 16;

my $PLCONFIG_TEST_DOMAIN = 'org.0x61736b.plconfig.testunit';

my $test_config = {
    foo     => 'bar',
    xyzzy   => 'fishy',
    quick   => 'fox',
    brown   => 'char',
    note    => 'blue',
};

BEGIN {
use_ok( 'Config::PlConfig' );
}

diag( "Testing Config::PlConfig $Config::PlConfig::VERSION" );

my $plconfig = Config::PlConfig->new();
isa_ok($plconfig, 'Config::PlConfig');

isa_ok($plconfig->host, 'Config::PlConfig::Host::Local');

my $plconfig_global = Config::PlConfig->new({
    host => 'global'
});
isa_ok($plconfig_global->host, 'Config::PlConfig::Host::Global');


$plconfig->save($test_config);

my $reloaded = $plconfig->load;

is_deeply($test_config, $reloaded, 'dumped structure same as original');

my $config = Config::PlConfig->new({
    domain => $PLCONFIG_TEST_DOMAIN,
});

ok($config->host->confdir, 'has hostdir');
is($config->domain, $PLCONFIG_TEST_DOMAIN);
isa_ok($config->load, 'HASH', 'load');

ok( $config->save($test_config), 'save' );

my $loaded = $config->load;
ok( ref $loaded eq 'HASH', 'reloaded after save');
is_deeply($loaded, $test_config, 'content same after save');

is( $config->get('foo'),   'bar'   );
is( $config->get('xyzzy'), 'fishy' );
is( $config->get('quick'), 'fox'   );
is( $config->get('brown'), 'char'  );
is( $config->get('note'),  'blue'  );
