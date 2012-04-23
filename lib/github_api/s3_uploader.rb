# encoding: utf-8

require 'github_api/response/xmlize'

module Github
  class S3Uploader

    REQUIRED_S3_PARAMS = %w[
      path
      acl
      name
      accesskeyid
      policy
      signature
      mime_type
    ].freeze

    # Status code for successful upload to Amazon S3 service
    SUCCESS_STATUS = 201

    attr_accessor :resource, :filename

    def initialize(resource, filename)
      @resource = resource
      @filename = filename
    end

    def send
      REQUIRED_S3_PARAMS.each do |key|
        unless resource.respond_to?(key)
          raise ArgumentError, "Expected following key: #{key}"
        end
      end

      mapped_params = Github::CoreExt::OrderedHash[
        'key', resource.path,
        'acl', resource.acl,
        'success_action_status', SUCCESS_STATUS,
        'Filename', resource.name,
        'AWSAccessKeyId', resource.accesskeyid,
        'Policy', resource.policy,
        'Signature', resource.signature,
        'Content-Type', resource.mime_type,
        'file', Faraday::UploadIO.new(filename, 'application/octet-stream')
      ]

      http = Faraday.new do |builder|
        builder.request :multipart
        builder.use Github::Response::Xmlize
        builder.adapter :net_http
      end

      http.post resource.s3_url, mapped_params
    end

  end # S3Uploader
end # Github
