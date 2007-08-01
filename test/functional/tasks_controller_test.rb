require File.dirname(__FILE__) + '/../test_helper'
require 'tasks_controller'

# Re-raise errors caught by the controller.
class TasksController; def rescue_action(e) raise e end; end

class TasksControllerTest < Test::Unit::TestCase
  fixtures :tasks, :users

  def setup
    @controller = TasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @user = users(:quentin)
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:dated_tasks)
    assert assigns(:later_tasks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_task
    old_count = Task.count
    post :create, :new_task => { :name => 'Do it now!' }
    assert_equal old_count+1, Task.count
    
    assert_redirected_to tasks_path
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_task
    put :update, :id => 1, :task => { :name => 'Cool!' }
    assert_redirected_to tasks_path
  end
  
  def test_should_destroy_task
    old_count = Task.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Task.count
    
    assert_redirected_to tasks_path
  end
  
  def test_should_complete_task
    assert_difference '@user.tasks.dated.size', -1 do
      post :complete, :id => 1
    end
    
    assert_response :success
  end
  
  def test_should_show_completed_task
    get :completed
    assert_response :success
    assert assigns(:tasks)
  end
end
