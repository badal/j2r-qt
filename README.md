# JacintheReports
[![Code Climate](https://codeclimate.com/github/badal/jacman-qt.png)](https://codeclimate.com/github/badal/jacman-qt)

## Description
   **JacintheReports** is a utility library to produce reports from the Jacinthe-DB database.

## Version
   Jacinthe rouge, v2.3

## Dependencies
  * checked on ruby 1.9.3 (on Windows and OSX) and on ruby 2.0.0 (on Centos)
  * gem mysql2
  * gem sequel (3. or 4.)
  * gem qtbindings (for GUI)
  * gem prawn (for producing PDF)

## System
  * OS identification in 'j2r.rb'
  * Works in Windows and OSX : specific tests win? and darwin?
  * For other systems, add in 'j2r.rb' the necessary test
  and complete the methods where the tests are used.

## Usage

### Parameters
  * Default DATA directories are in 'j2r/files_and_directories.rb'
  * Connection parameters are in the file 'DATA/config/connect.ini'
  * Extended fields and joins building parameters are in 'DATA/config/joins.ini'
  * Sources tables for the reporter are in 'DATA/config/sources.ini'
  * For user parameters, see the documentation (see also 'j2r/recipes.user.rb'

### Installation (and each time the database structure changes)
  * To parametrize and build the DATA files (each time the database structure changes),
  run the file 'update.rb' (in the directory 'database_update')
  * The loaded files are in the DATA directory
  * See the detailed documentation

### Exploitation
  * reporter.rb starts the reporter GUI
  * auditer.rb starts the auditer GUI
  * batch\_reporter.rb and tableau\_de\_bord.rb are batch utilities

## More documentation
  * Specific "Mode d'emploi" for users
  * Specific "Documentation Technique" for developers
  * Full Yardoc documentation

## Bugs and warnings
  * If using a 64bits Mysql client, you may have compile the mysql gems with a special connector (see the web)

## Source and issues
   [![Code Climate](https://codeclimate.com/github/badal/j2r-qt.png)](https://codeclimate.com/github/badal/jacman-qt)

   * Source code on repository [GitHub](https://github.com/badal/j2r-qt)
   * [Issue Tracker](https://bitbucket.org/mdemazure/j2r/issues?status=new&status=openissues/new)

## Copyright
  * (c) 2012-2013, Michel Demazure

## License
  *  See LICENSE (MIT)

## Author
  * Michel Demazure (with help by Kenji Lefèvre-Hasegawa)
  * mail for MD : firstname at name dot com


