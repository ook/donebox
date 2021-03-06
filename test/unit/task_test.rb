  require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
  fixtures :tasks, :users, :categories

  def test_find_dated
    assert_equal [tasks(:due_today)], users(:quentin).tasks.dated
  end
  
  def test_find_for_later
    assert_equal [tasks(:due_later)], users(:quentin).tasks.later
  end
  
  def test_completed
    assert_equal true, tasks(:completed).completed?
    assert_equal false, tasks(:due_today).completed?
  end
  
  def test_due_later
    assert_equal true, tasks(:due_later).due_later?
    assert_equal false, tasks(:due_today).due_later?
  end
    
  def test_complete
    task = tasks(:due_today)
    task.complete
    task.save
    
    assert task.completed?
  end
  
  def test_uncomplete
    task = tasks(:completed)
    task.uncomplete
    task.save
    
    assert !task.completed?
  end
  
  def test_create_with_name
    task = users(:quentin).tasks.create :name => 'testing'
    assert_valid task
  end
  
  def test_extract_category_from_name
    task = Task.new :name => '[project] Write some tests', :user => users(:quentin)
    task.instance_eval{extract_category_from_name}
    assert_equal 'project', task.category.name.downcase
    assert_equal 'Write some tests', task.name
    
    task = Task.new :name => '[cool-project] Write some cooler tests', :user => users(:quentin)
    task.instance_eval{extract_category_from_name}
    assert_equal 'cool-project', task.category.name
    assert_equal 'Write some cooler tests', task.name
    
    task = Task.new :name => 'Write some tests', :user => users(:quentin)
    task.instance_eval{extract_category_from_name}
    assert_equal nil, task.category
    assert_equal 'Write some tests', task.name

    task = Task.new :name => '@ShortCategory Write tests with shortcuts', :user => users(:quentin)
    task.instance_eval{extract_category_from_name}
    assert_equal 'ShortCategory', task.category.name
    assert_equal 'Write tests with shortcuts', task.name

    task = Task.new :name => '@Short_Category Write tests with shortcuts', :user => users(:quentin)
    task.instance_eval{extract_category_from_name}
    assert_equal 'Short Category', task.category.name
    assert_equal 'Write tests with shortcuts', task.name
  end
  
  def test_find_all_categories
    assert_equal %w(Miscellaneous Project), users(:quentin).categories_values
    assert_equal %w(Project), users(:aaron).categories_values
  end
  
  def test_extract_due_date_from_name_with_idioms
    Time.stubs(:now).returns Time.parse('2007-01-01')
    
    task = Task.new :name => 'Do this for today'
    task.instance_eval{extract_due_date_from_name}
    assert_equal Date.today.to_s, task.due_on.to_s
    assert_equal 'Do this', task.name
    
    task = Task.new :name => 'Do this first day next month'
    task.instance_eval{extract_due_date_from_name}
    assert_equal Time.parse('2007-02-01').to_date, task.due_on
    assert_equal 'Do this', task.name

    task = Task.new :name => 'Test it never or die, tomorrow'
    task.instance_eval{extract_due_date_from_name}
    assert_equal Time.parse('2007-01-02').to_date, task.due_on
    assert_equal 'Test it never or die', task.name

    task = Task.new :name => 'Test it now, or die, tomorrow'
    task.instance_eval{extract_due_date_from_name}
    assert_equal Time.parse('2007-01-02').to_date, task.due_on
    assert_equal 'Test it now, or die', task.name
  end
  
  def test_extract_due_date_from_name_with_metric
    task = Task.new :name => 'Do this in 2 days'
    task.instance_eval{extract_due_date_from_name}
    assert_equal 2.days.since.to_date, task.due_on
    assert_equal 'Do this', task.name
    
    task = Task.new :name => 'Do this in chips'
    task.instance_eval{extract_due_date_from_name}
    assert_nil task.due_on
    
    task = Task.new :name => 'Do this in x apples'
    task.instance_eval{extract_due_date_from_name}
    assert_nil task.due_on
  end
  
  def test_do_not_extract_when_no_date
    task = Task.new :name => 'Add support for linking'
    task.instance_eval{extract_due_date_from_name}
    assert_nil task.due_on
    assert_equal 'Add support for linking', task.name

    task = Task.new :name => 'Add support for linking, or not'
    task.instance_eval{extract_due_date_from_name}
    assert_nil task.due_on
    assert_equal 'Add support for linking, or not', task.name

    task = Task.new :name => 'Add support for linking, or not, or... nevermind'
    task.instance_eval{extract_due_date_from_name}
    assert_nil task.due_on
    assert_equal 'Add support for linking, or not, or... nevermind', task.name
  end

  def test_set_kind
    task = Task.create :name => 'No date', :user => users(:quentin)
    assert_equal 'asap', task.kind
    task.due_on = Date.today
    task.save
    assert_nil task.kind
  end
end
