Usage
=====

Running :code:`autofonce`
-------------------------

Before running tests, you will need to create a file :code:`autofonce.env`
in your project (if it does not exist yet).

This file is used by :code:`autofonce` for two purposes:

* It is used to set the environment variables to run each test. You can
  typically use parts of :code:`atconfig` and :code:`atlocal` from
  your project (as these files are used by GNU Autoconf to run the tests).

* It is use as an anchor, to create in the
  same directory the directory :code:`_autotest`, where :code:`autofonce`
  will run the tests. This allows :code:`autofonce` to be called from
  any sub-directory of that directory and still run the tests in the
  same directory.

To create this file, you can use the following command::

  $ autofonce init

Using this command makes :code:`autofonce` try to autodetect the
project, in which case it can generate a good example. This will only
work for *known* projects, currently only :code:`gnucobol`. For
autodetection to work, the name of a directory in the path should
match the name of the known project.

Once this file has been generated, you should check its content to
verify that it matches your own setting. It typically contains
configuration options, such as the sub-directory were the binaries
have been built, and options detected by :code:`./configure`, that you
should update.

Once you have a working :code:`autofonce.env`, you can try to read the
testsuite using::

  $ autofonce list

This command should display the list of tests it was able to read, or
errors if it could not read the testsuite.

Typically, :code:`autofonce` tries to locate
:code:`tests/testsuite.at` in the upper directories. You can change
this default using for example::

  $ autofonce list --testsuite test/mytests.at

Once you are able to read the testsuite, you can run the tests with::

  $ autofonce run

If a failure appends, you can check the directory
:code:`_autotest/NNNN/` where :code:`NNNN` is the test numeric
identifier.

For skipped test, you can check the file :code:`_autotest/results.log`.

Unless you use the arguments :code:`--keep-more` or :code:`--keep-all`,
test sub-directories are not kept if the tests are skipped, or if they
succeed.

Within a test sub-directory, you should find:

* :code:`env_autofonce.sh`: the script used to initialize the environment
  for the test. It contains the content of the file :code:`autofonce.env`.
  If you want to call commands in this directory with the same env as the
  tests, you should use::

    . ./env_autofonce.sh

* :code:`00_CHECK.sh`: the shell script to run the first check of the test
* :code:`00_CHECK.out`: the stdout output of the test
* :code:`00_CHECK.err`: the stderr output of the test
* :code:`00_CHECK.???.expected`: if the comparison between the outputs
  failed, this file contains what was expected by the test
* :code:`CHECK` files are numbered, with nested numbering for nested checks
* other files are either files created by :code:`AT_DATA` macros, or files
  generated by checks

