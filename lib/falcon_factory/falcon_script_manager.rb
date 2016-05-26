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

end
