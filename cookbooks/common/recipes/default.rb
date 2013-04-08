#
# Cookbook Name:: common
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# apt-get update
execute "apt-get update" do
  command "apt-get -y update"
end

# apt-get upgrade
execute "apt-get upgrade" do
  command "apt-get -y upgrade"
end

# Package install
%w{wget vim}.each do |package_name|
  package package_name do
    action :install
  end
end
