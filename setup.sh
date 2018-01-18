#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters. Usage:- bash setup.sh <KAGGLE_USERNAME> <KAGGLE_PASSWORD>"
fi

# Step - 1 - a - Install Nvidia Drivers
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt-get install nvidia-390
nvidia-smi
echo "Check output of nvidia-smi"
sudo reboot

# Step - 1 - b - Install Cuda
curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i ./cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda
echo "After reboot, run nvidia-smi. There should be no driver/library version mismatch."
sudo reboot

# Step - 2 -Install Miniconda - Faster and precise - Python 3.6.3
curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
echo "Installing miniconda in default location ~/miniconda3" 
bash ./Miniconda3-latest-Linux-x86_64.sh -b

echo "Adding conda in PATH in bashrc"
echo 'export PATH=~/miniconda3/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

conda create -y --name py36 python=3.6.3
source activate py36
echo "Created conda environment py36"

echo "Installing dependencies for the project" 
conda install -y numpy=1.14.0 opencv=3.3.1 
conda install -y -c anaconda pillow=5.0.0 pandas=0.22.0 jupyter=1.0.0
conda install -y -c pytorch pytorch=0.3.0 torchvision=0.2.0
conda install -y -c conda-forge matplotlib=2.1.1 cycler=0.10.0 progressbar2=3.34.3

# Step 3 - Download dataset - https://www.kaggle.com/c/diabetic-retinopathy-detection
echo "Downloading dataset. Remember to accept the permission at Kaggle for this project by attempting to download a file."
pip install kaggle-cli
sudo apt install p7zip-full # Faster unzip without concatenating multipart zip files
mkdir -p data/full
cd data/full
KAGGLE_USERNAME=$1
KAGGLE_PASSWORD=$2
kg download -u ${KAGGLE_USERNAME} -p ${KAGGLE_PASSWORD} -c diabetic-retinopathy-detection -f test.zip.001
kg download -u ${KAGGLE_USERNAME} -p ${KAGGLE_PASSWORD} -c diabetic-retinopathy-detection -f test.zip.002
kg download -u ${KAGGLE_USERNAME} -p ${KAGGLE_PASSWORD} -c diabetic-retinopathy-detection -f test.zip.003
kg download -u ${KAGGLE_USERNAME} -p ${KAGGLE_PASSWORD} -c diabetic-retinopathy-detection -f test.zip.004
kg download -u ${KAGGLE_USERNAME} -p ${KAGGLE_PASSWORD} -c diabetic-retinopathy-detection -f test.zip.005
kg download -u ${KAGGLE_USERNAME} -p ${KAGGLE_PASSWORD} -c diabetic-retinopathy-detection -f test.zip.006
kg download -u ${KAGGLE_USERNAME} -p ${KAGGLE_PASSWORD} -c diabetic-retinopathy-detection -f test.zip.007
7z x test.zip.001
rm test.zip.00*
echo "Test dataset downloaded and decompressed."