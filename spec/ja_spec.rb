#
# Author:: TANABE Ken-ichi (<nabeken@tknetworks.org>)
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
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
      node.set['spamassassin']['use_ja_patch'] = true
    end
  }

  context 'before patching' do
    before do
      stub_command('test -f /usr/share/perl5/Mail/SpamAssassin/Plugin/Tokenizer/MeCab.pm').and_return(false)
      chef_run.converge('spamassassin::ja')
    end

    it 'should install dependencies for japanese patch' do
      %w{
        libencode-detect-perl
        libtext-mecab-perl
        mecab-ipadic-utf8
      }.each do |pkg|
        expect(chef_run).to install_package pkg
      end
    end

    it 'should patch a japanese support' do
      bash = chef_run.find_resource('bash', 'apply-sa-ja.patch')
      expect(chef_run).to run_bash('apply-sa-ja.patch')
      .with(
        user: 'root',
        cwd: '/usr/share/perl5'
      )
      expect(bash).to notify('service[spamassassin]').to(:restart)
    end

    it 'should configure tokenizer' do
      expect(chef_run).to render_file("#{chef_run.node['spamassassin']['dir']}/tokenizer.pre")
      .with_content("loadplugin Mail::SpamAssassin::Plugin::Tokenizer::#{chef_run.node['spamassassin']['tokenizer']}")
      expect(chef_run.template("#{chef_run.node['spamassassin']['dir']}/tokenizer.pre")).to notify('service[spamassassin]').to(:restart)
    end

    it "should configure spamassassin" do
      local_cf = "#{chef_run.node['spamassassin']['dir']}/local.cf"
      [
        /^ok_languages en ja$/,
        /^ok_locales en ja$/,
      ].each do |l|
        expect(chef_run).to render_file(local_cf)
        .with_content(l)
      end
      expect(chef_run.template(local_cf)).to notify('service[spamassassin]').to(:restart)
    end
  end

  context 'after patching' do
    before do
      stub_command('test -f /usr/share/perl5/Mail/SpamAssassin/Plugin/Tokenizer/MeCab.pm').and_return(true)
      chef_run.converge('spamassassin::ja')
    end

    it 'should not patch a japanese support' do
      expect(chef_run).not_to run_bash('apply-sa-ja.patch')
    end
  end
end
