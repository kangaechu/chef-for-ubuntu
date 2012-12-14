maintainer       "Sytse Sijbrandij"
maintainer_email "support@gitlab.com"
license          "Apache 2.0"
description      "Installs/Configures gitlab"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.1"
%w{ gitolite nginx }.each do |cb_conflict|
  conflicts cb_conflict
end
%w{ ruby_build git redisio build-essential python readline sudo openssh perl xml zlib aws}.each do |cb_depend|
  depends cb_depend
end
%w{ amazon debian ubuntu }.each do |os|
  supports os
end
