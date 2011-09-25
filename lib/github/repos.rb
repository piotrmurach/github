module Repos
 
  # GET /repos/:user/:repo/branches
  def branches(user, repo, params={})
    _validate_user_repo_params
    response = get("/repos#{user}/#{repo}", options)
  end

  def collaborators

  end

  def commits

  end
  
  # List contributors 
  #
  # GET /repos/:user/:repo/contributors
  # 
  # Examples:
  #    client = Client.new
  #    client.contributors(:user => 'john', :role => 'twitter')
  def contributors(user, repo, flag=nil)
    get("/repos/#{user}/#{repo}/contributors", flag)
  end
  
  def tags(params={})

  end
  
end
