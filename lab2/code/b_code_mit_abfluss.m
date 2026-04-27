%% 2b - Behälter mit Loch (PI-Regler)
clear;
close all;
clc;

savetofolder = '/home/ruth/Desktop/Uni/8. Semester Sensorik/Regelungstechnik/Labor/2 Füllstandsreglung/plots_aufgabe2/b';

%% Parameter 
d = 0.17;               % [m]
A = pi*(d/2)^2;         % [m²]
h_soll_wert = 0.1;      % Führungsgrößensprung [m]
c = 0.003;              % [m³/(s·m)]
Kr_fixed = 0.006;       % Reglerverstärkung 

assignin('base', 'A', A);
assignin('base', 'c', c);
assignin('base', 'Kr', Kr_fixed);

%% Nachstellzeiten (TN) für PI-Regler 
%Tn_vector = [100, 50, 20, 10, 5, 2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01];
Tn_vector = [6.2, 6.15, 6.1, 6.05, 6];
n_sim = length(Tn_vector);

% Initialisierung 
overshoot_percent = zeros(1, n_sim);
has_overshoot = zeros(1, n_sim);
steady_state_h = zeros(1, n_sim);
max_h_values = zeros(1, n_sim);

%% Simulationsparameter 
run_time = 30;
open_system('b_modell_mit_abfluss');
set_param('b_modell_mit_abfluss', 'StopTime', num2str(run_time));
set_param('b_modell_mit_abfluss', 'StartTime', '0');
set_param('b_modell_mit_abfluss/Integrator', 'InitialCondition', '0');

% Step-Block
set_param('b_modell_mit_abfluss/Step', 'Time', '0');
set_param('b_modell_mit_abfluss/Step', 'Before', '0');
set_param('b_modell_mit_abfluss/Step', 'After', num2str(h_soll_wert));

for i = 1:n_sim
    Tn = Tn_vector(i);
    Ki = 1/Tn; 
    
    fprintf('\n========== TN = %.4f s (Ki = %.4f) ==========\n', Tn, Ki);
    
    set_param('b_modell_mit_abfluss/PID Controller', 'P', num2str(Kr_fixed));
    set_param('b_modell_mit_abfluss/PID Controller', 'I', num2str(Ki));
    set_param('b_modell_mit_abfluss/PID Controller', 'D', '0');
    
    simOut = sim("b_modell_mit_abfluss.slx");
    
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
    
    if isa(h, 'timeseries')
        h = h.Data;
        t = t.Data;
        q_zu = q_zu.Data;
        q_ab = q_ab.Data;
    end
    
    sim_data{i}.t = t;
    sim_data{i}.h = h;
    sim_data{i}.q_zu = q_zu;
    sim_data{i}.q_ab = q_ab;
    sim_data{i}.Tn = Tn;
    sim_data{i}.Ki = Ki;
    
    % Stationärer Endwert
    n_end = round(0.9 * length(h));
    h_end = mean(h(n_end:end));
    steady_state_h(i) = h_end;
    
    % Maximalen Wert finden, nach dem Einschwingen, d.h. nach t>2s
    idx_start = find(t > 2, 1, 'first');
    if isempty(idx_start)
        idx_start = 1;
    end
    h_max = max(h(idx_start:end));
    max_h_values(i) = h_max;
    
    % Überschwinger berechnen (in %)
    if h_max > h_end * 1.01
        overshoot_percent(i) = (h_max - h_end) / h_end * 100;
        has_overshoot(i) = 1;
        fprintf('  -> ÜBERSCHWINGER: %.2f%% (h_max = %.4f m, h_end = %.4f m)\n', ...
                overshoot_percent(i), h_max, h_end);
    else
        overshoot_percent(i) = 0;
        has_overshoot(i) = 0;
        fprintf('  -> Kein Überschwinger (h_max = %.4f m, h_end = %.4f m)\n', h_max, h_end);
    end
    
    % Plots
    figure('Name', sprintf('TN = %.3f s, Ki = %.4f', Tn, Ki), ...
           'Numbertitle', 'off', ...
           'Position', [100, 100, 900, 700]);
    
    h_soll_plot = h_soll_wert * ones(size(t));
    
    subplot(2, 1, 1);
    
    yyaxis left;
    plot(t, h_soll_plot, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Führungsgröße h_{soll}(t)');
    hold on;
    plot(t, h, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Regelgröße h(t)');
    ylabel('Füllstand h [m]', 'FontSize', 11);
    ylim([0, max([h_soll_plot; h]) * 1.1]);
    
    yyaxis right;
    plot(t, q_zu, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Stellgröße q_{zu}(t)');
    plot(t, q_ab, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Störgröße q_{ab}(t)');
    plot(t, q_zu - q_ab, 'k--', 'LineWidth', 1, 'DisplayName', 'q_{zu} - q_{ab}');
    ylabel('Volumenstrom q [m³/s]', 'FontSize', 11);
    ylim([0, 0.006]);

    plot(nan, nan, 'b-', 'DisplayName', sprintf('T_n = %.2f', Tn), 'HandleVisibility', 'on');

    xlabel('Zeit t [s]', 'FontSize', 11);
    xlim([0, run_time]);
    grid on;
    
    legend('Location', 'southeast', 'FontSize', 9);
    hold off;
      
    filename = fullfile(savetofolder, sprintf('b_modell_mit_abfluss_TN_%.2f.png', Tn));
    saveas(gcf, filename);
    close(gcf);  
    
    fprintf('  -> Plot gespeichert: %s\n', filename);
end

%% Auswertung
fprintf('\n\n');
fprintf('================================================================\n');
fprintf('ERGEBNISSE PI-Regler mit Kr = %.4f\n', Kr_fixed);
fprintf('================================================================\n');
fprintf('\n');

fprintf('------------------------------------------------------------\n');
fprintf('| TN [s]    | Ki        | Überschwinger [%%] | vorhanden |\n');
fprintf('|-----------|-----------|-------------------|-----------|\n');
for i = 1:n_sim
    fprintf('| %-9.4f | %-9.4f | %-17.2f | %-9s |\n', ...
            Tn_vector(i), 1/Tn_vector(i), overshoot_percent(i), ...
            string(has_overshoot(i)));
end
fprintf('------------------------------------------------------------\n');

% Intervallbestimmung
Tn_overshoot = Tn_vector(has_overshoot == 1);
Tn_no_overshoot = Tn_vector(has_overshoot == 0);

fprintf('\nINTERVALLBESTIMMUNG:\n');

if ~isempty(Tn_no_overshoot) && ~isempty(Tn_overshoot)
    Tn_max_no_overshoot = max(Tn_no_overshoot);    % Größtes TN ohne Überschwinger
    Tn_min_overshoot = min(Tn_overshoot);          % Kleinstes TN mit Überschwinger
    
    fprintf('  Keine Überschwinger für TN ≥ %.4f s\n', Tn_max_no_overshoot);
    fprintf('  Überschwinger vorhanden für TN ≤ %.4f s\n', Tn_min_overshoot);
    fprintf('  Grenzbereich: %.4f s < TN_kritisch < %.4f s\n', Tn_max_no_overshoot, Tn_min_overshoot);
    
elseif isempty(Tn_no_overshoot)
    fprintf('  Bei allen getesteten TN-Werten treten Überschwinger auf!\n');
elseif isempty(Tn_overshoot)
    fprintf('  Bei keinem getesteten TN-Wert treten Überschwinger auf!\n');
end

%% plot: Überschwinger % vs. Nachstellzeit TN
figure('Name', 'Überschwinger als Funktion der Nachstellzeit TN', ...
       'Numbertitle', 'off', ...
       'Position', [100, 100, 800, 500]);

semilogx(Tn_vector, overshoot_percent, 'bo-', 'LineWidth', 2, 'MarkerSize', 8, ...
         'MarkerFaceColor', 'b');
hold on;

xlabel('Nachstellzeit T_N [s]', 'FontSize', 12);
ylabel('Überschwinger [%]', 'FontSize', 12);
grid on;
xlim([6, 6.2]);
ylim([0, 1.5]);

for i = 1:n_sim
    text(Tn_vector(i), overshoot_percent(i) + 2, ...
         sprintf('%.1f', overshoot_percent(i)), ...
         'FontSize', 8, 'HorizontalAlignment', 'center');
end

legend('Überschwinger', 'Location', 'northeast');
hold off;

filename_comp = fullfile(savetofolder, sprintf('b_modell_mit_abfluss_überschwinger.png'));
saveas(gcf, filename_comp);
fprintf('\nVergleichsplot gespeichert: %s\n', filename_comp);
close(gcf);  

fprintf('\n');
fprintf('================================================================\n');
fprintf('FERTIG! Alle Plots wurden gespeichert in:\n');
fprintf('%s\n', savetofolder);
fprintf('================================================================\n');