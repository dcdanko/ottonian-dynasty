

NTHREADS=`cat /proc/cpuinfo | grep processor | wc -l`

# Initial setup
apt-get update
yes | apt-get install gcc
yes | apt-get install git
yes | apt-get install bzip2

git clone https://github.com/dcdanko/ottonian-dynasty.git
OTTO=${HOME}/ottonian-dynasty

# Build and activate conda environment
#wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
#bash Miniconda2-latest-Linux-x86_64.sh -b -p miniconda_py2
#export PATH="$HOME/miniconda_py2/bin:$PATH"
#conda config --add channels bioconda
#conda config --add channels conda-forge
#conda create --name cap_py2 --file ${OTTO}/py2_requirements.txt

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda_py3
export PATH="$HOME/miniconda_py3/bin:$PATH"
conda config --add channels bioconda
conda config --add channels conda-forge
yes | conda create --name cap_py3
yes | conda update readline
source activate cap_py3
conda install -y bowtie2
conda install -y diamond
conda install -y -c maxibor adapterremoval2
conda install -y mash
conda install -y microbecensus
conda install -y kraken
conda install -y krakenhll
conda install -y bracken
conda install -y snakemake

yes | pip2 install humann2


mkdir tools
cd tools
    git clone https://github.com/cdeanj/resistomeanalyzer.git
    cd resistomeanalyzer
        make
        cp resistome ${HOME}/bin
    cd ..
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
    yes | moduleultra install pipeline --dev ${HOME}/pipelines/MetaSUB_QC_Pipeline
    moduleultra add pipeline metasub_qc_cap
    yes | moduleultra install pipeline --dev ${HOME}/pipelines/MetaSUB_CAP
    moduleultra add pipeline metasub_cap
    datasuper add type sample microbiome
    datasuper bio add-fastqs -1 _1.fastq.gz -2 _2.fastq.gz microbiome ${HOME}/ottonian-dynasty/test_metagenomic_1.fastq.gz ${HOME}/ottonian-dynasty/test_metagenomic_2.fastq.gz
    moduleultra run pipeline -p metasub_qc_cap -c ${HOME}/ottonian-dynasty/custom_config.py
    moduleultra run pipeline -p metasub_cap --jobs $NTHREADS -c ${HOME}/ottonian-dynasty/custom_config.py
cd
