from os import environ

HOME = environ['HOME']
RAM = 384
CORES = 28
RAM_PER_CORE = 13


def dbdir(filename):
    return f'{HOME}/databases/{filename}'


config = {
    'align_to_sa_n315': {
        'threads': 2,
        'time': 2,
        'ram': 10,
        'db': {
            'bt2': dbdir('microbes/staph_aureus_n315.bt2')
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
            'filepath': dbdir('minikraken/minikraken_20171019_8GB')
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
            'filepath': dbdir('genes/uniref90_annotated.1.1.dmnd')
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
            'bt2': dbdir('megares/megares_database_v1.01.bt2'),
            'fasta': dbdir('megares/megares_database_v1.01.fasta'),
            'annotations': dbdir('megares/megares_annotations_v1.01.csv')
        },
        'bt2_time': 2,
        'bt2_ram': RAM_PER_CORE * 3,
    },
    'align_to_methyltransferases': {
        'fasta_db': {'filepath': dbdir('methyls/methyltransferases_90.aa.fa')},
        'dmnd': {
            'filepath': dbdir('methyls/methyltransferases_90.dmnd'),
            'threads': 7,
            'time': 2,
            'ram': RAM_PER_CORE * 7,
            'block_size': (RAM_PER_CORE * 7) // 8,
        }
    },
    'align_to_amr_genes': {
        'time': 10,
        'fasta_db': {'filepath': dbdir('card/card_oct_2017_prot_seqs.faa')},
        'dmnd': {
            'filepath': dbdir('card/card_oct_2017_prot_seqs.dmnd'),
            'threads': 7,
            'time': 20,
            'ram': (RAM_PER_CORE * 7) // 8,
            'block_size': (RAM_PER_CORE * 7) // 8
        }
    },
    'vfdb_quantify': {
        'time': 10,
        'fasta_db': {'filepath': dbdir('vfdb/VFDB_setB_pro.faa')},
        'dmnd': {
            'filepath': dbdir('vfdb/VFDB_setB_pro.dmnd'),
            'threads': 7,
            'time': 20,
            'ram': (RAM_PER_CORE * 7),
            'block_size': (RAM_PER_CORE * 7) // 8
        }
    },
    'quantify_macrobial': {
        'biases': dbdir('macrobes/quantified_bias.json'),
        'db': {'filepath': dbdir('macrobes/100M_base_limited_genomes/limited_genomes.bt2')},
        'threads': 7,
        'ram': RAM_PER_CORE * 7,
        'time': 10,
    },
}