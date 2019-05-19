class SilentSystem
  def self.exec(cmd)
    system("#{cmd} > /dev/null")
  end
end
