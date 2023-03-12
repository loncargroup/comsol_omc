function [model,P] = build_material(model,P,sels)
%BUILDMAT Summary of this function goes here
%   Detailed explanation goes here
P = load_material_parameters(P);
matTags = mphmodel(model.material);
beamMat = P.beamMat;
%Create diamond in the model
if ~isfield(matTags,beamMat)
    bMat = model.material.create(beamMat);
else
    bMat = model.material(beamMat);
end
bMat.label(beamMat);
bMat_def = bMat.propertyGroup('def');
% density
bMat_def.set('density', P.rho);
% rotate crystal from [100] direction, about normal to {100}
if (isfield(P,'rxtal') && isfield(P,'D'))
    [~,D] = RotateXtalTensor(P.D,P.rxtal);
    P.D = D; 
end
% define anisotropic material (and generate full 6x6 elasticity matrix), 
% or define material based on Young's modulus and Poisson's ratio
if isfield(P,'D')
    if length(P.D) < 21
        error('Insufficient number of stiffness constants specified');
    end
    bMat_aniso = bMat.propertyGroup.create('AnisotropicVoGrp', 'Anisotropic, Voigt notation');
    bMat_aniso.set('DVo', P.D);
    
elseif (isfield(P,'E') && isfield(P,'nu')) 
    bMat_def.set('youngsmodulus', P.E);
    bMat_def.set('poissonsratio', P.nu);
else
    error('No stiffness type specified');
end
%Pick the domain to apply this to
bMat.selection.geom('geom1', 3);
bMat.selection.set(sels.diamondDomain);

if P.doOpt
if ~isfield(matTags,'air')
    air = model.material.create('air');
else
    air = model.material('air');
end
air.label('Air');
air_def = air.propertyGroup('def');
nbeam=P.nbeam;
P.sigma = {0,P.sigmaVal};  % conductivity
P.epsilonr = {1,nbeam^2};    % relative permittivity
P.n = {1,nbeam};             % refractive index
% define optical properties of air and beam materials
air_ref = air.propertyGroup.create('air_ref', 'Refractive index');
air_def.set('electricconductivity', P.sigma{1});
air_def.set('relpermittivity', P.epsilonr{1});
air_def.set('relpermeability', 1);
air_ref.set('n', P.n{1});
bMat_ref = bMat.propertyGroup.create('bMat_ref', 'Refractive index');

bMat_def.set('electricconductivity', P.sigma{2});
bMat_def.set('relpermittivity', P.epsilonr{2});
bMat_def.set('relpermeability', 1);
bMat_ref.set('n', P.n{2});

air.selection.geom('geom1', 3);    %to select domain
air.selection.set(sels.airDomain);
end
if P.printText
disp(['Beam material: ',P.beamMat,' added']);
end
end

