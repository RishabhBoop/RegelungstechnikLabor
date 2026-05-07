% Stabilitätsuntersuchung und empirische Reglereinstellungen
% Aufgabe 2: P-Regler

% Eingang: u
% Ausgang: y

clear;
close all;
clc;

savetofolder = '/home/ruth/Desktop/Uni/8. Semester Sensorik/Regelungstechnik/Labor/4 Stabilität/A2';

% Simulation
run_time = 0.05;
open_system('PRegler');
set_param('PRegler', 'StopTime', 'run_time');
set_param('PRegler', 'StartTime', '0');

%reglerverstärkungen
K_values = [1, 4, 7, 8.75, 10];
n_sim = length(K_values);
T_vector = zeros(1, n_sim);

for i = 1:n_sim
    K_actual = K_values(i);
    assignin('base', 'K', K_actual); 
    simOut = sim("PRegler.slx");
    
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
    
    fprintf('Simulation für K=%.2f abgeschlossen.\n', K_actual);

    % plot
    figure('Name', sprintf('K=%.2f', K_actual), ...
           'Position', [100, 100, 1000, 700]);
    
    subplot(2, 1, 1);
    plot(t, u, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Stellgröße');
    hold on;
    plot(t, y, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Regelgröße');
    hold on;
    plot(t, step, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Führungsgröße');

    xlabel('Zeit t [s]', 'FontSize', 11);
    xlim([0, run_time]);
    grid on;
    legend('Location', 'northeast', 'FontSize', 9);
    hold off;
    
    filename = fullfile(savetofolder, sprintf('P_Regler_K_%.2f.png', K_actual));
    saveas(gcf, filename);
    fprintf('Plot für K=%.2f gespeichert.\n\n', K_actual);
    close(gcf);
end

