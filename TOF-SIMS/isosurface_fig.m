% Load data
data_mg = readtable('NaF_5min_top_O1keV_p2 (18) - Mg+.txt');
data_CaF = readtable("NaF_5min_top_O1keV_p2 (21) - CaF+.txt");
data_Na = readtable('NaF_5min_top_O1keV_p2 (19) - Na+.txt');
data_total = readtable('NaF_5min_top_O1keV_p2 (0) - total.txt');

% extract data
x = data_mg.Var1;
y = data_mg.Var2;
z1 = data_mg.Var3;
% flip up 
z = flipud(z1);
% convert the data to atom%
atom = data_mg.Var4 ./ data_total.Var4 * 100;

% Set the resolution of grid
grid_size = 200;

% Take the data region
x_min = min(x);
x_max = max(x);
y_min = min(y);
y_max = max(y);
z_min = min(z);
z_max = max(z);

% Create the grid from scatter data
xq = linspace(x_min, x_max, grid_size);
yq = linspace(y_min, y_max, grid_size);
zq = linspace(z_min, z_max, grid_size);
[Xq, Yq, Zq] = meshgrid(xq, yq, zq);

% Convert scatter data to grid
Vq = griddata(x, y, z, atom, Xq, Yq, Zq, 'linear');

% Calsium fluoride ver
x_F = data_CaF.Var1;
y_F = data_CaF.Var2;
z1_F = data_CaF.Var3;
z_F = flipud(z1_F);
atom_F = data_CaF.Var4 ./ data_total.Var4 * 100;

% Set the resolution of grid
grid_size = 200;

% Take the data region
x_min_F = min(x_F);
x_max_F = max(x_F);
y_min_F = min(y_F);
y_max_F = max(y_F);
z_min_F = min(z_F);
z_max_F = max(z_F);

% Create the grid from scatter data
xq_F = linspace(x_min_F, x_max_F, grid_size);
yq_F = linspace(y_min_F, y_max_F, grid_size);
zq_F = linspace(z_min_F, z_max_F, grid_size);
[Xq_F, Yq_F, Zq_F] = meshgrid(xq_F, yq_F, zq_F);

% Convert scatter data to grid
Vq_F = griddata(x_F, y_F, z_F, atom_F, Xq_F, Yq_F, Zq_F, 'linear');

x_Na = data_Na.Var1;
y_Na = data_Na.Var2;
z1_Na = data_Na.Var3;
z_Na = flipud(z1_Na);
atom_Na = data_Na.Var4 ./ data_total.Var4 * 100;

% Set the resolution of grid
grid_size = 200;

% Take the data region
x_min_Na = min(x_Na);
x_max_Na = max(x_Na);
y_min_Na = min(y_Na);
y_max_Na = max(y_Na);
z_min_Na = min(z_Na);
z_max_Na = max(z_Na);

% Create the grid from scatter data
xq_Na = linspace(x_min_Na, x_max_Na, grid_size);
yq_Na = linspace(y_min_Na, y_max_Na, grid_size);
zq_Na = linspace(z_min_Na, z_max_Na, grid_size);
[Xq_Na, Yq_Na, Zq_Na] = meshgrid(xq_Na, yq_Na, zq_Na);

% Convert scatter data to grid
Vq_Na = griddata(x_Na, y_Na, z_Na, atom_Na, Xq_Na, Yq_Na, Zq_Na, 'linear');


% Display isosurface for atom density >= 8%
figure;
p = patch(isosurface(Xq, Yq, Zq, Vq, 6));
isonormals(Xq, Yq, Zq, Vq, p);
p.FaceColor = 'red';
p.EdgeColor = 'none';
camlight; lighting phong;

hold on
p_F = patch(isosurface(Xq_F, Yq_F, Zq_F, Vq_F, 4));
isonormals(Xq_F, Yq_F, Zq_F, Vq_F, p_F);
p_F.FaceColor = 'blue'
p_F.EdgeColor = 'none';

p_Na = patch(isosurface(Xq_Na, Yq_Na, Zq_Na, Vq_Na, 0.5));
isonormals(Xq_Na, Yq_Na, Zq_Na, Vq_Na, p_Na);
p_Na.FaceColor = 'green'
p_Na.EdgeColor = 'none';

hold off
camlight; lighting phong;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Isosurface of Atom Density >= 8%');
axis tight; view(3);
grid on;

volumeViewer

%%
I = imread("OU_F5min_p_CaF_Mg_4_6_top.tif");
imshow(I,[]);
impixel

%%
% extract isosurface data
[faces, verts] = isosurface(Xq,Yq,Zq,Vq,6);
% Find the z-axis center index
center_z = (z_min + z_max) / 2;

% Filter vertices close to the z-axis center
tolerance = (z_max - z_min) / grid_size;  % Define a tolerance level based on the grid size
close_to_center = abs(verts(:, 3) - center_z) < tolerance;

% Extract the vertices close to the z-axis center
verts_center_slice = verts(close_to_center, :);

% Create a 2D scatter plot of the isosurface at the z-axis center
figure;
scatter(verts_center_slice(:, 1), verts_center_slice(:, 2), 10, verts_center_slice(:, 3), 'filled');
colormap('jet');
colorbar;
xlabel('X-axis');
ylabel('Y-axis');
title('Isosurface Vertices near Z-axis Center');
axis equal;