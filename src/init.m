%close all;
clear;

addpath(genpath('library'));
addpath common;
addpath ../src;

%initialize config
global config;
config = IniConfig();
config.ReadFile('../config.ini');

global dataPath;
dataPath = GetFullPath('../data');

%suppress warnings
warning('off','images:initSize:adjustingMag')
