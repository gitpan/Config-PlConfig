# $Id$
# $Source$
# $Author$
# $HeadURL$
# $Revision$
# $Date$
package Config::PlConfig;
use warnings;
use strict;
use 5.006001;
use Carp;
use version; our $VERSION = qv('0.1_01');
{

    use Class::Dot qw( property isa_String isa_Data isa_Hash);
    use Config::PlConfig::Constants;
    use Config::PlConfig::Host::Local;
    use Config::PlConfig::Host::Global;
    use YAML::Syck qw(LoadFile DumpFile);
    
    my %HOST_TO_CLASS = (
        'local'     => 'Config::PlConfig::Host::Local',
        'global'    => 'Config::PlConfig::Host::Global',
    );

    property domain     => isa_String('system.DEFAULT');
    property host       => isa_Data();
    property options    => isa_Hash();
    property config     => isa_Hash();

    sub new {
        my ($class, $options_ref) = @_;
        my $self = { };
        bless $self, $class;

        my $DEFAULT_HOST = Config::PlConfig::Constants->get(
           'DEFAULT_HOST'
        );

        my $host_class = $options_ref->{host}
                ? $HOST_TO_CLASS{ $options_ref->{host} }
                : $HOST_TO_CLASS{ $DEFAULT_HOST        };
        my $host = $host_class->new($options_ref);

        if ($options_ref->{domain}) {
            $self->set_domain( $options_ref->{domain} );
        }

        $self->set_host($host);
        $self->set_options($options_ref);

        $self->load( );
    
        return $self;
    }

    sub get {
        my ($self, $key) = @_;
        my $config       = $self->config;

        return $config->{$key};
    }

    sub load {
        my ($self) = @_;
        my $host   = $self->host;
        my $domain = $self->domain;
        my $cfile  = $host->file_for_domain($domain);

        if (! -f $cfile) {
            return;
        }

        my $config = YAML::Syck::LoadFile($cfile);
        $self->set_config($config);

        return $config;
    }

    sub save {
        my ($self) = @_;
        my $host   = $self->host;
        my $domain = $self->domain;
        my $config = $self->config;
        my $cfile  = $host->file_for_domain($domain);

        return YAML::Syck::DumpFile($cfile, $config);
    }

    sub DEMOLISH {
        my ($self) = @_;

        $self->save( );

        return;
    }
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Config::PlConfig - Maintain a single place for configuration files.


=head1 VERSION

This document describes Config::PlConfig version 0.1_01


=head1 SYNOPSIS

    use Config::PlConfig;

    # User configuration.

    my $plconfig_userconfig = Config::PlConfig->new({
        host    => 'local',
        domain  => 'com.mycorp.myapp',
    });

    my $config = $plconfig_userconfig->load();

    $config->{database}{driver} = 'mysql';
    
    $config->save();

    # Global configuration.

    my $plconfig_globalconfig = Config::PlConfig->new({
        host    => 'global',
        domain  => 'com.mycorp.myapp',
    }); 

    $config->{mycorp_homepage} = 'http://foo.com';
    
    $config->save;
    

=head1 DESCRIPTION

This is a prototype for a configuration system in Perl.
It is meant to be inspired by the gconf and Apple Property List configuration
systems.

The name, API and features of this module is most likely to change in the near
future so it's not meant to be used for production systems.

If you'd like to help develop a configuration system for Perl, you are very welcome.


=head1 WHERE DOES IT SAVE CONFIGURATION FILES?

=head2 LOCAL CONFIGURATION

Local configuration files will be stored in the data directory of the users
home directory.

L<File::HomeDir>s C<my_data> method is used to find the data directory.

=head2 GLOBAL CONFIGURATION

The global configuration directory has to be writable by the user the program
is running-as. One way to do this is to make the directory world-writable.
Hopefully a better solution will be implemented in the future.

=head3 UNIX-like systems. (Linux FreeBSD OpenBSD NetBSD)

    /etc/plconf

=head3 Mac OS X / Darwin

    /Library/Application Support/plconf

=head3 Windows

Not properly supported at the moment.

=head1 SUBROUTINES/METHODS

=head2 CONSTRUCTOR

=head3 C<new(%options)>

Create a new L<Config::PlConfig> object.

Options:

    host    - The host to access the configuration from.
              Can be either local (user) or global (all users).
    domain  - The configuration domain. Can be any string but a reverse DNS type string
              is preferred. i.e com.mycorpname.myapplicationname

The default host is local. There is no default domain.

=head2 INSTANCE METHODS

=head3 C<load>

Load the configuration file. Returns reference to the configuration hash.

=head3 C<save>

Save the configuration file.

=head3 C<get($configuration_key)>

Get the value of a configuration key.

=head1 DIAGNOSTICS

None.

=head1 CONFIGURATION AND ENVIRONMENT

None.

=head1 DEPENDENCIES

=head2 L<Class::Dot>

=head2 L<YAML::Syck>

=head2 L<File::HomeDir>

=head2 L<version>

=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-config-plconfig@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Ask Solem  C<< <asksh@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007, Ask Solem C<< <asksh@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
# End:
# vim: expandtab tabstop=4 shiftwidth=4 shiftround
