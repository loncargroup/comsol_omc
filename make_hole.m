function make_hole(hole_params,wp,i)
%BUILD_HOLE: This function takes a set of hole_parameters and makes a hole
%in a given workplane

if strcmp(hole_params.beamType,'rib')
    build_rib(wp, hole_params,i);
elseif strcmp(hole_params.beamType,'hole')
    build_ellipse(wp,hole_params,i);
elseif strcmp(hole_params.beamType,'tri')
    build_tri(wp,hole_params,i);
else
    ellName = ['Throw',num2str(i)];
    ell = wp.geom.create(ellName,'Ellipse');
    ell.set('pos', [0 10]);
    ell.set('semiaxes', [1 1]);
end
end

function build_ellipse(wp,hole_params,i)
hx=hole_params.hx;
hy=hole_params.hy;
pos=hole_params.pos;

ellName = ['Ellipse',num2str(i)];
ell = wp.geom.create(ellName,'Ellipse');
ell.set('pos', [pos 0]);
ell.set('semiaxes', [hx/2 hy/2]);
end

function build_rib(wp,hole_params,i)
    a = hole_params.a;
    hx=hole_params.hx;
    hy=hole_params.hy;
    beamW=hole_params.w;
    pos=hole_params.pos;
    curveOneName = ['curveOne',num2str(i)];
    curveOne = wp.geom.create(curveOneName, 'ParametricCurve');
    curveOne.set('parmin', -a/2);
    curveOne.set('parmax', -hx/2);
    curveOne.set('coord', {'s' [num2str(-hy/(a-hx)^2,8),'*(s+',num2str(a/2,8),')^2 + ',num2str(beamW/2,8)]});
    curveTwoName = ['curveTwo',num2str(i)];
    curveTwo = wp.geom.create(curveTwoName, 'ParametricCurve');
    curveTwo.set('parmin', -hx/2);
    curveTwo.set('parmax', a/2-hx);
    curveTwo.set('coord', {'s' [num2str((beamW-hy)/2,8),'+', num2str(hy/(a-hx)^2,8),'*(s+',num2str(hx-a/2,8),')^2']});
    LineBotName = ['BotLine',num2str(i)];
    lineBot = wp.geom.create(LineBotName, 'LineSegment');
    lineBot.set('specify1', 'coord');
    lineBot.set('coord1', [(a/2-hx) (beamW-hy)/2]);
    lineBot.set('specify2', 'coord');
    lineBot.set('coord2', [(hx-a/2) (beamW-hy)/2]);
    curveThreeName = ['curveThree',num2str(i)];
    curveThree = wp.geom.create(curveThreeName, 'ParametricCurve');
    curveThree.set('parmin', hx-a/2);
    curveThree.set('parmax', hx/2);
    curveThree.set('coord', {'s' [num2str( (beamW-hy)/2,8),'+', num2str(hy/(a-hx)^2,8),'*(s+',num2str(-hx+a/2,8),')^2']});
    curveFourName = ['curveFour',num2str(i)];
    curveFour = wp.geom.create(curveFourName, 'ParametricCurve');
    curveFour.set('parmin', hx/2);
    curveFour.set('parmax', a/2);
    curveFour.set('coord', {'s' [num2str(-hy/(a-hx)^2,8),'*(s-',num2str(a/2,8),')^2+',num2str(beamW/2,8)]});
    LineTopName = ['TopLine',num2str(i)];
    lineTop = wp.geom.create(LineTopName, 'LineSegment');
    lineTop.set('specify1', 'coord');
    lineTop.set('coord1', [-a/2 beamW/2]);
    lineTop.set('specify2', 'coord');
    lineTop.set('coord2', [a/2 beamW/2]);
    convertName = ['csol',num2str(i)];
    convert = wp.geom.create(convertName, 'ConvertToSolid');
    convert.selection('input').set({LineBotName LineTopName curveOneName curveTwoName curveThreeName curveFourName});
    convert.set('repairtoltype', 'relative');
    convert.set('repairtol', 1.0E-6);

    mirName = ['mir',num2str(i)];
    mir = wp.geom.create(mirName, 'Mirror');
    mir.set('keep', true);
    mir.set('axis', [0 1]);
    mir.selection('input').set({convertName});
    movName = ['mov',num2str(i)];
    mov = wp.geom.create(movName, 'Move');
    mov.setIndex('displx', pos, 0);
    mov.selection('input').set({mirName convertName});
end

function build_tri(wp,hole_params,i)
hx=hole_params.hx;
hy=hole_params.hy;
pos=hole_params.pos;

polName = ['Polygon',num2str(i)];
poly = wp.geom.create(polName, 'Polygon');
poly.set('type', 'closed');
poly.set('source', 'table');
poly.set('table', [hx/2 0;0 hy/2;-hx/2 0;hx/2 0]);

convertName = ['csol',num2str(i)];
convert = wp.geom.create(convertName, 'ConvertToSolid');
convert.selection('input').set({polName});

mirName = ['mir',num2str(i)];
mir = wp.geom.create(mirName, 'Mirror');
mir.set('keep', true);
mir.set('axis', [0 1]);
mir.selection('input').set({convertName});

movName = ['mov',num2str(i)];
mov = wp.geom.create(movName, 'Move');
mov.setIndex('displx', pos, 0);
mov.selection('input').set({mirName convertName});
end
