% Ex2_4_1_Torque.m
% Torque dinâmico e gravitacional sobre um segmento articulado
% Seção 2.4 | Aula 1 — Robô Otto
%
% Para theta(t) = A sin(omega t), calcula:
%   tau_din(t) = I * alpha(t)          torque de inércia
%   tau_grav(t) = m*g*r * cos(theta)   torque gravitacional
%   tau_total   = tau_din + tau_grav   demanda total do servo
%
% O segmento é modelado como haste uniforme: I = m*L^2/3, r = L/2.
% Compara tau_total com a capacidade nominal do servo SG90.

clc; clear; close all;

% --- parâmetros do segmento ---
m  = 0.010;         % massa do segmento [kg]  (10 g)
L  = 0.05;          % comprimento [m]          (5 cm)
g  = 9.81;          % aceleração gravitacional [m/s2]
I  = m * L^2 / 3;   % momento de inércia — haste uniforme [kg·m2]
r  = L / 2;         % distância CoM–eixo [m]

% --- parâmetros do movimento ---
A     = deg2rad(20);    % amplitude [rad]
omega = 2;              % frequência angular [rad/s]
t     = linspace(0, 6, 600);

% --- cinemática ---
theta   = A * sin(omega * t);
alpha_t = -A * omega^2 * sin(omega * t);   % aceleração angular analítica [rad/s2]

% --- torques ---
tau_din  = I * alpha_t;                    % torque dinâmico [N·m]
tau_grav = m * g * r * cos(theta);         % torque gravitacional [N·m]
tau_tot  = tau_din + tau_grav;             % torque total [N·m]

% capacidade do SG90
tau_sg90 = 0.177;   % N·m  (1,8 kgf·cm)

fprintf('--- Torques de pico ---\n');
fprintf('Torque dinâmico máx:      %+.4f N·m\n', max(abs(tau_din)));
fprintf('Torque gravitacional máx: %+.4f N·m\n', max(abs(tau_grav)));
fprintf('Torque total máx:         %+.4f N·m\n', max(abs(tau_tot)));
fprintf('Capacidade SG90:          %+.4f N·m\n', tau_sg90);
if max(abs(tau_tot)) > tau_sg90
    fprintf('ATENÇÃO: demanda excede a capacidade do servo!\n');
else
    fprintf('Dentro da capacidade do servo.\n');
end

% --- figura ---
figure('Position', [100 100 700 400]);

plot(t, tau_din  * 1000, 'LineWidth', 2, 'Color', [0.15 0.39 0.66]); hold on;
plot(t, tau_grav * 1000, 'LineWidth', 2, 'Color', [0.10 0.48 0.31]);
plot(t, tau_tot  * 1000, 'LineWidth', 2, 'Color', [0.75 0.22 0.17]);
yline( tau_sg90 * 1000, 'k--', 'LineWidth', 1.5);
yline(-tau_sg90 * 1000, 'k--', 'LineWidth', 1.5);
yline(0, 'Color', [0.6 0.6 0.6], 'LineWidth', 0.5);

grid on;
xlabel('Tempo [s]');
ylabel('Torque [mN·m]');
title(sprintf('Torque sobre o segmento  (A = %g°, \\omega = %g rad/s)', ...
    rad2deg(A), omega));
legend('\tau_{din} = I\alpha', ...
       '\tau_{grav} = mgr\cdotcos(\theta)', ...
       '\tau_{total}', ...
       sprintf('\\pm capacidade SG90 (%.0f mN·m)', tau_sg90*1000), ...
       'Location', 'northeast');

% exportgraphics(gcf, 'fig04_torque.png', 'Resolution', 150);
