# Multifit

Run the command below in Matlab to install multifit:

```
websave('install_multifit.m', 'https://dobrisan.uk/multifit/install_multifit.m');install_multifit;
```

All the above command does is fetch the required zip file for your operating system from the server ('https://dobrisan.uk/multifit/'), unzip it and move the files to the top folder on your Matlab path so that the command 'multifit' is immediately accessible.
If this fails (e.g. if you do not have write permission to your top path folder) or if you want to do things differently you can grab the archives straight from the above URL and unpack them to the Matlab readable folder of your choice.

To test the library you can run the data from Li and Lehane (2010). To do this download the zip file from the link below:

```
https://dobrisan.uk/multifit/Li_Lehane_paper.zip
```

Unzip and then run the MATLAB script *multifit_analysis.m* which is found in the included *code* folder

To update multifit at any time just run:

```
multifit('update')
```
