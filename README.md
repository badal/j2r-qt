# JacintheReports
[![Code Climate](https://codeclimate.com/github/badal/jacman-qt.png)](https://codeclimate.com/github/badal/jacman-qt)

## Description
   **JacintheReports** is a utility library to produce reports from the Jacinthe-DB database.

## Version
   Jacinthe violette, version 3.1

## Dependencies
  * checked on ruby 1.9.3 (on Windows and OSX) and on ruby 2.0.0 (on Centos)
  * gem mysql2
  * gem sequel (3. or 4.)
  * gem qtbindings (for GUI)
  * gem prawn (for producing PDF)
  * gems j2r-core and j2r-jaccess
  
## Usage

### Parameters
  * Sources tables for the reporter are in 'DATA/config/sources.ini'
  * For user parameters, see the documentation (see also in j2r-core, 'j2r/recipes/user.rb')

### Installation (and each time the database structure changes)
  * To parametrize and build the DATA files (each time the database structure changes),
  run the file 'update.rb' (in the directory 'database_update')
  * The loaded files are in the DATA directory
  * See the detailed documentation

### Exploitation
  * reporter_qt.rb starts the reporter GUI
  * auditer_qt.rb starts the auditer GUI

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
  * (c) 2012-2014, Michel Demazure

## License
  *  See LICENSE (MIT)

## Author
  * Michel Demazure (with help by Kenji Lefèvre-Hasegawa)
  * mail for MD : firstname at name dot com


