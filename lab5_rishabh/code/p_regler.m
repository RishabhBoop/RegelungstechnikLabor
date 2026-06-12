% load parameters
params;
jump_time = 0; % Startzeitpunkt der Simulation
jump_init_val = 0; % Anfangswert der Schrittantwort
jump_end_val = 0; % Endwert der Schrittantwort
disp('Parameters loaded:');
disp("R = " + R + " Ohm");
disp("L = " + L + " H");
disp("m = " + m + " kg");
disp("ci = " + ci + " N/A");
disp("cy = " + cy + " N/m");
disp("P-Regler Verstärkungen K_Rs = " + mat2str(K_Rs));
disp("Saturation upper limit = " + sat_upper_limit + " V");
disp("Saturation lower limit = " + sat_lower_limit + " V");
disp("Integrator saturation upper limit = " + integrator_sat_upper + " m");
disp("Integrator saturation lower limit = " + integrator_sat_lower + " m");
disp("Initial position y0 = " + y0 + " m");
disp("-------------------------");

% Create ONE huge figure before the loop starts
figure('Name', 'Simulation des P-Reglers', 'Position', [100, 100, 2000, 1200]);

% Create a flexible layout grid (MATLAB R2019b or newer)
t = tiledlayout('flow', 'TileSpacing', 'compact', 'Padding', 'compact');
title(t, 'Simulationsergebnisse eines P-Reglers für verschiedene K_R', 'FontSize', 16, 'FontWeight', 'bold');

% simulate using simulink model
for i = 1:length(K_Rs)
    K_R = K_Rs(i);
    % disp("Simulating with P-Regler Verstärkung K_R = " + K_R);
    sim_outputs = sim('p_regler_simulink', 'SimulationMode', 'normal', 'StopTime', '10');
    disp('Simulation completed for K_R = ' + string(K_R));

    % extract data from simulink
    % y_i = sim_outputs.logsout.get('i').Values; % Stromextrahieren
    % y_u = sim_outputs.logsout.get('u').Values; % Eingang (Spannung) extrahieren
    % y_v = sim_outputs.logsout.get('v').Values; % Geschwindigkeit extrahieren
    % y_y = sim_outputs.logsout.get('y').Values; % Y-Position extrahieren
    y_f = sim_outputs.logsout.get('Führungsgröße').Values; % Führungsgröße extrahieren
    y_s = sim_outputs.logsout.get('Stellgröße').Values; % Stellgröße extrahieren
    y_r = sim_outputs.logsout.get('Regelgröße').Values; % Regelgröße extrahieren

    % change units
    y_f.Data = y_f.Data * 1; % convert V to V
    y_s.Data = y_s.Data * 1; % convert V to V
    y_r.Data = y_r.Data * 1e3; % convert m to mm

    % Select the next tile/subplot for this loop iteration
    nexttile;

    % plot results in one plot
    % figure('Name', 'Simulation des P-Reglers mit K_R = ' + string(K_R));
    hold on;
    grid on;
    plot(y_s.Time, y_s.Data, 'b', 'LineWidth', 1.5);
    plot(y_r.Time, y_r.Data, 'm', 'LineWidth', 1.5);
    ylabel('Werte');
    xlabel('Zeit [s]');
    legend('Stellgröße [V]', 'Regelgröße [mm]', 'Location', 'best', 'FontSize', 14);
    title('K_R = ' + string(K_R));
    hold off;
end
drawnow;
set(gcf, 'PaperOrientation', 'landscape', 'PaperPositionMode', 'auto');
exportgraphics(gcf, './lab5_rishabh/a2_p_regler.pdf', 'Resolution', 300);