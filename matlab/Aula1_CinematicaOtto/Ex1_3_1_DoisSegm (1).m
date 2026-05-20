% Ex1_3_1_DoisSegm.m
% Cinemática direta — dois segmentos em série
% Seção 1.3 | Aula 1 — Robô Otto
%
% Calcula e plota a configuração da perna (quadril–joelho–pé) para
% ângulos fixos theta1 e theta2, usando as equações:
%   x1 = L1 cos(theta1)             y1 = L1 sin(theta1)
%   x2 = x1 + L2 cos(theta1+theta2) y2 = y1 + L2 sin(theta1+theta2)
%
% Altere theta1 e theta2 para explorar diferentes configurações.

clc; clear; close all;

% --- parâmetros ---
L1     = 5;         % comprimento do 1º segmento [cm]
L2     = 5;         % comprimento do 2º segmento [cm]
theta1 = deg2rad(30);   % ângulo da 1ª junta (quadril) [rad]
theta2 = deg2rad(20);   % ângulo relativo da 2ª junta (joelho) [rad]

% --- cinemática ---
x1 = L1 * cos(theta1);
y1 = L1 * sin(theta1);

x2 = x1 + L2 * cos(theta1 + theta2);
y2 = y1 + L2 * sin(theta1 + theta2);

fprintf('Junta intermediária: (%.3f, %.3f) cm\n', x1, y1);
fprintf('Posição do pé:       (%.3f, %.3f) cm\n', x2, y2);

% --- figura ---
figure('Position', [100 100 480 480]);

% segmento 1 (verde — quadril→joelho)
plot([0 x1], [0 y1], '-o', ...
    'LineWidth', 5, 'Color', [0.10 0.48 0.31], ...
    'MarkerSize', 8, 'MarkerFaceColor', [0.10 0.48 0.31]); hold on;

% segmento 2 (azul — joelho→pé)
plot([x1 x2], [y1 y2], '-o', ...
    'LineWidth', 5, 'Color', [0.15 0.39 0.66], ...
    'MarkerSize', 8, 'MarkerFaceColor', [0.15 0.39 0.66]);

% origem
plot(0, 0, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

% pé
plot(x2, y2, 'o', 'MarkerSize', 12, ...
    'MarkerFaceColor', [0.75 0.22 0.17], 'MarkerEdgeColor', 'none');

% arco theta1
th_arc = linspace(0, theta1, 40);
r_arc  = 1.5;
plot(r_arc*cos(th_arc), r_arc*sin(th_arc), 'Color', [0.10 0.48 0.31], 'LineWidth', 1.5);
text(r_arc*cos(theta1/2)*1.3, r_arc*sin(theta1/2)*1.3, ...
    sprintf('\\theta_1=%d°', round(rad2deg(theta1))), ...
    'FontSize', 9, 'Color', [0.10 0.48 0.31]);

% arco theta2 (relativo ao 1º segmento)
th_arc2 = linspace(theta1, theta1+theta2, 40);
plot(x1 + r_arc*cos(th_arc2), y1 + r_arc*sin(th_arc2), ...
    'Color', [0.15 0.39 0.66], 'LineWidth', 1.5);
text(x1 + r_arc*cos(theta1+theta2/2)*1.4, ...
     y1 + r_arc*sin(theta1+theta2/2)*1.4, ...
    sprintf('\\theta_2=%d°', round(rad2deg(theta2))), ...
    'FontSize', 9, 'Color', [0.15 0.39 0.66]);

% rótulos dos pontos
text( 0.2,  0.3, 'origem', 'FontSize', 9);
text(x1+0.2, y1+0.2, sprintf('junta\n(%.1f, %.1f)', x1, y1), 'FontSize', 9);
text(x2+0.2, y2-0.5, sprintf('pé\n(%.1f, %.1f)', x2, y2), ...
    'FontSize', 9, 'Color', [0.75 0.22 0.17]);

% eixos
plot([-2 12], [0 0], 'k-', 'LineWidth', 0.5);
plot([0 0], [-2 12], 'k-', 'LineWidth', 0.5);
axis equal; grid on;
xlim([-2 12]); ylim([-2 12]);
xlabel('x [cm]'); ylabel('y [cm]');
title(sprintf('Cinemática estática — dois segmentos  (\\theta_1=%d°, \\theta_2=%d°)', ...
    round(rad2deg(theta1)), round(rad2deg(theta2))));

% exportgraphics(gcf, 'fig01_cinematica_estatica.png', 'Resolution', 150);
