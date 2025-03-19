function test_kappa(p, q, N)

    % TEST_KAPPA(P, Q, N) Runs the function KAPPA over a multifolium curve
    % of optional parameters 'P', 'Q' (natural numbers) and resolution 'N'.
    % A figure with the multifolium, its superimposed normalised curvature
    % and evolute is generated as an output.


    % Get curve resulotion
    if nargin < 3
        N = 1e4;
    end

    % Get number of geometric features
    if nargin < 2
        M = 10;
        p = randi(M);
        q = randi(M);
    end
    p = p / gcd(p, q);
    q = q / gcd(p, q);
    r = p / q;

    % Get knot vector for calculations
    if p == q
        t = 2 * pi * (0 : 1 / (N - 1) : 1)';
    else
        t = pi * q * (1 + (mod(p * q, 2) == 0)) * (0 : 1 / (N - 1) : 1)';
    end

    % Precalculate trigonometric relations
    c = cos(t);
    s = sin(t);
    cc = cos(r * t);
    ss = sin(r * t);
    
    % Get curvature parameters
    x = cc .* [c, s];
    [k, n, e] = kappa(x);
    K = x + k .* n / max(k);
    
    % Validate curvature and assess discretisation
    a = -r * ss .* [c, s] + cc .* [-s, c];
    b = -cc .* [c, s] .* (r .^ 2 + 1) - 2 * r * ss .* [-s, c];
    res = (a(:, 1) .* b(:, 2) - a(:, 2) .* b(:, 1));
    res = res ./ sqrt(sum(a .* a, 2)) .^ 3;
    if mean(abs(k - res) ./ res) > 1e-4
        warning('Deficient resolution')
    end

    % Plot function, curvature and evolute
    figure
    hold on
    plot(x(:, 1), x(:, 2))
    plot(K(:, 1), K(:, 2))
    plot(e(:, 1), e(:, 2))
    axis equal

    % Get axes limits and adjust ratio
    if p == q
        axis tight
        xx = [-0.25, 1.25];
        yy = [-0.90, 0.70];
    else
        xx = max(max(abs(get(gca, 'xlim'))), max(abs(get(gca, 'ylim'))));
        xx = [-xx, xx];
        yy = xx - [0.2, 0];
    end
    xlim(xx)
    ylim(yy)
    
    % Format axes
    h = findall(gca, 'Type', 'axes');
    set(h, 'box', 'on', 'Color', 'w')
    set(h, 'TickLabelInterpreter', 'LaTeX')
    
    % Format title
    h = title(strcat('Multifolium of $$p, q =$$', {' '}, num2str(p), ...
        ', ', {' '}, num2str(q)));
    set(h, 'FontSize', 12)
    set(h, 'Interpreter', 'LaTeX')
    
    % Format legend
    h = legend('Function', 'Curvature', 'Evolute');
    set(h, 'NumCol', 3)
    set(h, 'Box', 'off')
    set(h, 'Location', 'South')
    set(h, 'Interpreter', 'LaTeX')
end