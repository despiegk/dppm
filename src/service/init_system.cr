module Service::InitSystem
  getter name : String,
    file : Path,
    boot_file : Path

  private abstract def config_parse(io : IO)
  private abstract def config_build(io : IO)

  getter config : Config do
    if @file && File.exists? @file.to_s
      File.open @file.to_s do |io|
        config_parse io
      end
    else
      Config.new
    end
  end

  def type : String
    self.class.type
  end

  def boot? : Bool
    File.exists? @boot_file.to_s
  end

  def exists? : Bool
    File.symlink?(@file.to_s) || File.exists?(@file.to_s)
  end

  def writable? : Bool
    File.writable? @file.to_s
  end

  def creatable? : Bool
    File.writable? @file.dirname
  end

  def boot(value : Bool) : Bool
    case value
    when boot? # nothing to do
    when true  then File.symlink @file.to_s, @boot_file.to_s
    when false then File.delete @boot_file.to_s
    end
    value
  end

  def real_file : String
    File.real_path @file.to_s
  end

  private def delete_internal
    stop if run?
    boot false if boot?
    File.delete @file.to_s if exists?
  end

  def check_delete
    if !writable?
      raise "Root execution needed for system service deletion: " + name
    elsif !exists?
      raise "Service doesn't exist: " + name
    end
  end
end
