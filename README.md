

# HW-GFS2

Homework

Objective:
 - virtual machine with iscsi
 - 3 virtual machines with GFS2 shared file system on top of cLVM
 - fencing is disabled because of yandex cloud
 - terraform manifests
 - ansible role
 - README file









## Pre-requirements

To run this project, you will need to prepare your yandex cloud, 


and then set environment variables:
```
export TF_VAR_yc_token=$(yc iam create-token)
export TF_VAR_yc_cloud_id=$(yc config get cloud-id)
export TF_VAR_yc_folder_id=$(yc config get folder-id)
```
in this case the terraform.tfvars file is not needed






## Deployment

To deploy this project run

```bash
  git clone https://github.com/abelovn/hw-GFS2.git && cd  hw-GFS2/terraform/ && terraform init && terraform plan && terraform apply  -auto-approve 
```




All external and internal ip addresses will be shown in the output data. To test the stand operation, it is necessary to ssh to the jump-host, from which, in turn, you can also ssh to VMs with ISCSI and GFS2 by their internal ip-addresses or hostname.

To do this from the working folder of the project it is necessary to execute:
<external_ip_address_ansible> can be viewed in terraform output or the yc console.
```
 ssh cloud-user@<external_ip_address_ansible> -i id_rsa
```
Access via ssh to GFS2 storage nodes:

```
[cloud-user@ansible]$ ssh gfs-server0

[cloud-user@ansible]$ ssh gfs-server1

[cloud-user@ansible]$ ssh gfs-server2

[cloud-user@ansible]$ ssh iscsi
```
Next, from any node in the cluster, you can run

```
sudo pcs status --full

```

and get the full status of the cluster with running resources:

```
Cluster name: gfs2_cluster
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: 192.168.100.13 (3) (version 2.1.6-9.1.el8-6fdc9deea29) - partition with quorum
  * Last updated: Thu Dec  7 03:58:03 2023 on 192.168.100.18
  * Last change:  Thu Dec  7 03:50:18 2023 by root via cibadmin on 192.168.100.18
  * 3 nodes configured
  * 12 resource instances configured

Node List:
  * Node 192.168.100.11 (2): online, feature set 3.17.4
  * Node 192.168.100.13 (3): online, feature set 3.17.4
  * Node 192.168.100.18 (1): online, feature set 3.17.4

Full List of Resources:
  * Clone Set: locking-clone [locking]:
    * Resource Group: locking:0:
      * dlm     (ocf::pacemaker:controld):       Started 192.168.100.13
      * lvmlockd        (ocf::heartbeat:lvmlockd):       Started 192.168.100.13
    * Resource Group: locking:1:
      * dlm     (ocf::pacemaker:controld):       Started 192.168.100.11
      * lvmlockd        (ocf::heartbeat:lvmlockd):       Started 192.168.100.11
    * Resource Group: locking:2:
      * dlm     (ocf::pacemaker:controld):       Started 192.168.100.18
      * lvmlockd        (ocf::heartbeat:lvmlockd):       Started 192.168.100.18
  * Clone Set: shared_vg-clone [shared_vg]:
    * Resource Group: shared_vg:0:
      * shared_lv       (ocf::heartbeat:LVM-activate):   Started 192.168.100.13
      * shared_fs       (ocf::heartbeat:Filesystem):     Started 192.168.100.13
    * Resource Group: shared_vg:1:
      * shared_lv       (ocf::heartbeat:LVM-activate):   Started 192.168.100.11
      * shared_fs       (ocf::heartbeat:Filesystem):     Started 192.168.100.11
    * Resource Group: shared_vg:2:
      * shared_lv       (ocf::heartbeat:LVM-activate):   Started 192.168.100.18
      * shared_fs       (ocf::heartbeat:Filesystem):     Started 192.168.100.18

Migration Summary:

Tickets:

PCSD Status:
  192.168.100.11: Online
  192.168.100.13: Online
  192.168.100.18: Online

Daemon Status:
  corosync: active/enabled
  pacemaker: active/enabled
  pcsd: active/enabled

```



