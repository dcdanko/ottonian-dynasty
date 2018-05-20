

NTHREADS=`cat /proc/cpuinfo | grep processor | wc -l`

# Initial setup
apt-get update
yes | apt-get install gcc
yes | apt-get install g++
yes | apt-get install git
yes | apt-get install bzip2
yes | apt-get install libncurses-dev
yes | apt-get install emacs
yes | apt-get install unzip
yes | apt-get install libgfortran3


git clone https://github.com/dcdanko/ottonian-dynasty.git
OTTO=${HOME}/ottonian-dynasty


wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda_py3
export PATH="$HOME/miniconda_py3/bin:$PATH"

conda config --add channels bioconda
conda config --add channels conda-forge
conda update -y readline
conda install -y bowtie2 diamond=0.8.9 mash kraken krakenhll bracken snakemake samtools
conda install -yc maxibor adapterremoval2
conda install -yc anaconda ncurses

yes | pip install blessings
yes | pip install gimme_input
yes | pip install numpy
yes | pip2 install humann2

mkdir bin
export PATH="$HOME/bin:$PATH"

mkdir tools
cd tools
    git clone https://github.com/cdeanj/resistomeanalyzer.git
    cd resistomeanalyzer
        make
        cp resistome ${HOME}/bin
    cd ..

    git clone https://github.com/snayfach/MicrobeCensus
    cd MicrobeCensus
        python2 setup.py install
    cd ..

    wget https://bitbucket.org/biobakery/metaphlan2/get/default.zip
    unzip default.py
    ln -s ${HOME}/tools/biobakery-metaphlan2-f27c42a7fbf1/metaphlan2.py ~/bin/

    wget https://github.com/DerrickWood/kraken/archive/v0.10.5-beta.tar.gz
    tar -xzf v0.10.5-beta.tar.gz
    cd kraken-0.10.5-beta/
        ./install_kraken.sh ~/tools/kraken
    cd ..
    ln -s ~/tools/kraken/kraken* ~/bin/
cd

# Download pipelines
mkdir pipelines
cd pipelines
    git clone https://github.com/MetaSUB/MetaSUB_QC_Pipeline.git
    git clone https://github.com/MetaSUB/MetaSUB_CAP.git
cd


# Install Dev Programs From GitHub
mkdir dev
cd dev
    git clone https://github.com/dcdanko/DataSuper.git
    cd DataSuper
        python setup.py develop
    cd ..
    
    git clone https://github.com/dcdanko/PackageMega.git
    cd PackageMega
        python setup.py develop
    cd ..
    
    git clone https://github.com/dcdanko/ModuleUltra.git
    cd ModuleUltra
        python setup.py develop
    cd ..
cd


# Download databases
mkdir databases
cd databases
    python ${OTTO}/databases.py
cd


# Make a MU repo, install and test pipelines
mkdir test_cap
cd test_cap
    moduleultra init
    yes | moduleultra install --dev ${HOME}/pipelines/MetaSUB_QC_Pipeline
    moduleultra add pipeline metasub_qc_cap
    yes | moduleultra install --dev ${HOME}/pipelines/MetaSUB_CAP
    moduleultra add pipeline metasub_cap
    datasuper add type sample microbiome
    datasuper bio add-fastqs -1 _1.fastq.gz -2 _2.fastq.gz microbiome ${OTTO}/test_metagenomic_1.fastq.gz ${OTTO}/test_metagenomic_2.fastq.gz
    moduleultra run -p metasub_qc_cap -c ${OTTO}/custom_config.py
    moduleultra run -p metasub_cap --jobs $NTHREADS -c ${OTTO}/custom_config.py
cd
