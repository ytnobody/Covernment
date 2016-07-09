package Covernment::Client;
use strict;
use warnings;
use HTTP::Request::Common;
use URI;
use LWP::UserAgent;
use Carp;
use Git::Wrapper;
use YAML;
use File::Temp 'tempdir';

our $AGENT = LWP::UserAgent->new(agent => __PACKAGE__, timeout => 300);
our $CONFIG;
our $GITINFO;

sub config {
    $CONFIG ||= YAML::LoadFile('.covernment.yml');
    $CONFIG;
}

sub upload_project {
    my ($class, $path) = @_;
    my $req = $class->create_request($path);
    my $res = $AGENT->request($req);
    if (!$res->is_success) {
        croak $res->status_line;
    }
    $res;
}

sub git_info {
    my ($class) = @_;
    if (!$GITINFO) {
        my $git = Git::Wrapper->new('.');
        my ($branch) = grep {/^\* /} $git->branch;
        $branch =~ s/^\* //;
        my ($head) = $git->log;
        $GITINFO = { branch => $branch, commit => $head->id };
    }
    $GITINFO;
}

sub archive_filename {
    my $class = shift;
    sprintf "%s-%s-%s.tar.gz", $class->config->{name}, $class->git_info->{branch}, $class->git_info->{commit};
}

sub agent_url {
    my $class = shift;
    $class->config->{agent_url} || 'http://127.0.0.1:9210';
}

sub create_request {
    my ($class, $path) = @_;

    my $tempdir = tempdir(CLEANUP => 1);
    my $archive = File::Spec->catfile($tempdir, $class->archive_filename);

    `tar czvf $archive ./`;

    my $git_info = $class->git_info($path);

    my $url = URI->new($class->agent_url);
    $url->path('/api/v1/upload');

    my $req = POST(
        $url->as_string, 
        Content_Type => 'form-data', 
        Content      => [ file => [$archive], name => $class->config->{name}, %$git_info ]
    );

    return $req;
}

1;
