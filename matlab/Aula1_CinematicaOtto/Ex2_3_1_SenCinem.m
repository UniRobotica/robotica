% Ex2_3_1_SenCinem.m
% Posição, velocidade e aceleração angular — movimento senoidal
% Seção 2.3 | Aula 1 — Robô Otto
%
% Para theta(t) = A sin(omega t + phi), calcula numericamente
% omega(t) = d theta/dt  e  alpha(t) = d^2 theta/dt^2
% e compara com as expressões analíticas:
%   omega_max  = A * omega
%   alpha_max  = A * omega^2
%
% Altere A, omega e phi para explorar o efeito na demanda de torque.

clc; clear; close all;

% --- parâmetros ---
A   = 20;           % amplitude [graus]
w   = 2;            % frequência angular [rad/s]
phi = pi / 4;       % fase inicial [rad]

t = linspace(0, 10, 1000);

% --- cinemática ---
theta   = A * sin(w * t + phi);
omega_t = gradient(theta, t);       % d theta/dt  [graus/s]
alpha_t = gradient(omega_t, t);     % d2 theta/dt2 [graus/s2]

% --- valores analíticos de pico ---
omega_max_analitico = A * w;        % [graus/s]
alpha_max_analitico = A * w^2;      % [graus/s2]

fprintf('--- Valores analíticos de pico ---\n');
fprintf('omega_max = A*omega    = %.1f graus/s\n', omega_max_analitico);
fprintf('alpha_max = A*omega^2  = %.1f graus/s2\n', alpha_max_analitico);
fprintf('--- Valores numéricos de pico ---\n');
fprintf('omega_max (numérico)   = %.1f graus/s\n', max(abs(omega_t)));
fprintf('alpha_max (numérico)   = %.1f graus/s2\n', max(abs(alpha_t)));

% --- figura ---
figure('Position', [100 100 680 400]);

plot(t, theta,   'LineWidth', 2, 'Color', [0.10 0.48 0.31]); hold on;
plot(t, omega_t, 'LineWidth', 2, 'Color', [0.15 0.39 0.66]);
plot(t, alpha_t, 'LineWidth', 2, 'Color', [0.75 0.22 0.17]);
yline(0, 'k--', 'LineWidth', 0.5);

grid on;
xlabel('Tempo [s]');
ylabel('Magnitude');
title(sprintf('Cinemática angular senoidal  (A = %g°, \\omega = %g rad/s, \\phi = \\pi/4)', A, w));
legend('\theta(t)  [graus]', ...
       '\omega(t) = d\theta/dt  [graus/s]', ...
       '\alpha(t) = d^2\theta/dt^2  [graus/s^2]', ...
       'Location', 'northeast');

% anotação do pico de alpha
[alpha_pk, idx_pk] = max(alpha_t);
text(t(idx_pk) + 0.2, alpha_pk + 1, ...
    sprintf('\\alpha_{max} = A\\omega^2 = %.0f °/s^2', alpha_max_analitico), ...
    'FontSize', 9, 'Color', [0.75 0.22 0.17]);

% exportgraphics(gcf, 'fig03_senoide_cinematica.png', 'Resolution', 150);
