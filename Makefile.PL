# $Id: Makefile.PL,v 1.2 2004/12/17 12:58:35 mike Exp $

use 5.006;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Net::Z3950::PQF',
    'VERSION_FROM'	=> 'PQF.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (AUTHOR     => 'Mike Taylor <mike@indexdata.com>') : ()),
);
