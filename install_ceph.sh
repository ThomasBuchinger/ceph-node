#1/bin/bash


MY_IP=$(ip route get 8.8.8.8 | grep -oe 'src.*'  | cut -d ' ' -f2)

function is_ceph_running() {
  ceph status
  return $?
}

function install_packages() {
  dnf install -y cockpit cockpit-storaged vim
  systemctl enable --now cockpit.socket

  dnf install -y centos-release-ceph-quincy
  dnf install -y cephadm ceph-common
}


function bootstrap_ceph() {
  cephadm bootstrap \
    --mon-ip "${MY_IP}" \
    --single-host-defaults \
    --config config/initial-config.ini \
    --initial-dashboard-password changeme \
    --dashboard-password-noupdate | tee install.log
  ceph orch apply osd --all-available-devices

}

function configure_ceph_serivces() {
  ceph orch apply rgw s3
  ceph orch apply nfs foo
}


install_packages
is_ceph_running || bootstrap_ceph
# configure_ceph_services