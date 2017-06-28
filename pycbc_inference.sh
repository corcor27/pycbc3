# injection parameters
TRIGGER_TIME=1126259462.0
INJ_PATH=injection.xml.gz

# sampler parameters
CONFIG_PATH=inference.ini
OUTPUT_PATH=inference.hdf
SEGLEN=8
PSD_INVERSE_LENGTH=4
IFOS="H1 L1"
STRAIN="H1:aLIGOZeroDetHighPower L1:aLIGOZeroDetHighPower"
SAMPLE_RATE=2048
F_MIN=30.
N_UPDATE=500
N_WALKERS=5000
N_ITERATIONS=12000
N_CHECKPOINT=1000
PROCESSING_SCHEME=cpu

# the following sets the number of cores to use; adjust as needed to
# your computer's capabilities
NPROCS=12

# get coalescence time as an integer
TRIGGER_TIME_INT=${TRIGGER_TIME%.*}

# start and end time of data to read in
GPS_START_TIME=$((${TRIGGER_TIME_INT} - ${SEGLEN}))
GPS_END_TIME=$((${TRIGGER_TIME_INT} + ${SEGLEN}))

# run sampler
# specifies the number of threads for OpenMP
# Running with OMP_NUM_THREADS=1 stops lalsimulation
# to spawn multiple jobs that would otherwise be used
# by pycbc_inference and cause a reduced runtime.
OMP_NUM_THREADS=1 \
pycbc_inference --verbose \
    --seed 12 \
    --instruments ${IFOS} \
    --gps-start-time ${GPS_START_TIME} \
    --gps-end-time ${GPS_END_TIME} \
    --psd-model ${STRAIN} \
    --psd-inverse-length ${PSD_INVERSE_LENGTH} \
    --fake-strain ${STRAIN} \
    --fake-strain-seed 44 \
    --sample-rate ${SAMPLE_RATE} \
    --low-frequency-cutoff ${F_MIN} \
    --channel-name H1:FOOBAR L1:FOOBAR \
    --injection-file ${INJ_PATH} \
    --config-file ${CONFIG_PATH} \
    --output-file ${OUTPUT_PATH} \
    --processing-scheme ${PROCESSING_SCHEME} \
    --sampler kombine \
    --skip-burn-in \
    --update-interval ${N_UPDATE} \
    --likelihood-evaluator gaussian \
    --nwalkers ${N_WALKERS} \
    --niterations ${N_ITERATIONS} \
    --checkpoint-interval ${N_CHECKPOINT} \
    --checkpoint-fast \
    --nprocesses ${NPROCS} \
    --save-strain \
    --save-psd \
    --save-stilde \
    --force
