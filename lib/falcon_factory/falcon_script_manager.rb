class FalconScriptManager

  def initialize(file_name)
    @file = File.new(file_name, "w")
  end

  def write_to_file(line)
    @file.puts(line)
  end

  def close_file
    @file.close
  end

  def write_script_to_add_relation_line_in_model(model,line_content)
    model_file_name = "app/models/#{model}.rb"
    add_relation_command = "awk 'NR==2{print \"#{line_content}\"}1' #{model_file_name} > newfile"
    write_to_file(add_relation_command)
    add_relation_command = "rm #{model_file_name}"
    write_to_file(add_relation_command)
    add_relation_command = "mv newfile #{model_file_name}"
    write_to_file(add_relation_command)

  end

  def write_script_to_add_query_support(model_name)
    model_capitalized = model_name.slice(0,1).capitalize + model_name.slice(1..-1)
    query_support_line_content =     "@#{model_name.pluralize} = #{model_capitalized}.where(params[:where]).offset(params[:offset]).limit(params[:limit]).order(params[:order])"
    controller_file_name = "app/controllers/#{model_name.pluralize}_controller.rb"
    add_query_command = "awk 'NR==7{print \"#{query_support_line_content}\"}1' #{controller_file_name} > newfile"
    write_to_file(add_query_command)
    add_query_command = "rm #{controller_file_name}"
    write_to_file(add_query_command)
    add_query_command = "mv newfile #{controller_file_name}"
    write_to_file(add_query_command)
    add_query_command = "sed -i.bak -e  '6d' #{controller_file_name}"
    write_to_file(add_query_command)
    add_query_command = "rm #{controller_file_name}.bak"
    write_to_file(add_query_command)
  end

end
