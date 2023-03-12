function [model,sels] = build_smech(model,P,sels)
%CREATESMECH Summary of this function goes here
%   Detailed explanation goes here
%% Create physics 
smech = model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');

if (isfield(P,'rxtal') && isfield(P,'D'))
    smech.feature('lemm1').set('SolidModel', 'Anisotropic');
    smech.feature('lemm1').set('AnisotropicOption', 'AnisotropicVo');
    smech.feature('lemm1').set('DVo_mat', 'from_mat');
elseif (isfield(P,'E') && isfield(P,'nu')) 
    smech.feature('lemm1').set('SolidModel', 'Isotropic');
    smech.feature('lemm1').set('IsotropicOption', 'Enu');
    smech.feature('lemm1').set('E_mat', 'from_mat');
    smech.feature('lemm1').set('nu_mat', 'from_mat');
end
smech.feature('lemm1').set('rho_mat', 'from_mat');
smech.selection.set(sels.diamondDomain);

sels.pbc_inds = [];

pbcX = smech.create('pbcX', 'PeriodicCondition', 2);
pbcX.label('Periodic BC, x-direction');
pbcX.set('PeriodicType', 'Floquet');
sels.pbc_inds(end+1:end+length(sels.pbcXinds)) = sels.pbcXinds;
pbcX.selection.set(sels.pbcXinds);
perBC_dest = pbcX.create('perBC_dest', 'DestinationDomains', 2);
perBC_dest.selection.set(sels.pbcXindsR);    %set face at x=a/2 as destination
pbcX.set('kFloquet', {'kx'; '0'; '0'});        %initialize Floquet vector

%Here is where we do the creation of the 4 symBCs
sym_y_BCs = smech.create('sym_Y_BCs', 'SymmetrySolid', 2);
sym_y_BCs.label('Symmetric Y BC');

asym_y_BCs = smech.create('asym_Y_BCs', 'Antisymmetry', 2);
asym_y_BCs.label('Anti-symmetric Y BC');

sym_z_BCs = smech.create('sym_Z_BCs', 'SymmetrySolid', 2);
sym_z_BCs.label('Symmetric Z BC');

asym_z_BCs = smech.create('asym_Z_BCs', 'Antisymmetry', 2);
asym_z_BCs.label('Anti-symmetric Z BC');
% symmetric BC for xz plane containing point (0,0,0)
if P.symY == 1
    sym_y_BCs.selection.set(sels.symYinds);
    asym_y_BCs.selection.set([]);
elseif P.symY == -1
    asym_y_BCs.selection.set(sels.symYinds);
    sym_y_BCs.selection.set([]);
else
    asym_y_BCs.selection.set([]);
    sym_y_BCs.selection.set([]);
end

% symmetric BC for xy plane containing point (0,0,0)
if P.symZ == 1
    sym_z_BCs.selection.set(sels.symZinds);
    asym_z_BCs.selection.set([]);
elseif P.symZ == -1
    asym_z_BCs.selection.set(sels.symZinds);
    sym_z_BCs.selection.set([]);
else
    asym_z_BCs.selection.set([]);
    sym_z_BCs.selection.set([]);
end
end

