package MT::Plugin::DataAPICanonicalJSON;
use strict;
use warnings;
use utf8;

use base qw( MT::Plugin );

my $plugin = __PACKAGE__->new(
    {   name        => 'DataAPICanonicalJSON',
        version     => 0.01,
        author_name => 'Masahiro Iuchi',
        author_link => 'https://github.com/masiuchi',
        plugin_link =>
            'https://github.com/masiuchi/mt-plugin-data-api-canonical-json',
        description =>
            '<__trans phrase="The same object should always be stringified to the exact same string.">',

        registry => {
            l10n_lexicon => {
                ja => {
                    'The same object should always be stringified to the exact same string.'
                        => 'Data API の出力する JSON のキーをソートして、出力を一意にします。',
                },
            },
        },
    }
);
MT->add_plugin($plugin);

{
    require MT::DataAPI::Format::JSON;
    my $serialize = \&MT::DataAPI::Format::JSON::serialize;

    require MT::Util;
    my $to_json = \&MT::Util::to_json;

    no warnings 'redefine';
    *MT::DataAPI::Format::JSON::serialize = sub {
        local *MT::Util::to_json = sub {
            my ( $value, $args ) = @_;
            $args->{canonical} = 1;
            $to_json->( $value, $args );
        };
        $serialize->(@_);
    };
}

1;
