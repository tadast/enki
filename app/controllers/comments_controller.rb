class CommentsController < ApplicationController
  include UrlHelper
  OPEN_ID_ERRORS = { 
    :missing  => "Sorry, the OpenID server couldn't be found", 
    :canceled => "OpenID verification was canceled",
    :failed   => "Sorry, the OpenID verification failed" }

  before_filter :find_post, :except => [:new]
  before_filter :check_honeypots, :only => %w'create index'
  before_filter :cleanup_honey

  def index
    if request.post? || using_open_id?
      create
    else
      redirect_to(post_path(@post))
    end
  end

  def new
    @comment = Comment.build_for_preview(params[:comment])

    respond_to do |format|
      format.js do
        render :partial => @comment
      end
    end
  end

  def create
    @comment = Comment.new((session[:pending_comment] || params[:comment] || {}).reject {|key, value| !Comment.protected_attribute?(key) })
    @comment.post = @post

    logger.info @comment.inspect
    logger.info params.inspect
    logger.info(((session[:pending_comment] || params[:comment] || {}).reject {|key, value| !Comment.protected_attribute?(key) }).inspect)

    session[:pending_comment] = nil

    unless @comment.requires_openid_authentication?
      @comment.blank_openid_fields
      @comment.author_email = (session[:pending_comment] || params[:comment])[:author_email]
    else
      session[:pending_comment] = params[:comment]
      return if authenticate_with_open_id(@comment.author, :optional => [:nickname, :fullname, :email]) do |result, identity_url, registration|
        if result.status == :successful
          @comment.post = @post

          @comment.author_url   = @comment.author
          @comment.author       = (registration["fullname"] || registration["nickname"] || @comment.author_url).to_s
          @comment.author_email = (registration["email"] || @comment.author_url).to_s

          @comment.openid_error = ""
          session[:pending_comment] = nil
        else
          @comment.openid_error = OPEN_ID_ERRORS[ result.status ]
        end
      end
    end

    if session[:pending_comment].nil? && @comment.save
      redirect_to post_path(@post)
    else
      prepare_hidden_styles
      render :template => 'posts/show'
    end
  end

  protected

  def find_post
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
  end

  def check_honeypots
    logger.info "check honeypots: #{params.inspect}"
  
    fields = [
      [:comment, :author_website],
      [:comment, :website],
      :website,
      :url
    ]
    r = true
    fields.each do |f|
      if f.is_a?(Array)
        unless params[f[0]].try(:[], f[1]).blank?
          r = false
          break
        end
      else
        unless params[f].blank?
          r = false
          break
        end
      end
    end

    unless r
      session[:honeypot_data] = params
      redirect_to post_path(@post)
    end

    r
  end

  def cleanup_honey
    if params[:comment]
      params[:comment].try(:delete,:author_website)
      params[:comment].try(:delete,:website)
    end
    true
  end
end
