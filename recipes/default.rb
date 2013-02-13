#
# Cookbook Name:: pureftpd
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yumrepo::epel"

package "pure-ftpd"

group node['pureftpd']['ftp_group']

user  node['pureftpd']['ftp_user'] do
  gid   node['pureftpd']['ftp_group']
  shell "/sbin/nologin"
  home  "/dev/null"
end

template "/etc/pure-ftpd/pure-ftpd.conf" do
  source "pure-ftpd.conf.erb"
  variables({
              :ftp_user_id => %x( getent passwd #{node['pureftpd']['ftp_user']} | awk -F':' '{print $3}' )
            })
  mode   "0644"
  notifies :restart, "service[pure-ftpd]"
end

service "pure-ftpd" do
  action [ :enable, :start ]
end

