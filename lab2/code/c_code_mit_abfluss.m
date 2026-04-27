% 2c: Torricelli-Gesetz
clear;
close all;
clc;

savetofolder = '/home/ruth/Desktop/Uni/8. Semester Sensorik/Regelungstechnik/Labor/2 Füllstandsreglung/plots_aufgabe2/c';

%% Parameter 
d = 0.17;               % [m]
A = pi*(d/2)^2;         % [m²]
h_soll_wert = 0.1;      % Führungsgrößensprung [m]
k = 0.0003 / sqrt(0.05);  % = 0.001342 m^2.5/s,  Torricelli-Konstante
Kr_fixed = 0.006;
Tn = 6.2;
Ki = 1/Tn;

assignin('base', 'k', k);
assignin('base', 'A', A);
assignin('base', 'Kr', Kr_fixed);
assignin('base', 'Ki', Ki);
assignin('base', 'h_soll_wert', h_soll_wert);

%% Simulationsparameter 
run_time = 30;
open_system('c_modell_mit_abfluss');
set_param('c_modell_mit_abfluss', 'StopTime', 'run_time');
set_param('c_modell_mit_abfluss', 'StartTime', '0');

% Step-Block 
set_param('c_modell_mit_abfluss/Step', 'Time', '0');
set_param('c_modell_mit_abfluss/Step', 'Before', '0');
set_param('c_modell_mit_abfluss/Step', 'After', num2str(h_soll_wert));

simOut = sim("c_modell_mit_abfluss.slx");

%% Daten auslesen 
if isstruct(simOut)
    t = simOut.tout;
    h = simOut.h;
    q_zu = simOut.q_zu;
    q_ab = simOut.q_ab;
    h_soll = simOut.h_soll;
else
    t = simOut.get('tout');
    h = simOut.get('h');
    q_zu = simOut.get('q_zu');
    q_ab = simOut.get('q_ab');
    h_soll = simOut.get('h_soll');
end

% Bei timeseries-Objekten: Daten extrahieren
if isa(h, 'timeseries')
    h = h.Data;
    t = t.Data;
    q_zu = q_zu.Data;
    q_ab = q_ab.Data;
    h_soll = h_soll.Data;
end

%% Stationärer Endwert 
n_end = round(0.9 * length(h));
h_end = mean(h(n_end:end));
q_ab_end = mean(q_ab(n_end:end));
q_zu_end = mean(q_zu(n_end:end));

fprintf('Stationäre Werte (letzte 10%%):\n');
fprintf('  h(∞) = %.4f m (%.1f cm)\n', h_end, h_end*100);
fprintf('  q_ab(∞) = %.6f m³/s (%.3f L/s)\n', q_ab_end, q_ab_end*1000);
fprintf('  q_zu(∞) = %.6f m³/s (%.3f L/s)\n', q_zu_end, q_zu_end*1000);

%% Plot 
figure('Name', sprintf('Torricelli: Kr = %.4f, Tn = %.1f', Kr_fixed, Tn), ...
       'Position', [100, 100, 1000, 700]);

h_soll_plot = h_soll_wert * ones(size(t));

subplot(2, 1, 1);
yyaxis left;
plot(t, h_soll_plot, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Führungsgröße h_{soll}(t)');
hold on;
plot(t, h, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Regelgröße h(t)');
ylabel('Füllstand h [m]', 'FontSize', 11);

y_max_h = max([h_soll_plot; h]);
y_min_h = min([h_soll_plot; h]);
if y_min_h >= 0
    ylim([0, y_max_h * 1.1]);
else
    ylim([y_min_h * 1.1, y_max_h * 1.1]);
end

yyaxis right;
plot(t, q_zu, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Stellgröße q_{zu}(t)');
plot(t, q_ab, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Störgröße q_{ab}(t)');
plot(t, q_zu - q_ab, 'k--', 'LineWidth', 1, 'DisplayName', 'q_{zu} - q_{ab}');
ylabel('Volumenstrom q [m³/s]', 'FontSize', 11);

y_max_q = max([q_zu; q_ab]);
y_min_q = min([q_zu; q_ab]);
if y_min_q >= 0
    ylim([0, y_max_q * 1.2]);
else
    ylim([y_min_q * 1.2, y_max_q * 1.2]);
end

xlabel('Zeit t [s]', 'FontSize', 11);
xlim([0, run_time]);
grid on;
legend('Location', 'best', 'FontSize', 9);
hold off;

filename = fullfile(savetofolder, sprintf('c_modell_mit_abfluss_torricelli.png', Kr_fixed, Tn));
saveas(gcf, filename);
fprintf('\nPlot gespeichert: %s\n', filename);

%% Abschlussausgabe
fprintf('\n==================== ERGEBNISSE Aufgabe 2c ====================\n');
fprintf('Regler: PI mit KR = %.4f, TN = %.1f s\n', Kr_fixed, Tn);
fprintf('Torricelli-Konstante k = %.6f m^2.5/s\n', k);
fprintf('Stationärer Endwert: h(∞) = %.4f m = %.1f cm\n', h_end, h_end*100);
fprintf('Stationäre Regelabweichung: %.2f %%\n', abs((h_soll_wert - h_end)/h_soll_wert*100));
fprintf('================================================================\n');