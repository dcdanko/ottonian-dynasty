

NTHREADS=`cat /proc/cpuinfo | grep processor | wc -l`

# Initial setup
apt-get update
yes | apt-get install gcc
yes | apt-get install git
yes | apt-get install bzip2

git clone https://github.com/dcdanko/ottonian-dynasty.git
OTTO=${HOME}/ottonian-dynasty


wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda_py3
export PATH="$HOME/miniconda_py3/bin:$PATH"
conda config --add channels bioconda
conda config --add channels conda-forge
conda update -y readline
conda install -y bowtie2 diamond mash kraken krakenhll bracken snakemake
conda install -y -c maxibor adapterremoval2

yes | pip install microbecensus
yes | pip install gimme_input
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
    datasuper bio add-fastqs -1 _1.fastq.gz -2 _2.fastq.gz microbiome ${OTTO}/test_metagenomic_1.fastq.gz ${OTTO}/test_metagenomic_2.fastq.gz
    moduleultra run pipeline -p metasub_qc_cap -c ${HOME}/ottonian-dynasty/custom_config.py
    moduleultra run pipeline -p metasub_cap --jobs $NTHREADS -c ${HOME}/ottonian-dynasty/custom_config.py
cd
