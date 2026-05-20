% Ex4_2_1_MalhaFechada.m
% Resposta ao degrau — malha fechada com PID + servo de 1ª ordem
% Seção 4.2 | Aula 1 — Robô Otto
%
% Simula numericamente (Euler explícito) o sistema:
%   planta:       G(s) = 1 / (tau_s * s + 1)
%   controlador:  C(s) = Kp + Ki/s + Kd*s  (PID ideal)
%   malha fechada: y segue a referência degrau r = 1
%
% Não requer o Control System Toolbox — compatível com Octave.
% Para usar o Toolbox (MATLAB), veja o bloco comentado no final.

clc; clear; close all;

% --- parâmetros do controlador ---
Kp = 1.2;
Ki = 0.3;
Kd = 0.15;

% --- modelo do servo (1ª ordem) ---
tau_s = 0.1;    % constante de tempo [s]

% --- simulação por Euler ---
dt    = 0.001;              % passo de integração [s]
T_fim = 3;                  % duração [s]
t     = 0:dt:T_fim;
N     = length(t);

r     = ones(1, N);         % referência degrau
y     = zeros(1, N);        % saída (ângulo real)
e     = zeros(1, N);        % erro
u     = zeros(1, N);        % sinal de controle
intE  = 0;                  % integral do erro
eAnt  = 0;                  % erro anterior (para termo derivativo)

for k = 1:N-1
    e(k)  = r(k) - y(k);
    intE  = intE + e(k) * dt;
    dedt  = (e(k) - eAnt) / dt;
    u(k)  = Kp * e(k) + Ki * intE + Kd * dedt;
    % equação de estado do servo: tau_s * dy/dt + y = u
    y(k+1) = y(k) + (dt / tau_s) * (u(k) - y(k));
    eAnt  = e(k);
end
e(N) = r(N) - y(N);

% --- indicadores de desempenho (manual) ---
% tempo de subida: 10% → 90% do valor final
y_final = y(end);
idx_10  = find(y >= 0.10 * y_final, 1);
idx_90  = find(y >= 0.90 * y_final, 1);
t_subida = t(idx_90) - t(idx_10);

overshoot = (max(y) - y_final) / y_final * 100;

idx_acom = find(abs(y - y_final) > 0.02 * y_final, 1, 'last');
t_acom   = t(idx_acom);

fprintf('--- Indicadores de desempenho ---\n');
fprintf('Tempo de subida (10→90%%): %.3f s\n', t_subida);
fprintf('Tempo de acomodação (2%%): %.3f s\n', t_acom);
fprintf('Overshoot:                %.2f %%\n', overshoot);

% --- figura ---
figure('Position', [100 100 680 400]);

plot(t, r, '--', 'LineWidth', 1.5, 'Color', [0.10 0.48 0.31]); hold on;
plot(t, y,       'LineWidth', 2,   'Color', [0.15 0.39 0.66]);
plot(t, e,       'LineWidth', 1.5, 'Color', [0.75 0.22 0.17]);
yline(0, 'Color', [0.6 0.6 0.6], 'LineWidth', 0.5);

% banda de acomodação ±2%
patch([0 T_fim T_fim 0], ...
    [1.02 1.02 0.98 0.98], ...
    [0.10 0.48 0.31], 'FaceAlpha', 0.08, 'EdgeColor', 'none');

grid on;
xlabel('Tempo [s]');
ylabel('Posição normalizada');
title(sprintf('Malha fechada com PID  (Kp=%.1f, Ki=%.2f, Kd=%.2f)', Kp, Ki, Kd));
legend('Referência r(t)', 'Saída y(t)', 'Erro e(t)', 'Location', 'northeast');
xlim([0 T_fim]);

% exportgraphics(gcf, 'fig06_malha_fechada.png', 'Resolution', 150);

% =============================================================
% ALTERNATIVA com Control System Toolbox (MATLAB)
% =============================================================
% G = tf(1, [tau_s 1]);
% C = pid(Kp, Ki, Kd);
% T = feedback(C * G, 1);
% figure; step(T, linspace(0, T_fim, 500));
% info = stepinfo(T);
% fprintf('stepinfo — subida: %.3f s, acom: %.3f s, OS: %.2f%%\n', ...
%     info.RiseTime, info.SettlingTime, info.Overshoot);
% =============================================================
