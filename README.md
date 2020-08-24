# Multifit

Run the command below in Matlab to install multifit:

```
websave('install_multifit.m', 'https://dobrisan.uk/multifit/install_multifit.m');install_multifit;
```

All the above command does is fetch the required zip file for your operating system from the server ('https://dobrisan.uk/multifit/'), unzip it and move the files to the top folder on your Matlab path so that the command 'multifit' is immediately accessible.
If this fails (e.g. if you do not have write permission to your top path folder) or if you want to do things differently you can grab the archives straight from the above URL and unpack them to the Matlab readable folder of your choice.
Just bear in mind that the Matlab files are supported by C++ code and multifit expects all files to be in the same directory as in the archive.

The code was compiled to work on Windows, Mac and Linux with some recent version of Matlab (2015a, 2017a, 2017b, 2019b, 2020a). On Windows it was tested on Windows 7 and 10, on Mac on Catalina (10.15) and on Linux on Ubuntu 18.04, 20.04 and Fedora 31. If you encounter issues with the code please let us know at 'ad622@eng.cam.ac.uk'.

To test the library you can run the data from Li and Lehane (2010). To do this download the zip file from the link below:

```
https://dobrisan.uk/multifit/Li_Lehane_paper.zip
```

Unzip and then run the MATLAB script *multifit_analysis.m* which is found in the included *code* folder

To update multifit at any time just run:

```
multifit('update')
```

The multifit function was coded to accepts a varied input in a relatively straightforward format. For a retaining wall problem the function expects three inputs for each level of differentiation. I.e. three inputs for pressure, three for shear, moment, rotation, deflection..
