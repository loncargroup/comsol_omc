function [model,sels] = build_geom(P)
%BUILD_GEOM Summary of this function goes here
%   Detailed explanation goes here
import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.component.create('comp1', true);

geom = model.component('comp1').geom.create('geom1', 3);

%Setting length scale to um
geom.lengthUnit([native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']);
wp = geom.create('wp', 'WorkPlane').set('quickz', -P.t/2);
wp.set('unite', true);

hole_params = P;
make_hole(hole_params,wp,0)
mphgeom(model)

hole = geom.create('holes', 'Extrude');
hole.setIndex('distance', P.t, 0);
hole.selection('input').set({'wp'});

sZ = P.symZ;
sY = P.symY;

block = geom.create('blk','Block');
block.set('pos', [-P.a/2 -(1-sY)*P.w/2 -(1-sZ)*P.t/2]);
block.set('base', 'corner');
block.set('size', [P.a (2-sY)*P.w/2 (2-sZ)*P.t/2]);

beam = geom.create('beam', 'Difference');
beam.selection('input').set({'blk'});
beam.selection('input2').set({'holes'});

mphgeom(model)

pbcX1 = index_boundary(geom, [-P.a/2 0 0], [1 0 0]);
pbcX2 = index_boundary(geom, [P.a/2 0 0], [1 0 0]);
sels.pbcXinds = [pbcX1 pbcX2];
sels.pbcXindsR = pbcX2;

%ZSym
symZ = index_boundary(geom, [P.a/2 0 0], [0 0 1]);
sels.symZinds = symZ;

%YSym
symY = index_boundary(geom, [P.w/2 0 0], [0 1 0]);
sels.symYinds = symY;

end

