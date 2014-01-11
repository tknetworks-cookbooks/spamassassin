maintainer       "TANABE Ken-ichi"
maintainer_email "nabeken@tknetworks.org"
license          "Apache 2.0"
description      "Installs/Configures spamassassin"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
name             "spamassassin"

%w{
  debian
}.each do |os|
  supports os
end

%w{
  apt
}.each do |c|
  depends c
end