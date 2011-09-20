#ifndef SIMPLE_CMD_LINE_HELPER_H__
#define SIMPLE_CMD_LINE_HELPER_H__

#include<iostream>
#include<map>
#include<sstream>
#include<cstdlib>
#include<string>

using std::map;
using std::string;

extern map<string, bool> CMD_LINE_BOOLS;
extern map<string, float> CMD_LINE_FLOATS;
extern map<string, int> CMD_LINE_INTS;
extern map<string, string> CMD_LINE_STRINGS;
extern map<string, string> CMD_LINE_DESCRIPTIONS;

void AddFlag(const string& flag_name,
 const string& description,
 bool default_value);

void AddFlag(const string& flag_name,
 const string& description,
 float default_value);

void AddFlag(const string& flag_name,
 const string& description,
 int default_value);

void AddFlag(const string& flag_name,
 const string& description,
 string default_value);

void ShowHelp();
bool ParseBoolFlag(char** argv, int*i);
bool ParseGeneralFlag(int argc, char** argv, int* i);
void ParseFlags(int argc, char** argv);

#endif
