function [M,V,A] = detMVA(nodes,nD,g,mpData)
%Mass, velocity, acceleration determination  
%--------------------------------------------------------------------------
% Author: lgd
% Date:   13/11/2024
% Description:
% Function to determine the mass, velocity, acceleration at nodes based on
% initialization at material points.
%
%                  mapping
%        mpData ----------->> element nodes
%                  mapping
%
%--------------------------------------------------------------------------
% [M,V,A] = DETMVA(nodes,nD,g,mpData)
%--------------------------------------------------------------------------
% Input(s):
% nodes  - number of nodes (total in mesh)
% nD     - number of dimensions
% g      - gravity
% mpData - material point structured array. Function requires:
%           mpM   : material point mass
%           mpV   : material point velocity
%           mpA   : material point acceleration
%           nIN   : nodes linked to the material point
%           Svp   : basis functions for the material point
%           fp    : point forces at material points
%--------------------------------------------------------------------------
% Ouput(s);
% M      - grid mass (nodes,1)
% V      - grid velocity (nodes*nD,1)
% A      - grid acceleration (nodes*nD,1)
%--------------------------------------------------------------------------
% See also:
% 
%--------------------------------------------------------------------------
nmp  = size(mpData,2);                                                          % number of material points & dimensions
M = zeros(nodes,1);                                                             % zero the mass vector

for mp = 1:nmp
   ed    = mpData(mp).nIN;                                                      % nodes associated with MP
   Svp   = (mpData(mp).Svp).';                                                  % basis functions
   mass  = mpData(mp).mpM;                                                      % material point mass
   M(ed) = M(ed)+Svp*mass;                                                      % compute mass at nodes
end

V = zeros(nodes*nD,1);                                                          % zero the velocity vector
A = zeros(nodes*nD,1);                                                          % zero the acceleration vector
for mp = 1:nmp
   nIN = mpData(mp).nIN;                                                        % nodes associated with MP
   nn  = length(nIN);                                                           % number of nodes influencing the MP
   Svp = mpData(mp).Svp;                                                        % basis functions
   mass= mpData(mp).mpM;                                                        % material point mass
   vel = mpData(mp).mpV;                                                        % material point velocity
   acc = mpData(mp).mpA;                                                        % material point acceleration
   gv  = mass*vel*Svp;                                                          % grid velocity
   ga  = mass*acc*Svp;                                                          % grid acceleration
   ed  = repmat((nIN-1)*nD,nD,1)+repmat((1:nD).',1,nn);                         % nodel degrees of freedom
   gm  = repmat(M(nIN).',nD,1);                                                 % nodel mass
   V(ed) = V(ed) + gv./gm;                                                      % combine into velocity vector
   A(ed) = A(ed) + ga./gm;                                                      % combine into velocity vector
end
end

