use inc::Module::Install;

name 'Data-Cloud';
all_from 'lib/Data/Cloud.pm';

requires 'Carp';

build_requires 'Test::More';

tests 't/*.t';

auto_include;
auto_install;

WriteAll;
