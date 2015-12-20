<div align="center">
  <a href="http://peter-murach.github.io/github/"><img width="136" src="https://github.com/peter-murach/github/raw/master/icons/github_api.png" alt="github api logo" /></a>
</div>
# GithubAPI
[![Gem Version](https://badge.fury.io/rb/github_api.svg)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/github.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/github/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/github/badge.svg?branch=master)][coverage]
[![Inline docs](http://inch-ci.org/github/peter-murach/github.svg)][inchpages]
[![Dependency Status](https://gemnasium.com/peter-murach/github.svg?travis)][gemnasium]

[gem]: http://badge.fury.io/rb/github_api
[travis]: http://travis-ci.org/peter-murach/github
[codeclimate]: https://codeclimate.com/github/peter-murach/github
[coverage]: https://coveralls.io/r/peter-murach/github
[inchpages]: http://inch-ci.org/github/peter-murach/github
[gemnasium]: https://gemnasium.com/peter-murach/github

[Website](http://peter-murach.github.io/github/) | [Wiki](https://github.com/peter-murach/github/wiki) | [RDocs](http://rubydoc.info/github/peter-murach/github/master/frames)

A Ruby client for the official GitHub API.

Supports all the API methods. It's built in a modular way. You can either instantiate the whole API wrapper Github.new or use parts of it i.e. Github::Client::Repos.new if working solely with repositories is your main concern. Intuitive query methods allow you easily call API endpoints.

## Features

* Intuitive GitHub API interface navigation.
* It's comprehensive. You can request all GitHub API resources.
* Modular design allows for working with parts of API.
* Fully customizable including advanced middleware stack construction.
* Supports OAuth2 authorization.
* Flexible argument parsing. You can write expressive and natural queries.
* Requests pagination with convenient DSL and automatic options.
* Easy error handling split for client and server type errors.
* Supports multithreaded environment.
* Custom media type specification through the 'media' parameter.
* Request results caching
* Fully tested with unit and feature tests hitting the live api.

## Installation

Install the gem by running

```ruby
gem install github_api
```

or put it in your Gemfile and run `bundle install`

```ruby
gem "github_api"
```

## Contents

* [1. Usage](#1-usage)
    * [1.1 API Navigation](#11-api-navigation)
    * [1.2 Modularity](#12-modularity)
    * [1.3 Arguments](#13-arguments)
    * [1.4 Response Querying](#14-response-querying)
      * [1.4.1 Response Body](#141-response-body)
      * [1.4.2 Response Headers](#142-response-headers)
      * [1.4.3 Response Success](#143-response-success)
    * [1.5 Request Headers](#15-request-headers)
      * [1.5.1 Media Types](#151-media-types)
* [2. Configuration](#2-configuration)
    * [2.1 Basic](#21-basic)
    * [2.2 Advanced](#22-advanced)
    * [2.3 SSL](#23-ssl)
    * [2.4 Caching](#24-caching)
* [3. Authentication](#3-authentication)
    * [3.1 Basic](#31-basic)
    * [3.2 Authorizations API](#32-authorizations-api)
    * [3.3 Scopes](#33-scopes)
    * [3.4 Application OAuth](#34-application-oauth)
    * [3.5 Two-Factor](#35-two-factor)
* [4. Pagination](#4-pagination)
  * [4.1 Auto pagination](#41-auto-pagination)
* [5. Error Handling](#5-error-handling)
* [6. Examples](#6-examples)
  * [6.1 Rails](#61-rails)
  * [6.2 Manipulating Files](#62-manipulating-files)
* [7. Testing](#7-testing)

## 1 Usage

To start using the gem, you can either perform requests directly on `Github` namespace:

```ruby
Github.repos.list user: 'peter-murach'
```

or create a new client instance like so

```ruby
github = Github.new
```

and then call api methods, for instance, to list a given user repositories do

```ruby
github.repos.list user: 'peter-murach'
```

### 1.1 API Navigation

The **github_api** closely mirrors the [GitHub API](https://developer.github.com/v3/) hierarchy. For example, if you want to create a new file in a repository, look up the GitHub API spec. In there you will find contents sub category underneath the repository category. This would translate to the request:

```ruby
github = Github.new
github.repos.contents.create 'peter-murach', 'finite_machine', 'hello.rb',
                             path: 'hello.rb',
                             content: "puts 'hello ruby'"
```

The whole library reflects the same api navigation. Therefore, if you need to list releases for a repository do:

```ruby
github.repos.releases.list 'peter-murach', 'finite_machine'
```

or to list a user's followers:

```ruby
github.users.followers.list 'peter-murach'
```

The code base has been extensively documented with examples of how to use each method. Please refer to the [documentation](http://rubydoc.info/github/peter-murach/github/master/frames) under the `Github::Client` class name.

Alternatively, you can find out which methods are supported by an api by calling `actions` on a class or instance. For example, in order to find out available endpoints for `Github::Client::Repos::Contents` api call `actions` method:

```ruby
Github::Client::Repos::Contents.actions
=> [:archive, :create, :delete, :find, :get, :readme, :update]
```

### 1.2 Modularity

The code base is modular. This means that you can work specifically with a given part of GitHub API. If you want to only work with activity starring API do the following:

```ruby
starring = Github::Client::Activity::Starring.new oauth_token: token
starring.star 'peter-murach', 'github'
```

Please refer to the [documentation](http://rubydoc.info/github/peter-murach/github/master/frames) and look under `Github::Client` to see all available classes.

### 1.3 Arguments

The **github_api** library allows for flexible argument parsing.

Arguments can be passed directly inside the method called. The `required` arguments are passed in first, followed by optional parameters supplied as hash options:

```ruby
issues = Github::Client::Issues.new
issues.milestones.list 'peter-murach', 'github', state: 'open'
```

In the previous example, the order of arguments is important. However, each method also allows you to specify `required` arguments using hash symbols and thus remove the need for ordering. Therefore, the same example could be rewritten like so:

```ruby
issues = Github::Client::Issues.new
issues.milestones.list user: 'peter-murach', repo: 'github', state: 'open'
```

Furthermore, `required` arguments can be passed during instance creation:

```ruby
issues = Github::Client::Issues.new user: 'peter-murach', repo: 'github'
issues.milestones.list state: 'open'
```

Similarly, the `required` arguments for the request can be passed inside the current scope such as:

```ruby
issues = Github::Client::Issues.new
issues.milestones(user: 'peter-murach', repo: 'github').list state: 'open'
```

But why limit ourselves? You can mix and match arguments, for example:

```ruby
issues = Github::Client::Issues.new user: 'peter-murach'
issues.milestones(repo: 'github').list
issues.milestones(repo: 'tty').list
```

You can also use a bit of syntactic sugar whereby "username/repository" can be passed as well:

```ruby
issues = Github::Client::Issues.new
issues.milestones('peter-murach/github').list
issues.milestones.list 'peter-murach/github'
```

Finally, use the `with` scope to clearly denote your requests

```ruby
issues = Github::Client::Issues.new
issues.milestones.with(user: 'peter-murach', repo: 'github').list
```

Please consult the method [documentation](http://rubydoc.info/github/peter-murach/github/master/frames) or [GitHub specification](https://developer.github.com/v3/) to see which arguments are required and what are the option parameters.

### 1.4 Response Querying

The response is of type `Github::ResponseWrapper` and allows traversing all the json response attributes like method calls. In addition, if the response returns more than one resource, these will be automatically yielded to the provided block one by one.

For example, when request is issued to list all the branches on a given repository, each branch will be yielded one by one:

```ruby
repos = Github::Client::Repos.new
repos.branches user: 'peter-murach', repo: 'github' do |branch|
  puts branch.name
end
```

#### 1.4.1 Response Body

The `ResponseWrapper` allows you to call json attributes directly as method calls. there is no magic here, all calls are delegated to the response body. Therefore, you can directly inspect request body by calling `body` method on the `ResponseWrapper` like so:

```ruby
response = repos.branches user: 'peter-murach', repo: 'github'
response.body  # => Array of branches
```

#### 1.4.2 Response Headers

Each response comes packaged with methods allowing for inspection of HTTP start line and headers. For example, to check for rate limits and status codes do:

```ruby
response = Github::Client::Repos.branches 'peter-murach', 'github'
response.headers.ratelimit_limit     # "5000"
response.headers.ratelimit_remaining # "4999"
response.headers.status              # "200"
response.headers.content_type        # "application/json; charset=utf-8"
response.headers.etag                # "\"2c5dfc54b3fe498779ef3a9ada9a0af9\""
response.headers.cache_control       # "public, max-age=60, s-maxage=60"
```

#### 1.4.3 Response Success

If you want to verify if the response was success, namely, that the `200` code was returned call the `success?` like so:

```ruby
response = Github::Client::Repos.branches 'peter-murach', 'github'
response.success?  # => true
```

### 1.5 Request Headers

It is possible to specify additional header information which will be added to the final request.

For example, to set `etag` and `X-Poll_Interval` headers, use the `:headers` hash key inside the `:options` hash like in the following:

```ruby
events = Github::Client::Activity::Events.new
events.public headers: {
    'X-Poll-Interval': 60,
    'ETag': "a18c3bded88eb5dbb5c849a489412bf3"
  }
```

#### 1.5.1 Media Types

In order to set custom media types for a request use the accept header. By using the `:accept` key you can determine media type like in the example:

```ruby
issues = Github::Client::Issues.new
issues.get 'peter-murach', 'github', 108, accept: 'application/vnd.github.raw'
```

## 2 Configuration

The **github_api** provides ability to specify global configuration options. These options will be available to all api calls.

### 2.1 Basic

The configuration options can be set by using the `configure` helper

```ruby
Github.configure do |c|
  c.basic_auth = "login:password"
  c.adapter    = :typheous
  c.user       = 'peter-murach'
  c.repo       = 'finite_machine'
end
```

Alternatively, you can configure the settings by passing a block to an instance like:

```ruby
Github.new do |c|
  c.endpoint    = 'https://github.company.com/api/v3'
  c.site        = 'https://github.company.com'
  c.upload_endpoint = 'https://github.company.com/api/uploads'
end
```

or simply by passing hash of options to an instance like so

```ruby
github = Github.new basic_auth: 'login:password',
                    adapter: :typheous,
                    user: 'peter-murach',
                    repo: 'finite_machine'
```

The following is the full list of available configuration options:

```ruby
adapter            # Http client used for performing requests. Default :net_http
auto_pagination    # Automatically traverse requests page links. Default false
basic_auth         # Basic authentication in form login:password.
client_id          # Oauth client id.
client_secret      # Oauth client secret.
connection_options # Hash of connection options.
endpoint           # Enterprise API endpoint. Default: 'https://api.github.com'
oauth_token        # Oauth authorization token.
org                # Global organization used in requests if none provided
per_page           # Number of items per page. Max of 100. Default 30.
repo               # Global repository used in requests in none provided
site               # enterprise API web endpoint
ssl                # SSL settings in hash form.
user               # Global user used for requests if none provided
user_agent         # Custom user agent name. Default 'Github API Ruby Gem'
```

### 2.2 Advanced

The **github_api** will use the default middleware stack which is exposed by calling `stack` on a client instance. However, this stack can be freely modified with methods such as `insert`, `insert_after`, `delete` and `swap`. For instance, to add your `CustomMiddleware` do:

```ruby
Github.configure do |c|
  c.stack.insert_after Github::Response::Helpers, CustomMiddleware
end
```

Furthermore, you can build your entire custom stack and specify other connection options such as `adapter` by doing:

```ruby
Github.new do |c|
  c.adapter :excon

  c.stack do |builder|
    builder.use Github::Response::Helpers
    builder.use Github::Response::Jsonize
  end
end
```

### 2.3 SSL

By default requests over SSL are set to OpenSSL::SSL::VERIFY_PEER. However, you can turn off peer verification by

```ruby
github = Github.new ssl: { verify: false }
```

If your client fails to find CA certs, you can pass other SSL options to specify exactly how the information is sourced

```ruby
ssl: {
  client_cert: "/usr/local/www.example.com/client_cert.pem"
  client_key:  "/user/local/www.example.com/client_key.pem"
  ca_file:     "example.com.cert"
  ca_path:     "/etc/ssl/"
}
```

For instance, download CA root certificates from Mozilla [cacert](http://curl.haxx.se/ca/cacert.pem) and point ca_file at your certificate bundle location. This will allow the client to verify the github.com ssl certificate as authentic.

### 2.4 Caching

Caching is supported through the [`faraday-http-cache` gem](https://github.com/plataformatec/faraday-http-cache).

Add the gem to your Gemfile:

```ruby
gem 'faraday-http-cache'
```

You can now configure cache parameters as follows

```ruby
Github.configure do |config|
  config.stack do |builder|
    builder.use Faraday::HttpCache, store: Rails.cache
  end
end
```

More details on the available options can be found in the gem's own documentation: https://github.com/plataformatec/faraday-http-cache#faraday-http-cache

## 3 Authentication

### 3.1 Basic

To start making requests as authenticated user you can use your GitHub username and password like so

```ruby
Github.new basic_auth: 'login:password'
```

Though this method is convenient you should strongly consider using `OAuth` for improved security reasons.

### 3.2 Authorizations API

#### 3.2.1 For a User

To create an access token through the GitHub Authorizations API, you are required to pass your basic credentials and scopes you wish to have for the authentication token.

```ruby
github = Github.new basic_auth: 'login:password'
github.oauth.create scopes: ['repo'], note: 'admin script'
```

You can add more than one scope from the `user`, `public_repo`, `repo`, `gist` or leave the scopes parameter out, in which case, the default read-only access will be assumed (includes public user profile info, public repo info, and gists).

#### 3.2.2 For an App

Furthermore, to create auth token for an application you need to pass `:app` argument together with `:client_id` and `:client_secret` parameters.

```ruby
github = Github.new basic_auth: 'login:password'
github.oauth.app.create 'client-id', scopes: ['repo']
```

In order to revoke auth token(s) for an application you must use basic authentication with `client_id` as login and `client_secret` as password.

```ruby
github = Github.new basic_auth: "client_id:client_secret"
github.oauth.app.delete 'client-id'
```

Revoke a specific app token.

```ruby
github.oauth.app.delete 'client-id', 'access-token'
```

### 3.3 Scopes

You can check OAuth scopes you have by:

```ruby
github = Github.new oauth_token: 'token'
github.scopes.list    # => ['repo']
```

To list the scopes that the particular GitHub API action checks for do:

```ruby
repos = Github::Client::Repos.new
response = repos.list user: 'peter-murach'
response.headers.accepted_oauth_scopes  # => ['delete_repo', 'repo', 'public_repo']
```

To understand what each scope means refer to [documentation](http://developer.github.com/v3/oauth/#scopes)

### 3.4 Application OAuth

In order to authenticate your app through OAuth2 on GitHub you need to

* Visit https://github.com/settings/applications/new and register your app.
  You will need to be logged in to initially register the application.

* Authorize your credentials https://github.com/login/oauth/authorize

You can use convenience methods to help you achieve this using **GithubAPI** gem:

```ruby
github = Github.new client_id: '...', client_secret: '...'
github.authorize_url redirect_uri: 'http://localhost', scope: 'repo'
# => "https://github.com/login/oauth/authorize?scope=repo&response_type=code&client_id='...'&redirect_uri=http%3A%2F%2Flocalhost"
```
After you get your authorization code, call to receive your access_token

```ruby
token = github.get_token( authorization_code )
```

Once you have your access token, configure your github instance following instructions under Configuration.

**Note**: If you are working locally (i.e. your app URL and callback URL are localhost), do not specify a ```:redirect_uri``` otherwise you will get a ```redirect_uri_mismatch``` error.

### 3.5 Two-Factor

In order to use [Two-Factor](https://help.github.com/articles/about-two-factor-authentication) authentication you need provide `X-GitHub-OTP: required; :2fa-type` header.

You can add headers during initialization:

```ruby
Github.new do |config|
  config.basic_auth         = "user:password"
  config.connection_options = {headers: {"X-GitHub-OTP" => '2fa token'}}
end
```

or per request:

```ruby
github = Github.new basic_auth: 'login:password'
github.oauth.create scopes: ["public_repo"],
                    headers: {"X-GitHub-OTP" => "2fa token"}
```

## 4 Pagination

Any request that returns multiple items will be paginated to 30 items by default. You can specify custom `page` and `per_page` query parameters to alter default behavior. For instance:

```ruby
repos    = Github::Client::Repos.new
response = repos.list user: 'wycats', per_page: 10, page: 5
```

Then you can query the pagination information included in the link header by:

```ruby
response.links.first  # Shows the URL of the first page of results.
response.links.next   # Shows the URL of the immediate next page of results.
response.links.prev   # Shows the URL of the immediate previous page of results.
response.links.last   # Shows the URL of the last page of results.
```

In order to iterate through the entire result set page by page, you can use convenience methods:

```ruby
response.each_page do |page|
  page.each do |repo|
    puts repo.name
  end
end
```

or use `has_next_page?` and `next_page` helper methods like in the following:

```ruby
while response.has_next_page?
  ... process response ...
  res.next_page
end
```

One can also navigate straight to the specific page by:

```ruby
res.count_pages  # Number of pages
res.page 5       # Requests given page if it exists, nil otherwise
res.first_page   # Get first page
res.next_page    # Get next page
res.prev_page    # Get previous page
res.last_page    # Get last page
```

### 4.1 Auto pagination

You can retrieve all pages in one invocation by passing the `auto_pagination` option like so:

```ruby
github = Github.new auto_pagination: true
```

Depending at what stage you pass the `auto_pagination` it will affect all or only a single request. For example, in order to auto paginate all Repository API methods do:

```ruby
Github::Сlient::Repos.new auto_pagination: true
```

However, to only auto paginate results for a single request do:

```ruby
Github::Client::Repos.new.list user: '...', auto_pagination: true
```

## 5 Error Handling

The generic error class `Github::Error::GithubError` will handle both the client (`Github::Error::ClientError`) and service (`Github::Error::ServiceError`) side errors. For instance in your code you can catch errors like

```ruby
begin
  # Do something with github_api gem
rescue Github::Error::GithubError => e
  puts e.message

  if e.is_a? Github::Error::ServiceError
    # handle GitHub service errors such as 404
  elsif e.is_a? Github::Error::ClientError
    # handle client errors e.i. missing required parameter in request
  end
end
```

## 6 Examples

### 6.1 Rails

A Rails controller that allows a user to authorize their GitHub account and then performs a request.

```ruby
class GithubController < ApplicationController

  def authorize
    address = github.authorize_url redirect_uri: 'http://...', scope: 'repo'
    redirect_to address
  end

  def callback
    authorization_code = params[:code]
    access_token = github.get_token authorization_code
    access_token.token   # => returns token value
  end

  private

   def github
    @github ||= Github.new client_id: '...', client_secret: '...'
   end
end
```

### 6.2 Manipulating Files

In order to be able to create/update/remove files you need to use Contents API like so:

```ruby
contents = Github::Client::Repos::Contents.new oauth_token: '...'
```

Having instantiated the contents, to create a file do:

```ruby
contents.create 'username', 'repo_name', 'full_path_to/file.ext',
  path: 'full_path_to/file.ext',
  message: 'Your commit message',
  content: 'The contents of your file'
```

Content is all Base64 encoded to/from the API, and when you create a file it encodes it automatically for you.

To update a file, first you need to find the file so you can get the SHA you're updating off of:

```ruby
file = contents.find path: 'full_path_to/file.ext'
```

Then update the file just like you do with creating:

```ruby
contents.update 'username', 'repo_name', 'full_path_to/file.ext',
  path: 'full_path_to/file.ext'
  message: 'Your commit message',
  content: 'The contents to be updated',
  sha: file.sha
```

Finally to remove a file, find the file so you can get the SHA you're removing:

```ruby
file = contents.find path: 'full_path_to/file.ext'
```

Then delete the file like so:

```ruby
github.delete 'username', 'tome-of-knowledge', 'full_path_to/file.ext',
  path: 'full_path_to/file.ext',
  message: 'Your Commit Message',
  sha: file.sha
```

## 7 Testing

The test suite is split into two groups, `live` and `mock`.

The `live` tests are the ones in `features` folder and they simply exercise the GitHub API by making live requests and then being cached with VCR in directory named `features\cassettes`. For details on how to get set up, please navigate to the `features` folder.

The `mock` tests are in the `spec` directory and their primary concern is to test the gem internals without the hindrance of external calls.

## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/peter-murach/github/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests are passing by running `bundle` and `rake`.

## Copyright

Copyright (c) 2011-2014 Piotr Murach. See LICENSE.txt for further details.
