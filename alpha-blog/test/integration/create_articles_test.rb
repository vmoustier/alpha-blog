require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest
  
  def setup 
     @user = User.create(username: "John", email: "John@example.com", password: "password", admin: true)
     @article = Article.new(title: "Automated test", description: "Automated test description")
     @notarticle = Article.new(title: " ", description: "Automated test description")
  end
  
  test "get new article form and create article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    post_via_redirect articles_path,  article: {title: @article.title, description: @article.description }
    assert_match @article.title, response.body
    assert_equal 'Article was successfully created', flash[:success]
  end
  
  test "Not logged in user can not create" do
    #sign_in_as(@user, "password")
    get new_article_path
    assert_redirected_to root_path
    assert_equal 'You must be logged in to perform that action', flash[:danger]
  end
  
  test "get new article form and try create failure article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    post_via_redirect articles_path,  article: {title: @notarticle.title, description: @notarticle.description }
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
end
