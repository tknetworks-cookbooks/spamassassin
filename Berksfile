site :opscode

metadata

%w{
  debian
}.each do |c|
  cookbook c, git: "git://github.com/tknetworks-cookbooks/#{c}.git"
end

group :integration do
  cookbook 'apt'
  cookbook 'minitest-handler'

  %w{
  }.each do |c|
    cookbook c, git: "git://github.com/tknetworks-cookbooks/#{c}.git"
  end
end
