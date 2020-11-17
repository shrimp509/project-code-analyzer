
class CodeCounter
  def initialize root_path, file_type
    @dir = Dir[File.join(root_path, "**/*.#{file_type}")]
    @sum = 0
    @hash = {}
  end

  def count
    @dir.each do |file|
      lines = File.readlines(file).count
      @sum += lines
      @hash.merge!({file => lines})
    end
    [@sum, @hash]
  end
end

class ProjectLinesAnalyzer

  def self.main
    @lines, @details = CodeCounter.new(project_path_from_cmd, file_type_from_cmd).count
    show_details
    show_lines_result
  end

  private
  def self.project_path_from_cmd
    raise params_error_msg if ARGV.length == 0
    return ARGV[0]
  end

  def self.file_type_from_cmd
    return (ARGV[1] || 'rb')
  end

  def self.params_error_msg
    "歡迎使用 ProjectLinesCounter，此小工具接受兩個參數：
    - project_path: 計算此路徑底下所有的程式碼行數
    - file_type: 想要計算的程式碼類型，若不輸入，預設為 rb 類型的檔案
    使用範例： `$ ruby count_lines.rb /Users/rongson/RailsProjects rb`"
  end

  def self.show_details
    @details.sort_by {|k,v| v}.each { |pair| puts "#{pair.first}: #{pair.last}" }
  end

  def self.seperate_comma n
    n.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(',').reverse
  end

  def self.show_lines_result
    result_msg = "  [*] 執行完成：#{project_path_from_cmd} 專案底下的 .#{file_type_from_cmd} 程式碼，總共 `#{seperate_comma(@lines)}` 行"
    brackets_count = result_msg.length + 20
    puts '=' * brackets_count
    puts result_msg
    puts '=' * brackets_count
  end
end

ProjectLinesAnalyzer.main
