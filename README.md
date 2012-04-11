# GithubAPI
[![Build Status](https://secure.travis-ci.org/peter-murach/github.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/peter-murach/github.png?travis)][gemnasium]

[travis]: http://travis-ci.org/peter-murach/github
[gemnasium]: https://gemnasium.com/peter-murach/github

[Wiki](https://github.com/peter-murach/github/wiki) | [RDocs](http://rubydoc.info/github/peter-murach/github/master/frames)

A Ruby wrapper for the GitHub REST API v3.

Supports all the API methods(nearly 200). It's build in a modular way, that is, you can either instantiate the whole api wrapper Github.new or use parts of it e.i. Github::Repos.new if working solely with repositories is your main concern.

## Installation

Install the gem by issuing

```ruby
gem install github_api
```

or put it in your Gemfile and run `bundle install`</tt>

```ruby
gem "github_api"
```

## Usage

Create a new client instance

```ruby
@github = Github.new
```

At this stage you can also supply various configuration parameters, such as `:user`,`:repo`, `:org`, `:oauth_token`, `:login`, `:password` or `:basic_auth` which are used throughout the API

```ruby
@github = Github.new :user => 'peter-murach', :repo => 'github-api'
```

or

```ruby
@github = Github.new do |opts|
  opts.user = 'peter-murach'
  opts.repo = 'github-api'
end
```

You can authenticate either using OAuth authentication convenience methods(see section OAuth) or through basic authentication by passing your login and password credentials

```ruby
@github = Github.new :login => 'peter-murach', :password => '...'
```

or use convenience method:

```ruby
@github = Github.new :basic_auth => 'login:password'
```

You can interact with GitHub interface, for example repositories, by issueing following calls

```ruby
@github.repos.commits
@github.repos.branches
@github.repos.contributors
```

The code base is modular and allows for you to work specifically with a given part of GitHub API e.g. repositories

```ruby
@repos = Github::Repos.new
@repos.branches 'peter-murach', 'github'

or

@repos = Github::Repos.new :user => 'peter-murach', :repo => 'github'
@repos.branches
```

The response is of type [Hashie::Mash] and allows to traverse all the json response attributes like method calls e.i.

```ruby
@repos = Github::Repos.new :user => 'peter-murach', :repo => 'github'
@repos.branches do |branch|
  puts branch.name
end
```

## API

Main API methods are grouped into the following classes that can be instantiated on their own

```ruby
Github         - full API access
Github::Gists
Github::GitData
Github::Issues
Github::Orgs
Github::PullRequests
Github::Repos
Github::Users
Github::Events
Github::Authorizations
```

Some parts of GitHub API v3 require you to be autheticated, for instance the following are examples of APIs only for the authenticated user

```ruby
Github::Users::Emails
Github::Users::Keys
```

All method calls form ruby like sentences and allow for intuitive api navigation, for instance

```ruby
@github = Github.new :oauth_token => '...'
@github.users.following 'wycats'  # => returns users that 'wycats' is following
@github.users.following 'wycats' # => returns true if following, otherwise false
```

For specification on all available methods go to http://developer.github.com/v3/ or
read the rdoc, all methods are documented there with examples of usage. Alternatively,
you can find out supported methods by issuing the following in your `irb`:

```ruby
>> Github::Repos.actions
---
|--> branches
|--> contribs
|--> contributors
|--> create_repo
...
```

## Inputs

Some API methods apart from required parameters such as username, repository name
or organisation name, allow you to switch the way the data is returned to you, for instance

```ruby
@github = Github.new
@github.git_data.tree 'peter-murach', 'github', 'c18647b75d72f19c1e0cc8af031e5d833b7f12ea'
# => gets a tree

@github.git_data.tree 'peter-murach', 'github', 'c18647b75d72f19c1e0cc8af031e5d833b7f12ea', :recursive => true
# => gets a whole tree recursively
```

by passing a block you can iterate over the file tree

```ruby
@github.git_data.tree 'peter-murach', 'github', 'c18647b75d72f19c1e0cc8af031e5d833b7f12ea',
  :recursive => true do |file|

  puts file.path
end
```

## OAuth

In order to authenticate the user through OAuth2 on GitHub you need to

* visit https://github.com/settings/applications/new and register your app
  You will need to be logged in to initially register the application.

* authorize your credentials https://github.com/login/oauth/authorize
  You can use convenience methods to help you achieve this that come with this gem:

```ruby
@github = Github.new :client_id => '...', :client_secret => '...'
@github.authorize_url :redirect_uri => 'http://localhost', :scope => 'repo'
# => "https://github.com/login/oauth/authorize?scope=repo&response_type=code&client_id='...'&redirect_uri=http%3A%2F%2Flocalhost"
```
After you get your authorization code, call to receive your access_token

```ruby
token = github.get_token( authorization_code )
```

Once you have your access token, configure your github instance following instructions under Configuration.

Alternatively you can use OAuth Authorizations API. For instance, to create access token through GitHub API do following

```ruby
@github = Github.new :basic_auth => 'login:password'
@github.oauth.create_authorization 'scopes' => ['repo']
```

You can add more than one scope from the <tt>user</tt>, <tt>public_repo</tt>, <tt>repo</tt>, <tt>gist</tt> or leave the scopes parameter out, in which case, the default read-only access will be assumed(includes public user profile info, public repo info, and gists).

## MIME Types

Issues, PullRequests and few other API leverage custom mime types which are <tt>:json</tt>, <tt>:blob</tt>, <tt>:raw</tt>, <tt>:text</tt>, <tt>:html</tt>, <tt>:full</tt>. By default <tt>:raw</tt> is used.

In order to pass a mime type with your request do

```ruby
@github = Github.new
@github.pull_requests.pull_requests 'peter-murach', 'github', :mime_type => :full
```

  Your header will contain 'Accept: "application/vnd.github-pull.full+json"' which in turn returns raw, text and html representations in response body.

## Configuration

Certain methods require authentication. To get your GitHub OAuth v2 credentials,
register an app at https://github.com/settings/applications/
You will need to be logged in to register the application.

```ruby
Github.configure do |config|
  config.oauth_token   = YOUR_OAUTH_ACCESS_TOKEN
  config.basic_auth    = 'login:password'
end

or

Github.new(:oauth_token => YOUR_OAUTH_TOKEN)
Github.new(:basic_auth => 'login:password')
```

All parameters can be overwirtten as per method call. By passing parameters hash...

## Caching

Each `get` request by default is not going to be cached. In order to set the cache do... If no cache type is provided a default memoization is done.

  Github.cache do...

## Pagination

Any request that returns multiple items will be paginated to 30 items by default. You can specify custom <tt>:page</tt> and <tt>:per_page</tt> query parameters to alter default behavior. For instance:

```ruby
res = Github::Repos.new.repos :user => 'wycats', :per_page => 10
```

Then you can query pagination information included in the link header by:

```ruby
res.links.first  # Shows the URL of the first page of results.
res.links.next   # Shows the URL of the immediate next page of results.
res.links.prev   # Shows the URL of the immediate previous page of results.
res.links.last   # Shows the URL of the last page of results.
```

In order to iterate through the entire result set page by page, you can use convenience methods:

```ruby
res.each_page do |page|
  page.each do |repo|
    puts repo.name
  end
end
```

or use `has_next_page?` and `next_page` like in the following:

```ruby
while res.has_next_page?
  ... process response ...
  res.next_page
end
```

One can also navigate straight to specific page by:

```ruby
res.page 5     # Requests given page if it exists, nil otherwise
res.first_page
res.prev_page
res.last_page
```

## Response Message

Each response comes packaged with methods allowing for inspection of HTTP start line and headers. For example to check for rate limits and status code issue

```ruby
res = Github::Repos.new.branches 'peter-murach', 'github'
res.ratelimit_limit     # "5000"
res.ratelimit_remainig  # "4999"
res.status              # "200"
res.content_type        # "application/json; charset=utf-8"
```

## Examples

Some api methods require input parameters, these are added simply as a hash properties, for instance

```ruby
@issues = Github::Issues.new :user => 'peter-murach', :repo => 'github-api'
@issues.milestones :state => 'open', :sort => 'due_date', :direction => 'asc'
```

Other methods may require inputs as an array of strings

```ruby
@users = Github::Users.new :oauth_token => '...'
@users.add_email 'email1', 'email2', ..., 'emailn' # => Adds emails to the authenticated user
```

If a method returns a collection, you can iterator over it by supplying a block parameter,

```ruby
@issues = Github::Issues.new :user => 'peter-murach', :repo => 'github-api'
@issues.events do |event|
  puts event.actor.login
end
```

Query requests instead of http responses return boolean values

```ruby
@github = Github.new
@github.orgs.public_member? 'github', 'technoweenie' # => true
```

## Rails Example

A Rails controller that allows a user to authorize their GitHub account and then perform request.

```ruby
class GithubController < ApplicationController

  def authorize
    github = Github.new :client_id => '...', :client_secret => '...'
    address = github.authorize_url :redirect_uri => 'http://...', :scope => 'repo'
    redirect_to address
  end

  def callback
    authorization_code = params[:code]
    token = github.get_token authorization_code
    access_token = token.token
  end
end
```

## TODO

* Add request caching - local filestore?, http caching?.
* Add live api tests

## Development

Questions or problems? Please post them on the [issue tracker](https://github.com/peter-murach/github/issues). You can contribute changes by forking the project and submitting a pull request. You can ensure the tests are passing by running `bundle` and `rake`.

## Copyright

Copyright (c) 2011-2012 Piotr Murach. See LICENSE.txt for further details.
