0.4.0 (January 14, 2012)

* add helper methods for clearing api keys
* add constants module to preserver memory and improve GC
* add http header links parsing class utility
* add pagination iterator class for internal link traversal
* add new result set methods for retrieving pages including each_page method
* add specific request module for handling page related parameters
* extend filter_params to accept json_callback and page parameters
* change readme to new format and add pagination information among other things

0.3.9 (January 3, 2012)

* add specs for git data tags, references and commits apis
* fix bugs with parameter passing inside git data api
* comment out and remove dead code from main api
* removed duplication from specs setup

0.3.8 (January 1, 2012)

* add specs for git data blobs and trees apis
* refactored parameter filtering fuction to fix tree_create bug

0.3.7 (January 1, 2012)

* add block parameter passing for main github instance
* refactor methods inside issues labels api
* add specs to cover issues labels api

0.3.6 (December 26, 2011)

* refactor specs setup to common base class
* add specs for issues events and comments apis
* fix bug with gem loading lib folder

0.3.5 (December 18, 2011)

* adding specs for issues milestones api
* updating specs to check for constants existence
* fixing problems with some request missing passed parameters

0.3.4 (December 17, 2011)

* adding coverage reporting
* adding specs to authorization module to increase coverage to 100%
* adding specs to issues api to fix create issues bug and increase code coverage

0.3.3 (December 4, 2011)

* fixing json parsing issue preventing repository creation
