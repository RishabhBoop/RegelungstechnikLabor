% Stabilitätsuntersuchung und empirische Reglereinstellungen
% Aufgabe 3: PID-Regler

% Eingang: u
% Ausgang: y

clear;
close all;
clc;

savetofolder = '/home/ruth/Desktop/Uni/8. Semester Sensorik/Regelungstechnik/Labor/4 Stabilität/A3';

% Simulation
run_time = 0.01;
set_param('PIDRegler', 'StopTime', 'run_time');
set_param('PIDRegler', 'StartTime', '0');

%parameter
K = 10;
R1 = 10e3; %R1=R2=R3=R5
R4 = 1e3;

% zum "ausprobieren"
R6 = 30e3;
% C2 = 370e-9;
C2 = 390e-9;
C3 = 60e-9;

% PID-Regler
P = 1;
I = 1/(C2 * R1);
D = R1 * C3;
N = 1 / (C3 * R4);
F = R6 / R1; %=3

simOut = sim("PIDRegler.slx");

if isstruct(simOut)
    t = simOut.tout;
    u = simOut.u;
    y = simOut.y;
    step = simOut.step;
else
    t = simOut.get('tout');
    u = simOut.get('u');
    y = simOut.get('y');
    step = simOut.get('step');
end

if isa(u, 'timeseries')
    u = u.Data;
    y = y.Data;
    step = step.Data;
end

fprintf('Simulation abgeschlossen.\n');

% t* berechnen

zielwert = 5;
untergrenze = 0.98 * zielwert;
obergrenze = 1.02 * zielwert;
ausreisser = find(y < untergrenze | y > obergrenze);

if isempty(ausreisser)
    t_stern = 0;
else
    letzter_ausreisser = ausreisser(end);
    if letzter_ausreisser < length(t)
        t_stern = t(letzter_ausreisser + 1);
    else
        t_stern = NaN;
    end
end
fprintf('Eintritt in das Intervall [0.98, 1.02] erfolgt bei t*=%.3fs \n', t_stern);

% plot
figure('Name', sprintf('R6=%.1e, C2=%.1e, C3=%.1e', R6, C2, C3), ...
       'Position', [100, 100, 1000, 700]);

subplot(2, 1, 1);
plot(t, u, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Stellgröße');
hold on;
plot(t, y, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Regelgröße');
hold on;
plot(t, step, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Führungsgröße');

title(sprintf('Parameter: R6=%.1e, C2=%.1e, C3=%.1e', R6, C2, C3));
xlabel('Zeit t [s]', 'FontSize', 11);
xlim([0, run_time]);
grid on;
legend('Location', 'northeast', 'FontSize', 9);
hold off;

filename = fullfile(savetofolder, sprintf('PID_Regler_R6=%.1e.png', R6));
saveas(gcf, filename);
fprintf('Plot gespeichert.\n\n');
%close(gcf);


