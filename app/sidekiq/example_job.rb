class ExampleJob
  include Sidekiq::Job

  def perform(*args)
    puts "Performing a background job with args: #{args.inspect}"
  end
end
