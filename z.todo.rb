#!/usr/bin/env ruby
require 'tempfile'
require 'fileutils'

class Item
  attr_accessor :value
  def initialize(value)
    @value = value
   # @status = value
  end

end

class Todo
  attr_accessor :items

  def initialize(options = {})
    @options, @items = options, []
    is_todo_list_present?
    load_file
  end

  FILE = File.expand_path('.todos')

  def add(todo)
    @items << Item.new(todo)
    save_todo(todo)
  end

  def delete(line)
    tmp = Tempfile.new("todo_temp")
    open(file, "r").each.with_index do |l, index|
      tmp << l unless line.to_i == index+1
    end
    tmp.close
    FileUtils.mv(tmp.path, file)

  end

  def list
    @items.each.with_index do |todo, index|
      puts "[#{index+1}]: #{todo}"
    end
  end

  def clear
    File.open(file, "w") do |f|
     f.truncate(0)
    end
  end

  def file
    @file ||= File.exist?(FILE) ? FILE : "#{ENV['HOME']}/.todos"
  end

  private

  def is_todo_list_present?
    return if File.exist?(file)
  end

  def load_file
    File.open(file, 'r') do |f|
      f.each do |line|
        @items << line
      end
    end
  end

#Åpner opp lagringsfila og lagrer todo'en
  def save_todo(todo)
    File.open(file, "a") do |f|
      f.write("#{todo} \n")
    end
  end
end

  def intro
    line =  "-----------------------------------------"
    puts line
    puts "z.Todo"
    puts line
    puts "Usage:"
    puts " add 'todo'  | Adds a new todo"
    puts " delete 'n'  | Deletes a todo"
#  puts " edit 'n'    | Edit a todo"
#  puts " done 'todo' | Mark todo as done"
    puts " list        | List all todos"
    puts " clear       | Clear the todolist"
    puts line
  end


case ARGV[0]
  when 'add', 'a'
    if ARGV[1] == nil
      puts "No todo added. To add todo, use: 'add', followed with the todo item. "
    else
    puts "Added todo: #{ARGV[1]}"
    Todo.new.add(ARGV[1])
    end
  when 'list', 'l'
    puts "Showing todos-items:"
    Todo.new.list
#  when 'done'
#    puts "Ferdig med todo"
  when 'delete', 'del', 'd'
    puts "Deleted todo-item"
      Todo.new.delete(ARGV[1])
#  when 'edit', 'e'
#    puts "Edit valgte todo"
  when 'clear'
    puts "Deleted todo-list"
    Todo.new.clear
  else
    intro
end
