#1/bin/bash


MY_IP=$(ip route get 8.8.8.8 | grep -oe 'src.*'  | cut -d ' ' -f2)


function install_cockpit() {
  dnf install -y cockpit cockpit-storaged
  systemctl enable --now cockpit.socket

}


function install_ceph() {
  dnf install -y centos-release-ceph-quincy
  dnf install -y cephadm ceph-common

  cephadm bootstrap \
    --mon-ip "${MY_IP}" \
    --single-host-defaults \
    --config initial-config.ini
  ceph orch apply osd --all-available-devices

}

function configure_ceph_serivces() {
  ceph orch apply rgw s3
  ceph orch apply nfs foo
}


install_cockpit
install_ceph
# configure_ceph_services