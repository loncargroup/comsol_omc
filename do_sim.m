function freqs = do_sim(P)
%DO_SIM Summary of this function goes here
%   Detailed explanation goes here

[model,sels] = build_geometry(P);
%Build material
[model,P] = build_material(model,P,sels);
%Build sweep
[model,P] = build_sweep(model,P);
%Build physics
[model,sels] = build_smech(model,P,sels);
%Build mesh
model = build_mesh(model,P);
%Build study
[model,solv,pbatch] = build_solver(model,P);

solv.runAll;
pbatch.run;

model.result.dataset('dset1').tag('dset');
dset = model.result.dataset('dset');
dset.set('solution', 'solv');
model.result.dataset('dset2').tag('pdset');
pdset = model.result.dataset('pdset');
pdset.set('solution', 'psolv');
mphsave(model,'testUnit.mph')
%Build analysis

sols = mphsolutioninfo(model);
lambda_inds = find(strcmp(sols.psolv.mapheaders,'lambda'));
k_inds = find(strcmp(sols.psolv.mapheaders,'k'));
inner_inds = find(strcmp(sols.psolv.mapheaders,'Inner'));
outer_inds = find(strcmp(sols.psolv.mapheaders,'Outer'));

freqs = ones(P.kpts+1, P.nbands);
for ki = 0:P.kpts
    % assemble eigenvalues and eigenfrequencies
    lambda_ki = find(sols.psolv.map(:,outer_inds)==ki+1);
    results.lambda = sols.psolv.map(lambda_ki,lambda_inds);
    results.freqs = abs(results.lambda)/(2*pi);
    for nb = 1:P.nbands
        freqs(ki+1,nb) = results.freqs(nb);
    end
end

end

