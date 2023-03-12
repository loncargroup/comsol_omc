clear P

P.a = .3;
P.hx = .7*P.a;
P.hy = .8*P.a;
P.w = 1*P.a;
P.t = .5*P.a;
P.pos = 0;


P.doOpt = 0;

P.kpts = 10;
P.nbands = 6;
P.freq = 1e9;
P.meshSize = 3;
P.printText = 1;

P.beamType = 'hole';
P.beamMat = 'diamond';

P.symZ = 1;
P.symY = 1;

kpts = P.kpts;
k_norm = 0:P.kpts;
for ki = 0:P.kpts
    k_norm(ki+1) = ki/P.kpts;
end
hold on
view(2)
symYZ_freqs = do_sim(P);
ds.F = symYZ_freqs;
[mgsYZ, bgsYZ] = find_gaps(ds);
plot(k_norm,symYZ_freqs*1e-9,"Color","r","LineStyle","-")

for i = 1:length(mgsYZ)
    rectangle(Position = [0,mgsYZ(i)*1e-9-bgsYZ(i)/2*1e-9,1,bgsYZ(i)*1e-9], ...
        FaceColor="r", EdgeColor="r")
end
P.symY = -1;
symZ_asymY_freqs = do_sim(P);
ds.F = symZ_asymY_freqs;
[mgsZaY, bgsZaY] = find_gaps(ds);
view(2)
plot(k_norm,symZ_asymY_freqs*1e-9,"Color","g","LineStyle","-")
% for i = 1:length(mgsZaY)
%     rectangle(Position = [0,mgsZaY(i)*1e-9-bgsZaY(i)/2*1e-9,1,bgsZaY(i)*1e-9], ...
%         FaceColor="g", EdgeColor="g")
% end
% P.symZ = -1;
% asymYZ_freqs = do_sim(P);
% ds.F = asymYZ_freqs;
% [mgaYZ, bgaYZ] = find_gaps(ds);
% plot(k_norm,asymYZ_freqs*1e-9,"Color","g","LineStyle","-")
% for i = 1:length(mgaYZ)
%     rectangle(Position = [0,mgaYZ(i)*1e-9-bgaYZ(i)/2*1e-9,1,bgaYZ(i)*1e-9], ...
%         FaceColor="g", EdgeColor="g")
% end      
