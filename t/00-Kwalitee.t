use Test::More;

if ($ENV{TEST_COVERAGE}) {
    plan( skip_all => 'Disabled when testing coverage.' );
}

if ( not $ENV{CONFIG_PLCONFIG_AUTHOR} ) {
    my $msg = 'Author test.  Set $ENV{CONFIG_PLCONFIG_AUTHOR} to a true value to
run.';
    plan( skip_all => $msg );
}

eval { require Test::Kwalitee; Test::Kwalitee->import() };

plan( skip_all => 'Test::Kwalitee not installed; skipping' ) if $@;
