# vim: ai et sw=4
use strict;
use warnings;
use 5.010;
package Mojolicious::Plugin::YamlConfig;

use base 'Mojolicious::Plugin::JsonConfig';

our $VERSION = '0.1.0';

sub register {
    my ( $self, $app, $conf ) = @_;
    $conf ||= {};
    $conf->{ext} = 'yaml';
    $conf->{class} ||= $ENV{MOJO_YAML} || 'YAML::Tiny';
    $self->{class} = $conf->{class};
    unless ( $conf->{class} ~~ [qw(YAML YAML::XS YAML::Tiny YAML::Old)]) {
        warn("$conf->{class} is not supported, use at your own risk");
    }
    return $self->SUPER::register( $app, $conf );
}

sub parse {
    my ($self, $content, $file, $conf, $app) = @_;
    local $@;

    my $class = $self->{class};
    eval "require $class; 1" || die($@);

    my ($config,$error);

    # Render
    $content = $self->render($content, $file, $conf, $app);

    if ($class ~~ [qw(YAML YAML::Old)]) {
        # they are broken *sigh*
        $content = Encode::decode('UTF-8', $content);
    }

    $config = eval $class.'::Load($content)';
    if($@) {
        $error = $@;
    }

    die qq/Couldn't parse config "$file": $error/ if !$config && $error;
    die qq/Invalid config "$file"./ if !$config || ref $config ne 'HASH';

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
YAML spec. Currently you can use L<YAML::XS>, L<YAML::Old> and L<YAML> via the
C<class> option to parse the data with a more advanced YAML parser.

=head2 AUTHOR

Danijel Tasov <data@cpan.org>

=head2 SEE ALSO

L<Mojolicious>, L<Mojolicous::Plugin::JsonConfig>, L<Mojolicious::Guides>

