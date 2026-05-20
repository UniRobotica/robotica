% Ex4_1_1_CinAnim.m
% Animação da cinemática dinâmica — perna de dois segmentos
% Seção 4.1 | Aula 1 — Robô Otto
%
% Combina a cinemática direta (Seção 1.3) com o movimento senoidal
% (Seção 2.1): avalia a posição da perna quadro a quadro enquanto
% theta1(t) e theta2(t) variam senoidalmente com defasamento pi/2.
%
% A trajetória acumulada do pé é desenhada em cinza pontilhado.
% Para capturar um quadro estático, descomente a linha exportgraphics.

clc; clear; close all;

% --- parâmetros ---
L1 = 5; L2 = 5;                % comprimentos dos segmentos [cm]
t  = linspace(0, 10, 300);     % vetor de tempo [s]

trajX = zeros(1, length(t));
trajY = zeros(1, length(t));

figure('Position', [100 100 480 480]);

for k = 1:length(t)

    % ângulos senoidais com defasamento de pi/2
    theta1 = deg2rad(20 * sin(t(k)));
    theta2 = deg2rad(15 * sin(t(k) + pi/2));

    % cinemática direta
    x1 = L1 * cos(theta1);
    y1 = L1 * sin(theta1);
    x2 = x1 + L2 * cos(theta1 + theta2);
    y2 = y1 + L2 * sin(theta1 + theta2);

    trajX(k) = x2;
    trajY(k) = y2;

    clf;

    % trajetória acumulada do pé
    plot(trajX(1:k), trajY(1:k), ':', ...
        'Color', [0.6 0.6 0.6], 'LineWidth', 1); hold on;

    % segmento 1 (verde — quadril → joelho)
    plot([0 x1], [0 y1], '-o', ...
        'LineWidth', 4, 'Color', [0.10 0.48 0.31], ...
        'MarkerSize', 7, 'MarkerFaceColor', [0.10 0.48 0.31]);

    % segmento 2 (azul — joelho → pé)
    plot([x1 x2], [y1 y2], '-o', ...
        'LineWidth', 4, 'Color', [0.15 0.39 0.66], ...
        'MarkerSize', 7, 'MarkerFaceColor', [0.15 0.39 0.66]);

    % marcador do pé
    plot(x2, y2, 'o', 'MarkerSize', 10, ...
        'MarkerFaceColor', [0.75 0.22 0.17], 'MarkerEdgeColor', 'none');

    grid on; axis equal;
    xlim([-11 11]); ylim([-11 11]);
    xlabel('x [cm]'); ylabel('y [cm]');
    title(sprintf('Cinemática dinâmica — t = %.2f s', t(k)));

    drawnow;

    % para exportar um quadro em t ≈ 2 s, descomente:
    % if abs(t(k) - 2.0) < (t(2)-t(1))/2
    %     exportgraphics(gcf, 'fig05_cinematica_dinamica.png', 'Resolution', 150);
    % end

end
