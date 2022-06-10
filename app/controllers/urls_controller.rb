# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    # recent 10 short urls
    @url = Url.new
    @urls = Url.last(10)
  end

  def create
    data = params[:url]
    @url = Url.new
    @url.original_url = data[:original_url]
    @url.short_url = @url.generate_url
    if @url.valid?
      @url.save
      redirect_to '/', notice: "URL has successfully been added!" and return
    else
      if !@url.errors[:original_url].empty?
        redirect_to '/', notice: "URL is invalid!" and return
      end

      while !@url.errors[:short_url].empty?
        @url.update_attributes(short_url: @url.generate_url)
      end
      redirect_to '/', notice: "URL has successfully been added!"

    end
  end

  def show
    @url = Url.find_by_short_url(params[:url])
    # implement queries
    if @url.present?
      clicks = Click.all.where(url_id: @url.id).pluck(:created_at)
      @daily_clicks = @url.get_dates(clicks)
      browsers = Click.all.where(url_id: @url.id).pluck(:browser)
      @browsers_clicks = @url.get_list(browsers)
      platform = Click.all.where(url_id: @url.id).pluck(:platform)
      @platform_clicks = @url.get_list(platform)
      byebug
    else
      render file: "#{Rails.root}/public/404"
    end
  end

  def visit
    @url = Url.find_by_short_url(params[:short_url])
    if @url.present?
      @url.update_attributes(clicks_count: @url.clicks_count+1)
      Click.create(browser: browser.name, platform: browser.platform.name, url_id: @url.id)
      redirect_to @url.original_url and return
    else
      render file: "#{Rails.root}/public/404"
    end
  end
end
