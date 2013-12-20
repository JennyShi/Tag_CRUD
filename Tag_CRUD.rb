require 'rally_api_emc_sso' 
require 'date'
class Tag_CRUD
  
  def initialize (workspace,project)
    headers = RallyAPI::CustomHttpHeader.new()
    headers.name = 'My Utility'
    headers.vendor = 'MyCompany'
    headers.version = '1.0'

    #==================== Making a connection to Rally ====================
    config = {:base_url => "https://rally1.rallydev.com/slm"}
    config = {:workspace => workspace}
    config[:project] = project
    config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()

    @rally = RallyAPI::RallyRestJson.new(config)
    #puts "Workspace #{@workspace}"
    #puts "Project #{@project}"
  end
  
  def setup(row)
    if (is_userstory(row["Formatted ID"]))
      puts "is user story"
      type = "story"
      res = find_userstory(row)
      @object = res.first
      if (res.length != 0)
        find_tag(row)
        update_tag(row,type)
      else
        puts "Can't update Tags!"
      end
    else if (is_feature(row["Formatted ID"]))
      puts "is feature"
      type = "portfolioItem"
      res = find_feature(row)
      @object = res.first
      if (res.length != 0)
        result = find_tag(row)
        @tag = result.first
        puts @tag._ref
        update_tag(row,type)
      else
        puts "Can't update Tags!"
      end
    else
      puts "Not a userstory or a feature!"
    end
    end
  end
  
  def is_userstory(id)
    if((id[0..1].eql?("US") ) && (id[2..6]=~ /^[-+]?[0-9]+$/) )
      return true
    else
      return false
    end
  end
  
  def is_feature(id)
    if((id[0].eql?("F") ) && (id[1..id.length]=~ /^[-+]?[0-9]+$/) )
      return true
    else
      return false
    end
  end
  
  def find_userstory(row)
    query = RallyAPI::RallyQuery.new()
    query.type = "HierarchicalRequirement"
    query.fetch = "Name,FormattedID"
    query.query_string = "(FormattedID = \"#{row["Formatted ID"]}\")"
    results = @rally.find(query)
  
 # result.first.read
 # puts result.first.read.Children.size
  
    if (results.length != 0)
      results.each do |res|
        res.read
        puts "Find #{res.FormattedID}"
      end
    else
      puts "No such user story #{row["Formatted ID"]}"
    end
    results
  end
  
  def find_feature(row)
    query = RallyAPI::RallyQuery.new()
    query.type = "portfolioItem"
    query.fetch = "Name,FormattedID"
    query.query_string = "(FormattedID = \"#{row["Formatted ID"]}\")"
    results = @rally.find(query)
  
 # result.first.read
 # puts result.first.read.Children.size
  
    if (results.length != 0)
      results.each do |res|
        res.read
        puts "Find #{res.FormattedID}"
       # puts res.Tags.Name
      end
    else
      puts "No such feature #{row["Formatted ID"]}"
    end
    results
  end
  
  def update_tag(row,type)
    @object.read
    field = {}
    existing_tags = @object.Tags
    updated_tags = existing_tags
    
    if !updated_tags.results.count == 0 then
     updated_tags.push(@tag)
    else
     updated_tags = [@tag]
     puts "Inside else"
    end
    field["Tags"] = updated_tags
    puts "Updated Tags: #{updated_tags.count} and type is #{type} and tags is #{field["Tags"]} and ID: #{@object["FormattedID"]}"
    @rally.update("#{type}","FormattedID|#{@object["FormattedID"]}",field)
    puts "#{row["Formatted ID"  ]} updated"
  end
  
  def find_tag(row)
    query = RallyAPI::RallyQuery.new()
    query.type = "Tag"
    query.fetch = "Name"
    query.query_string = "(Name = \"#{row["Tags"]}\")"
    results = @rally.find(query)
    
    if (results != nil)
      #results.read
      puts "Find the tag #{row["Tags"]}!"
      results.each do |res|
        res.read
        puts "Name: #{res.Name}"
      end
    else
      puts "No such tag #{row["Tags"]}!"
    end
    results
  end
end