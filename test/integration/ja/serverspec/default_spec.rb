#
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
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
  let(:spamd_args) { "--create-prefs --max-children 5 --helper-home-dir -u debian-spamd" }

  describe package('spamassassin') do
    it { should be_installed }
  end

  describe file('/etc/spamassassin/local.cf') do
    it { should be_file }

    its(:content) {
      [
        'report_safe 0',
        'use_bayes 1',
        'bayes_auto_learn 1',
        'bayes_ignore_header X-Bogosity',
        'bayes_ignore_header X-Spam-Flag',
        'bayes_ignore_header X-Spam-Status',
        /ok_languages en/,
        /ok_locales en/,
      ].each do |l|
        should match l
      end
    }
  end

  describe file('/etc/default/spamassassin') do
    it { should be_file }
    its(:content) {
      ['ENABLED=1', %Q{OPTIONS="#{spamd_args}"}].each do |l|
        should match l
      end
    }
  end

  describe service('spamassassin') do
    it {
      should be_enabled
      should be_running
    }
  end

  context 'spamd' do
    spamd = process('/usr/sbin/spamd')

    describe spamd do
      its(:user) { should eq "root" }
      its(:args) { should eq "/usr/sbin/spamd #{spamd_args} -d --pidfile=/var/run/spamd.pid" }
    end

    describe command("ps --ppid #{spamd.pid} -o user=") do
      it { should return_stdout /debian-spamd/ }
    end
  end
end
