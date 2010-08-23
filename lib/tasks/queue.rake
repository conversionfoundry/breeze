namespace :breeze do
  namespace :queue do
  
    if defined? Resque
      desc "Run Resque worker"
      task :resque => :environment do
        require 'resque'
        require 'breeze'
        require 'breeze/queueing'
        require 'breeze/queueing/resque'

        worker = nil
        queues = (ENV['QUEUES'] || ENV['QUEUE'] || "breeze").to_s.split(',')

        begin
          worker = Resque::Worker.new(*queues)
          worker.verbose = ENV['LOGGING'] || ENV['VERBOSE']
          worker.very_verbose = ENV['VVERBOSE']
        rescue Resque::NoQueueError
          abort "set QUEUE env var, e.g. $ QUEUE=critical,high rake breeze:queue:resque"
        end

        worker.log "Starting worker #{worker}"

        worker.work(ENV['INTERVAL'] || 5) # interval, will block
      end
    end
  end
end
