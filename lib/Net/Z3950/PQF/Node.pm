# $Id: Node.pm,v 1.1 2004/12/17 15:29:00 mike Exp $

package Net::Z3950::PQF::Node;

use strict;
use warnings;


=head1 NAME

Net::Z3950::PQF::Node - Abstract class for nodes in a PQF parse tree

=head1 SYNOPSIS

 $node = new Net::Z3950::PQF::Term('unix');
 $node->isa("Net::Z3950::PQF::Node") or die "oops";

=head1 DESCRIPTION

This module implements the types for the nodes that make up a PQF
parse tree.  Each such concrete type is a subclass of the abstract
base class
C<Net::Z3950::Node>,
and has a type whose name is of the form
C<Net::Z3950::PQF::>I<somethingNode>.

The following node types are defined:

=over 4

=item C<TermNode>

Represents an actual query term such as
C<brian>,
C<"brian">
or
C<"Brian W. Kernighan">.

The term is accompanied by zero or more 
I<attributes>,
each of which is a triple represented by a reference to a
three-element array.  Each such array consists of an 
I<attribute set identifier>
which may be either an OID or a short descriptive string,
an integer
I<type>,
and a
I<value>
which may be either an integer or a string.

=item C<AndNode>

Represents an AND node with two sub-nodes.

=item C<OrNode>

Represents an OR node with two sub-nodes.

=item C<NotNode>

Represents a NOT node with two sub-nodes.  In the Z39.50 Type-1 query,
and hence in PQF, NOT is a binary AND-NOT operator rather than than a
unary negation operator.

=item C<ProxNode>

Represents a proximity node with two subnodes and five parameters:

I<exclusion>:
a boolean indicating whether the condition indicated by the other
parameters should be inverted.

I<distance>:
an integer indicating the number of units that may separate the
fragments identified by the subnodes.

I<ordered>:
a boolean indicating whether the elements indicated by the subnodes
are constrained to be in the same order as the subnodes themselves.

I<relation>:
indicates the relation required on the specified distance in order
for the condition to be satisfied.

I<unit>:
a short string indicating the units of proximity (C<word>,
C<sentence>, etc.)

=back

Except where noted, the methods described below are defined for all of
the concrete node types.


=head1 METHODS

=head2 new()

 $term1 = new Net::Z3950::PQF::TermNode('brian', [ "bib-1", 1, 1003 ]);
 $term2 = new Net::Z3950::PQF::TermNode('unix', [ "bib-1", 1, 4 ]);
 $and = new Net::Z3950::PQF::AndNode($term1, $term2);

Creates a new node object of the appropriate type.  It is not possible
to instantiate the abstract node type, C<Net::Z3950::PQF::Node>, only its
concrete subclasses.

The parameters required are different for different node types:

=over 4

=item C<TermNode>

The first parameter is the actual term, and the remainder are
attributes, each represented by a triple of
[ I<attribute-set>, I<type>, I<value> ].

=item C<AndNode>, C<OrNode>, C<NotNode>

The two parameters are nodes representing the subtrees.

=item C<ProxNode>

The seven parameters are, in order: the two nodes representing the
subtrees, and the five parameters exclusion, distance, ordered,
relation and unit.

=back

=cut

sub new {
    my $class = shift();
    die "can't create an abstract $class";
}


=head2 render()

 $node->render(0);

Renders the contents of the tree rooted at the specified node,
indented to a level indicated by the parameter.  This output is in a
human-readable form that is useful for debugging but probably not much
else.

=cut

sub render {
    my $class = shift();
    die "can't render an abstract $class";
}



package Net::Z3950::PQF::TermNode;

sub new {
    my $class = shift();
    my($term, @attrs) = @_;

    return bless {
	term => $term,
	attrs => [ @attrs ],
    }, $class;
}

sub render {
    my $this = shift();
    my($level) = @_;

    die "render() called with no level" if !defined $level;
    my $text = ("\t" x $level) . "term: " . $this->{term} . "\n";
    foreach my $attr (@{ $this->{attrs} }) {
	my($set, $type, $val) = @$attr;
	$text .= ("\t" x ($level+1)) . "attr: $set $type=$val\n";
    }

    return $text;
}



# PRIVATE class, used as base by AndNode, OrNode and NotNode
package Net::Z3950::PQF::BooleanNode;

sub new {
    my $class = shift();
    my(@sub) = @_;

    return bless {
	sub => [ @sub ],
    }, $class;
}

sub render {
    my $this = shift();
    my($level) = @_;

    die "render() called with no level" if !defined $level;
    my $text = ("\t" x $level) . $this->_op() . "\n";
    foreach my $sub (@{ $this->{sub} }) {
	$text .= $sub->render($level+1);
    }

    return $text;
}



package Net::Z3950::PQF::AndNode;
use vars qw(@ISA);
@ISA = qw(Net::Z3950::PQF::BooleanNode);

sub _op { "and" }



package Net::Z3950::PQF::OrNode;
use vars qw(@ISA);
@ISA = qw(Net::Z3950::PQF::BooleanNode);

sub _op { "or" }



package Net::Z3950::PQF::NotNode;
use vars qw(@ISA);
@ISA = qw(Net::Z3950::PQF::BooleanNode);

sub _op { "not" }



package Net::Z3950::PQF::ProxNode;

sub new {
    my $class = shift();
    die "### class $class not yet implemented";
}

sub render {
    my $this = shift();
    die "you shouldn't have been able to make $this";
}




=head1 PROVENANCE

This module is part of the Net::Z3950::PQF distribution.  The
copyright, authorship and licence are all as for the distribution.

=cut


1;
