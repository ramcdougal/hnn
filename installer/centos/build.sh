# start with this since it gets input needed

# HNN repo from bitbucket
#git clone https://bitbucket.org/samnemo/hnn.git# old repo

# HNN repo from github - moved to github on April 8, 2018
git clone https://github.com/jonescompneurolab/hnn.git

wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -i epel-release-latest-7.noarch.rpm
sudo yum -y install python34-devel.x86_64
sudo yum -y install libX11-devel
sudo yum -y group install "Development Tools"
sudo yum -y install xorg-x11-fonts-100dpi 
sudo yum -y install Cython
sudo yum -y install python34-pip python-tools
sudo pip3 install matplotlib
# make sure matplotlib version 2 is used -- is this strictly needed?
sudo pip3 install --upgrade matplotlib
sudo pip3 install scipy
sudo yum -y install ncurses-devel
sudo yum -y install openmpi openmpi-devel
sudo yum -y install libXext libXext-devel
export PATH=$PATH:/usr/lib64/openmpi/bin
sudo PATH=$PATH:/usr/lib64/openmpi/bin pip3 install mpi4py

# save dir installing hnn to
startdir=$(pwd)
echo $startdir

git clone https://github.com/nrnhines/nrn
git clone https://github.com/nrnhines/iv
cd iv
git checkout d4bb059
./build.sh
./configure
make -j4
sudo make install -j4
cd ../nrn
#git checkout be2997e
./build.sh
./configure --with-nrnpython=python3 --with-paranrn --disable-rx3d
make -j4
sudo PATH=$PATH:/usr/lib64/openmpi/bin make install -j4
cd src/nrnpython
sudo python3 setup.py install

# move outside of nrn directories
cd $startdir

# setup HNN itself
cd hnn
# make compiles the mod files
export CPU=$(uname -m)
export PATH=$PATH:/usr/local/nrn/$CPU/bin
make
cd ..

# qt, pyqt, and supporting packages - needed for GUI
wget https://sourceforge.net/projects/pyqt/files/sip/sip-4.19.2/sip-4.19.2.tar.gz
tar -zxf sip-4.19.2.tar.gz
cd sip-4.19.2
sudo python3 configure.py
make -j4
sudo make install -j4
cd ..

sudo yum -y install qt-devel
sudo yum -y install qt5-qtbase
sudo yum -y install qt5-qtbase-devel

wget https://sourceforge.net/projects/pyqt/files/PyQt5/PyQt-5.8.2/PyQt5_gpl-5.8.2.tar.gz
tar -xvf PyQt5_gpl-5.8.2.tar.gz
cd PyQt5_gpl-5.8.2
python3 configure.py --qmake=/usr/lib64/qt5/bin/qmake --confirm-license
make -j4
sudo make install -j4
cd ..

# used by pqtgraph - for visualization
sudo pip3 install PyOpenGL PyOpenGL_accelerate

# pyqtgraph - only used for visualization
cd hnn
git clone https://github.com/pyqtgraph/pyqtgraph.git
cd pyqtgraph
git checkout pyqt5
git pull
sudo python3 setup.py install

# needed for matplotlib
sudo yum -y install python34-tkinter

