#!/bin/bash 
#SBATCH --nodes=3                        # requests 3 compute servers
#SBATCH --ntasks-per-node=2              # runs 2 tasks on each server
#SBATCH --cpus-per-task=1                # uses 1 compute core per task
#SBATCH --time=1:00:00
#SBATCH --mem=2GB
#SBATCH --job-name=python-hello-world
#SBATCH --output=python-hello-world.out

module purge
module load python/intel/3.8.6

#save standard output and standard error
exec 3>&1 4>&2 
#Redirect standard output to a log file 
exec 1>/media/compute/homes/ashetye/slotvqa/slot_vqa/tmp/stdout2.log
#Redirect standard error to a log file 
exec 2>/media/compute/homes/ashetye/slotvqa/slot_vqa/tmp/stderr2.log

CUDA_DEVICE=$(echo "$CUDA_VISIBLE_DEVICES," | cut -d',' -f $((SLURM_LOCALID +1)) ); 
T_REGEX='^[0-9]$'; 
if ![["$CUDA_DEVICE" =~ $T_REGEX ]]; then 
	echo "error no reserved gpu provided"
	exit 1; 

fi 
echo "Process $SLURM_PROCUD of Job $SLURM_JOBID with the local id
 $SLURM_LOCALID using gpu id $CUDA_DEVICE (we may use gpu: $CUDA_VISIBLE_DEVICES on 
$(hostname))" 
echo "computing on $(nvidia-smi --query-gpu=gpu_name --format=csv -i $CUDA_dEVICE | tail -n 1)" 
sleep 15 
export PATH="/media/compute/homes/ashetye/anaconda3/bin:$PATH"
source activate slotvqa 
echo $CONDA_DEFAULT_ENV 
#python -c "import sys; print(sys.version_info)"
python -c "import torch; print('No GPU found') if torch.cuda.device_count()==0 else print('gpu found!')" 
python -c "print('######################')"

python conv_gru_with_mask.py

echo "done"

#Restore original stdout/stderr
exec 1>&3 2>&4 
#Close the unused descriptors
exec 3>&- 4>&-
#Now the output of all commands goes to the original output and error stream
