# $Id: 2-parser.t,v 1.1 2004/12/17 15:34:09 mike Exp $

use strict;
use warnings;
use Test::More tests => 2;
BEGIN { use_ok('Net::Z3950::PQF') };

my $parser = new Net::Z3950::PQF();
ok(defined $parser, "created parser");

#my $query = '@and @attr 1=1003 kernighan @attr 1=4 unix';
#my $top = $parser->parse($query);
#ok(defined $top, "parsed query");

