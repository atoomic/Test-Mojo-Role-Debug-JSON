package Test::Mojo::Role::Debug;

use Mojo::Base -base;
use Role::Tiny;
use Carp qw/croak/;
use Test::More ();

# VERSION

sub d {
    my ( $self, $selector ) = @_;
    return $self->success ? $self : $self->da( $selector );
}

sub da {
    my ( $self, $selector ) = @_;
    my $markup = length($selector//'')
        ? $self->tx->res->dom->at($selector)
        : $self->tx->res->dom;

    unless ( defined $markup and length $markup ) {
        Test::More::diag "\nDEBUG DUMPER: the selector ($selector) you provided "
            . "did not match any elements\n\n";
        return $self;
    }

    Test::More::diag "\nDEBUG DUMPER:\n$markup\n\n";

    $self;
}

q|
The optimist says: "The glass is half full"
The pessimist says: "The glass is half empty"
The programmer says: "The glass is twice as large necessary"
|;

__END__

=encoding utf8

=for stopwords Znet Zoffix app DOM

=head1 NAME

Test::Mojo::Role::Debug - Test::Mojo role to make debugging test failures easier

=head1 SYNOPSIS

=for pod_spiffy start code section

    use Test::More;
    use Test::Mojo::WithRoles 'Debug';
    my $t = Test::Mojo::WithRoles->new('MyApp');

    $t->get_ok('/')->status_is(200)
        ->element_exists('existant')
        ->d         # Does nothing, since test succeeded
        ->element_exists('non_existant')
        ->d         # Dump entire DOM on fail
        ->d('#foo') # Dump a specific element on fail
        ->da        # Always dump
    ;

    done_testing;

=for pod_spiffy end code section

=head1 DESCRIPTION

When you chain up a bunch of tests and they fail, you really want an easy
way to dump up your markup at a specific point in that chain and see
what's what. This module comes to the rescue.

=head1 METHODS

You have all the methods provided by L<Test::Mojo>, plus these:

=head2 C<d>

    $t->d;         # print entire DOM on failure
    $t->d('#foo'); # print a specific element on failure

B<Returns> its invocant.
On failure of previous tests (see L<Mojo::DOM/"success">),
dumps the DOM of the current page to the screen. B<Takes> an optional
selector to be passed to L<Mojo::DOM/"at">, in which case, only
the markup of that element will be dumped.

=head2 C<da>

    $t->da;
    $t->da('#foo');

Same as L</d>, except it always dumps, regardless of whether the previous
test failed or not.

=head1 SEE ALSO

L<Test::Mojo> (L<Test::Mojo/"or"> in particular), L<Mojo::DOM>

=for pod_spiffy hr

=head1 REPOSITORY

=for pod_spiffy start github section

Fork this module on GitHub:
L<https://github.com/zoffixznet/Test-Mojo-Role-Debug>

=for pod_spiffy end github section

=head1 BUGS

=for pod_spiffy start bugs section

To report bugs or request features, please use
L<https://github.com/zoffixznet/Test-Mojo-Role-Debug/issues>

If you can't access GitHub, you can email your request
to C<bug-test-mojo-role-debug at rt.cpan.org>

=for pod_spiffy end bugs section

=head1 AUTHOR

=for pod_spiffy start author section

=for pod_spiffy author ZOFFIX

=for pod_spiffy end author section

=head1 CONTRIBUTORS

=for pod_spiffy start contributors section

=for pod_spiffy author JBERGER

=for pod_spiffy end contributors section

=head1 LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the C<LICENSE> file included in this distribution for complete
details.

=cut
