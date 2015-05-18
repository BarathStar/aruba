require 'fileutils'
require 'erb'
require 'cgi'
require 'bcat/ansi'
require 'kramdown'
require 'rouge'
require 'aruba/spawn_process'

module Aruba
  module Reporting
    class << self
      def reports
        @reports ||= Hash.new do |hash, feature|
          hash[feature] = []
        end
      end
    end

    def pygmentize(file)
      warn('The use of "pygmentize" is deprecated. Use "syntax_highlighting" instead.')

      syntax_highlighting(file)
    end

    def syntax_highlight(file)
      source = File.read(file)
      formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
      lexer = Rouge::Lexers::Shell.new
      formatter.format(lexer.lex(source))
    end

    def title
      @scenario.title
    end

    def description
      text = @scenario.feature.legacy_conflated_name_and_description.gsub(/^(\s*)\\/, '\1')
      Kramdown::Document.new(text).to_html
    end

    def commands
      @commands || []
    end

    def output
      @aruba_keep_ansi = true # We want the output coloured!
      escaped_stdout = CGI.escapeHTML(all_stdout)
      html = Bcat::ANSI.new(escaped_stdout).to_html
      Bcat::ANSI::STYLES.each do |name, style|
        html.gsub!(/style='#{style}'/, %{class="xterm_#{name}"})
      end
      html
    end

    def report
      erb = ERB.new(template('main.erb'), nil, '-')
      erb.result(binding)
    end

    def files
      erb = ERB.new(template('files.erb'), nil, '-')
      file = current_directory
      erb.result(binding)
    end

    def again(erb, erbout, file)
      erbout.concat(erb.result(binding))
    end

    def children(dir)
      Dir["#{dir}/*"].sort
    end

    def template(path)
      IO.read(File.join(ENV['ARUBA_REPORT_TEMPLATES'], path))
    end

    def depth
      File.dirname(@scenario.feature.file).split('/').length
    end

    def index
      erb = ERB.new(template('index.erb'), nil, '-')
      erb.result(binding)
    end

    def index_title
      "Examples"
    end
  end
end

if ENV['ARUBA_REPORT_DIR']
  World(Aruba::Reporting)
  ENV['ARUBA_REPORT_TEMPLATES'] ||= File.dirname(__FILE__) + '/../../templates'

  After do |scenario|
    @scenario = scenario
    html_file = "#{scenario.feature.file}:#{scenario.location}.html"
    report_file = File.join(ENV['ARUBA_REPORT_DIR'], html_file)

    _mkdir(File.dirname(report_file))
    File.open(report_file, 'w') do |io|
      io.write(report)
    end

    Aruba::Reporting.reports[scenario.feature] << [scenario, html_file]

    FileUtils.cp_r(File.join(ENV['ARUBA_REPORT_TEMPLATES'], '.'), ENV['ARUBA_REPORT_DIR'])
    Dir["#{ENV['ARUBA_REPORT_DIR']}/**/*.erb"].each{|f| FileUtils.rm(f)}
  end

  at_exit do
    extend(Aruba::Reporting)

    index_file = File.join(ENV['ARUBA_REPORT_DIR'], "index.html")
    File.open(index_file, 'w') do |io|
      io.write(index)
    end
  end
end
