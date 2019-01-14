module Database::Base
  getter uri : URI,
    user : String

  private def database_exists_error
    raise "database already exists in #{@uri}: #{@user}"
  end

  private def users_exists_error
    raise "user already exists in #{@uri}: #{@user}"
  end

  def vars
    {
      "database_address" => "[#{@uri.host}]:#{@uri.port}",
      "database_port"    => @uri.port.to_s,
      "database_host"    => @uri.host.not_nil!,
      "database_user"    => @user,
      "database_name"    => @user,
      "database_type"    => @uri.scheme.not_nil!,
    }
  end
end