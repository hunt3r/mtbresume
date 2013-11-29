#PMBA B1tch


deploy_to_host = "blog.chrishunters.com"
deploy_to_port = 22
deploy_to_path = "/usr/share/nginx/www/2013mtb"
public_src = "_site" #should match destination in config

desc "Generate a new public site from source."
task :generate do
  system('jekyll')
end

desc "Run the jekyll server for testing"
task :server do
  system('jekyll --server')
end

desc "Commit changes to repository"
task :commit do
  unless ENV.include?("message")
    raise "usage: rake commit message='<Your Message>'" 
  end
  message = ENV['message']
  puts "Syncing _public submodule repository with _site folder"
  system("rsync -zr --delete --exclude-from './_bin/rsync-excludes.txt' _site/* _public/.")
  system('git status')
  system('cd _public && git add -A && git commit -m"'+message+'" && git push')
  puts "Commit the main repository"
  system('git add -A && git add -A && git commit -m"'+message+'" && git push')
end

desc "Deploy this to server"
task :deploy do

#  description = "SCP #{public_src} to #{deploy_to_host}:#{deploy_to_port}#{deploy_to_path}/."

 # puts description
  puts "Are you sure? [y/n]"
  STDOUT.flush
  input = STDIN.gets.chomp
  if input == "y"
    puts "chose y"
    #system("scp -P#{deploy_to_port} #{public_src}/* #{deploy_to_host}:#{deploy_to_path}")
    system("rsync -avzr -e \"ssh -p #{deploy_to_port}\" --delete --exclude-from _site/* #{public_src} #{deploy_to_host}:#{deploy_to_path}/.")
  else
    puts "Didn't understand, giving up..."
  end

end