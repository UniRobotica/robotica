% Ex1_5_1_SimOtto.m
% Simulacao fiel da caminhada do Otto DIY (vista frontal)
% Proporcoes reais: corpo 80x55 mm, perna/canela 45x18 mm, pe 80x22 mm
% Cores: azul (corpo, cabeca, pes) e amarelo (pernas e canelas)
% Sem toolboxes extras.

% ── Parametros geometricos [m] ──────────────────────────────────────
SC   = 1e-3;          % 1 mm em metros
BW   = 80  * SC;      % largura do corpo
BH   = 55  * SC;      % altura do tronco
LW   = 18  * SC;      % largura da perna/canela (retangulo)
LH   = 45  * SC;      % comprimento da coxa
SH   = 45  * SC;      % comprimento da canela
FW   = 80  * SC;      % largura do pe
FH   = 22  * SC;      % espessura do pe
HW   = 72  * SC;      % largura da cabeca
HH   = 58  * SC;      % altura da cabeca
JRAD = 4   * SC;      % raio das juntas

% Paleta fiel ao Otto
C_BODY = [0.08 0.40 0.75];   % azul corpo / cabeca / pes
C_LEG  = [0.99 0.85 0.21];   % amarelo pernas
C_EYE  = [0.00 0.90 1.00];   % ciano LEDs
C_JNT  = [0.05 0.18 0.42];   % azul escuro juntas

% ── Parametros de movimento ─────────────────────────────────────────
A  = deg2rad(15);   % amplitude servos do quadril
Af = deg2rad(12);   % amplitude servos dos pes
f  = 0.5;           % frequencia de caminhada [Hz]
om = 2*pi*f;
T  = 4/f;           % duracao total (4 ciclos)
dt = 0.02;

% ── Figura ─────────────────────────────────────────────────────────
fig = figure('Name','Otto DIY — Simulacao','NumberTitle','off','Color','w');
ax  = axes('Parent', fig);
limX = BW * 2.2;
limY = (LH + SH + BH + HH) * 1.15;
axis(ax, [-limX limX -FH*0.5 limY]);
axis(ax, 'equal'); grid(ax,'on');
xlabel(ax,'Posicao lateral x [m]');
ylabel(ax,'Altura y [m]');
title(ax,'Otto DIY — caminhada (vista frontal)');
hold(ax,'on');

% ── Funcao auxiliar: retangulo orientado (centro na base) ─────────
% Recebe posicao da BASE do retangulo, largura, altura e angulo
function hPatch = drawRect(ax, xBase, yBase, w, h, ang, col)
    % Pontos no frame local (base centrada em x=0)
    px = [-w/2  w/2  w/2 -w/2];
    py = [ 0    0    h    h  ];
    % Rotacao
    c = cos(ang); s = sin(ang);
    rx = px*c - py*s + xBase;
    ry = px*s + py*c + yBase;
    hPatch = fill(ax, rx, ry, col, 'EdgeColor', [0 0 0 0.15], 'LineWidth', 0.8);
end

% ── Pre-aloca patches para animacao ────────────────────────────────
% Perna esq / dir (coxa)
hCoxaL = drawRect(ax, 0, 0, LW, LH, 0, C_LEG);
hCoxaR = drawRect(ax, 0, 0, LW, LH, 0, C_LEG);
% Canela esq / dir
hCanelaL = drawRect(ax, 0, 0, LW, SH, 0, C_LEG);
hCanelaR = drawRect(ax, 0, 0, LW, SH, 0, C_LEG);
% Pes
hPeL = drawRect(ax, 0, 0, FW, FH, 0, C_BODY);
hPeR = drawRect(ax, 0, 0, FW, FH, 0, C_BODY);
% Corpo
hBody = fill(ax,[0 0 0 0],[0 0 0 0], C_BODY, 'EdgeColor',[0 0 0 0.2],'LineWidth',1.2);
% Cabeca
hHead = fill(ax,[0 0 0 0],[0 0 0 0], C_BODY, 'EdgeColor',[0 0 0 0.2],'LineWidth',1.2);
% Olhos
hEyeL = fill(ax,[0 0 0 0],[0 0 0 0], C_EYE);
hEyeR = fill(ax,[0 0 0 0],[0 0 0 0], C_EYE);
% Boca
hMouth = plot(ax,[0 0],[0 0], 'Color',[0.56 0.79 0.98], 'LineWidth',2.0);

% ── Laco de animacao ────────────────────────────────────────────────
function px = rotRect(xBase, yBase, w, h, ang, offsetX)
    % retorna [xdata; ydata] do retangulo apos rotacao
    lx = [-w/2  w/2  w/2 -w/2 -w/2];
    ly = [ 0    0    h    h    0  ];
    c = cos(ang); s = sin(ang);
    px = [lx*c - ly*s + xBase + offsetX; ...
          lx*s + ly*c + yBase];
end

t = 0;
while ishandle(fig) && t <= T

    % Angulos servos
    thHL =  A  * sin(om*t);
    thHR =  A  * sin(om*t + pi);
    thFL =  Af * sin(om*t + pi/2);
    thFR =  Af * sin(om*t + pi/2 + pi);

    gY   = 0;
    xHL  = -BW/2;  xHR = BW/2;

    % Tornozelos (eixo vertical do quadril → deslocamento lateral)
    xAL = xHL + (LH+SH)*sin(thHL);   yAL = gY;
    xAR = xHR + (LH+SH)*sin(thHR);   yAR = gY;

    % Joelhos
    xKL = xHL + LH*sin(thHL);  yKL = yAL + (LH+SH)*cos(thHL) - SH*cos(thHL);
    xKR = xHR + LH*sin(thHR);  yKR = yAR + (LH+SH)*cos(thHR) - SH*cos(thHR);

    % Quadris
    yHipL = yAL + (LH+SH)*cos(thHL);
    yHipR = yAR + (LH+SH)*cos(thHR);

    % Coxa esq
    p = rotRect(xHL, yHipL, LW, LH, thHL, 0);
    set(hCoxaL, 'XData', p(1,1:4), 'YData', p(2,1:4));
    % Coxa dir
    p = rotRect(xHR, yHipR, LW, LH, thHR, 0);
    set(hCoxaR, 'XData', p(1,1:4), 'YData', p(2,1:4));
    % Canela esq (base no joelho, mesma direcao)
    p = rotRect(xKL, yKL, LW, SH, thHL, 0);
    set(hCanelaL, 'XData', p(1,1:4), 'YData', p(2,1:4));
    % Canela dir
    p = rotRect(xKR, yKR, LW, SH, thHR, 0);
    set(hCanelaR, 'XData', p(1,1:4), 'YData', p(2,1:4));

    % Pe esq (servo de pe — gira em torno do tornozelo)
    c=cos(thFL); s=sin(thFL);
    px=[-FW*0.35  FW*0.65  FW*0.65 -FW*0.35];
    py=[ 0        0        FH       FH      ];
    pxL = px*c - py*s + xAL;  pyL = px*s + py*c + yAL;
    set(hPeL,'XData',pxL,'YData',pyL);
    % Pe dir
    c=cos(thFR); s=sin(thFR);
    pxR = px*c - py*s + xAR;  pyR = px*s + py*c + yAR;
    set(hPeR,'XData',pxR,'YData',pyR);

    % Corpo
    bY = max(yHipL, yHipR);
    set(hBody,'XData',[-BW/2  BW/2  BW/2 -BW/2], ...
              'YData',[ bY    bY    bY+BH  bY+BH]);

    % Cabeca
    hY = bY + BH;
    set(hHead,'XData',[-HW/2  HW/2  HW/2 -HW/2], ...
              'YData',[ hY    hY    hY+HH  hY+HH]);

    % Olhos (retangulos LED)
    eW=HW*0.28; eH=HH*0.38; eYp=hY+HH*0.28;
    exL=-HW*0.22; exR=HW*0.22;
    set(hEyeL,'XData',[exL exL+eW exL+eW exL],'YData',[eYp eYp eYp+eH eYp+eH]);
    set(hEyeR,'XData',[exR exR+eW exR+eW exR],'YData',[eYp eYp eYp+eH eYp+eH]);

    % Boca (curva Bezier aproximada por pontos)
    bmt = linspace(0,1,20);
    p1x=-HW*0.22; p2x=-HW*0.08; p3x=HW*0.08; p4x=HW*0.22;
    p1y=hY+HH*0.72; p2y=hY+HH*0.82; p3y=hY+HH*0.82; p4y=hY+HH*0.72;
    bx = (1-bmt).^3*p1x + 3*(1-bmt).^2.*bmt*p2x + 3*(1-bmt).*bmt.^2*p3x + bmt.^3*p4x;
    by = (1-bmt).^3*p1y + 3*(1-bmt).^2.*bmt*p2y + 3*(1-bmt).*bmt.^2*p3y + bmt.^3*p4y;
    set(hMouth,'XData',bx,'YData',by);

    drawnow;
    t = t + dt;
end
hold(ax,'off');
