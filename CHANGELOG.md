0.4.6 (February 27, 2012)

* Update gem dependencies, specifically core libraries: multi_json, oauth2, faraday and testing: webmock. (Cannot udpate guard as it conflicts with Growl notifications.)
* Fix test dependency for github_spec and users_spec test suites.
* Add specs for user followers api.
* Add better support for isolation of test dependency by resetting request mocks and github instance variables.
* Remove jeweler dependency from gemspec and rakefile. Clean up rakefile.

0.4.5 (February 25, 2012)

* add specs for the main pull requests api
* add specs for the pull reqeust review comments api
* change method signatures inside pull request api to be more concise
* add new generic error class
* add GitHub service specific error types
* change response raising error to use new error types and increased encapsulation of http header information
* fix breakage across api classes and test suite

0.4.4 (February 9, 2012)

* factor out request validation into its own module
* factor out request filtering inside its own module
* add factory for creating main api submodules
* add specs for gists comments api
* expand filtering to allow for toggling recursive behaviour

0.4.3 (February 4, 2012)

* add api extension allowing to list a given api actions(methods)
* add api methods deprecation module
* add specs for gists and modify unstar method signature
* change gists starred? method to return boolean
* add gists, error codes feature tests
* change api client setting to work on per api class initialization to scope variables such as per_page per api instance, added specs
* fix issue with pagination helper for iterating over response set
* change test coverage reporting to split results for rspec and cucumber

0.4.2 (January 22, 2012)

* fix pagination iterator to work with 'commits' method for Github::Repos api
* fix bug with pagination returned collection set
* add cukes to test pagination
* extend response set with new helper methods such as etag, server
* fix bug with pagination params for 'watched' method for Github::Repos api

0.4.1 (January 18, 2012)

* fix bug with default settings for paginated items in result set
* added api rest methods listing
* updated specs for main api

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
