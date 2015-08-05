function [RGB,Err] = xyz2rgb(X,Y,Z)
% xyz2rgb v1.32
%
% This function calculates RGB triplets for CIE (1931) XYZ values
%
% Usage: GAMXYZ = xyz2rgb(filename) (= initialization) or
%
%     [RGB,Err] = xyz2rgb(XYZ) or
%     [RGB,Err] = xyz2rgb(X,Y,Z)
%
%           filename = display calibration file name
%             GAMXYZ = 3 x 3 matrix of monitor gamut XYZ values
%                XYZ = (n x 3) matrix or
%			   X,Y,Z = individual X,Y,Z arrays of equal size
%                RGB = (n x 3) matrix
%                Err = (n x 1) matrix of error values:-
%                      Err(i) is the sum of the following errors
%                      Err(i)=1 - XYZ reset from -ve to zero
%                      Err(i)=2 - High Y value reset
%                      Err(i)=4 - Gamut error correction
%
global COGGPH_RGB2XYZ

BadArg = 1;
switch nargin
case 0
	clear global COGGPH_RGB2XYZ
    return
case 1
	if isnumeric(X)
		[m,n] = size(X);
		if (n == 3)
			XYZ = X;
			BadArg = 0;
		end
	elseif ischar(X)
		if X == '?'
			PrintUsage
			return
		end
			
        GAMXYZ = rgb2xyz(X);
        if nargout > 0
            RGB = GAMXYZ;
        end
		return
	end
case 3
	if (length(X(:)) == length(Y(:)))&(length(X(:)) == length(Z(:)))
		XYZ = [X(:) Y(:) Z(:)];
		BadArg = 0;
	end
end

if BadArg
	PrintUsage
	return
end

BadArg = 1;
if exist('COGGPH_RGB2XYZ')
	if isstruct(COGGPH_RGB2XYZ)
		BadArg = 0;
	end
end

if BadArg
	fprintf('\nERROR - First initialize with xyz2rgb(filename)\n')
	fprintf('where filename = display calibration file name\n\n')
	return
end

[RGB,Err] = XYZRGBM(XYZ);

return
%--------------------------------------------------------
% This function prints the usage guide
%
function PrintUsage

fprintf('\n xyz2rgb v1.32\n\n')
fprintf('This function calculates RGB triplets for CIE (1931) XYZ values\n\n')
fprintf('Usage: GAMXYZ = xyz2rgb(filename) (= initialization) or\n\n')
fprintf('    [RGB,Err] = xyz2rgb(XYZ) or\n')
fprintf('    [RGB,Err] = xyz2rgb(X,Y,Z)\n\n')
fprintf('            filename = display calibration file name\n')
fprintf('              GAMXYZ = 3 x 3 matrix of monitor gamut XYZ values\n')
fprintf('                 XYZ = (n x 3) matrix\n')
fprintf('               X,Y,Z = individual X,Y,Z arrays of equal length\n\n')
fprintf('                 RGB = (n x 3) matrix\n')
fprintf('                 Err = (n x 1) matrix of error values:-')
fprintf('                       Err(i) is the sum of the following errors\n')
fprintf('                       Err(i)=1 - XYZ reset from -ve to zero\n')
fprintf('                       Err(i)=2 - High Y value reset\n')
fprintf('                       Err(i)=4 - Gamut error correction\n\n')

return
%--------------------------------------------------------
% This function converts XYZ to RGB
%
function [RGB,ERR] = XYZRGB(XYZ)

global COGGPH_RGB2XYZ

RGB = [0 0 0];
ERR = 0;
ERR2 = 0;

a = find(XYZ < 0);
if ~isempty(a)
	XYZ(a) = 0;
	ERR = bitor(ERR,1);
    ERR2 = bitor(ERR2,1);
end

XYZ = max(XYZ - COGGPH_RGB2XYZ.ZERXYZ,[0 0 0]);

F = COGGPH_RGB2XYZ.MAXXYZ'\XYZ';
%
% Ignore small discrepancies
%
Factor = 10000;
F = round(F*Factor)/Factor;

if max(F) > 1
    ERR = bitor(ERR,2);
    F = F/max(F);
end

i = find(F < 0);
if ~isempty(i)
    ERR = bitor(ERR,4);
    F(i) = 0;
    %
    % Try moving towards white
    %
    XYZ2 = MoveXYZ(XYZ);
    F2 = COGGPH_RGB2XYZ.MAXXYZ'\XYZ2';
    F2 = round(F2*Factor)/Factor;
    ERR2 = bitor(ERR2,4);
    if max(F2) > 1
        ERR2 = bitor(ERR2,2);
        F2 = F2/max(F2);
    end
    i = find(F2 < 0);
    if isempty(i)
        ERR = ERR2;
        F = F2;
    end
end

for i = 1:3
    [minval,minind] = min(abs(COGGPH_RGB2XYZ.INTXYZ(i,:) - F(i)));
    RGB(i) = COGGPH_RGB2XYZ.INTRGB(minind);
end

return
%
% This function moves the requested XYZ point towards the white point(x,y,z) = (1/3,1/3,1/3)
% to get it within monitor gamut
%
function newXYZ = MoveXYZ(XYZ)

global COGGPH_RGB2XYZ

x = XYZ(1)/sum(XYZ);
y = XYZ(2)/sum(XYZ);
BigY = XYZ(2);

for i = 1:3
    xp(i) = COGGPH_RGB2XYZ.MAXXYZ(i,1)/sum(COGGPH_RGB2XYZ.MAXXYZ(i,:));
    yp(i) = COGGPH_RGB2XYZ.MAXXYZ(i,2)/sum(COGGPH_RGB2XYZ.MAXXYZ(i,:));
end

x0 = 1/3;
y0 = 1/3;
dmin = -1;
for i = 1:3
    j = 1 + mod(i,3);
    
    x1 = xp(i);
    y1 = yp(i);
    x2 = xp(j);
    y2 = yp(j);
    
    [xi,yi,e] = Intersect(x0,y0,x,y,x1,y1,x2,y2);
    
    if e < 1
        dx = x1 - x2;
        dy = y1 - y2;
        
        d1 = dx*dx + dy*dy;

        dx = xi - x1;
        dy = yi - y1;

        d2 = dx*dx + dy*dy;
        
        dx = xi - x2;
        dy = yi - y2;

        d3 = dx*dx + dy*dy;

        if (d1 >= d2)&(d1 >= d3)
            dx = xi - x;
            dy = yi - y;
    
            d = dx*dx + dy*dy;
    
            if (dmin < 0)|(d < dmin)
                dmin = d;
                xmin = xi;
                ymin = yi;
            end
        end
    end
end

if dmin < 0
    newXYZ = XYZ;
else
    newXYZ = [xmin*BigY/ymin BigY (1 - xmin - ymin)*BigY/ymin];
end

return

function [xi,yi,e] = Intersect(x1,y1,x2,y2,x3,y3,x4,y4)

b1_b2 = (y2 - y1)*(x4 - x3) - (y4 - y3)*(x2 - x1);

if b1_b2 == 0
    xi = 0;
    yi = 0;
    e = 1;
    return;
end

a1_a2 = (x2*y1 - x1*y2)*(x4 - x3) - (x4*y3 - x3*y4)*(x2 - x1);
xi = -a1_a2/b1_b2;

a1_a2 = (y4*x3 - y3*x4)*(y2 - y1) - (y2*x1 - y1*x2)*(y4 - y3);
yi = -a1_a2/b1_b2;

e = 0;

return
%--------------------------------------------------------
% This function converts XYZ to RGB
%
function [RGB,ERR] = XYZRGBM(XYZ)

global COGGPH_RGB2XYZ

[m,n] = size(XYZ);

ERR = uint8(zeros(1,m));
ERR2 = ERR;

a = find(XYZ < 0);
if ~isempty(a)
	XYZ(a) = 0;
    a2 = 1 + mod((a - 1),m);
	ERR(a2) = bitor(ERR(a2),1);
    ERR2(a2) = bitor(ERR2(a2),1);
end

XYZ = XYZ - repmat(COGGPH_RGB2XYZ.ZERXYZ,m,1);
a = find(XYZ < 0);
if ~isempty(a)
	XYZ(a) = 0;
end

F = COGGPH_RGB2XYZ.MAXXYZ'\XYZ';
%
% Ignore small discrepancies
%
Factor = 10000;
F = round(F*Factor)/Factor;

a = find(F > 1);

if ~isempty(a)
    a2 = sort(fix((a + 2)/3));
    %
    % a2 has the indices of all F values greater than one.
    %
    % There may be some duplicates. Remove them.
    %
    k = 1 + find((a2(2:end) - a2(1:(end - 1))) ~= 0);
    a3 = [a2(1)' a2(k)'];
    ERR(a3) = bitor(ERR(a3),2);
    F(:,a3) = F(:,a3)./repmat(max(F(:,a3)),3,1);
end

a = find(F < 0);

if ~isempty(a)
    a2 = sort(fix((a + 2)/3));
    %
    % a2 has the indices of all F values less than zero.
    %
    % There may be some duplicates. Remove them.
    %
    k = 1 + find((a2(2:end) - a2(1:(end - 1))) ~= 0);
    a3 = [a2(1)' a2(k)'];
    ERR(a3) = bitor(ERR(a3),4);
    
    F(a) = 0;
    %
    % Try moving towards white
    %
    for i = 1:length(a3)
		a3i = a3(i);
        tmpXYZ = XYZ(a3i,:);
        
        XYZ2 = MoveXYZ(tmpXYZ);
        F2 = COGGPH_RGB2XYZ.MAXXYZ'\XYZ2';
        F2 = round(F2*Factor)/Factor;
        ERR2(a3i) = bitor(ERR2(a3i),4);
        if max(F2) > 1
            ERR2(a3i) = bitor(ERR2(a3i),2);
            F2 = F2/max(F2);
        end
        ii = find(F2 < 0);
        if isempty(ii)
            ERR(a3i) = ERR2(a3i);
            F(:,a3i) = F2;
        end
    end
end

RGB = zeros(3,m);

for i = 1:3
    tmpINTXYZ = COGGPH_RGB2XYZ.INTXYZ(i,:);
    tmpF = F(i,:);
    
    aa = tmpF;
    bb = tmpINTXYZ;
    
    mm = size(aa,2);
    nn = size(bb,2);
    [cc,pp] = sort([aa,bb]);
    qq = 1:mm+nn;
    qq(pp) = qq;
    tt = cumsum(pp>mm);
    rr = 1:nn; rr(tt(qq(mm+1:mm+nn))) = rr;
    ss = tt(qq(1:mm));
    id = rr(max(ss,1));
    iu = rr(min(ss+1,nn));
    [dd,it] = min([abs(aa-bb(id));
    abs(bb(iu)-aa)]);
    ib = id+(it-1).*(iu-id);    
    
    minind = ib;
    
    RGB(i,:) = COGGPH_RGB2XYZ.INTRGB(minind);
end

RGB = RGB';

return
