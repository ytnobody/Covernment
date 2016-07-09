requires 'perl', '5.008001';
requires 'Git::Wrapper';
requires 'Archive::Tar';
requires 'LWP::UserAgent';
requires 'Carp';
requires 'File::Spec';
requires 'File::Basename';
requires 'URI';
requires 'HTTP::Request::Common';
requires 'YAML';
requires 'Mojolicious::Lite';
requires 'Proc::Simple';
requires 'Guard';
requires 'Time::Piece';
requires 'Devel::Cover::Report::Html';
requires 'File::Temp';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

