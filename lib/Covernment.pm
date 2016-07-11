package Covernment;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";



1;
__END__

=encoding utf-8

=head1 NAME

Covernment - Devel::Cover::Reporter::Html as a Service

=head1 SYNOPSIS

Run a server.

    $ plackup ./app.psgi -p 9210

Then, Run covernment client under your git repository.

    $ curl -L https://is.gd/covernment > covernment
    $ bash ./covernment MyProjectName http://yourhostname:9210

=head1 DESCRIPTION

Covernment is a Service of Devel::Cover::Reporter::Html.

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

