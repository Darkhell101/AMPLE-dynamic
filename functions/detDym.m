function [Kd,Fdym] = detDym(uvw,M,V,A,dt,nD)
%Dynamic effect determination  
%--------------------------------------------------------------------------
%
% Author: lgd
% Date:   15/11/2024
% Description:
% Function to determine the dynamic part at nodes based on newmark method.
%
%--------------------------------------------------------------------------
% [Kd,Fdym] = DETDYM(uvw,M,V,A,fd,dt)
%--------------------------------------------------------------------------
% Input(s):
% uvw    - nodal displacements that influence the MP (nn*nD,1)
% M      - grid mass
% V      - grid velocity
% A      - grid acceleration
% fd     - free degrees of freedom (*,1)
% dt     - time increment
% nD     - number of dimensions
%--------------------------------------------------------------------------
% Ouput(s):
% Kd     - stiffness from dynamic part
% Fdym   - dynamic force
%--------------------------------------------------------------------------
% See also:
%   1. Implicit time integration for the material point method: Quantitative
%      and algorithmic comparisons with the finite element method
%   2. An implicit locking-free B-spline Material Point Method for large 
%      strain geotechnical modelling
%--------------------------------------------------------------------------
M = repmat(M,1,nD);
M = reshape(M',[],1);
Fdym = M.*(4/dt^2*uvw - 4/dt*V - A);
% Fdym = M.*A;
L = length(M);
Kd = 4*spdiags(M,0,L,L)/dt/dt;
end

