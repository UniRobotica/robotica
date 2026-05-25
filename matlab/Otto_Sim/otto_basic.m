clc;
clear;
close all;

% =========================================================
% MODELO CINEMÁTICO DO OTTO
%
% Hip servos:
%   rotação no plano XY (eixo Z)
%
% Foot servos:
%   rotação no plano XZ (eixo X)
%
% Tronco rígido
% Pernas prismáticas
% Pés com pivô no calcanhar
% =========================================================

%% ========================================================
% FIGURA
% =========================================================

fig = figure( ...
    'Name','Otto Kinematic Model', ...
    'Color',[1 1 1], ...
    'Position',[100 100 1200 700]);

ax = axes(fig);

axis(ax,[-180 180 -180 180 0 220]);
axis(ax,'equal');
grid(ax,'on');
view(ax,35,20);

xlabel('X');
ylabel('Y');
zlabel('Z');

hold(ax,'on');

%% ========================================================
% PARÂMETROS INICIAIS
% =========================================================

params.bodyW = 70;
params.bodyD = 50;
params.bodyH = 60;

params.legW  = 12;
params.legD  = 18;
params.legL  = 85;

params.footW = 30;
params.footD = 55;
params.footH = 10;

params.hipSpacing = 50;

params.hipAmp  = 25;
params.footAmp = 20;

params.speed = 1;

%% ========================================================
% SLIDERS
% =========================================================

uicontrol(fig,'Style','text', ...
    'Position',[20 640 120 20], ...
    'String','Hip amplitude');

sHip = uicontrol(fig,'Style','slider', ...
    'Min',0,'Max',45,'Value',25, ...
    'Position',[20 620 200 20]);

uicontrol(fig,'Style','text', ...
    'Position',[20 590 120 20], ...
    'String','Foot amplitude');

sFoot = uicontrol(fig,'Style','slider', ...
    'Min',0,'Max',45,'Value',20, ...
    'Position',[20 570 200 20]);

uicontrol(fig,'Style','text', ...
    'Position',[20 540 120 20], ...
    'String','Leg length');

sLeg = uicontrol(fig,'Style','slider', ...
    'Min',50,'Max',140,'Value',85, ...
    'Position',[20 520 200 20]);

%% ========================================================
% BOTÕES
% =========================================================

mode = "forward";

uicontrol(fig,'Style','pushbutton', ...
    'String','Forward', ...
    'Position',[20 450 90 30], ...
    'Callback',@(src,event)setMode("forward"));

uicontrol(fig,'Style','pushbutton', ...
    'String','Backward', ...
    'Position',[120 450 90 30], ...
    'Callback',@(src,event)setMode("backward"));

uicontrol(fig,'Style','pushbutton', ...
    'String','Turn Left', ...
    'Position',[20 410 90 30], ...
    'Callback',@(src,event)setMode("left"));

uicontrol(fig,'Style','pushbutton', ...
    'String','Turn Right', ...
    'Position',[120 410 90 30], ...
    'Callback',@(src,event)setMode("right"));

uicontrol(fig,'Style','pushbutton', ...
    'String','Swing', ...
    'Position',[70 370 90 30], ...
    'Callback',@(src,event)setMode("swing"));

%% ========================================================
% ESTADO GLOBAL
% =========================================================

robotPos = [0 0 120];
robotYaw = 0;

t = 0;

%% ========================================================
% LOOP
% =========================================================

while ishandle(fig)

    cla(ax);

    % =====================================================
    % PARÂMETROS
    % =====================================================

    params.hipAmp  = sHip.Value;
    params.footAmp = sFoot.Value;
    params.legL    = sLeg.Value;

    % =====================================================
    % FASE
    % =====================================================

    t = t + 0.04 * params.speed;

    hipL  = params.hipAmp  * sin(t);
    hipR  = -params.hipAmp * sin(t);

    footL = params.footAmp * sin(t + pi/2);
    footR = -params.footAmp * sin(t + pi/2);

    % =====================================================
    % TURN
    % =====================================================

    switch mode

        case "forward"

            robotPos(2) = robotPos(2) + 0.6;

        case "backward"

            robotPos(2) = robotPos(2) - 0.6;

        case "left"

            robotYaw = robotYaw + deg2rad(0.8);
            robotPos(2) = robotPos(2) + 0.4;

        case "right"

            robotYaw = robotYaw - deg2rad(0.8);
            robotPos(2) = robotPos(2) + 0.4;

        case "swing"

            robotYaw = robotYaw + deg2rad(1.2);

    end

    % =====================================================
    % MATRIZ BASE
    % =====================================================

    Rz = rotz(robotYaw);

    % =====================================================
    % TRONCO
    % =====================================================

    bodyCenter = robotPos;

    drawBox(bodyCenter, ...
        params.bodyW, ...
        params.bodyD, ...
        params.bodyH, ...
        Rz, ...
        [0.2 0.4 1]);

    % =====================================================
    % QUADRIS
    % =====================================================

    hipLeft = bodyCenter + (Rz * ...
        [-params.hipSpacing/2 0 -params.bodyH/2]')';

    hipRight = bodyCenter + (Rz * ...
        [ params.hipSpacing/2 0 -params.bodyH/2]')';

    % =====================================================
    % PERNA ESQUERDA
    % =====================================================

    RL = Rz * rotz(deg2rad(hipL));

    legLeftCenter = hipLeft + ...
        (RL * [0 0 -params.legL/2]')';

    drawBox( ...
        legLeftCenter, ...
        params.legW, ...
        params.legD, ...
        params.legL, ...
        RL, ...
        [0.1 0.7 0.3]);

    % =====================================================
    % PERNA DIREITA
    % =====================================================

    RR = Rz * rotz(deg2rad(hipR));

    legRightCenter = hipRight + ...
        (RR * [0 0 -params.legL/2]')';

    drawBox( ...
        legRightCenter, ...
        params.legW, ...
        params.legD, ...
        params.legL, ...
        RR, ...
        [0.2 0.5 1]);

    % =====================================================
    % TORNOZELOS
    % =====================================================

    ankleLeft = hipLeft + ...
        (RL * [0 0 -params.legL]')';

    ankleRight = hipRight + ...
        (RR * [0 0 -params.legL]')';

    % =====================================================
    % PÉS
    %
    % ROTACIONAM NO PLANO XZ
    % PIVÔ NO CALCANHAR
    % =====================================================

    RFLeft = RL * rotx(deg2rad(footL));
    RFRight = RR * rotx(deg2rad(footR));

    footOffset = RFLeft * [0 params.footD/2 0]';

    footLeftCenter = ankleLeft + footOffset';

    footOffsetR = RFRight * [0 params.footD/2 0]';

    footRightCenter = ankleRight + footOffsetR';

    drawBox( ...
        footLeftCenter, ...
        params.footW, ...
        params.footD, ...
        params.footH, ...
        RFLeft, ...
        [1 0.5 0.1]);

    drawBox( ...
        footRightCenter, ...
        params.footW, ...
        params.footD, ...
        params.footH, ...
        RFRight, ...
        [1 0.3 0.2]);

    % =====================================================
    % SOLO
    % =====================================================

    surf(ax, ...
        [-300 300; -300 300], ...
        [-300 -300; 300 300], ...
        [0 0; 0 0], ...
        'FaceColor',[0.95 0.95 0.95], ...
        'EdgeColor',[0.85 0.85 0.85]);

    drawnow;

end

%% ========================================================
% FUNÇÕES
% =========================================================

function setMode(m)
    assignin('base','mode',m);
end

function R = rotx(a)

R = [ ...
    1 0 0
    0 cos(a) -sin(a)
    0 sin(a) cos(a)];

end

function R = rotz(a)

R = [ ...
    cos(a) -sin(a) 0
    sin(a)  cos(a) 0
    0 0 1];

end

function drawBox(center,w,d,h,R,color)

v = [ ...
    -w/2 -d/2 -h/2
     w/2 -d/2 -h/2
     w/2  d/2 -h/2
    -w/2  d/2 -h/2
    -w/2 -d/2  h/2
     w/2 -d/2  h/2
     w/2  d/2  h/2
    -w/2  d/2  h/2];

v = (R * v')';

v = v + center;

f = [ ...
    1 2 3 4
    5 6 7 8
    1 2 6 5
    2 3 7 6
    3 4 8 7
    4 1 5 8];

patch( ...
    'Vertices',v, ...
    'Faces',f, ...
    'FaceColor',color, ...
    'EdgeColor',[0.2 0.2 0.2], ...
    'FaceAlpha',0.95);

end