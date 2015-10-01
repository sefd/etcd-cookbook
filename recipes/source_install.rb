# Encoding: UTF-8
#
#
# Installs etcd from source
#

include_recipe 'git'
include_recipe 'golang'

# checkout from git
git "#{Chef::Config[:file_cache_path]}/etcd" do
  repository node[:etcd][:source][:repo]
  reference node[:etcd][:source][:revision]
  action :sync
  notifies :run, 'bash[compile_etcd]'
end

# build and 'install'
bash 'compile_etcd' do
  user 'root'
  cwd "#{Chef::Config[:file_cache_path]}/etcd"
  code <<-EOH
  ./build
  mv ./bin/etcd /usr/local/bin/
  mv ./bin/etcdctl /usr/local/bin
  EOH

  not_if "type etcd && type etcdctl"
end
