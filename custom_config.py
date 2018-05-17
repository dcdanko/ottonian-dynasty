
RAM = 384
CORES = 28
RAM_PER_CORE = 13


def dbdir(filename):
    pass


config = {
    'align_to_sa_n315': {
        'threads': 2,
        'time': 2,
        'ram': 10,
        'db': {
            'bt2': dbdir('staph_aureus_n315.bt2.prefix')
        }
    },
    'metaphlan2_taxonomy_profiling': {
        'threads': 2,
        'time': 2,
        'ram': 10,
    },
    'bracken_abundance_estimation': {
        'kmer_distributions': dbdir('bracken.kmers.0'),
    },
    'kraken_taxonomy_profiling': {
        'db': {
            'filepath': dbdir('minikraken.kraken-db.dir')
        },
        'threads': 2,
        'time': 2,
        'ram': 10,
    },
    'krakenhll_taxonomy_profiling': {
        'db': {
            'filepath': dbdir('krakenhll.refseq.dir')
        },
        'threads': 18,
        'time': 99,
        'ram': RAM_PER_CORE * 18,
    },
    'humann2_functional_profiling': {
        'db': {
            'filepath': dbdir('uniref90.dmnd.0')
        },
        'dmnd': {
            'time': 99,
            'ram': RAM_PER_CORE * 7,
            'threads': 7,
            'block_size': (RAM_PER_CORE * 7) // 8,
        },
        'threads': 1,
        'time': 10,
        'ram': 32,
    },
    'microbe_census': {
        'threads': 7,
        'time': 4,
        'ram': RAM_PER_CORE * 7,
    },
    'resistome_amrs': {
        'threads': 3,
        'thresh': 80,
        'db': {
            'bt2': dbdir('megares.bt2.prefix'),
            'fasta': dbdir('megares.fasta.0'),
            'annotations': dbdir('megares.csv.0')
        },
        'bt2_time': 2,
        'bt2_ram': RAM_PER_CORE * 3,
    },
    'align_to_methyltransferases': {
        'fasta_db': {'filepath': dbdir('methyl.fasta.0')},
        'dmnd': {
            'filepath': dbdir('methyl.dmnd.0'),
            'threads': 7,
            'time': 2,
            'ram': RAM_PER_CORE * 7,
            'block_size': (RAM_PER_CORE * 7) // 8,
        }
    },
    'align_to_amr_genes': {
        'time': 10,
        'fasta_db': {'filepath': dbdir('card.fasta.0')},
        'dmnd': {
            'filepath': dbdir('card.dmnd.0'),
            'threads': 7,
            'time': 20,
            'ram': (RAM_PER_CORE * 7) // 8,
            'block_size': (RAM_PER_CORE * 7) // 8
        }
    },
    'vfdb_quantify': {
        'time': 10,
        'fasta_db': {'filepath': dbdir('vfdb.fasta.0')},
        'dmnd': {
            'filepath': dbdir('vfdb.dmnd.0'),
            'threads': 7,
            'time': 20,
            'ram': (RAM_PER_CORE * 7),
            'block_size': (RAM_PER_CORE * 7) // 8
        }
    },
    'quantify_macrobial': {
        'biases': 'foo',
        'db': {'filepath': 'bar'},
        'threads': 7,
        'ram': RAM_PER_CORE * 7,
        'time': 10,
    },
}