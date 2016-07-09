package Covernment::Server;
use strict;
use warnings;
use Mojolicious::Lite;
use Plack::Builder;
use Covernment::Worker;
use Git::Wrapper;
use Time::Piece;

our $WORKDIR = $ENV{COVERNMENT_WORKDIR} || '/tmp/covernment';

if (! -d $WORKDIR) {
    mkdir $WORKDIR or die "Could not create directory $WORKDIR : $!";
}

### redirect to dashboard
get '/' => sub {
    my $c = shift;
    $c->redirect_to('/dashboard/');
};

### entrypoint for covernment client
post '/api/v1/upload' => sub {
    my $c = shift;
    my $file   = $c->req->upload('file');
    my $name   = $c->param('name');
    my $branch = $c->param('branch');
    my $commit = $c->param('commit');

    my $err = !$file   ? 'a cover_db file compressed with tar.gz format is required' :
              !$name   ? 'name is required' :
              !$branch ? 'branch is required' :
              !$commit ? 'commit is required' :
              undef
    ;

    if ($err) {
        $c->render(json => {status => 400, message => $err});
    }
    else {
        my $qid = Covernment::Worker->work(
            workdir => $WORKDIR, 
            file    => $file, 
            name    => $name, 
            branch  => $branch, 
            commit  => $commit,
        );
        $c->render(json => {qid => $qid});
    }
};

### project list
get '/api/v1/projects' => sub {
    my $c = shift;
    my @projects = map {s|^$WORKDIR/project/||r} glob "$WORKDIR/project/*";
    $c->render(json => {projects => [@projects]});
};

### branch list
get '/api/v1/project/:project/branches' => sub {
    my $c = shift;
    my $project = $c->stash('project');
    my @branches = map {s|^$WORKDIR/project/$project/||r} glob "$WORKDIR/project/$project/*"; 
    $c->render(json => {branches => [@branches]});
};

### commit list
get '/api/v1/project/:project/:branch/commits' => sub {
    my $c = shift;
    my $project = $c->stash('project');
    my $branch  = $c->stash('branch');
    my @commits = 
        map {s|^$WORKDIR/project/$project/$branch/*||r} 
        sort {
            my ($rev_a) = Git::Wrapper->new($a)->log;
            my ($rev_b) = Git::Wrapper->new($b)->log;
            my $sec_a = Time::Piece->strptime($rev_a->date, "%a %b %e %H:%M:%S %Y %z")->strftime('%s');
            my $sec_b = Time::Piece->strptime($rev_b->date, "%a %b %e %H:%M:%S %Y %z")->strftime('%s');
            0+ $sec_b <=> 0+ $sec_a;
        } 
        glob "$WORKDIR/project/$project/$branch/*"
    ; 
    $c->render(json => {commits => [@commits]});
};

### application
sub go {
    my $class = shift;
    builder {
        enable "Static", path => qr{^/project/.+?/.+?/.+?/cover_db/}, root => $WORKDIR;
        enable "Static", path => qr{^/dashboard/}, root => 'htdocs';
        app->start;
    };
}

1;
