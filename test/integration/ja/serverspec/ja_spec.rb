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

describe 'spamassassin::ja' do
  %w{
    libencode-detect-perl
    libmecab-perl
    mecab-ipadic-utf8
  }.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe file('/etc/spamassassin/tokenizer.pre') do
      it { should be_file }
  end

  describe file('/etc/spamassassin/local.cf') do
    it { should be_file }
    [
      /^ok_languages en ja$/,
      /^ok_locales en ja$/,
    ].each do |l|
      its(:content) {
          should match l
      }
    end
  end

  describe file('/usr/share/perl5/Mail/SpamAssassin/Plugin/Tokenizer/MeCab.pm') do
    it { should be_file }
  end
end
