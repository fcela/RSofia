#!/bin/bash

### fit_model(learner_type, loop_type, training_file, model_out, binpath)

function fit_model { 

${5}/sofia-ml --learner_type $1 \
           --loop_type $2 \
           --lambda 0.1 \
           --iterations 100000 \
           --dimensionality 5 \
           --training_file $3 \
           --model_out $4

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
