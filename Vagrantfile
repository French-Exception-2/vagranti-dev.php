# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_VERSION = 2

ENV["LC_ALL"] = "en_US.UTF-8"

# Get this file directory
  dir = File.dirname(File.expand_path(__FILE__))

# Load Configuration & its Overload
  require 'json'
  vagrant_config = JSON.parse(File.read(File.join(dir,"\\instance\\config.json")))

Vagrant.configure(VAGRANT_VERSION) do |config|
# Global

  # Plugins

    # Networking plugin hostmanager #
        if Vagrant.has_plugin?('vagrant-hostmanager') && true == vagrant_config['vagrant']['plugins']['vagrant-hostmanager']['enabled']
          config.hostmanager.enabled             =   vagrant_config["vagrant"]["plugins"]["vagrant-hostmanager"]["config"]["hostmanager.enabled"] || false
          config.hostmanager.manage_host         =   vagrant_config["vagrant"]["plugins"]["vagrant-hostmanager"]["config"]["hostmanager.manage_host"] || false
          config.hostmanager.manage_guest        =   vagrant_config["vagrant"]["plugins"]["vagrant-hostmanager"]["config"]["hostmanager.manage_guest"] || false
        end

    # VB Guest
    
        if Vagrant.has_plugin?('vagrant-vbguest')  && true == vagrant_config['vagrant']['plugins']['vagrant-vbguest']['enabled']
            config.vbguest.auto_update              =   vagrant_config["vagrant"]["plugins"]["vagrant-vbguest"]["config"]["vbguest.auto_update"] || false
            config.vbguest.auto_reboot              =   vagrant_config["vagrant"]["plugins"]["vagrant-vbguest"]["config"]["vbguest.auto_reboot"] || false
            config.vbguest.installer_arguments      =   vagrant_config["vagrant"]["plugins"]["vagrant-vbguest"]["config"]["vbguest.installer_arguments"] || false
        end

    # Env dotfile

        if Vagrant.has_plugin?('vagrant-env')
            config.env.enable
        end

  # Virtual Machines
  # Iterate through nodes entry in JSON file
  vagrant_config["nodes"].each do |servername, server|
    
    if (!server['enabled'])
      next
    end
    
    srv_type_name = server['vagrant_type']
    srv_type = vagrant_config['nodes-types'][srv_type_name]
    instances_n = server['instances'].to_i
    
    (0..instances_n-1).each { |instance| 
      
      instance_str = format('%02d', instance)

      ip = server['ip'].gsub("\#{NUMBER}", (instance+server["ip.start"]).to_s)
     
      servername_real = server["name"]
        .gsub("\#{NUMBER}", instance_str)
        .gsub("\#{VAGRANTDEV_INSTANCE}", format('%02d', vagrant_config['vagrant']['instance']))
      
      config.vm.define servername_real, primary: (server['primary'] && instance == 0) do |srv|

        server = Vagrant::Util::DeepMerge.deep_merge(srv_type, server)

        srv.trigger.after :up, :reload do |trigger|
          trigger.ruby do |env,machine|
            puts "==> #{machine.name}: Updating your ssh config."            
            `pwsh ./bin/Update-MachineSshHostConfig.ps1 -FullName '#{machine.name}'`
            puts "==> #{machine.name}: Run 'ssh #{machine.name}' to connect to VM."
          end
        end
  
        srv.trigger.after :halt, :destroy do |trigger|
          trigger.ruby do |env,machine|
            puts "==> #{machine.name}: Removing in your ssh config."
            `pwsh ./bin/Remove-MachineSshHostConfig.ps1 -MachineName '#{machine.name}'`
          end
        end

        srv.vm.box = server['box']

        if (server['box_version']) 
          srv.vm.box_version = server['box_version']
        end

        srv.vm.network 'private_network', ip: ip
  
        srv.vm.network "public_network", bridge: server['bridge'] || ENV['vagrant_machine_default_bridge']

        srv.vm.hostname = servername_real
  
        srv.vm.provider "virtualbox" do |vb|
          vb.customize ["modifyvm", :id, "--cpuexecutioncap", server['cpucap']]
          vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
          vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
          vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
          vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
          vb.customize ["modifyvm", :id, "--ioapic", "on"]
          vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
          vb.customize ["modifyvm", :id, "--hpet", "on"]
          vb.customize ["modifyvm", :id, "--nestedpaging", "on"]
          vb.customize ["modifyvm", :id, "--largepages", "on"]
          vb.customize ["modifyvm", :id, "--vtxvpid", "on"]
          vb.customize ["modifyvm", :id, "--vtxux", "on"]
          vb.customize ["modifyvm", :id, "--pae", "on"]
          vb.customize ["modifyvm", :id, "--chipset", "ich9"]
          vb.customize ["modifyvm", :id, "--biosapic", "x2apic"]
          vb.customize ["modifyvm", :id, "--vrde", "off"]
          vb.customize ["modifyvm", :id, "--usb", "off"]
          vb.customize ["modifyvm", :id, "--ostype", server['os_type']]
          vb.customize ["modifyvm", :id, "--vram", server['vram_mb']]
          vb.customize ["modifyvm", :id, "--groups", "/" + (server['group'] ? server['group'] : vagrant_config['vagrant']['group']).gsub("\n",'').to_s]
          vb.customize ["modifyvm", :id, "--accelerate3d", server['3d']]
         
          if (server['bioslogoimagepath'] || srv_type['bioslogoimagepath'])
            vb.customize ["modifyvm", :id, "--bioslogoimagepath", File.expand_path(server['bioslogoimagepath'] || srv_type['bioslogoimagepath'])]
          end

          vb.memory = server["ram_mb"]
          vb.cpus   = server["vcpus"]
          vb.gui    = server["gui"]
        end # srv.vm.provider virtualbox
  
        if (server['files'])
          server['files'].each do |key,value|
            if (value['enabled'] && true != value['enabled'])
              next 
            end # if enabled
            srv.vm.provision "file", 
                                  source: value["source"], 
                                  destination: value["destination"]
          end # foreach files
  
        end # if files
  
        if (server['shared_folders'])
          server['shared_folders'].each do |key,value|
            if (value['enabled'] && true != value['enabled'])
              next 
            end # if enabled
  
            srv.vm.synced_folder value['host_path'], value['guest_path'], 
                                type: value['type'],
                                disabled: value["disabled"] || false
  
          end # each shared folder
        end # if shared folders
  
        if (server['provisioning'])
            
          os_type = server['os_type']
          os_version = server['os_version']
          
          server['provisioning'].each do |key,value|
            extension = value['ext'] || 'sh'
            if (server && server['provisioning'] && server['provisioning'][key]) then
              env = (value['env'] || {}).merge(server['provisioning'][key]).to_h
            else
              env = value['env'] || {}
            end
            if (value['reload:before'] && true == value['reload:before'])
              srv.vm.provision :reload
            end
            srv.vm.provision "shell", name: key, 
                                      path: "./provisioning/#{os_type}/#{os_version}/#{key}.#{extension}", 
                                      env: env, 
                                      privileged: value['privileged'] || false
  
            if (value['reload:after'] && true == value['reload:after'])
              srv.vm.provision :reload
            end # if reload after
          end # foreach provisioning
        end # if provisioning
      end # config.vm.define
    }
  end # servers.each
end