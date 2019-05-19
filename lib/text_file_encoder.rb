class TextFileEncoder
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def encode
    return path unless text?
    return path if utf8?

    converted_to_utf8_path
  end

  private

  def mime
    @mime ||= `file -i #{path}`
  end

  def text?
    mime.match(%r{text/plain})
  end

  def encoding
    @encoding ||= EncodingDetector.new(path, 'ru').detect
  end

  def utf8?
    encoding == 'utf-8'
  end

  def iconv_command(output)
    @iconv_command ||= begin
                         cmd = ['iconv', '-c']
                         cmd += ['-f', encoding] if encoding
                         cmd += ['-t', 'utf-8', '-o', output]
                         cmd << path
                         cmd.join(' ')
                       end
  end

  def converted_to_utf8_path
    return nil unless SilentSystem.exec('which iconv')

    output = "#{path}-utf8"
    cmd = iconv_command(output)
    StdoutLogger.info(cmd)
    output if SilentSystem.exec(cmd)
  end
end
