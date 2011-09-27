module Github
  class Repos
    module Downloads
      
      REQUIRED_PARAMS = %w[ name size ]
      VALID_PARAMS = %w[ name size description content_type ]

      REQUIRED_S3_PARAMS = %w[ key acl success_action_status Filename AWSAccessKeyId Policy Signature Content-Type file ]

      # List downloads for a repository
      #
      # GET /repos/:user/:repo/downloads
      #
      def list(user, repo)
        get("/repos/#{user}/#{repo}/downloads")
      end

      # Get a single download
      #
      # GET /repos/:user/:repo/downloads/:id
      #
      def get(user, repo, download_id)
        get("/repos/#{user}/#{repo}/downloads/#{download_id}")
      end

      # Delete download from a repository
      #
      # DELETE /repos/:user/:repo/downloads/:id
      #
      def delete(user, repo, download_id)
        delete("/repos/#{user}/#{repo}/downloads/#{download_id}")
      end

      # Creating a new download is a two step process. 
      # You must first create a new download resource using this method.
      # Response from this method is to be used in #upload method.
      #
      # POST /repos/:user/:repo/downloads
      #
      def create(user, repo, params={})
        _normalize_params_keys(params)
        raise ArgumentError, "expected following inputs to the method: #{REQUIRED_INPUTS.join(', ')}" unless _valid_inputs(REQUIRED_PARAMS, params)
        _filter_params_keys(VALID_PARAMS, params)

        post("/repos/#{user}/#{repo}/downloads", params)
      end
        
      # Upload a file to Amazon, using the reponse instance from 
      # Github::Repos::Downloads#create. This can be done by passing 
      # the response object as an argument to upload method.
      #
      def upload(result, file)
        REQUIRED_S3_PARAMS.each do |key|
          raise ArgumentError, "expected following keys: #{REQUIRED_S3_PARAMS.join(', ')}" unless result.respond_to?(key) 
        end
        
        # TODO use ordered hash if Ruby < 1.9
        mapped_params = {
          "key"                   => result.path,
          "acl"                   => result.acl,
          "success_action_status" => 201,
          "Filename"              => result.name,
          "AWSAccessKeyId" => result.accesskeyid,
          "Policy" => result.policy,
          "Signature" => result.signature,
          "Content-Type" => result.mime_type,
          "file" => file 
        }
        
        post(result.s3_url, mapped_params)
      end

    end # Downloads
  end # Repos
end # Github
