# Input/output helpers shared by every screen.
module UI
  class << self
    attr_accessor :fast # skip typewriter delays (dev mode / tests)

    def slow_print(text, delay = 0.02)
      if fast
        puts text
        return
      end
      text.each_char do |c|
        print c
        $stdout.flush
        sleep(delay)
      end
      puts
    end

    def pause
      print "\n[Press Enter to continue]"
      $stdin.gets
    end

    def clear
      system("clear") || system("cls")
    end

    def header(text)
      puts "=" * 40
      puts text.center(40)
      puts "=" * 40
    end

    # Reads a line; exits cleanly on EOF (Ctrl-D).
    def read(label = "> ")
      print "\n#{label}"
      line = $stdin.gets
      exit if line.nil?
      line.strip.downcase
    end

    # Keeps asking until the answer is in `options`.
    def choose(options)
      loop do
        input = read
        return input if options.include?(input)

        puts "Please choose one of: #{options.join(', ')}"
      end
    end

    def ask(label)
      print label
      ($stdin.gets || "").strip
    end
  end
end
