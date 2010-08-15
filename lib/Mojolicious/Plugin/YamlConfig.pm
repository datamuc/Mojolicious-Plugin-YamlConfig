# vim: ai et sw=4
# ABSTRACT: YAML Configuration Plugin for Mojolicious
use strict;
use warnings;
package Mojolicious::Plugin::YamlConfig;

use YAML::Any();
use base 'Mojolicious::Plugin::JsonConfig';

our $VERSION = '0.0.2';

sub register {
   my ($self, $app, $conf) = @_;
   $conf ||= {};
   $conf->{ext} ||= 'yaml';
   return $self->SUPER::register($app, $conf);
}

sub _parse_config {
    my ($self, $encoded, $name) = @_;
    local $@;

    # Parse
    my ($config,$error);
    eval {
        $config = YAML::Any::Load($encoded);
    }; if($@) {
        $error = $@;
    }

    die qq/Couldn't parse config "$name": $error/ if !$config && $error;
    die qq/Invalid config "$name"./ if !$config || ref $config ne 'HASH';

    return $config;
}

1;

__END__

=head1 NAME

Mojolicious::Plugin::YamlConfig - YAML Configuration Plugin

=head1 SYNOPSIS

    # myapp.yaml
    --
    foo: "bar"
    music_dir: "<%= app->home->rel_dir('music') %>"

    # Mojolicious
    $self->plugin('yaml_config');

    # Mojolicious::Lite
    plugin 'yaml_config';

    # Reads myapp.yaml by default and puts the parsed version into the stash
    my $config = $self->stash('config');

    # Everything can be customized with options
    my $config = plugin yaml_config => {
        file      => '/etc/myapp.conf',
        stash_key => 'conf'
    };

=head2 DESCRIPTION

Look at L<Mojolicious::Plugin::JsonConfig> and replace "json" with "yaml"
and you should be fine. :)

=head2 AUTHOR

Danijel Tasov <data@cpan.org>

=head2 SEE ALSO

L<Mojolicious>, L<Mojolicous::Plugin::JsonConfig>, L<Mojolicious::Guides>

