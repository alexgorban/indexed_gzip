#!/bin/bash
#
# This script is called via .travis.yml. It is not intended
# to be called in any other manner.
#

PYV=$PYTHON_VERSION

apt-get update
apt-get install -y libssl-dev openssl wget build-essential libffi-dev libsqlite3-dev
cd /
wget https://www.python.org/ftp/python/$PYV/Python-$PYV.tar.xz
tar xf Python-$PYV.tar.xz
cd Python-$PYV
./configure --prefix=/mypython
make && make install
cd /mypython/bin

if [ ! -e python ]; then
    ln -s python3 python
fi

if [ ! -e pip ]; then
    if [ -e pip3 ]; then
        ln -s pip3 pip
    else
        wget https://bootstrap.pypa.io/get-pip.py
        ./python get-pip.py
    fi
fi

export PATH=/mypython/bin:$PATH

pip install --upgrade cython numpy pytest coverage pytest-cov

cd /indexed_gzip
python setup.py develop
pytest --no-cov -v -s --niters 500
pytest --no-cov -v -s --niters 500 --concat
