package MooseX::Validation::Doctypes::Errors;
use Moose;
# ABSTRACT: error class for MooseX::Validation::Doctypes

=head1 SYNOPSIS

  use MooseX::Validation::Doctypes;

  doctype 'Location' => {
      id      => 'Str',
      city    => 'Str',
      state   => 'Str',
      country => 'Str',
      zipcode => 'Int',
  };

  doctype 'Person' => {
      id    => 'Str',
      name  => {
          # ... nested data structures
          first_name => 'Str',
          last_name  => 'Str',
      },
      title   => 'Str',
      # ... complex Moose types
      friends => 'ArrayRef[Person]',
      # ... using doctypes same as regular types
      address => 'Maybe[Location]',
  };

  use JSON;

  # note the lack of Location,
  # which is fine because it
  # was Maybe[Location]

  my $data = decode_json(q[
      {
          "id": "1234-A",
          "name": {
              "first_name" : "Bob",
              "last_name"  : "Smith",
           },
          "title": "CIO",
          "friends" : [],
      }
  ]);

  use Moose::Util::TypeConstraints;

  my $person = find_type_constraint('Person');
  my $errors = $person->validate($data);

  use Data::Dumper;

  warn Dumper($errors->errors)     if $errors->has_errors;
  warn Dumper($errors->extra_data) if $errors->has_extra_data;

=head1 DESCRIPTION

This class holds the errors that were found when validating a doctype. There
are two types of errors: either an existing piece of data didn't validate
against the given type constraint, or extra data was provided that wasn't
listed in the doctype. These two types correspond to the C<errors> and
C<extra_data> attributes described below.

=cut

=attr errors

Returns the errors that were detected. The return value will be a data
structure with the same form as the doctype, except only leaves corresponding
to values that failed to match their corresponding type constraint. The values
will be an appropriate error message.

=method has_errors

Returns true if any errors were found when validating the data against the type
constraints.

=cut

has errors => (
    is        => 'ro',
    predicate => 'has_errors',
);

=attr extra_data

Returns the extra data that was detected. The return value will be a data
structure with the same form as the incoming data, except only containing
leaves for data which was not represented in the doctype. The values will be
the values from the actual data being validated.

=method has_extra_data

Returns true if any extra data was found when comparing the data to the
doctype.

=cut

has extra_data => (
    is        => 'ro',
    predicate => 'has_extra_data',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;
