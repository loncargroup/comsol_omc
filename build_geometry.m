function [model,sels] = build_geometry(P)
%BUILD_GEOM Summary of this function goes here
%   Detailed explanation goes here
import com.comsol.model.*
import com.comsol.model.util.*

a = P.a;
w = P.w;
t = P.t;
sZ = abs(P.symZ);
sY = abs(P.symY);

model = ModelUtil.create('Model');
model.component.create('comp1', true);
geom = model.component('comp1').geom.create('geom1', 3);
ModelUtil.showProgress(true);
%Setting length scale to um
model.geom('geom1').lengthUnit('um');
wp = geom.create('wp', 'WorkPlane').set('quickz', -t/2);
wp.set('unite', true);

make_hole(P,wp,0)

hole = geom.create('holes', 'Extrude');
hole.setIndex('distance', t, 0);
hole.selection('input').set({'wp'});

block = geom.create('blk','Block');
block.set('pos', [-a/2 -(1-sY)*w/2 -(1-sZ)*t/2]);
block.set('base', 'corner');
block.set('size', [a (2-sY)*w/2 (2-sZ)*t/2]);

beam = geom.create('beam', 'Difference');
beam.selection('input').set({'blk'});
beam.selection('input2').set({'holes'});

mphgeom(model)

pbcX1 = index_boundary(geom, [-a/2 0 0], [1 0 0]);
pbcX2 = index_boundary(geom, [a/2 0 0], [1 0 0]);
sels.pbcXinds = [pbcX1 pbcX2];
sels.pbcXindsR = pbcX2;

%ZSym
symZ = index_boundary(geom, [a/2 0 0], [0 0 1]);
sels.symZinds = symZ;

%YSym
symY = index_boundary(geom, [w/2 0 0], [0 1 0]);
sels.symYinds = symY;

delta = .01;
sels.diamondDomain = mphselectbox(model, 'geom1',[-a/2-delta -w/2-delta -t/2-delta; a/2+delta w/2+delta t/2+delta]', 'domain');
end

