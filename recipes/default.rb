#
# Author:: TANABE Ken-ichi (<nabeken@tknetworks.org>)
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

case node['platform']
when 'debian'
  package 'spamassassin' do
    action :install
  end

  template '/etc/default/spamassassin' do
    owner 'root'
    group 'root'
    mode '644'
    source 'spamassassin.erb'
    notifies :restart, 'service[spamassassin]'
  end

  template "#{node['spamassassin']['dir']}/local.cf" do
    owner 'root'
    group 'root'
    mode '0644'
    source 'local.cf.erb'
    variables :settings => node['spamassassin']['local']
    notifies :restart, 'service[spamassassin]'
  end

  service 'spamassassin' do
    action [:enable, :start]
  end
end
