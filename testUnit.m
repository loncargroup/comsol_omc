function out = model
%
% testUnit.m
%
% Model exported on Mar 11 2023, 18:49 by COMSOL 6.0.0.405.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\LoncarLab\Documents\GitHub\comsol_omc');

model.label('testUnit.mph');

model.param.set('k', '0');
model.param.set('a', '0.3[um]');
model.param.set('kx', 'pi/a*k');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').lengthUnit([native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']);
model.component('comp1').geom('geom1').create('wp', 'WorkPlane');
model.component('comp1').geom('geom1').feature('wp').set('quickz', -0.075);
model.component('comp1').geom('geom1').feature('wp').set('unite', true);
model.component('comp1').geom('geom1').feature('wp').geom.create('Polygon0', 'Polygon');
model.component('comp1').geom('geom1').feature('wp').geom.feature('Polygon0').set('type', 'closed');
model.component('comp1').geom('geom1').feature('wp').geom.feature('Polygon0').set('source', 'table');
model.component('comp1').geom('geom1').feature('wp').geom.feature('Polygon0').set('table', [0.105 0; 0 0.12; -0.105 0; 0.105 0]);
model.component('comp1').geom('geom1').feature('wp').geom.create('csol0', 'ConvertToSolid');
model.component('comp1').geom('geom1').feature('wp').geom.feature('csol0').selection('input').set({'Polygon0'});
model.component('comp1').geom('geom1').feature('wp').geom.create('mir0', 'Mirror');
model.component('comp1').geom('geom1').feature('wp').geom.feature('mir0').set('keep', true);
model.component('comp1').geom('geom1').feature('wp').geom.feature('mir0').set('axis', [0 1]);
model.component('comp1').geom('geom1').feature('wp').geom.feature('mir0').selection('input').set({'csol0'});
model.component('comp1').geom('geom1').feature('wp').geom.create('mov0', 'Move');
model.component('comp1').geom('geom1').feature('wp').geom.feature('mov0').selection('input').set({'mir0' 'csol0'});
model.component('comp1').geom('geom1').create('holes', 'Extrude');
model.component('comp1').geom('geom1').feature('holes').setIndex('distance', '0.15', 0);
model.component('comp1').geom('geom1').feature('holes').selection('input').set({'wp'});
model.component('comp1').geom('geom1').create('blk', 'Block');
model.component('comp1').geom('geom1').feature('blk').set('pos', [-0.15 0 0]);
model.component('comp1').geom('geom1').feature('blk').set('size', [0.3 0.15 0.075]);
model.component('comp1').geom('geom1').create('beam', 'Difference');
model.component('comp1').geom('geom1').feature('beam').selection('input').set({'blk'});
model.component('comp1').geom('geom1').feature('beam').selection('input2').set({'holes'});
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').material.create('diamond', 'Common');

model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');
model.component('comp1').physics('solid').create('pbcX', 'PeriodicCondition', 2);
model.component('comp1').physics('solid').feature('pbcX').selection.set([1 9]);
model.component('comp1').physics('solid').feature('pbcX').create('perBC_dest', 'DestinationDomains', 2);
model.component('comp1').physics('solid').feature('pbcX').feature('perBC_dest').selection.set([9]);
model.component('comp1').physics('solid').create('symBCs', 'SymmetrySolid', 2);
model.component('comp1').physics('solid').feature('symBCs').selection.set([3]);
model.component('comp1').physics('solid').create('asymBCs', 'Antisymmetry', 2);
model.component('comp1').physics('solid').create('symYBCs', 'SymmetrySolid', 2);
model.component('comp1').physics('solid').feature('symYBCs').selection.set([2 8]);

model.component('comp1').mesh('mesh1').autoMeshSize(3);

model.component('comp1').material('diamond').label('diamond');
model.component('comp1').material('diamond').propertyGroup('def').set('density', '3500');
model.component('comp1').material('diamond').propertyGroup('def').set('youngsmodulus', '1.05E12');
model.component('comp1').material('diamond').propertyGroup('def').set('poissonsratio', '0.2');

model.component('comp1').physics('solid').feature('pbcX').set('PeriodicType', 'Floquet');
model.component('comp1').physics('solid').feature('pbcX').set('kFloquet', {'kx'; '0'; '0'});
model.component('comp1').physics('solid').feature('pbcX').label('Periodic BC, x-direction');
model.component('comp1').physics('solid').feature('symBCs').label('Symmetric BC');
model.component('comp1').physics('solid').feature('asymBCs').label('Anti-symmetric BC');
model.component('comp1').physics('solid').feature('symYBCs').label('Symmetric BC Y');

out = model;
