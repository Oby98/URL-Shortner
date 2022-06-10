# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'validates original URL is a valid URL' do
      url = create(:url)
      expect(url).to be_valid
    end

    it 'validates short URL is present' do
      url = create(:url)
      expect(url).to be_valid
    end

    # add more tests
  end
end
