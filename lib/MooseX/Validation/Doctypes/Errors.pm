package MooseX::Validation::Doctypes::Errors;
use Moose;

has errors => (
    is        => 'ro',
    predicate => 'has_errors',
);

has extra_data => (
    is        => 'ro',
    predicate => 'has_extra_data',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;
