# AMPLE-dynamic
Here is an implementation of implicit dynamic material point method (MPM) based on newmark's method.

The related Papers are listed as:
(1) Implicit time integration for the material point method: Quantitative and algorithmic comparisons with the finite element method
(2) AMPLE: A Material Point Learning Environment
(3) An implicit locking-free B-spline Material Point Method for large strain geotechnical modelling

The main algorithm is from the third paper.
I reproduce some of its work, and Xie Mian makes a significant revision to my wrong implementation.
You can find traces from the main function of the code.
Additionally, the correspondence author of the third paper, López-Querol Susana, offers rather important assistance.

Importantly, this is a toy implementation.
If one wants to do more research based on it, one may be intrested in the work of [William M. Coombs](https://www.durham.ac.uk/staff/w-m-coombs/)

The aim of this repository is to decrease the effort for main algorithm and to focus more meaningful topics, like constitutive laws, contact, impact...

If any problems, my mail is [lgd1447210528@gmail.com](lgd1447210528@gmail.com). I will reply and answer if I know.



# AMPLE
AMPLE - A Material Point Learning Environment

AMPLE is a quasi-static implicit implementation of the material point method in MATLAB.  
More informatio about AMPLE can be obtained from the project webapges:
https://wmcoombs.github.io/

AMPLE is an elasto-plastic large deformation material point code with a regular quadrilateral background mesh 
(the main code is ample.m).   The continuum framework is based on an updated Lagrangian formation and two 
different constitutive models are included: linear elasticity and a linear elastic-perfectly plastic model 
with a von Mises yield surface.  
 
It is suggested that users start by looking at the “index.html” file within the “documentation” folder.  
The html files were complied with M2HTML (https://www.artefact.tk/software/matlab/m2html/) and they should 
provide  an overview of the code and how it all fits together.  The scripts should also be compatible with 
MATLAB’s “help” function. 

Version history:

AMPLE     - original AMPLE release

AMPLE_1.1 - version 1.1, released August 2020 - focused on runtime improvement
