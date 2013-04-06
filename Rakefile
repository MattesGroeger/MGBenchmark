class String
  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def red
    self.class.colorize(self, 31)
  end

  def green
    self.class.colorize(self, 32)
  end
end

desc 'Run the tests'
task :test do
  test_result = compile_tests()

  puts "\n\n\n" if verbose
  puts "iOS: #{test_result == 0 ? 'PASSED'.green : 'FAILED'.red}"
end

task :default => :test

def compile_tests
  command = "xcodebuild -workspace MGBenchmark.xcworkspace -scheme MGBenchmarkTests -configuration Debug -sdk iphonesimulator" 
  IO.popen(command) do |io|
    while line = io.gets do
      puts line
      if line == "** BUILD SUCCEEDED **\n"
        return 0
      elsif line == "** BUILD FAILED **\n"
        return 1
      end
    end
  end
end
