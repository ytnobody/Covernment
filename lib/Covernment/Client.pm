package Covernment::Client;
use strict;
use warnings;
use Archive::Tar;
use HTTP::Request::Common;
use URI;
use LWP::UserAgent;
use Carp;

our $AGENT_URL        = $ENV{'COVERNMENT_URL'} || 'http://127.0.0.1:9210';
our $ARCHIVE_FILENAME = 'cover_db.tar.gz';
our $CLEANUP          = 0;

our $AGENT = LWP::UserAgent->new(agent => __PACKAGE__, timeout => 300);

sub upload_cover_db {
    my ($class, $path) = @_;
    my $req = $class->create_request($path);
    my $res = $AGENT->req($req);
    if (!$res->is_success) {
        croak $res->status_line;
    }
    $res;
}

sub create_request {
    my ($class, $path) = @_;
    Archive::Tar->create_archive($ARCHIVE_FILENAME, COMPRESS_GZIP, $path);

    my $url = URI->new($AGENT_URL);
    $url->path('/api/v1/upload');
    my $req = POST $url->as_string, Content_Type => 'form-data', Content => [file => [$ARCHIVE_FILENAME]];
    unlink $ARCHIVE_FILENAME if $CLEANUP;
    return $req;
}

1;
