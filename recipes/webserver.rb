# Copyright 2015 Sergey Bahchissaraitsev

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if (node["airflow"]["init_system"] == "upstart")
  service_target = "/etc/init/airflow-webserver.conf"
  service_template = "init_system/upstart/airflow-webserver.conf.erb"

  prep_service_target = "/etc/init/airflow-webserver-prep.conf"
  prep_service_template = "init_system/upstart/airflow-webserver-prep.conf.erb"
else
  service_target = "/usr/lib/systemd/system/airflow-webserver.service"
  service_template = "init_system/systemd/airflow-webserver.service.erb"
end

template prep_service_target do
  source prep_service_template
  owner "root"
  group "root"
  mode "0644"
  variables({
    :user => node["airflow"]["user"],
    :group => node["airflow"]["group"],
    :run_path => node["airflow"]["run_path"],
    :bin_path => node["airflow"]["bin_path"]
  })
end

template service_target do
  source service_template
  owner "root"
  group "root"
  mode "0644"
  variables({
    :user => node["airflow"]["user"],
    :group => node["airflow"]["group"],
    :locale => node["airflow"]["locale"],
    :run_path => node["airflow"]["run_path"],
    :bin_path => node["airflow"]["bin_path"]
  })
end

service "airflow-webserver" do
  action [:enable]
end

service "airflow-webserver-prep" do
  action [:enable]
end