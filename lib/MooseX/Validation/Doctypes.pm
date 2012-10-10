package MooseX::Validation::Doctypes;
use strict;
use warnings;

use MooseX::Meta::TypeConstraint::Doctype;

use Sub::Exporter -setup => {
    exports => ['doctype'],
    groups => {
        default => ['doctype'],
    },
};

sub doctype {
    my $name;
    $name = shift if @_ > 1;

    my ($doctype) = @_;

    # XXX validate name

    my $args = {
        ($name ? (name => $name) : ()),
        doctype            => $doctype,
        package_defined_in => scalar(caller),
    };

    my $tc = MooseX::Meta::TypeConstraint::Doctype->new($args);
    Moose::Util::TypeConstraints::register_type_constraint($tc)
        if $name;

    return $tc;
}

1;
