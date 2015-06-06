### Prep

mkdir -p /vagrant/.package_cache
mount --bind /vagrant/.package_cache /var/cache/apt/archives

mkdir -p /vagrant/.python_dist_packages
mount --bind /vagrant/.python_dist_packages /usr/local/lib/python2.7/dist-packages

# Prevents the "unable to re-open stdin: No file or directory" error.
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

apt-get update
apt-get install build-essential apt-file
apt-file update

pip install requests

### Start provision.

## Install PIP.

apt-get install -y python-pip

## Install caffe

# REF: http://caffe.berkeleyvision.org/install_apt.html

apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev
apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler
apt-get install -y libatlas-base-dev
apt-get install -y python-dev git python-numpy python-scipy

pip install scikit-image

git clone https://github.com/BVLC/caffe.git /caffe
chown vagrant:vagrant -R /caffe

sudo -u vagrant /vagrant/build_caffe.sh
if [ $? -ne 0 ]; then
    echo "Problem building Caffe."
    exit 1
fi

echo "export PYTHONPATH=.:/caffe/python" >> /etc/environment

## Install ipython

pip install -r /caffe/python/requirements.txt
pip install pyzmq jinja2 tornado jsonschema "ipython[all]"

echo "alias n='python -m IPython notebook --ip=0.0.0.0 --no-browser --notebook-dir=/caffe/examples'" >> /home/vagrant/.bashrc
