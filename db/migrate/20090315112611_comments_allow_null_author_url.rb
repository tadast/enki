class CommentsAllowNullAuthorUrl < ActiveRecord::Migration
  def self.up
    change_column_null :comments, :author_url, true
  end

  def self.down
    Comment.all(:conditions => { :author_url => nil }).each do |comment|
      comment.update_attribute :author_url, ''
    end
    change_column_null :comments, :author_url, false
  end
end
