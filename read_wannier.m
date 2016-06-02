function [vsig] = read_wannier(filename,va,center)

% Read the Wannier function file and compute the signature vector
%
% Input arguments:
%
% filename = Wannier function file
% va       = unit vectors of direct lattice
% center   = cartesian coordinate of the Wannier center
%
% Ouput arguments:
%
% vsig = signature vector

fd = fopen(filename);

while ~feof(fd)
    aline = fgetl(fd);
    
    if strncmpi(strtrim(aline),'BEGIN_DATAGRID_3D_',18)
        aline = fgetl(fd);
        a = str2num(aline);
        nx = a(1);
        ny = a(2);
        nz = a(3);
        
        aline = fgetl(fd);
        orig = str2num(aline);
        
        vas = zeros(3,3);
        for i = 1:3
            aline = fgetl(fd);
            vas(i,:) = str2num(aline);
        end
        
        w = zeros(1,nx*ny*nz);
        
        i = 0;
        while i < nx*ny*nz
            aline = fgetl(fd);
            a = str2num(aline);
            w(i+1:i+length(a)) = a;
            i = i+length(a);
        end
        
        w = reshape(w,nx,ny,nz);
    end
end

fclose(fd);

W = permute(w,[2 1 3]);
X = zeros(ny,nx,nz);
Y = zeros(ny,nx,nz);
Z = zeros(ny,nx,nz);

for k = 1:nz
    for j = 1:ny
        for i = 1:nx
            pos = orig+(i-1)/(nx-1)*vas(1,:)+(j-1)/(ny-1)*vas(2,:)+(k-1)/(nz-1)*vas(3,:);
            X(j,i,k) = pos(1);
            Y(j,i,k) = pos(2);
            Z(j,i,k) = pos(3);
        end
    end
end

c = 0.295;

figure
p = patch(isosurface(X,Y,Z,W,c));
p.FaceColor = 'red';
p.EdgeColor = 'none';
hold on
p = patch(isosurface(X,Y,Z,W,-c));
p.FaceColor = 'blue';
p.EdgeColor = 'none';
daspect([1,1,1])
view(3); axis tight
camlight 
lighting gouraud
xlabel('x (Ang)')
ylabel('y (Ang)')
zlabel('z (Ang)')

vsig = zeros(1,20);
xc = center(1);
yc = center(2);
zc = center(3);
%vol = dot(va(1,:),cross(va(2,:),va(3,:))); % volume of unit cell
%vols = dot(vas(1,:),cross(vas(2,:),vas(3,:))); % volume of supercell
Lx = norm(va(1,:));
Ly = norm(va(2,:));
Lz = norm(va(3,:));
x1 = linspace(0,1,nx);
x2 = linspace(0,1,ny);
x3 = linspace(0,1,nz);

count = 0;
for alpha = 0:3
    for beta = 0:3
        for gamma = 0:3
            if alpha+beta+gamma <= 3
                count = count+1;
                F = W.*(sin(2*pi/Lx*(X-xc)).^alpha).*(sin(2*pi/Ly*(Y-yc)).^beta).*(sin(2*pi/Lz*(Z-zc)).^gamma);
                vsig(count) = trapz(x2,trapz(x1,trapz(x3,F,3),2),1);
            end
        end
    end
end

vsig = vsig/norm(vsig);