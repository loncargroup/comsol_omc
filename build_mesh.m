function model = build_mesh(model,P)
%BUILD_MESH Summary of this function goes here
%   Detailed explanation goes here

model.component('comp1').mesh.create('mesh1');
model.component('comp1').mesh('mesh1').autoMeshSize(P.meshSize);
end

