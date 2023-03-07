#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
use JSON::XS;
use URI::Escape;

my $url = shift // exit;

my ($clean_url, $board) = $url =~ m{^(.*?4chan(?:nel)?\.org/(\w+)/thread/\d+)};

my @files = decode_json(qx{curl -sL "$clean_url.json" })->{posts}->@*;
@files = grep { $_->{filename} && $_->{filename} =~ /sound/ } @files;

my $count = 1;
my $total = @files;

for my $file (@files) {

    my $video_url = "https://i.4cdn.org/$board/$file->{tim}$file->{ext}";
    my $audio_url = uri_unescape $file->{filename} =~ /\[sound= (.*?) \]/x;

    system "clear";
    say "Playing $count of $total";
    say $video_url;
    say $audio_url;
    system qq{mpv --force-window --really-quiet "--audio-file=$audio_url" "$video_url" };
    $count++;
}