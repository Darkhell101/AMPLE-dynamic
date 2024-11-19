%AMPLE 1.1: A Material Point Learning Environment
%--------------------------------------------------------------------------
% Author: William Coombs
% Date:   27/08/2020
% Description:
% Large deformation elasto-plastic (EP) material point method (MPM) code
% based on an updated Lagrangian (UL) descripition of motion with a 
% quadrilateral background mesh. 
%
%--------------------------------------------------------------------------
% See also:
% SETUPGRID             - analysis specific information
% ELEMMPINFO            - material point-element information
% DETEXTFORCE           - external forces
% DETFDOFS              - mesh unknown degrees of freedom
% LINSOLVE              - linear solver
% DETMPS                - material point stiffness and internal force
% UPDATEMPS             - update material points
% POSTPRO               - post processing function including vtk output
%--------------------------------------------------------------------------
clear;
addpath('constitutive','functions','plotting','setup','ProgressBar','construct');
tic;
[lstps,dt,g,mpData,mesh] = setupGrid_collapse;                                  % setup information
NRitMax = 10; tol = 1e-9;                                                       % Newton Raphson parameters
[nodes,nD] = size(mesh.coord);                                                  % number of nodes and dimensions
[nels,nen] = size(mesh.etpl);                                                   % number of elements and nodes/element
nDoF = nodes*nD;                                                                % total number of degrees of freedom
nmp  = length(mpData);                                                          % number of material points
lstp = 0;                                                                       % zero loadstep counter (for plotting function)
run postPro;                                                                    % plotting initial state & mesh

for lstp=progress(1:lstps)
    [mesh,mpData] = elemMPinfo(mesh,mpData);                                    % material point - element information
    fext = detExtForce(nodes,nD,g,mpData);                                      % external force calculation (total)
    [M,V0,A0] = detMVA(nodes,nD,g,mpData);                                      % mapping mass, velocity, acceleration to grid
    oobf = fext;                                                                % initial out-of-balance force
    fErr = 1;                                                                   % initial error
    frct = zeros(nDoF,1);                                                       % zero the reaction forces
    uvw  = zeros(nDoF,1);                                                       % zero the displacements
    fd   = detFDoFs(mesh);                                                      % free degrees of freedom
    NRit = 0;                                                                   % zero the iteration counter
    Kt   = 0;                                                                   % zero global stiffness matrix
    while (fErr > tol) && (NRit < NRitMax) || (NRit < 2)                        % global equilibrium loop
        [duvw,drct] = linSolve(mesh.bc,Kt,oobf,NRit,fd);                        % linear solver
        uvw  = uvw+duvw;                                                        % update displacements
        frct = frct+drct;                                                       % update reaction forces
        [fint,Kt,mpData] = detMPs(uvw,mpData,nD);                               % global stiffness & internal force
        [Kd,Fdym] = detDym(uvw,M,V0,A0,dt,nD);                                  % I change your detDym function since your Fdym may be wrong (by Mian Xie)
        Kt=Kt+Kd;
        oobf = (fext-fint+frct-Fdym);                                           % out-of-balance force
        fErr = norm(duvw)/norm(uvw+eps);                                        % normalised uvw error
        NRit = NRit+1;                                                          % increment the NR counter
    end
    
    % For a Newmark scheme, you have to update the grid velocity and 
    % acceleration after you find a converged value (by Mian Xie)
    V = 2*uvw/dt-V0;
    A = 4*uvw/dt/dt-4*V0/dt-A0;
    
    mpData = updateMPs(uvw,A,dt,mpData);                                        % update material points
    run postPro;                                                                % Plotting and post processing
end

elapsedTime=toc;
fprintf('\nTotal time of load  step is %4.3fs\n', lstps*dt);
fprintf('Total time of simulation is %4.3fs\n', elapsedTime);
