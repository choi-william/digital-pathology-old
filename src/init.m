addpath common;

%initialize config
global config;
config = IniConfig();
config.ReadFile('../config.ini');

%suppress warnings
warning('off','images:initSize:adjustingMag')