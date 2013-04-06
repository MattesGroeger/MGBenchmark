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
  buildAndLogScheme("Tests")
end

task :default => :build

def buildAndLogScheme(name)
  workspace = Dir["*.xcworkspace"].first
  scheme = workspace.gsub(".xcworkspace", name)
  result = compile(workspace, scheme)
  log(scheme, result)
end

def log(scheme, result)
  scheme = "Default" if scheme == ""
  puts "#{scheme}: #{result == 0 ? 'PASSED'.green : 'FAILED'.red}"
end

def compile(workspace, scheme)
  command = "xcodebuild -workspace #{workspace} -scheme #{scheme} -configuration Debug -sdk iphonesimulator -verbose" 
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