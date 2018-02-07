package Test::Mojo::Role::Debug::JSON;

use Mojo::Base -role;

with 'Test::Mojo::Role::Debug';

use Carp qw/croak/;

use Mojo::JSON qw{from_json};
use Test::More ();

# VERSION

sub djson {
    my ( $self ) = @_;
    return $self->success ? $self : $self->djsona;
}

sub djsona {
    my ( $self ) = @_;

    local $@;
    my $json = eval { from_json( $self->tx->res->content->asset->slurp ) };

    Test::More::diag( $@ ) if $@;
    Test::More::diag( "DEBUG JSON DUMPER:\n", Test::More::explain(  $json ) ) if ref $json;

    return $self;
}

1;

__END__

=encoding utf8

=head1 NAME

Test::Mojo::Role::Debug::JSON - Test::Mojo role to make debugging test failures easier

This is an extension of Test::Mojo::Role::Debug

=head1 SYNOPSIS

=for pod_spiffy start code section

    use Test::More;
    
    use Test::Mojo::WithRoles 'Debug::JSON';
    
    my $t = Test::Mojo::WithRoles->new('MyApp');

    $t->get_ok('/')->status_is(200)
        ->element_exists('existant')
        ->djson     # Does nothing, since test succeeded
        ->element_exists('non_existant')
        ->djson     # Dump the main content as json
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
