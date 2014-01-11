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
default['spamassassin']['dir'] = '/etc/spamassassin'
default['spamassassin']['enable'] = true
default['spamassassin']['use_ja_patch'] = false
default['spamassassin']['user'] = 'debian-spamd'
default['spamassassin']['options'] = %w{
  --create-prefs
  --max-children 5
  --helper-home-dir
}
default['spamassassin']['enable_cron'] = false
default['spamassassin']['local']['report_safe'] = 0
default['spamassassin']['local']['use_bayes'] = 1
default['spamassassin']['local']['bayes_auto_learn'] = 1
default['spamassassin']['local']['ok_languages'] = %w{en}
default['spamassassin']['local']['ok_locales'] = %w{en}
