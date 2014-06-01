 # NAME
    Mojolicious::Plugin::YamlConfig - YAML Configuration Plugin

 # SYNOPSIS
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

 # DESCRIPTION
    Look at Mojolicious::Plugin::JSONConfig and replace "JSONConfig" with
    "yaml_config" and you should be fine. :)

 # LIMITATIONS
    YAML::Tiny is the default parser. It doesn't even try to implement the
    full YAML spec. Currently you can use YAML::XS, YAML::Old and YAML via
    the "class" option to parse the data with a more advanced YAML parser.

 # AUTHOR
    Danijel Tasov <data@cpan.org>

 # SEE ALSO
[Mojolicious](https://metacpan.org/pod/Mojolicious)

[Mojolicious::Plugin::JSONConfig](https://metacpan.org/pod/Mojolicious::Plugin::JSONConfig)

[Mojolicious::Guides](https://metacpan.org/pod/Mojolicious::Guides)

