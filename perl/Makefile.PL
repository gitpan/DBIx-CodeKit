
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME		=> 'DBIx::CodeKit',
    VERSION_FROM	=> 'CodeKit.pm',
    PREREQ_PM		=> { DBI => 0 },
    ABSTRACT_FROM       => 'CodeKit.pm',
    AUTHOR              => 'John Gorman <jgorman@webbysoft.com>',
    PM                  => { 'CodeKit.pm' => '$(INST_LIBDIR)/CodeKit.pm' }
);
