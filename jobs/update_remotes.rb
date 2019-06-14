require_relative '../config/require'
$stdout.sync = true
logger = Zold::Log::Regular.new
network = 'zold'
home = HOME
remotes = Zold::Remotes.new(File.join(home, 'remotes'), network: network)
cmd = Zold::Remote.new(remotes: remotes, log: logger)
cmd.run(['remote', 'update', "--network=#{network}", "--min-score=8"])

