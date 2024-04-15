# Multifit

## 1. Short description

Multifit is a novel way to think about fitting experimental data that makes sense for geotechnical structures such as monopiles and retaining walls. It is also designed to aide in getting experimental **p-y curves** with consideration for experimental errors.

Usually fitting data such as moment (strain gauges) or rotation (inclinometers) is quite inaccurate due to readings having errors and also the fact that there is no obvious way of picking out the best fit curve out of the literal infinite number of possibilities. At Cambridge we’ve recently developed a technique to fit pile data that solves most of the above issues. 

Named _multifit_, the routine asks the user to provide all relevant experimental data from the pile or retaining wall along with appropriate error ranges for the provided readings. The user can also specify physical constraints, such as zero pressure on a retaining wall at ground level or zero moment at the end of a pile. Multifit takes all this information and returns the family of polynomials that satisfies all of the pile or retaining wall data within the specified error ranges. Finally, the user can apply statistics to find the range of probable values for moment, pressure etc.

## 2. Installation

Run the command below in Matlab to install multifit:

```
websave('install_multifit.m', 'https://github.com/andrei-dobrisan/multifit/releases/download/1.0/install_multifit.m');install_multifit;
```

All the command above does is fetch the required zip file for your operating system from Github (https://github.com/andrei-dobrisan/multifit/releases), unzips it and moves the files to the top folder on your Matlab path so that the command 'multifit' is immediately accessible in Matlab. To test if multifit installed correctly run

```
which('multifit')
```
in Matlab. The `which` command should return the path multifit is installed at. If anything went wrong, Matlab will return `'multifit' not found`.

On **Windows** since there is no default C++ library installed and the code relies on C++ helper code, multifit includes the **Microsoft Visual C++ 2015-2019 Redistributable(x64)** .exe for convenience. You will be prompted to install this library, but if you already have it you can close the prompt. If you do not feel comfortable installing it from multifit, just grab it straight from Microsoft's own website at: https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0.

If this fails (e.g. if you do not have write permission to your top path folder) or if you want to do things differently, you can grab the archives straight from https://github.com/andrei-dobrisan/multifit/releases and unpack them to a Matlab readable folder of your choice.
Just bear in mind that the Matlab files are supported by C++ code and multifit expects all files to be in the same directory just like in the archives at https://github.com/andrei-dobrisan/multifit/releases.

The code was compiled to work on Windows, Mac and Linux and tested with a number of recent versions of Matlab (2015a, 2017a, 2017b, 2019b, 2020a). 
On Windows it was tested on Windows 7 and 10, on Mac on MacOS Catalina (10.15) and on Linux on Ubuntu 18.04, 20.04 and Fedora 31. 
If you encounter issues with the code please let us know at: _multifit(at)dobrisan.uk_ .

## 3. Worked example 

To test the library and familiarise yourself with the syntax it is **recommended** that you download and run the worked example below, based on retaining wall data published in Li and Lehane (2010):

```
https://dobrisan.uk/multifit/Li_Lehane_paper.zip
```
The example also includes support code for plotting data from a multifit analysis which you can then use as a basis for your own plotting routines. 

Once you download the example archive, unzip it and then run the MATLAB script `multifit_analysis.m` which is found in the included **code** folder. The script will take a couple of minutes to run (don't worry if you see lots of text displayed during analysis, that means the method is working fine). Once it finishes, the script will ask you to select a .mat file. You should have a single option so please select it and open it. It represents the data the script just analysed and it is just passing you now to the plotting function. At this stage figures will appear on screen. These are plots for deflection, rotation, moment, shear and net soil pressure for the retaining wall described in Li and Lehane (2010). The code also saves these figures inside the `plots` folder within a subfolder named as `order_no_poly_xxxx_DD_Month_YYYY` (as both .jpg and .pdf). You will also find in the `plots` folder a subfolder named `order_10_reference`. If the plots you've just generated are identical to the ones in the reference folder, it means multifit installed correctly and you have a working version of analysis and plotting codes.

## 4. How multifit works

The multifit function was coded to accepts varied inputs in a relatively straightforward format. For a retaining wall problem the function expects three inputs for each level of differentiation, i.e. three inputs for pressure, three for shear, moment, rotation, deflection.
The first input is the depth of the measurement, the second is the value and the third is the error associated with that measurement. 
It is **important** that measurements and depths have consistent dimensions and signs across the differentiation chain. 
The error term has two parts, an absolute value and a relative component. 
To keep errors unitless, the absolute value of error is given as a percentage from the maximum reading of a particular property like moment. 
It is applied to all moment measurement equally. The relative error is also a percentage input and is taken as relative to how large each reading is. 
These two types of error inputs are set to account for the two possible sources of error in  calibrating an instrument. Errors in the axis intercept (absolute) and errors in the slope of the calibration curve (relative).
If there is no data for a property, say Shear, then the three inputs for shear should be a string like 'no'.
The highest property in the chain cannot have 'no' as input, ie there should be data for that property. The chain can be as short as one property fitted (say Moment) and as long as it needs to be (a full retaining wall chain would have data for all five properties p, S, M, rotation and deflection).

Besides the experimental data to fit, multifit requires two additional parameters: the order of polynomials to use in fitting and how many polynomials it should pull from the solution space. Using a geometric analogy, the solution space is a volume and each polynomial represents a point taken from inside this enclosed space. The more polynomials requested, the better the volume is represented, but the law of diminishing returns applies such that requesting a very large numbers of polynomials will not produce significant improvements in prediction. A good strategy is to start with a lower number of requested polynomials (1E4 or 1E5) and work up until no change in fit prediction is observed.

A generic example of calling multifit is shown below to highlight syntax. This is for a retaining wall problem in which data for net soil pressure, moment and wall displacement are known, but not for shear or rotation. 
8th order polynomials are requested and 1E5 samples are taken from the solution space.

```
p = multifit(depth_pressure_meas, value_pres_meas, [err_abs_press err_rel_pres], 'no', 'no', 'no', depth_moment_meas, value_moment_meas, [err_abs_moment err_rel_moment], 'no', 'no', 'no', depth_disp_meas, value_disp_meas ./ B, [err_abs_disp err_rel_disp], 8, 1E5);
```
_B_ is bending stiffness to keep the differentiation consistent. 

The returned variable _p_ is a 1E5 by 9 matrix. Each row of _p_ represents the coefficients of an 8th order polynomial that fits the data within the given constraints. The coefficients are in the order of descending powers to keep with the way Matlab represents polynomials in its own builtin functions such as _polyfit_. 

Since there are 1E5 solutions returned, statistics can be used to narrow the results to a range of probable values. This is up to the user. In the worked example from Li and Lehane (2010) at each depth only the moment values within the 20th to 80th percentile band are considered (see lines 8, 10 and 44 in `multifit_band_plot.m` from the https://dobrisan.uk/multifit/Li_Lehane_paper.zip archive).

If both the relative and absolute values of error are given as 0 multifit will interpret the respective value of moment, shear etc. as a hard constraint, ie all fit polynomials have to exactly go through that point.

Another option is to specify that a property such as moment can only take values above or below a certain threshold between two depths. 
This is useful to constrain the fit polynomials to solutions that make physical sense especially if the results are oscillatory. 
If, for example, we want to constrain moment to values higher than 0 between 2m and 4m depth we would have:

```
depth_moment_meas = [other_points.. 2 4]; % the depths of the interval are here
value_moment_meas = [other_points.. 0 0]; % the threshold value is in this variable
[err_abs_moment err_rel_moment] = [other_points; Inf Inf]; % Inf sets the inequality up as greater than, -Inf as smaller than
```

All of the above features are illustred in the worked example at https://dobrisan.uk/multifit/Li_Lehane_paper.zip. 

## 5. Updates 

The multifit code is actively developed, to get the latest version simply run:

```
multifit('update')
```

## 6. Further development

The summary above is brief and aimed mostly at people I have spoken to about the method and are interested to try it out. There are many complexities and options the above description does not cover.

Further explanatory text and examples will be added once the paper on the method has been published.

However, multifit (formely known as probfit) has started seeing use in Cambridge PhDs (Garala, 2020) and in papers published at conferences such as ICPE 2021 (Zheng et al., 2021 and Dobrisan et al.,2021).

If you came across the method by reading one of the above papers and are thinking of trying out multifit, I absolutely encourage you to get in touch! I can help with issues and maybe give more context on how the method works and what the best practices of use are.

## 7. Contact

For any help please contact us at: _multifit(at)dobrisan.uk_.

## 8. References

Li, A., Lehane, B., 2010. Embedded cantilever retaining walls in sand. Geotechnique 60, 813–823. https://doi.org/10.1680/geot.8.P.147.

Garala T.K., 2020. Seismic Response of Pile Foundations in Soft Clays and Layered Soils. PhD Thesis, University of Cambridge

Zheng, T., Haigh, S.K., Dobrisan, A., Willcocks, F., Ishihara, Y., Okada, K. and Eguchi, M., 2021, June. The vertical and horizontal performance of pressed-in sheet piles. In _Proceedings of the Second International Conference on Press-in Engineering 2021_, Kochi, Japan (p. 86). CRC Press.

Dobrisan, A., Haigh, S.K. and Ishihara, Y., 2021, June. Experimental evaluation of the lateral capacity of large jacked-in piles and comparison to existing design standards. In _Proceedings of the Second International Conference on Press-in Engineering 2021_, Kochi, Japan (p. 166). CRC Press.
