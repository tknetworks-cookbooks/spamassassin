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
require 'spec_helper'

describe 'spamassassin::default' do
  include_context 'debian'

  let (:chef_run) {
    ChefSpec::Runner.new() do |node|
      set_node(node)
      node.set['spamassassin']['local']['bayes_ignore_header'] = %w{
        X-Bogosity
        X-Spam-Flag
        X-Spam-Status
      }
    end
  }

  before do
    chef_run.converge('spamassassin::default')
  end

  it "should install spamassassin package" do
    expect(chef_run).to install_package "spamassassin"
  end

  it "should configure spamassassin" do
    local_cf = "#{chef_run.node['spamassassin']['dir']}/local.cf"
    [
      'report_safe 0',
      'use_bayes 1',
      'bayes_auto_learn 1',
      'bayes_ignore_header X-Bogosity',
      'bayes_ignore_header X-Spam-Flag',
      'bayes_ignore_header X-Spam-Status',
      /^ok_languages en$/,
      /^ok_locales en$/,
    ].each do |l|
      expect(chef_run).to render_file(local_cf)
      .with_content(l)
    end
    expect(chef_run.template(local_cf)).to notify('service[spamassassin]').to(:restart)
  end

  it "should enable/run spamassassin service" do
    ['ENABLED=1', 'OPTIONS="--create-prefs --max-children 5 --helper-home-dir -u debian-spamd"'].each do |l|
      expect(chef_run).to render_file("/etc/default/spamassassin")
      .with_content(l)
    end

    expect(chef_run).to enable_service "spamassassin"
    expect(chef_run.template('/etc/default/spamassassin')).to notify('service[spamassassin]').to(:restart)
    expect(chef_run).to start_service "spamassassin"
  end
end
