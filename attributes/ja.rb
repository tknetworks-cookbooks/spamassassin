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
default['spamassassin']['3.3']['ja_patch_url'] = "http://spamassassin.emaillab.jp/pub/ja-patch/sa3.3/spamassassin-3.3.2-ja-1.patch"
default['spamassassin']['tokenizer'] = 'MeCab'

if node['spamassassin']['use_ja_patch']
  default['spamassassin']['local']['normalize_charset'] = 1
  default['spamassassin']['local']['ok_languages'] << 'ja'
  default['spamassassin']['local']['ok_locales'] << 'ja'
end
