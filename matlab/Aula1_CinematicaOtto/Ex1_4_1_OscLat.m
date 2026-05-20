% Ex1_4_1_OscLat.m
% Oscilação lateral do centro de massa — quadril do Otto
% Seção 1.4 | Aula 1 — Robô Otto
%
% Simula o deslocamento lateral x(t) = L sin(A sin(omega t))
% produzido pelo servo do quadril durante a caminhada.
% Plota também o ângulo do servo theta_h(t) para comparação direta.

clc; clear; close all;

% --- parâmetros ---
t     = linspace(0, 4, 500);   % vetor de tempo: 2 ciclos completos [s]
A     = deg2rad(15);            % amplitude angular do servo (15°) [rad]
omega = 2;                      % frequência angular [rad/s]
L     = 5;                      % comprimento da perna [cm]

% --- cinemática ---
theta_h = A * sin(omega * t);   % ângulo do servo do quadril [rad]
x       = L * sin(theta_h);     % deslocamento lateral do CoM [cm]

% --- figura com dois painéis ---
figure('Position', [100 100 640 420]);

% painel superior — ângulo do servo
subplot(2, 1, 1);
plot(t, rad2deg(theta_h), 'LineWidth', 2, 'Color', [0.60 0.30 0.70]);
yline(0, 'k--', 'LineWidth', 0.5);
grid on;
ylabel('\theta_h  [graus]');
title('Servo do quadril — ângulo e deslocamento lateral do CoM');
legend('\theta_h(t) = A\cdotsin(\omegat)', 'Location', 'northeast');
xlim([0 max(t)]);

% painel inferior — deslocamento lateral
subplot(2, 1, 2);
plot(t, x, 'LineWidth', 2, 'Color', [0.10 0.48 0.31]);
yline(0, 'k--', 'LineWidth', 0.5);
yline( L*sin(A), '--', 'Color', [0.75 0.22 0.17], 'LineWidth', 1);
yline(-L*sin(A), '--', 'Color', [0.75 0.22 0.17], 'LineWidth', 1);
grid on;
xlabel('Tempo [s]');
ylabel('x(t)  [cm]');
legend('x(t) = L\cdotsin(\theta_h)', ...
       sprintf('\\pm L\\cdotsin(A) = \\pm%.2f cm', L*sin(A)), ...
       'Location', 'northeast');
xlim([0 max(t)]);

fprintf('Alcance lateral máximo: ±%.3f cm\n', L * sin(A));

% exportgraphics(gcf, 'fig02_osc_lateral.png', 'Resolution', 150);
