# encoding: utf-8

require 'spec_helper'

RSpec.describe Github::Error::ServiceError, '::error_mapping' do
  it "matches error codes to error types" do
    expect(described_class.error_mapping).to include({
      400 => Github::Error::BadRequest,
      401 => Github::Error::Unauthorized,
      403 => Github::Error::Forbidden,
      404 => Github::Error::NotFound,
      405 => Github::Error::MethodNotAllowed,
      406 => Github::Error::NotAcceptable,
      409 => Github::Error::Conflict,
      414 => Github::Error::UnsupportedMediaType,
      422 => Github::Error::UnprocessableEntity,
      451 => Github::Error::UnavailableForLegalReasons,
      500 => Github::Error::InternalServerError,
      501 => Github::Error::NotImplemented,
      502 => Github::Error::BadGateway,
      503 => Github::Error::ServiceUnavailable
    })
  end
end
