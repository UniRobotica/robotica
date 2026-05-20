% Ex1_2_1_CinPerna.m
% Cinemática direta — um segmento rotacionando
% Seção 1.2 | Aula 1 — Robô Otto
%
% Plota a posição da extremidade de um segmento rígido de comprimento L
% para ângulos de 0° a 360°, ilustrando as equações:
%   x = L cos(theta)
%   y = L sin(theta)

clc; clear; close all;

L     = 5;                          % comprimento do segmento [cm]
theta = linspace(0, 2*pi, 360);     % ângulo [rad]

x = L * cos(theta);
y = L * sin(theta);

% --- figura ---
figure('Position', [100 100 480 480]);

% trajetória da extremidade (círculo)
plot(x, y, '--', 'Color', [0.75 0.75 0.75], 'LineWidth', 1); hold on;

% configurações de destaque para 4 ângulos
angulos_deg = [0, 45, 90, 135];
cores = {[0.10 0.48 0.31], [0.15 0.39 0.66], [0.75 0.22 0.17], [0.60 0.30 0.70]};

for k = 1:length(angulos_deg)
    th = deg2rad(angulos_deg(k));
    xk = L * cos(th);
    yk = L * sin(th);
    color = cores{k};

    % segmento
    plot([0 xk], [0 yk], '-o', ...
        'LineWidth', 3, 'Color', color, ...
        'MarkerSize', 6, 'MarkerFaceColor', color);

    % rótulo
    text(xk * 1.12, yk * 1.12, sprintf('\\theta = %d°', angulos_deg(k)), ...
        'FontSize', 9, 'Color', color);
end

% origem
plot(0, 0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');

% eixos e formatação
plot([-6 6], [0 0], 'k-', 'LineWidth', 0.5);
plot([0 0], [-6 6], 'k-', 'LineWidth', 0.5);
axis equal; grid on;
xlim([-6 6]); ylim([-6 6]);
xlabel('x = L\cdotcos(\theta)  [cm]');
ylabel('y = L\cdotsin(\theta)  [cm]');
title('Cinemática direta — um segmento (L = 5 cm)');

% exportgraphics(gcf, 'fig01_um_segmento.png', 'Resolution', 150);
