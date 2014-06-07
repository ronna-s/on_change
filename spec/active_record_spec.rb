require 'active_record'
require 'rails'
load 'lib/on_change.rb'
require 'pry'
ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    encoding: 'utf8',
    database: ":memory:")

ActiveRecord::Schema.define do
  create_table :books do |t|
    t.string  :title
    t.integer :num_reads
    t.string :author
  end
end

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string  :first_name
    t.string  :last_name
    t.string  :email
  end
end

class Book < ActiveRecord::Base
  on_change :title, :num_reads do |model, attr_name, old_value, new_value|
    model.res1(attr_name, old_value, new_value)
  end
  on_change :num_reads, :author, :res2
  def res1(x,y,z);end
  def res2(x,y,z); end
end

class User < ActiveRecord::Base
  on_change :first_name, :last_name, :hello_user
  def hello_user(x,y,z); end
end

describe OnChange do

  it "should invoke on change callback for title" do
    b = Book.new
    expect(b).to receive(:res1).with("title", nil, "hello")
    b.title = "hello"
  end
  it "should invoke on change callback for title a second time" do
    b = Book.new
    b.title = "hello"
    expect(b).to receive(:res1).with("title", "hello", "world")
    b.title = "world"
  end
  it "should invoke on change callback for title" do
    b = Book.new
    expect(b).to receive(:res1).with("title", nil, "hello")
    b.title = "hello"
  end

  it "should invoke on 2 callbacks for num_reads" do
    b = Book.new
    expect(b).to receive(:res1).with("num_reads", nil, 1)
    expect(b).to receive(:res2).with("num_reads", nil, 1)
    b.num_reads = 1
  end

  it "should invoke on 2 callbacks for num_reads" do
    b = Book.new
    expect(b).to receive(:res1).with("num_reads", nil, 1)
    expect(b).to receive(:res2).with("num_reads", nil, 1)
    b.num_reads = 1
  end

  it "should not invoke callbacks for user" do
    u = User.new
    expect(u).to receive(:hello_user).with("first_name", nil, "john")
    expect(u).to receive(:hello_user).with("last_name", nil, "doe")
    u.first_name = "john"
    u.last_name = "doe"
    u.email = "john@doe.com"
  end

end