clear;
close all;
clc;

savetofolder = '/home/ruth/Desktop/Uni/8. Semester Sensorik/Regelungstechnik/Labor/2 Füllstandsreglung/plots_aufgabe1';

% parameter zur füllstandsregelung
d = 0.17;       % durchmesser: 17cm
A = pi*(d/2)^2; % grundfläche des behälters
h_soll = 0.1;   % führungsgrößensprung: 10cm
Kr = 1;

%1: behälter ohne loch
% Regelgröße: h , Führungsgröße: h_soll , Stellgröße: q_zu
Kr_vector = [0.002, 0.004, 0.006, 0.008, 0.01]; % reglerverstärkungen
n_sim = length(Kr_vector);
T_vector = zeros(1, n_sim);             % initialvektor für zeitkonstanten

for i = 1:n_sim
    Kr_actual = Kr_vector(i);
    assignin('base', 'Kr', Kr_actual); 
    set_param('modell_ohne_abfluss/Step', 'After', num2str(0.10));
    simOut = sim("modell_ohne_abfluss.slx");

    if exist('simOut', 'var')
        if isstruct(simOut)
            h_soll = simOut.h_soll;
            h = simOut.h;
            q_zu = simOut.q_zu;
        else
            h_soll = simOut.get('h_soll');
            h = simOut.get('h');
            q_zu = simOut.get('q_zu');
        end
    end

    t_value = (0:length(h)-1)' * 0.01;  
    h_value = h;
    h_soll_value = h_soll;
    q_zu_value = q_zu;

    sim_data{i}.t_value = t_value;
    sim_data{i}.h_value = h_value;
    sim_data{i}.h_soll_value = h_soll_value;
    sim_data{i}.q_zu_value = q_zu_value;
    sim_data{i}.Kr = Kr_actual;

    % zeitkonstante
    h_end = h(end);
    h_soll_end = h_soll(end);
    zielwert = 0.632 * h_end; % 63.2 % der Führungsgröße
    zielindex = find(h >= zielwert, 1, 'first');
    T_actual = t_value(zielindex);
    T_vector(i) = T_actual; 
    fprintf('Reglerverstärkung Kr= %.3f:', Kr_actual);
    fprintf('    Zeitkonstante T= %.3f Sekunden\n\n', T_actual);

end

% plots

for i = 1:n_sim               % use i = 5; for debugging else: 1:n_sim 
    t = sim_data{i}.t_value;    % Zeit
    h = sim_data{i}.h_value;    % Regelgröße Füllstand
    h_soll = sim_data{i}.h_soll_value; % Führungsgröße Füllstand
    q_zu = sim_data{i}.q_zu_value; % Stellgröße Zufluss
    Kr_actual = sim_data{i}.Kr; % Verstärkung
    T_actual = T_vector(i);     % Zeitkonstante

    figure('Name', sprintf('Kr = %.2f, T = %.3f s', Kr_actual, T_actual), 'Numbertitle', 'off', 'Position', [100, 100, 800, 600]);
    subplot(2, 1, 1);

    yyaxis left;
    plot(t, h_soll, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Führungsgröße h_{soll}(t)');
    hold on;
    plot(t, h, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Regelgröße h(t)');
    hold on;
    ylabel('Füllstand h [m]');
    ylim([0, max([h_soll; h]) * 1.1]);
    
    yyaxis right;
    plot(t, q_zu, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Stellgröße q_{zu}(t)'); 
    ylabel('Zufluss q [m³/s]');
    ylim([0, max(q_zu) * 1.2]);

    plot(nan, nan, 'b-', 'DisplayName', sprintf('K_r = %.3f', Kr_actual), 'HandleVisibility', 'on');

    xlabel('Zeit t [s]', 'FontSize', 11);
    xlim([0, max(t)]);        
    grid on;
    legend('Location','east');
    hold off;
    filename = fullfile(savetofolder, sprintf('modell_ohne_abfluss_KR_%.3f.png', Kr_actual));
    saveas(gcf, filename);
    close(gcf);  
end


            