% Rapid calculation of discrete 1D curvature 'k', normal 'n' and evolute 'e' for a curve 'X' in the 
% two or three-dimensional Euclidean space. Optional parameter 'f' for rotating frame corrections 
% for preventing normal inversion at the inflexion points of X. Calling [k, n, e] = kappa(X, f) returns:
    % Discrete 1-D curvature vector 'k' calculated as the inverse of the radius of the circumscribing 
        % circle for every triplet of points in X. The end-values of the curvature are corrected with 
        % linear mid-point extrapolation.
    % Normals 'n' of the curve X calculated as the normalised difference between X and its evolute.
    % Evolute 'e' of the curve X calculated as the locus of the centres of the previously-defined 
        % circumscribing circles.
% Use of matrix form for maximising the speed of calculations and avoiding unnecessary pre-allocations. Some examples of the use of this function are:

% 2D Cardioid
path('toolbox',path);
close all; clear; clc;
t = 2 * pi * (0 : 1 / (1000 - 1) : 1)';
X = [(0.5 + cos(t)) .* sin(t), (0.5 + cos(t)) .* cos(t)];
[k, n, e] = kappa(X);
K = X + k .* n / max(k);

figure
hold on
plot(X(:, 1), X(:, 2))
plot(K(:, 1), K(:, 2))
plot(e(:, 1), e(:, 2))
legend('x','k','e');
axis equal
xlim([-1, 1])
ylim([-0.75, 1.75])

figure
hold on
h = plot(X(:, 1), X(:, 2), 'LineWidth', 1.2, 'Color', '#0072BD');
h.Color(4) = 0.8;
h = plot(K(:, 1), K(:, 2), 'LineWidth', 1.0, 'Color', '#0072BD');
h.Color(4) = 0.6;
for i = 1 : 1000 - 1
    h = plot([X(i, 1), K(i, 1)], [X(i, 2), K(i, 2)], 'Color', '#0072BD');
    h.Color(4) = 0.1;
end
axis equal
xlim([-1, 1])
ylim([-0.75, 1.75])

figure
hold on
h = plot(X(:, 1), X(:, 2), 'LineWidth', 1.2, 'Color', '#D95319');
h.Color(4) = 0.8;
h = plot(e(:, 1), e(:, 2), 'LineWidth', 1.0, 'Color', '#D95319');
h.Color(4) = 0.6;
for i = 1 : 1000 - 1
    h = plot([X(i, 1), e(i, 1)], [X(i, 2), e(i, 2)], 'Color', '#D95319');
    h.Color(4) = 0.1;
end
axis equal
xlim([-1, 1])
ylim([-0.75, 1.75])

%%
% 3D Derived Lissajous
t = 2 * pi * (0 : 1 / (1000 - 1) : 1)';
X = [cos(t), sin(t), 1.2 * cos(2 * t)];
[k, n, ~] = kappa(X);
K = X + k .* n / 8;
E = 1 ./ k;
E = X + E .* n / 16;

figure
hold on
plot3(X(:, 1), X(:, 2), X(:, 3))
plot3(K(:, 1), K(:, 2), K(:, 3))
plot3(E(:, 1), E(:, 2), E(:, 3))
view (3)
axis equal
xlim([-1, 1])
ylim([-1, 1])

figure
hold on
for i = 1 : 1000 - 1
    plot3([X(i, 1), K(i, 1)], [X(i, 2), K(i, 2)], [X(i, 3), K(i, 3)], ...
         'Color', [0.9 0.9447 0.9741]);
end
plot3(X(:, 1), X(:, 2), X(:, 3), 'LineWidth', 1.2, 'Color', ...
     [0.2 0.5576 0.7928]);
plot3(K(:, 1), K(:, 2), K(:, 3), 'LineWidth', 1.0, 'Color', ...
     [0.4 0.6682 0.8446]);
view(3)
axis equal
xlim([-1, 1])
ylim([-1, 1])

figure
hold on
for i = 1 : 1000 - 1
    plot3([X(i, 1), E(i, 1)], [X(i, 2), E(i, 2)], [X(i, 3), E(i, 3)], ...
         'Color', [0.985 0.9325 0.9098]);
end
plot3(X(:, 1), X(:, 2), X(:, 3), 'LineWidth', 1.2, 'Color', ...
     [0.88 0.46 0.2784]);
plot3(E(:, 1), E(:, 2), E(:, 3), 'LineWidth', 1.0, 'Color', ...
     [.91 0.595 0.4588]);
view(3)
axis equal
xlim([-1, 1])
ylim([-1, 1])

%%
% Correction of Frenet's frame of reference with rotating frame motion
b = (-1 : 2 / (1000 - 1) : 1)';
b = [b, b .^ 2 .* (b - 1)];
[k, n] = kappa(b, 0);
[K, N] = kappa(b, 1);

k = b + k .* n / max(k) / 10;
K = b + K .* N / max(K) / 10;

figure
hold on
plot(b(:, 1), b(:, 2), 'Color', 'k')
plot(k(:, 1), k(:, 2), 'Color', '#0072BD')
plot(K(:, 1), K(:, 2), 'Color', '#D95319')
title('Frenet (blue) and Rotated Frame (orange) curvatures')
axis equal

figure
hold on
plot(n, 'Color', '#0072BD')
plot(N, 'Color', '#D95319')
title('Frenet (blue) and Rotated Frame (orange) normals')