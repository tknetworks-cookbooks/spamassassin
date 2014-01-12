#
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
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
include_recipe 'spamassassin::default'

case node['platform']
when 'debian'
  %w{
    libencode-detect-perl
    libmecab-perl
    mecab-ipadic-utf8
  }.each do |pkg|
    package pkg do
      action :install
    end
  end

  patch_file = "#{Chef::Config[:file_cache_path]}/ja.patch"
  patch = remote_file patch_file do
    source node['spamassassin']['3.3']['ja_patch_url']
    backup false
    mode '0600'
    not_if do
      ::File.exists?(patch_file)
    end
  end
  patch.run_action(:create_if_missing)

  # patching ja.patch
  bash 'apply-sa-ja.patch' do
    user 'root'
    code "/usr/bin/patch -p2 < #{patch_file}"
    cwd '/usr/share/perl5'
    not_if 'test -f /usr/share/perl5/Mail/SpamAssassin/Plugin/Tokenizer/MeCab.pm'
    notifies :restart, 'service[spamassassin]'
  end

  template "#{node['spamassassin']['dir']}/tokenizer.pre" do
    source "tokenizer.pre.erb"
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[spamassassin]'
  end
end
