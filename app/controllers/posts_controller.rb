class PostsController < ApplicationController
  def index
    @tag = params[:tag]
    @posts = Post.find_recent(:tag => @tag, :include => :tags)

    raise(ActiveRecord::RecordNotFound) if @tag && @posts.empty?

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    @comment = Comment.new

    # normal styles
    @ns = 20.times.map{ "hs#{rand(10000)}" }.uniq.shuffle

    # hidden styles
    @hs = @ns.shift(@ns.size/2)
    
    def @ns.random; self[ Kernel.rand(size) ]; end
    def @hs.random; self[ Kernel.rand(size) ]; end

    @styles = []
    @ns.each{ |s| @styles << ".#{s} {}" }
    @hs.each{ |s| @styles << ".#{s} {display:none}" }
    @styles.shuffle!
  end
end
