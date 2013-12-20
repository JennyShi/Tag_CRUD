require 'rally_api_emc_sso'
require 'csv'

require './Tag_CRUD.rb'

# Default workspace is set to "Workspace 1" and project is set to "Rohan-test"
def start
  puts "Enter Workspace: 1. Workspace 1 \t2. USD"
  choice = gets.chomp

  case choice
  when "1" #Choose workspace 1
      
      @workspace = "Workspace 1"
      puts "Enter Project:"
      
      @project = gets.chomp
      puts "Enter your file name:#csv"
      
      file_name = gets.chomp
     # puts "Enter command : 1. Update\t2. Read"
     # command = gets.chomp
      
      read_file(file_name)
      puts @rows
      
      puts "Workspace #{@workspace}"
      puts "Project #{@project}"
      puts "\n"
        
      tag_crud = Tag_CRUD.new(@workspace, @project)
      
      @iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
      while @iCount < @rows.length
        tag_crud.setup(@rows[@iCount])
        @iCount += 1
      end
   when "2"
     @workspace = "USD"
      puts "Enter Project:"
      
      @project = gets.chomp
      puts "Enter your file name:#csv"
      
      file_name = gets.chomp
     # puts "Enter command : 1. Update\t2. Read"
     # command = gets.chomp
      
      read_file(file_name)
      puts @rows
      
      puts "Workspace #{@workspace}"
      puts "Project #{@project}"
      puts "\n"
        
      tag_crud = Tag_CRUD.new(@workspace, @project)
      
      @iCount = 0 #@iCount = 0 or rows.length-1
     #   puts @rows[@iCount]
      #  puts @rows.length
      while @iCount < @rows.length
        tag_crud.setup(@rows[@iCount])
        @iCount += 1
      end
   end
end


def read_file(file_name)
  input = CSV.read(file_name)
  header = input.first
  #puts header
  @rows = []
  (1...input.size).each { |i| @rows << CSV::Row.new(header, input[i]) }
end

start