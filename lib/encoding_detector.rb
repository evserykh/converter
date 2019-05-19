class EncodingDetector
  attr_reader :path, :enca_lang

  def initialize(path, enca_lang = 'none')
    @path = path
    @enca_lang = enca_lang
  end

  def detect
    matched_rule = rules.detect do |_, rule|
      enca_encoding.match?(rule['enca']) && uchardet_encoding.match?(rule['uchardet'])
    end

    matched_rule&.first
  end

  private

  def enca?
    SilentSystem.exec('which enca')
  end

  def uchardet?
    SilentSystem.exec('which uchardet')
  end

  def enca_encoding
    @enca_encoding ||= enca? ? `enca -L #{enca_lang} #{path}` : nil
  end

  def uchardet_encoding
    @uchardet_encoding ||= uchardet? ? `uchardet #{path}` : nil
  end

  def rules
    {
      'utf-8' => { 'enca' => /utf-8/i, 'uchardet' => /utf-8/i },
      'utf-16' => { 'enca' => /Universal character set 2 bytes/i, 'uchardet' => /utf-16/i },
      'cp1251' => { 'enca' => /MS-Windows code page 1251/i, 'uchardet' => /windows-1251/i },
      'cp866' => { 'enca' => %r{IBM/MS code page 866}i, 'uchardet' => /IBM866/i },
      'cp1252' => { 'enca' => /ASCII/i, 'uchardet' => /ascii/i }
    }
  end
end
