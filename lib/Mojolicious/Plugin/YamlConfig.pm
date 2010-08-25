# vim: ai et sw=4
use strict;
use warnings;
package Mojolicious::Plugin::YamlConfig;

use base 'Mojolicious::Plugin::JsonConfig';

our $VERSION = '0.0.4';

sub register {
   my ($self, $app, $conf) = @_;
   $conf ||= {};
   $conf->{ext} = 'yaml';
   $conf->{class} ||= 'YAML::Tiny';
   $self->{class} = $conf->{class};
   return $self->SUPER::register($app, $conf);
}

sub _parse_config {
    my ($self, $encoded, $name) = @_;
    local $@;

    my $class = $self->{class};
    eval "require $class; 1" || die($@);

    # Parse
    my ($config,$error);

    $config = eval $class.'::Load($encoded)';
    if($@) {
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
    plugin yaml_config => {
        file      => '/etc/myapp.conf',
        stash_key => 'conf',
        class     => 'YAML::XS'
    };

=head2 DESCRIPTION

Look at L<Mojolicious::Plugin::JsonConfig> and replace "json" with "yaml"
and you should be fine. :)

=head2 LIMITATIONS

L<YAML::Tiny> is the default parser. It doesn't even try to implement the full
YAML spec. Currently you can use YAML::XS via the C<class> option to parse the
data with L<YAML::XS> (It's currently the only supported alternative. Use
L<YAML>, L<YAML::Any>, L<YAML::Old> or L<YAML::Syck> at your own risk).

=head2 AUTHOR

Danijel Tasov <data@cpan.org>

=head2 SEE ALSO

L<Mojolicious>, L<Mojolicous::Plugin::JsonConfig>, L<Mojolicious::Guides>

