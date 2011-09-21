#!/bin/bash

### fit_model(learner_type, loop_type, training_file, model_out, binpath)

function fit_model { 

${5}/sofia-ml --learner_type $1 \
           --loop_type $2 \
           --lambda 0.1 \
           --eta_type pegasos \
           --iterations 100000 \
           --random_seed 1 \
           --dimensionality 5 \
           --training_file $3 \
           --model_out $4 \
           --rank_step_probability 0.5 \
           --passive_aggressive_c 10000000.0 \
           --passive_aggressive_lambda 0 \
           --perceptron_margin_size 1.0 \
           --hash_mask_bits 0
###--training_objective \ not set
###--no_bias_term = 0 
}

LEARNER_TYPE=( "pegasos" "sgd-svm" "passive-aggressive" "margin-perceptron" "romma" "logreg-pegasos" )
LOOP_TYPE=( "stochastic" "balanced-stochastic" "rank" "roc" "query-norm-rank" "combined-ranking" "combined-roc" )

for i in ${LEARNER_TYPE[@]}
do
  for j in ${LOOP_TYPE[@]}
  do
    fit_model $i $j "../testData/irismod.svmlight" "../SofiaModels/${i}_${j}.out" "../sofia-ml-read-only/sofia-ml/"
  done
done
