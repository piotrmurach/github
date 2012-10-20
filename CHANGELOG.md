0.7.1 (October 20, 2012)

* Add delete call to repositories api.
* Allow for type, sort & direction parameters when listing repositories.
* Change unit tests for repositories.
* Add code metrics tasks.
* Add assertion for checking non-empty request arguments.
* Change all requests to use new presence assertion.

0.7.0 (September 9, 2012)

* Fix multi json compatibility issues.
* Move assigness api inside the issues scope.
* Add Statuses Api.
* Add Starring Api.
* Change Watching api(old Watching available as Starring Api), rename
  'start_watching' to 'watch' and 'stop_watching' to 'unwatch'.
* Add Repository Merging Api.

0.6.5 (August 17, 2012)

* Add ability to list class subclasses.
* Change http error handling to allow for easy extensions of error classes.
* Add assignee api with tests.
* Add emojis api with tests.

0.6.4 (July 28, 2012)

* Fix bug Issue#41 - content stays encoded in base64 and
  caching Contents api call to correct instance.
* Fix bug Issue#46  - remove user parameters merging.
* Add response body parsing and http status code setup to ServiceError.
* Change all service errors to include http status code and
  to inherit from service error class.
* Update readme with error handling explanation.
* Add ratelimit requests.

0.6.3 (July 17, 2012)

* Add ability to modify default middleware stack or create custome one.
* Refactored and simplified main api initialization process.
* Fixed issues #39 with json encoding request bodies.

0.6.2 (July 15, 2012)

* Drop yajl from development dependencies to allow jruby pass.
* Add repository single branch retrieval.
* Add markdown api support.
* Rewrite connection to set proper http headers to agree with GitHub Api spec.
* Add ability to specify custom endpoints for enterprise clients.

0.6.1 (June 24, 2012)

* Add request parameters normalizer and update code references.
* Refactor Filter into ParameterFilter and update code references.
* Drop oauth2 dependency version requirement and update faraday.
* Add codeclimate integration in gem documentation.
* Add rubinius & jruby to Travis.

0.6.0 (June 12, 2012)

* Add search api with full test coverage.
* Add repository contents api with full test coverage.
* Change required keys validation and refactor all method calls.
* Change parameter procesing in users api, add feature tests.
* Change parameter processing in issues api, add feature tests.
* Add cache and location to response headers.
* Add unknown value error type and changed parameters values validation.
* Add redirects following.

0.5.4 (June 9, 2012)

* Update teams api documentation.
* Remove unused code from request processing.
* Remove require for addressable.
* Add feature tests for events, gists, orgs apis.
* Add core extension for extracting options from array.
* Change parameter slurping for organizations listing.

0.5.3 (June 6, 2012)

* Fix bug with preserving query parameters during pagination.
* Add feature tests to ensure correct pagination.
* Update vcr dependency.

0.5.2 (May 20, 2012)

* Change interface for listing unauthenticated user gists.
* Change gists find to get signature.
* Change oauth2 request.
* Add request json body encoding.
* Add live tests for emails api.
* Add ability to include body for delete request.
* Fix bug with deleting authenticated user emails.
* Update gem dependencies to faraday 0.8, oauth2 0.7 and guard.

0.5.1 (May 7, 2012)

* Fix bugs with references api and add live test coverage.
* Add live tests settings file.
* Add live tests for repository api.
* Add new section called testing to main docs to explain on test setup.

0.5.0 (April 27, 2012)

* Mainly documentation updates for method parameters and the way they are invoked.

0.5.0.rc1 (April 27, 2012)

* Rewrote all apis method calls to be consistent with GitHub API v3, namely,
  regardless which resource is being currently used, the 'create', 'edit', 'delete' methods are used for CRUD operations.
* Further ActiveRecord style methods are used, that is, 'all' for listing collection of resoruces and 'find' for getting a single resource.

0.4.11 (Apr 22, 2012)

* Add nokogiri as dependency.
* Update json dependency and remove deprecation warnings.

0.4.10 (Apr 15, 2012)

* Add xml resposne parsing.
* Add ordered hash to core extensions.
* Add amazon s3 services upload feature and integrate with downloads api upload method.

0.4.9 (Apr 9, 2012)

* Relax json and rspec gem dependencies.

0.4.8 (March 17, 2012)

* Change user emails api, fix bug with deleting emails, add specs.
* Change user keys api and add specs.

0.4.7 (March 11, 2012)

* Add custom client error class.
* Add custom errors invalid options and required params.
* Clean all github api specs from test dependencies.
* Change all github api to use new required params error class to provide clearer
  and more helpful request exceptions.
* Update cassettes and config to vcr 2.0
* Chage gem dependecies to use rake, bundler 1.1.0 and vcr 2.0

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
