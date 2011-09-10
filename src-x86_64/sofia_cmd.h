#ifndef R_SOFIA_CMD_H
#define R_SOFIA_CMD_H

#include<assert.h>
#include<cstdlib>
#include<ctime>
#include<fstream>
#include<iostream>
#include<string>

#include "simple-cmd-line-helper.h"
#include "sf-weight-vector.h"
#include "sf-hash-weight-vector.h"
#include "sofia-ml-methods.h"

using std::string;

void CommandLine(int argc, char** argv);
void PrintElapsedTime(clock_t start, const string& message);
void SaveModelToFile(const string& file_name, SfWeightVector* w);
void LoadModelFromFile(const string& file_name, SfWeightVector** w);
void TrainModel(const SfDataSet& training_data, SfWeightVector* w);

#endif
