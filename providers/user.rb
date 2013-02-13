action :create do

  cmd = if user_exists? new_resource.name
    usermod( new_resource.name, new_resource.password, new_resource.chroot_to )
  else
    useradd( new_resource.name, new_resource.password, new_resource.chroot_to )
  end

  directory new_resource.chroot_to do
    owner node['pureftpd']['ftp_user']
    group node['pureftpd']['ftp_group']
  end

  execute "Create pure-fptd user #{new_resource.name}" do
    command cmd
  end

  new_resource.updated_by_last_action(true) 
end

action :delete do
  cmd = userdel new_resource.name

  execute "Delete pure-fptd user #{new_resource.name}" do
    command cmd
  end

  new_resource.updated_by_last_action(true) 
end

def user_exists? login
  system "pure-pw show #{login} > /dev/null 2>&1"
  $?.exitstatus == 0 ? true : false
end

def useradd login, password, chroot_to
  "echo -e \"#{password}\n#{password}\" | pure-pw useradd #{login} -f #{node['pureftpd']['passwd']} -d #{chroot_to} -u #{node['pureftpd']['ftp_user']} -g #{node['pureftpd']['ftp_group']} -m"
end

def usermod login, password, chroot_to
  "echo -e \"#{password}\n#{password}\" | pure-pw usermod #{login} -f #{node['pureftpd']['passwd']} -d #{chroot_to} -u #{node['pureftpd']['ftp_user']} -g #{node['pureftpd']['ftp_group']} -m"
end

def userdel login
  "pure-pw userdel #{login} -m"
end
