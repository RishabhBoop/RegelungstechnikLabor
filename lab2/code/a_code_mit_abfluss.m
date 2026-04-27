%% 2a - Behälter mit Loch (P-Regler)

savetofolder = '/home/ruth/Desktop/Uni/8. Semester Sensorik/Regelungstechnik/Labor/2 Füllstandsreglung/plots_aufgabe2/a';

%% parameter
d = 0.17;           % [m]
A = pi*(d/2)^2;     % [m²]
h_soll_wert = 0.1;  % Führungsgrößensprung [cm]
c = 0.003;            %  [1/(s*m)] 

% Regelgröße: h, Führungsgröße: h_soll, Stellgröße: q_zu, Störgröße: q_ab
Kr_vector = [0.002, 0.004, 0.006, 0.008, 0.01]; % Reglerverstärkungen
n_sim = length(Kr_vector);

% Initialisierung für Ergebnisse
stationary_error_percent = zeros(1, n_sim);
stationary_error_abs = zeros(1, n_sim);
steady_state_h = zeros(1, n_sim);

open_system('a_modell_mit_abfluss');


% Simulationszeit
run_time = 30;
set_param('a_modell_mit_abfluss', 'StopTime', 'run_time');
set_param('a_modell_mit_abfluss', 'StartTime', '0');

% Step-Block
set_param('a_modell_mit_abfluss/Step', 'Time', '0');
set_param('a_modell_mit_abfluss/Step', 'Before', '0');
set_param('a_modell_mit_abfluss/Step', 'After', num2str(h_soll_wert));

for i = 1:n_sim
    Kr_actual = Kr_vector(i);
    
    assignin('base', 'Kr', Kr_actual);
    assignin('base', 'c', c);
    assignin('base', 'A', A);
    
    fprintf('StopTime VOR sim: %s\n', get_param('a_modell_mit_abfluss', 'StopTime'));
    simOut = sim("a_modell_mit_abfluss.slx");
    fprintf('StopTime NACH sim: %s\n', get_param('a_modell_mit_abfluss', 'StopTime'));

    if isstruct(simOut)
        t = simOut.tout;
        h = simOut.h;
        h_soll = simOut.h_soll;
        q_zu = simOut.q_zu;
        q_ab = simOut.q_ab;
    else
        t = simOut.get('tout');
        h = simOut.get('h');
        h_soll = simOut.get('h_soll');
        q_zu = simOut.get('q_zu');
        q_ab = simOut.get('q_ab');
    end
    
    sim_data{i}.t = t;
    sim_data{i}.h = h;
    sim_data{i}.h_soll = h_soll;
    sim_data{i}.q_zu = q_zu;
    sim_data{i}.q_ab = q_ab;
    sim_data{i}.Kr = Kr_actual;
    
    % Stationäre Regelabweichung 
    n_samples = length(h);
    steady_start = round(0.9 * n_samples); 
    steady_state_h(i) = mean(h(steady_start:end));
    stationary_error_abs(i) = h_soll_wert - steady_state_h(i);
    stationary_error_percent(i) = (stationary_error_abs(i) / h_soll_wert) * 100;
    
    fprintf('\n========== Kr = %.4f ==========\n', Kr_actual);
    fprintf('Stationärer Füllstand h(∞) = %.4f m\n', steady_state_h(i));
    fprintf('Absolute Regelabweichung e = %.4f m\n', stationary_error_abs(i));
    fprintf('Stationäre Regelabweichung = %.2f %%\n', stationary_error_percent(i));
end

%% Tabelle 
fprintf('\n');
fprintf('================================================================\n');
fprintf('Tabelle: Stationäre Regelabweichung in %% für verschiedenen Kr\n');
fprintf('================================================================\n');
fprintf('| Kr [--]     | h(∞) [m]    | e_abs [m]   | e_rel [%%]    |\n');
fprintf('|-------------|-------------|-------------|---------------|\n');
for i = 1:n_sim
    fprintf('| %.4f     | %.4f     | %.4f    | %.2f %%        |\n', ...
        Kr_vector(i), steady_state_h(i), stationary_error_abs(i), stationary_error_percent(i));
end
fprintf('================================================================\n');

%% Plots 
for i = 1:n_sim
    t = sim_data{i}.t;
    h = sim_data{i}.h;
    h_soll = sim_data{i}.h_soll;
    q_zu = sim_data{i}.q_zu;
    q_ab = sim_data{i}.q_ab;
    Kr_actual = sim_data{i}.Kr;
    
    figure('Name', sprintf('Kr = %.4f', Kr_actual), ...
           'Numbertitle', 'off', ...
           'Position', [100, 100, 900, 600]);
    
    subplot(2, 1, 1);
    
    yyaxis left;
    plot(t, h_soll, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Führungsgröße h_{soll}(t)');
    hold on;
    plot(t, h, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Regelgröße h(t)');
    ylabel('Füllstand h [m]', 'FontSize', 11);
    ylim([0, max([h_soll; h]) * 1.1]);
    
    yyaxis right;
    plot(t, q_zu, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Stellgröße q_{zu}(t)');
    plot(t, q_ab, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Störgröße q_{ab}(t)');
    plot(t, q_zu - q_ab, 'k--', 'LineWidth', 1, 'DisplayName', 'q_{zu} - q_{ab}');
    ylabel('Volumenstrom q [m³/s]', 'FontSize', 11);
    
    plot(nan, nan, 'b-', 'DisplayName', sprintf('K_r = %.3f', Kr_actual), 'HandleVisibility', 'on');

    xlabel('Zeit t [s]', 'FontSize', 11);
    xlim([0, run_time]);
    grid on;
    legend('Location', 'southeast');
    hold off;
    
    filename = fullfile(savetofolder, sprintf('a_modell_mit_abfluss_KR_%.4f.png', Kr_actual));
    saveas(gcf, filename);
    fprintf('Plot gespeichert: %s\n', filename);
    close(gcf);  
end

%% Vergleich aller Regelgrößen 
figure('Numbertitle', 'off', ...
       'Position', [100, 100, 1000, 600]);

colors = {'b', 'r', 'g', 'c', 'm'};
hold on;

for i = 1:n_sim
    t = sim_data{i}.t;
    h = sim_data{i}.h;
    Kr_actual = sim_data{i}.Kr;
    plot(t, h, colors{i}, 'LineWidth', 1.5, ...
         'DisplayName', sprintf('Kr = %.3f; e = %.1f %%', Kr_actual, stationary_error_percent(i)));
end

t_soll = sim_data{1}.t;
h_soll_plot = sim_data{1}.h_soll;
plot(t_soll, h_soll_plot, 'k--', 'LineWidth', 2, 'DisplayName', 'Sollwert h_{soll} = 0.1 m');

xlabel('Zeit t [s]', 'FontSize', 12);
ylabel('Füllstand h [m]', 'FontSize', 12);
xlim([0, run_time]);
ylim([0, 0.12]);
grid on;
legend('Location', 'northeast', 'FontSize', 10);

hold off;

filename = fullfile(savetofolder, 'Vergleich_alle_KR.png');
saveas(gcf, filename);
close(gcf);  

%%  Command Window 
fprintf('\n');
fprintf('============================================================\n');
fprintf('ERGEBNISSE Behälter mit Loch (P-Regler)\n');
fprintf('============================================================\n');
fprintf('Reglerverstärkung Kr | Stationäre Abweichung [%%]\n');
fprintf('------------------------------------------------------------\n');
for i = 1:n_sim
    fprintf('      %.4f          |        %.2f %%\n', Kr_vector(i), stationary_error_percent(i));
end
