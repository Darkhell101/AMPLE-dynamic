%Post processing script for the AMPLE code
%--------------------------------------------------------------------------
% Author: William Coombs
% Date:   29/01/2019
% Description:
% The script produces VTK output files based on the background mesh and
% material point data.  
% Background mesh is plotted for lstp = 0.  
%
%--------------------------------------------------------------------------
% POSTPRO
%--------------------------------------------------------------------------
% See also:
% MAKEVTK           - VTK file for background mesh
% MAKEVTKMP         - VTK file for MP data
%--------------------------------------------------------------------------

if lstp==0
    fpath = './output';
    if ~exist(fpath, 'dir')
        mkdir(fpath);
    else
        disp('Folder exists.')
    end
    makeVtk(mesh.coord,mesh.etpl,'output/mesh.vtk')                         % generate mesh VTK file
end

mpDataName = sprintf('output/mpData_%i.vtk',lstp);                          % MP output data file name
sig = reshape([mpData.sig],6,nmp)';                                         % all material point stresses (nmp,6)
mpC = reshape([mpData.mpC],nD,nmp)';                                        % all material point coordinates (nmp,nD)
mpV = reshape([mpData.mpV],nD,nmp)';                                        % all material point velocity (nmp,nD)
mpA = reshape([mpData.mpA],nD,nmp)';                                        % all material point acceleration (nmp,nD)
mpU = [mpData.u]';                                                          % all material point displacements
makeVtkMP(mpC,sig,mpU,mpV,mpA,mpDataName);                                  % generate material point VTK file
if lstp==0
    makeVtk(mesh.coord,mesh.etpl,'output/mesh.vtk')                         % generate mesh VTK file
end


% if lstp==lstps
%     result = tabulate(StateVar(:,1));
%     d = 0;
%     for i=1:length(StateVar)
%         d = d + 1/result(StateVar(i,1), 2);
%         StateVar(i,5) = d;                                                  % update plot indexed in state variables
%     end
%     writematrix(StateVar, './output/Statevar.csv');
% end
