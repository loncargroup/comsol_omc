function [model,solv,pbatch]  = build_solver(model,P)
%% Add study and solver sequences
% add parametric and eigenfrequency study
study = model.study.create('study');
std_param = study.create('std_param', 'Parametric');
std_param.set('pname', 'k');
std_param.set('plistarr', P.kliststr);
std_param.set('punit', '');
std_eigv = study.create('std_eigv','Eigenfrequency');
std_eigv.set('neigsactive',true).set('neigs',P.nbands);
std_eigv.set('shiftactive',true).set('shift',num2str(0-1i*2*pi*P.freq));

solv = model.sol.create('solv');
solv.study('study');           % connect solver sequence to study node
solv.attach('study');         % comes from .m saved from GUI - needed?
solv_stdstep = solv.create('solv_stdstep', 'StudyStep'); % define study step, vars, solver node
solv_stdstep.set('study','study').set('studystep','std_eigv');
solv_vars = solv.create('solv_vars', 'Variables');
solv_vars.set('control','std_eigv');
solv_eigv = solv.create('solv_eigv', 'Eigenvalue');
solv_eigv.set('transform', 'eigenfrequency');
solv_eigv.set('control','std_eigv');
solv_eigv.set('eigref',num2str(0-1i*2*pi*P.freq));
solv_eigv.feature('dDef').set('linsolver', 'spooles');
solv_eigv.feature('aDef').set('complexfun', 'off');

psolv = model.sol.create('psolv');
psolv.study('study');

% add batch job configuration for parameter sweep
pbatch = model.batch.create('pbatch', 'Parametric');
pbatch_solseq = pbatch.create('pbatch_solseq', 'Solutionseq');
pbatch.study('study');
pbatch.attach('study');
pbatch.set('pname', 'k');
pbatch.set('plistarr', P.kliststr);
pbatch.set('punit', '');
pbatch.set('err', true);
pbatch.set('control', 'std_param');
pbatch_solseq.set('psol', 'psolv');
pbatch_solseq.set('param', P.kparamstr);
pbatch_solseq.set('seq', 'solv');
end

