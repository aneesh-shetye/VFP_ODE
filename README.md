# VFP_ODE

Project for Image and Video Processing class at NYU Tandon. 


## To set up the environment for the project: 

1. Create a conda environment:
```
conda create --name ivp 
```

2. Activate the environment: 
```
conda activate ivp
```

3. Install the dependancies:
```
pip install -r torchdiffeq/requirements.txt
```


## To run the code: 

Steps to train the model:

1. Enter in the project directory: 
```
cd torchdiffeq
```

2. To train a model which uses ODE solver to model the intermediate hidden states:
```
python conv_gru_with_mask.py
```
Alternatively, if running on a slurm based backend, clone the `slurm` branch and use: 
```
sbatch convtrain.sbatch
```

3. To train a model with vanilla ConvGRU layers:
```
python conv_gru.py
```

4. To validate the model, set the `--val` argument to `True ` :
```
python conv_gru_with_mask.py --val=True
```




