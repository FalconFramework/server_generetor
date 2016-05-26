require 'open3'
class FalconScriptManager

  def run_line(line)
    Open3.popen3("#{line}") do |stdout, stderr, status, thread|
      while line=stderr.gets do
        puts(line)
      end
    end
    # puts %x()
  end

  def run_script_to_add_relation_line_in_model(target_path,model,line_content)
    model_file_name = "#{target_path}/app/models/#{model}.rb"
    add_relation_command = "awk 'NR==2{print \"#{line_content}\"}1' #{model_file_name} > newfile"
    run_line(add_relation_command)
    add_relation_command = "rm #{model_file_name}"
    run_line(add_relation_command)
    add_relation_command = "mv newfile #{model_file_name}"
    run_line(add_relation_command)

  end

  def run_script_to_add_query_support(target_path,model_name)
    model_capitalized = model_name.slice(0,1).capitalize + model_name.slice(1..-1)
    query_support_line_content =     "@#{model_name.pluralize} = #{model_capitalized}.where(params[:where]).offset(params[:offset]).limit(params[:limit]).order(params[:order])"
    controller_file_name = "#{target_path}/app/controllers/#{model_name.pluralize}_controller.rb"
    add_query_command = "awk 'NR==7{print \"#{query_support_line_content}\"}1' #{controller_file_name} > newfile"
    run_line(add_query_command)
    add_query_command = "rm #{controller_file_name}"
    run_line(add_query_command)
    add_query_command = "mv newfile #{controller_file_name}"
    run_line(add_query_command)
    add_query_command = "sed -i.bak -e  '6d' #{controller_file_name}"
    run_line(add_query_command)
    add_query_command = "rm #{controller_file_name}.bak"
    run_line(add_query_command)
  end

end
