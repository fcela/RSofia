#!/bin/bash

### train_model(learner_type, loop_type, eta_type, no_bias_term, training_file, model_out, binpath)

function train_model { 

  if [ $4 -eq 1 ]
  then
    no_bias_term="--no_bias_term"
  else
    no_bias_term=""
  fi

  ${7}/sofia-ml --learner_type $1 \
           --loop_type $2 \
           --lambda 0.1 \
           --eta_type $3 \
           --iterations 100000 \
           --random_seed 1 \
           --dimensionality 5 \
           --training_file $5 \
           --model_out $6 \
           --rank_step_probability 0.5 \
           --passive_aggressive_c 10000000.0 \
           --passive_aggressive_lambda 0 \
           --perceptron_margin_size 1.0 \
           $no_bias_term \
           --hash_mask_bits 0
###--training_objective \ not set
}

function test_model {
  
  ${5}/sofia-ml --model_in $1 \
             --test_file $2 \
             --prediction_type $3 \
             --results_file $4

}

LEARNER_TYPE=( "pegasos" "sgd-svm" "passive-aggressive" "margin-perceptron" "romma" "logreg-pegasos" )
LOOP_TYPE=( "stochastic" "balanced-stochastic" "rank" "roc" "query-norm-rank" "combined-ranking" "combined-roc" )
ETA_TYPE=( "pegasos" "basic" "constant" )

for i in ${LEARNER_TYPE[@]}
do
  for j in ${LOOP_TYPE[@]}
  do
    for k in ${ETA_TYPE[@]}
    do
      for l in 0 1 
      do

        model_out="../SofiaModels/Models/${i}_${j}_${k}_nobias${l}.out"
        dataset="../testData/irismod.svmlight"
        sofia_path="../sofia-ml-read-only/sofia-ml/"

        train_model $i $j $k $l $dataset $model_out $sofia_path 
       
        if [ "$i" == "logreg-pegasos" ]
        then
          prediction_type="logistic"
        else
          prediction_type="linear"
        fi 
        
        test_out="../SofiaModels/Tests/${i}_${j}_${k}_nobias${l}_${prediction_type}.test"
        test_model $model_out $dataset $prediction_type $test_out $sofia_path

      done
    done
  done
done
