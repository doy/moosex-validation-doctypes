package MooseX::Validation::Doctypes;
use strict;
use warnings;
# ABSTRACT: validation of nested data structures with Moose type constraints

use MooseX::Meta::TypeConstraint::Doctype;

use Sub::Exporter -setup => {
    exports => ['doctype'],
    groups => {
        default => ['doctype'],
    },
};

=head1 SYNOPSIS

  use MooseX::Validation::Doctypes;

  doctype 'Person' => {
      id    => 'Str',
      name  => 'Str',
      title => 'Str',
  };

  use JSON;

  my $data = decode_json('{"id": "1234-A", "name": "Bob", "title": "CIO"}');

  use Moose::Util::TypeConstraints;

  my $person = find_type_constraint('Person');
  my $errors = $person->validate($data);

  use Data::Dumper;

  warn Dumper($errors->errors)     if $errors->has_errors;
  warn Dumper($errors->extra_data) if $errors->has_extra_data;

=head1 DESCRIPTION

This module allows you to declare L<Moose> type constraints to validate nested
data structures as you may get back from a JSON web service or something along
those lines. The doctype declaration can be any arbitrarily nested structure of
hashrefs and arrayrefs, and will be used to validate a data structure which has
that same form. The leaf values in the doctype should be Moose type
constraints, which will be used to validate the leaf nodes in the given data
structure.

=cut

=func doctype $name, $doctype

Declares a new doctype type constraint. C<$name> is optional, and if it is not
given, an anonymous type constraint is created instead.

=cut

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

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-moosex-validation-doctypes at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Validation-Doctypes>.

=head1 SEE ALSO

L<Moose::Meta::TypeConstraint>

L<MooseX::Types::Structured>

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc MooseX::Validation::Doctypes

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Validation-Doctypes>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Validation-Doctypes>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Validation-Doctypes>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Validation-Doctypes>

=back

=cut

1;
