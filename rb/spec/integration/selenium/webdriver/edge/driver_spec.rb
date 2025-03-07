# frozen_string_literal: true

# Licensed to the Software Freedom Conservancy (SFC) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The SFC licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require_relative '../spec_helper'

module Selenium
  module WebDriver
    module Edge
      describe Driver, exclusive: {browser: :edge} do
        it 'gets and sets network conditions' do
          driver.network_conditions = {offline: false, latency: 56, throughput: 789}
          expect(driver.network_conditions).to eq(
            'offline' => false,
            'latency' => 56,
            'download_throughput' => 789,
            'upload_throughput' => 789
          )
        end

        it 'sets download path' do
          driver.download_path = File.expand_path(__dir__)
          # there is no simple way to verify that it's now possible to download
          # at least it doesn't crash
        end

        it 'can execute CDP commands' do
          res = driver.execute_cdp('Page.addScriptToEvaluateOnNewDocument', source: 'window.was_here="TW";')
          expect(res).to have_key('identifier')

          begin
            driver.navigate.to url_for('formPage.html')

            tw = driver.execute_script('return window.was_here')
            expect(tw).to eq('TW')
          ensure
            driver.execute_cdp('Page.removeScriptToEvaluateOnNewDocument', identifier: res['identifier'])
          end
        end

        describe '#logs' do
          before do
            quit_driver
            options = Options.new(logging_prefs: {browser: 'ALL',
                                                  driver: 'ALL',
                                                  performance: 'ALL'})
            create_driver!(capabilities: options)
            driver.navigate.to url_for('errors.html')
          end

          after(:all) { quit_driver }

          it 'can fetch available log types' do
            expect(driver.logs.available_types).to include(:performance, :browser, :driver)
          end

          it 'can get the browser log' do
            driver.find_element(tag_name: 'input').click

            entries = driver.logs.get(:browser)
            expect(entries).not_to be_empty
            expect(entries.first).to be_kind_of(LogEntry)
          end

          it 'can get the driver log' do
            entries = driver.logs.get(:driver)
            expect(entries).not_to be_empty
            expect(entries.first).to be_kind_of(LogEntry)
          end

          it 'can get the performance log' do
            entries = driver.logs.get(:performance)
            expect(entries).not_to be_empty
            expect(entries.first).to be_kind_of(LogEntry)
          end
        end

        # This requires cast sinks to run
        it 'casts' do
          # Does not get list correctly the first time for some reason
          driver.cast_sinks
          sleep 2
          sinks = driver.cast_sinks
          unless sinks.empty?
            device_name = sinks.first['name']
            driver.start_cast_tab_mirroring(device_name)
            driver.stop_casting(device_name)
          end
        end
      end
    end # Edge
  end # WebDriver
end # Selenium
