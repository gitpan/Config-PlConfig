# $Id: Build.PL,v 1.5 2007/07/13 00:00:11 ask Exp $
# $Source: /opt/CVS/Getopt-LL/Build.PL,v $
# $Author: ask $
# $HeadURL$
# $Revision: 1.5 $
# $Date: 2007/07/13 00:00:11 $
use strict;
use warnings;

sub BEGIN {
    use File::Spec;
    use FindBin qw($Bin);
    my $inc = File::Spec->catdir($Bin, 'inc');
    unshift @INC, $inc;
}

use Module::Build;

# ##########################################################



sub YES { 1 };
sub NO  { 0 };

$ENV{DEVEL_COVER_OPTIONS} = '-ignore,blib/Class/InsideOut/Policy/Modwheel.pm';
my $builder = Module::Build->new(
    module_name          => 'Config::PlConfig',
    dist_version        => '0.1_01',
    license              => 'perl',
    dist_author          => 'Ask Solem <ASKSH@cpan.org>',
    all_from             => 'lib/Config/PlConfig.pm',
    dynamic_config       => NO,
    sign                 => NO, # asksh: have to find out why my signature fails.
    create_makefile_pl   => 'traditional',
    create_readme        => YES,
    recursive_test_files => YES,
    requires             => {
        'version'                               => 0,
        'Class::Dot'                            => 0,
        'File::HomeDir'                         => 0,
        'YAML::Syck'                            => 0,
    },
    recommends           => {
    },
    build_requires       => {
     'Test::Simple'            => 0.42,    # 
    },
    add_to_cleanup       => [ qw(
        a.out
        test.pl
        test.c
        test.cpp
        test.m
        *.swp
        .gdb_history
        install.cache
        t/cache
        cache/
    ) ],
    meta_merge => {
        distribution_type   => 'Module'
    },
);

$builder->create_build_script( );

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
# End:
# vim: expandtab tabstop=4 shiftwidth=4 shiftround
