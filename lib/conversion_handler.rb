class ConversionHandler
  InvalidParams = Class.new(StandardError)

  attr_reader :params, :file, :from, :to

  def initialize(params)
    @params = params
    @file = params['file']
    @from = params['from']
    @to = params['to']
  end

  def run
    check_params

    encoded_file_path = TextFileEncoder.new(tempfile.path).encode
    return unless encoded_file_path
    return File.new(encoded_file_path) if same_format?

    response = RestClient::Request.execute(
      method: 'post',
      url: libreoffice_url,
      headers: {
        content_type: from,
        accept: to
      },
      payload: File.read(encoded_file_path),
      timeout: libreoffice_timeout
    )
    Tempfile.new.tap do |tempfile|
      tempfile.binmode
      tempfile.write(response.body)
      tempfile.close
    end
  end

  private

  def libreoffice_url
    'http://127.0.0.1:8080/converter/service'
  end

  def libreoffice_timeout
    timeout = params['timeout'].to_i
    timeout.zero? ? 180 : timeout
  end

  def response(status, message)
    [status, message]
  end

  def check_params
    raise InvalidParams, 'Required params: input (file), from (mime), to (mime)' if empty_file? ||
                                                                                    empty?(from) ||
                                                                                    empty?(to)
  end

  def empty?(str)
    return true if str.nil?

    str.length.zero?
  end

  def empty_file?
    return true if empty?(file)

    !tempfile.is_a?(Tempfile)
  end

  def tempfile
    file['tempfile']
  end

  def same_format?
    from == to
  end
end
