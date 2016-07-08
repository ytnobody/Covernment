package Covernment::Worker;
use strict;
use warnings;
use Proc::Simple;
use File::Spec;
use Carp;
use Archive::Tar;
use Cwd;
use Guard;
use File::Copy;

sub work {
    my ($class, %param) = @_;
    my $job = Proc::Simple->new;
    $job->start(sub { $class->task(%param) }); 
    return $job->pid;
}

sub task {
    my ($class, %param) = @_;

    my $cwd     = getcwd;
    my $guard   = guard { chdir $cwd };

    $class->_extract(%param);
    $class->_build_html(%param);
}

sub _extract {
    my ($class, %param) = @_;

    my $root_dir   = $class->make_dir($param{workdir}, 'project');
    my $proj_dir   = $class->make_dir($root_dir, $param{name});
    my $branch_dir = $class->make_dir($proj_dir, $param{branch});
    my $commit_dir = $class->make_dir($branch_dir, $param{commit});

    my $dest = File::Spec->catfile($commit_dir, "cover_db.tar.gz");
    $param{file}->move_to($dest);

    chdir $commit_dir;

    my $archive = Archive::Tar->new;
    $archive->read($dest);
    $archive->extract;

    unlink $dest;
}

sub _build_html {
    my ($class, %param) = @_;
    `cover -report html`;
}


sub make_dir {
    my ($class, $parent, $dest) = @_;
    my $dest_dir = File::Spec->catdir($parent, $dest);
    if (! -d $dest_dir) {
        mkdir $dest_dir or croak "Could not create $dest_dir : $!";
    }
    $dest_dir;
}

1;
