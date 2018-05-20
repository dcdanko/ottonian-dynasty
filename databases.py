#! /usr/bin/env python3

from os import makedirs, chdir
from os.path import isfile, join
from urllib.request import urlretrieve
import tarfile
from concurrent.futures import ThreadPoolExecutor


def get_downloader(dirname, uri):
    def downloader():
        makedirs(dirname, exist_ok=True)
        fpath = join(dirname, uri.split('/')[-1])
        if isfile(fpath):
            return
        print(f'Downloading {uri}')
        urlretrieve(uri, filename=fpath)
        print(f'Finished {uri}')
        if ('.tar.gz' in fpath) or ('.tgz' in fpath):
            tar = tarfile.open(fpath)
            tar.extractall(path=dirname)
            tar.close()
    return downloader


download_jobs = [
    ('genes', 'https://s3.amazonaws.com/metasub-cap-databases/uniref90_annotated.1.1.dmnd'),
    ('card', 'https://s3.amazonaws.com/metasub-cap-databases/card_oct_2017_prot_seqs.faa'),
    ('card', 'https://s3.amazonaws.com/metasub-cap-databases/card_oct_2017_prot_seqs.dmnd'),
    ('methyls', 'https://s3.amazonaws.com/metasub-cap-databases/methyls_90.tar.gz'),
    ('vfdb', 'https://s3.amazonaws.com/metasub-cap-databases/vfdb_setB_pro.tar.gz'),
    ('megares', 'https://s3.amazonaws.com/metasub-cap-databases/megares_v1.0.1.tar.gz'),
    ('hg38', 'https://s3.amazonaws.com/metasub-cap-databases/hg38_alt_contigs.tar.gz'),
    ('minikraken', 'https://s3.amazonaws.com/metasub-cap-databases/minikraken_20171019_8GB.tgz'),
    ('minikraken', 'https://s3.amazonaws.com/metasub-cap-databases/minikraken_8GB_100mers_distrib.txt'),
    ('krakenhll_refseq', 'https://s3.amazonaws.com/metasub-cap-databases/krakenhll_refseq_complete.tar.gz'),
    ('microbes', 'https://s3.amazonaws.com/metasub-cap-databases/staph_aureus_n315.tar.gz'),
    ('macrobes', 'https://s3.amazonaws.com/metasub-cap-databases/macrobe_quantification.tar.gz'),
]

executor = ThreadPoolExecutor(max_workers=len(download_jobs))
futures = [
    executor.submit(get_downloader(*args))
    for args in download_jobs
]

for future in futures:
    future.result()
