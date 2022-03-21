#!/bin/bash

model="smp_UNet++"

epochs=1000
workers=1

train_batch_size=24
val_batch_size=16
full_res_validation="False"

lr=1e-3
optimizer="Adam"
wd=0.00001
lr_steps=4
step_gamma=0.1
#dice_loss_factor=-1

resized_height=256
resized_width=256
cropSize=-1

dataset="synapse"
data_dir="../src/data/datasets/${dataset}"
json_path="../src/data/classes/${dataset}SegClasses.json"
#checkpoint_path="/home/arcseg/jonathan/ARCSeg/results/resnet18_unet/cholec/bs_32_lr1e-3_e100/resnet18_unet_cholec_bs32lr0.001e100_checkpoint"

display_samples="False"
save_samples="True"

for dice_loss_factor in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1
do
	echo "dice_loss_factor = ${dice_loss_factor}"
	save_dir="../results/${model}/${dataset}/half_resolution_random_crop/dice_factor_${dice_loss_factor}/bs_train${train_batch_size}_val${val_batch_size}/imsize_${resized_height}x${resized_width}_wd_${wd}_optim_${optimizer}_lr${lr}_steps_${lr_steps}_gamma_${step_gamma}/e${epochs}_seed6210"
	seg_save_dir="${save_dir}/seg_results"

	mkdir -p $save_dir

	python ../src/trainSegNet.py \
	    --model $model \
	    --workers $workers \
	    --trainBatchSize $train_batch_size \
	    --valBatchSize $val_batch_size \
	    --full_res_validation $full_res_validation \
	    --resizedHeight $resized_height \
	    --resizedWidth $resized_width \
	    --cropSize $cropSize \
	    --lr $lr \
	    --dice_loss_factor $dice_loss_factor \
	    --epochs $epochs \
	    --lr_steps $lr_steps \
	    --step_gamma $step_gamma \
	    --optimizer $optimizer \
	    --wd $wd \
	    --dataset $dataset \
	    --display_samples $display_samples \
	    --save_samples $save_samples \
	    --data_dir $data_dir \
	    --json_path $json_path \
	    --save_dir $save_dir \
	    --seg_save_dir $seg_save_dir \
	    |& tee -a "${save_dir}/debug.log"
done
