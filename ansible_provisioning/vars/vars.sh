
# ###########################################################################################################################################################
# #                                                              !!!SET VARS HERE!!!                                                                      # #
# #   Vars must be set in order for ansible deploy to work. If you are unsure about what these VARS do, search for them in the project and get familiar.  # #
#############################################################################################################################################################


# GENERAL VARS
userid=$(whoami)
homedir=/home/$userid/repos/rancher_poc-1
public_ip=$(curl icanhazip.com) 
admin_pub_ip=$(echo ['"'$public_ip/32'"'])

# VAULT AUTH
source $homedir/ansible_provisioning/wrapper-scripts/vault-auth.sh

# ANSIBLE VARS
ANSIBLE_SUDO_PASS=rancherprd1234!
ANSIBLE_SSH_USER=rancher
SSH_PORT=22
container_volumes_location=/home/ubuntu/container-program-files

# INSTANCE IP's
master_node=192.168.0.34
worker_node_1=192.168.0.35
worker_node_2=192.168.0.36 #DB 