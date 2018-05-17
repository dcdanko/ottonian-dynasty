
# Initial setup
cd 

# Download pipelines
mkdir pipelines
cd pipelines

git clone git@github.com:MetaSUB/MetaSUB_QC_Pipeline.git
git clone git@github.com:MetaSUB/MetaSUB_CAP.git
cd MetaSUB_CAP
conda create --name cap --file requirements.txt
cd ..

cd ..


# Activate conda environment
source activate cap


# Install Dev Programs From GitHub
mkdir dev
cd dev

git clone git@github.com:dcdanko/DataSuper.git
cd DataSuper
python setup.py develop
cd ..

git clone git@github.com:dcdanko/PackageMega.git
cd PackageMega
python setup.py develop
cd ..

git clone git@github.com:dcdanko/ModuleUltra.git
cd ModuleUltra
python setup.py develop
cd ..

git clone git@github.com:MetaSUB/macrobial-genomes.git

cd ..


# Install pipelines
moduleultra install pipeline --dev ~/pipelines/MetaSUB_QC_Pipeline
moduleultra install pipeline --dev ~/pipelines/MetaSUB_CAP


# Download database
mkdir databases

wget https://s3.amazonaws.com/metasub-cap-databases/uniref90_annotated.1.1.dmnd
wget https://s3.amazonaws.com/metasub-cap-databases/card_oct_2017_prot_seqs.dmnd
wget https://s3.amazonaws.com/metasub-cap-databases/methyls_90.tar.gz
tar -xzf methyls_90.tar.gz
wget https://s3.amazonaws.com/metasub-cap-databases/vfdb_setB_pro.tar.gz
tar -xzf vfdb_setB_pro.tar.gz
wget https://s3.amazonaws.com/metasub-cap-databases/hg38_alt_contigs.tar.gz
tar -xzf hg38_alt_contigs.tar.gz
wget https://s3.amazonaws.com/metasub-cap-databases/minikraken_20171019_8GB.tgz
tar -xzf minikraken_20171019_8GB.tgz
wget https://s3.amazonaws.com/metasub-cap-databases/staph_aureus_n315.tar.gz
tar -xzf staph_aureus_n315.tar.gz

cd ..





