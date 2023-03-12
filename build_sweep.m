function [model,P] = build_sweep(model,P)
%BUILDSWEEP Summary of this function goes here
%   Detailed explanation goes here
%% Define k-points for sweep over wavevectors
% adapted from phononic crystal model on COMSOL

% parameter node for COMSOL model
% k runs from 0 to 3: 0-->1 for Gamma-X, 1-->2 for X-->M, 2-->3 for
% M-Gamma

kpts = P.kpts;
model.param.set('k', '0');
model.param.set('a', [num2str(P.a),'[um]']);
model.param.set('kx', 'pi/a*k');

for ki = 0:kpts
    P.k_norm(ki+1,1) = ki/kpts;
end

% compile expressions for input to COMSOL model
P.kliststr = ['range(0,1/',num2str(kpts),',1)'];
for ki = 1:kpts
    P.kparamstr{ki} = ['"k", "',num2str((ki-1)/kpts),'"'];
end
end

