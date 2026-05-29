clc;
clear;
close all;

%% =========================================================
% OTTO WALKING MODEL ESCALÁVEL
% ==========================================================

fig = figure( ...
    'Name','Otto Walking Simulator', ...
    'Color',[1 1 1], ...
    'Position',[50 50 1400 850]);

ax = axes(fig);
axis(ax,[-180 180 -180 180 0 220]);
axis(ax,'equal');
xlabel('X'); ylabel('Y'); zlabel('Z');
view(ax,38,22);
grid(ax,'on'); hold(ax,'on');

%% =========================================================
% PARÂMETROS ESCALÁVEIS
% ==========================================================
params.scale = 1.0; % fator de escala global

params.bodyW = 70 * params.scale;
params.bodyD = 50 * params.scale;
params.bodyH = 60 * params.scale;

params.legL = 60 * params.scale; % pernas mais longas
params.legW = 15 * params.scale;
params.legD = 20 * params.scale;

params.footW = 32 * params.scale;
params.footD = 60 * params.scale;
params.footH = 10 * params.scale;

params.hipSpacing = 48 * params.scale;
params.hipAmp = 20; params.footAmp = 15;
params.speed = 1;

%% =========================================================
% ESTADO GLOBAL
% ==========================================================
robotPos = [0 0 100];
robotYaw = 0; % virado para a tela
trail = [];
mode = "stop"; % inicia parado
t = 0;

%% =========================================================
% BOTÕES DE CONTROLE
% ==========================================================
uicontrol(fig,'Style','pushbutton','String','FORWARD', ...
    'Position',[20 590 100 35], ...
    'Callback',@(s,e)setMode("forward"));

uicontrol(fig,'Style','pushbutton','String','BACKWARD', ...
    'Position',[130 590 100 35], ...
    'Callback',@(s,e)setMode("backward"));

uicontrol(fig,'Style','pushbutton','String','TURN LEFT', ...
    'Position',[20 545 100 35], ...
    'Callback',@(s,e)setMode("left"));

uicontrol(fig,'Style','pushbutton','String','TURN RIGHT', ...
    'Position',[130 545 100 35], ...
    'Callback',@(s,e)setMode("right"));

uicontrol(fig,'Style','pushbutton','String','SWING', ...
    'Position',[75 500 100 35], ...
    'Callback',@(s,e)setMode("swing"));

uicontrol(fig,'Style','pushbutton','String','STOP', ...
    'Position',[75 455 100 35], ...
    'Callback',@(s,e)setMode("stop"));

%% =========================================================
% LOOP
% ==========================================================
while ishandle(fig)
    cla(ax);

    % Solo
    surf(ax,[-200 200; -200 200],[-200 -200; 200 200],[0 0;0 0], ...
        'FaceColor',[0.94 0.94 0.94],'EdgeColor',[0.82 0.82 0.82]);

    % Fase da marcha
    t = t + 0.05;
    phase = sin(t);

    hipL = params.hipAmp * phase;
    hipR = -params.hipAmp * phase;
    footL = params.footAmp * sin(t + pi/2);
    footR = -params.footAmp * sin(t + pi/2);

    stepGain = params.speed * 0.5;

    switch mode
        case "forward"
    robotPos(1) = robotPos(1) - sin(robotYaw) * stepGain;
    robotPos(2) = robotPos(2) - cos(robotYaw) * stepGain;

case "backward"
    robotPos(1) = robotPos(1) + sin(robotYaw) * stepGain;
    robotPos(2) = robotPos(2) + cos(robotYaw) * stepGain;

        case "left"
            robotYaw = robotYaw + deg2rad(1.0);
        case "right"
            robotYaw = robotYaw - deg2rad(1.0);
        case "swing"
            robotYaw = robotYaw + deg2rad(2.0);
        case "stop"
            % não move
    end

    % Limites: se bater, para
    LIM = 150;
    if abs(robotPos(1)) > LIM || abs(robotPos(2)) > LIM
        mode = "stop";
    end

    % Centro de massa com balanço lateral
    bodyLift = 5 * abs(phase);
    lateralShift = 8 * phase;
    bodyCenter = robotPos + [lateralShift 0 bodyLift];

    % Tronco
    Rz = rotz(robotYaw);
    drawBox(bodyCenter,params.bodyW,params.bodyD,params.bodyH,Rz,[0.25 0.45 1]);

    % Quadris
    hipLeft = bodyCenter + (Rz * [-params.hipSpacing/2 0 -params.bodyH/2]')';
    hipRight = bodyCenter + (Rz * [params.hipSpacing/2 0 -params.bodyH/2]')';

    % Pernas com rotação
    RL = Rz * rotz(deg2rad(hipL));
    RR = Rz * rotz(deg2rad(hipR));
    legLeftCenter = hipLeft + (RL * [0 0 -params.legL/2]')';
    legRightCenter = hipRight + (RR * [0 0 -params.legL/2]')';
    drawBox(legLeftCenter,params.legW,params.legD,params.legL,RL,[0.1 0.7 0.3]);
    drawBox(legRightCenter,params.legW,params.legD,params.legL,RR,[0.2 0.5 1]);

    % Pés com apoio alternado
ankleLeft = hipLeft + (RL * [0 0 -params.legL]')';
ankleRight = hipRight + (RR * [0 0 -params.legL]')';

% Condição: qual pé apoia e qual levanta
if phase > 0
    % Pé esquerdo apoia (fixo), direito levanta
    RFLeft = RL; 
    RFRight = RR * rotx(deg2rad(footR));
else
    % Pé direito apoia (fixo), esquerdo levanta
    RFLeft = RL * rotx(deg2rad(footL));
    RFRight = RR;
end

% Centros dos pés (sempre para frente)
footLeftCenter = ankleLeft + [0 -params.footD/2 0];
footRightCenter = ankleRight + [0 -params.footD/2 0];

% Desenho dos pés
drawBox(footLeftCenter,params.footW,params.footD,params.footH,RFLeft,[1 0.6 0.1]);
drawBox(footRightCenter,params.footW,params.footD,params.footH,RFRight,[1 0.35 0.15]);

    % Trajetória
    trail = [trail; bodyCenter];
    if size(trail,1) > 500, trail(1,:) = []; end
    plot3(trail(:,1),trail(:,2),trail(:,3),'r-','LineWidth',1.5);

    % Texto
    title(sprintf('Hip %.1f° | Foot %.1f° | Mode: %s',hipL,footL,mode));
    drawnow;
end

%% =========================================================
% FUNÇÕES AUXILIARES
% ==========================================================
function setMode(m)
assignin('base','mode',m);
end

function R = rotx(a)
R = [1 0 0; 0 cos(a) -sin(a); 0 sin(a) cos(a)];
end

function R = rotz(a)
R = [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];
end

function drawBox(center,w,d,h,R,color)
v = [-w/2 -d/2 -h/2; w/2 -d/2 -h/2; w/2 d/2 -h/2; -w/2 d/2 -h/2; ...
     -w/2 -d/2 h/2; w/2 -d/2 h/2; w/2 d/2 h/2; -w/2 d/2 h/2];
v = (R * v')'; v = v + center;
f = [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8];
patch('Vertices',v,'Faces',f,'FaceColor',color,'EdgeColor',[0.2 0.2 0.2],'FaceAlpha',0.96);
end
