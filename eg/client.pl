#!/usr/bin/env perl
use strict;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), qw/.. lib/),
);
use Covernment::Client;
use Data::Dumper;

$Covernment::Client::CLEANUP = 1;

my $req = Covernment::Client->create_request(File::Spec->catfile(dirname(__FILE__), qw/.. cover_db/));
warn Dumper($req);
