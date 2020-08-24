# Multifit

Run the command below in Matlab to install multifit:

```
websave('install_multifit.m', 'https://dobrisan.uk/multifit/install_multifit.m');install_multifit;
```

All the above command does is fetch the required zip file for your operating system from the server (https://dobrisan.uk/multifit/), unzip it and move the files to the top folder on your Matlab path so that the command 'multifit' is immediately accessible.
If this fails (e.g. if you do not have write permission to your top path folder) or if you want to do things differently you can grab the archives straight from the above URL and unpack them to the Matlab readable folder of your choice.
Just bear in mind that the Matlab files are supported by C++ code and multifit expects all files to be in the same directory as in the archive.

The code was compiled to work on Windows, Mac and Linux and tested with a number of recent versions of Matlab (2015a, 2017a, 2017b, 2019b, 2020a). 
On Windows it was tested on Windows 7 and 10, on Mac on MacOS Catalina (10.15) and on Linux on Ubuntu 18.04, 20.04 and Fedora 31. 
If you encounter issues with the code please let us know at ad622@eng.cam.ac.uk.

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
The first input is the depth of the measurement, the second is the value and the third is the error associated with that measurement. 
It is important that measurements and depths have consistent dimensions and signs across the differentiation chain. 
The error term has two parts, an absolute value and a relative component. 
To keep errors unitless, the absolute value of error is given as a percentage from the maximum reading of a particular property like moment. 
It is applied to all moment measurement equally. The relative error is also a percentage input and is taken as relative to how large each reading is. 
These two types of error inputs are set to account for the two possible sources of error in  calibrating an instrument. Errors in the axis intercept (absolute) and errors in the slope of the calibration curve (relative).
If there is no data for a property, say Shear, then the three inputs for shear should be a string like 'no'.
The highest property in the chain cannot have 'no' as input, ie there should be data for that property. The chain can be as short as one property fitted and as long as it needs to be to accommodate more uses.

Besides the experimental data to fit, multifit requires two additional parameters: the order of polynomials to use and how many it should pull from the solution space.

An example of calling multifit is shown below. This is for a retaining wall problem in which data for net soil pressure, moment and wall displacement are known, but not for shear or rotation. 
8th order polynomials are requested and 1E5 are taken from the soultion space.

```
p = multifit(depth_pressure_meas, value_pres_meas, [err_abs_press err_rel_pres], 'no', 'no', 'no', depth_moment_meas, value_moment_meas, [err_abs_moment err_rel_moment], 'no', 'no', 'no', depth_disp_meas, value_disp_meas ./ B, [err_abs_disp err_rel_disp], 8, 1E5);
```
where B is bending stiffness to keep the differentiation consistent.

If both the relative and absolute values of error are given as 0 multifit will interpret the respective value of moment, shear etc. as a hard constraint, ie all fit polynomials have to exactly go through that point.

Another option is to specify that a property such as moment can only take values above or below a certain threshold between two depths. This is useful to constrain the fit polynomials to solutions that make physical sense especially if the results are osscilatory. 
If, for example, we want to constrain moment to alues higher than 0 between 2m and 4m depth we would have:

```
depth_moment_meas = [other_points.. 2 4]; % the depths of the interval are here
value_moment_meas = [other_points.. 0 0]; % the threshold value is in this variable
[err_abs_moment err_rel_moment] = [other_points; Inf Inf]; % Inf sets the inequality up as greater than, -Inf as smaller than
```

All of the above features are illustred in the worked Li_Lehane_paper. 

The brief summary above is intended for expansion in the near future as the method is further developed.
For any help please contact us at ad622@eng.cam.ac.uk
