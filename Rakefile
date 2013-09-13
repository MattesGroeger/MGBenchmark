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
task :build do
  buildAndLogScheme("")
  buildAndLogScheme("Example")
  buildAndLogScheme("Tests", true)
end

task :default => :build

def buildAndLogScheme(name, is_test = false)
  workspace = Dir["*.xcworkspace"].first
  scheme = workspace.gsub(".xcworkspace", name)
  result = compile(workspace, scheme, is_test)
  log(scheme, result)
end

def log(scheme, result)
  scheme = "Default" if scheme == ""
  puts "#{scheme}: #{result == 0 ? 'PASSED'.green : 'FAILED'.red}"
end

def compile(workspace, scheme, is_test)
  command = "xcodebuild -workspace #{workspace} -scheme #{scheme} -configuration Release -sdk iphonesimulator -verbose" 
  command << " ONLY_ACTIVE_ARCH=NO TEST_AFTER_BUILD=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES" if is_test
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
