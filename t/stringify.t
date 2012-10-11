#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Moose::Util::TypeConstraints 'find_type_constraint';

use MooseX::Validation::Doctypes;

doctype 'Person' => {
    id    => 'Str',
    name  => 'Str',
    title => 'Str',
};

{
    my $person = find_type_constraint('Person');
    my $errors = $person->validate({ foo => "bar" });

    is(
        "$errors",
        "invalid value undef for 'id'\n"
      . "invalid value undef for 'name'\n"
      . "invalid value undef for 'title'\n"
      . "extra data found:\n"
      . "{\n"
      . "  'foo' => 'bar'\n"
      . "}",
        "stringified properly"
    );
}

done_testing;
