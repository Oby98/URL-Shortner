# frozen_string_literal: true

class Url < ApplicationRecord
  validates :original_url, format: URI::regexp(%w[http https])
  validates_presence_of :original_url, :short_url
  validates_uniqueness_of :short_url

  # scope :latest, -> {}
  #
  def generate_url
    Array('A'..'Z').sample(5).join
  end

  def get_dates(data)
    lst = []
    dates = data.group_by{|x| x.strftime("%-d") if x.strftime("%-m") == "#{Time.now.month}" }
    dates.each {|key,val| lst.push([key,val.count])}
    byebug
    lst
  end

  def get_list(data)
    lst = []
    lst2 = data.group_by{|x| x}
    lst2.each {|key,val| lst.push([key,val.count])}
    lst
  end
end
