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
disp("P-Anteil K_R = " + K_R + " V/m");
disp("D-Anteil Zeitkonstanten T_Vs = " + mat2str(T_Vs));
disp("Saturation upper limit = " + sat_upper_limit + " V");
disp("Saturation lower limit = " + sat_lower_limit + " V");
disp("Integrator saturation upper limit = " + integrator_sat_upper + " m");
disp("Integrator saturation lower limit = " + integrator_sat_lower + " m");
disp("Initial position y0 = " + y0 + " m");
disp("-------------------------");

% Create one figure before the loop starts
figure('Name', 'Simulation des PD-Reglers', 'Position', [100, 100, 2000, 1200]);

% Create a flexible layout grid (MATLAB R2019b or newer)
t = tiledlayout('flow', 'TileSpacing', 'compact', 'Padding', 'compact');
title(t, 'Simulationsergebnisse eines PD-Reglers für verschiedene T_V', 'FontSize', 16, 'FontWeight', 'bold');


% simulate using simulink model
for i = 1:length(T_Vs)
    T_V = T_Vs(i);
    % disp("Simulating with P-Regler Verstärkung K_R = " + K_R);
    sim_outputs = sim('pd_regler_simulink', 'SimulationMode', 'normal', 'StopTime', '10');
    disp('Simulation completed for T_V = ' + string(T_V));

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
    % figure('Name', 'Simulation des PD-Reglers mit T_V = ' + string(T_V));
    hold on;
    grid on;
    plot(y_s.Time, y_s.Data, 'b', 'LineWidth', 1.5);
    ylabel('Stellgröße [V]');
    yyaxis right;
    plot(y_r.Time, y_r.Data, 'm', 'LineWidth', 1.5);
    ylabel('Regelgröße [mm]');
    xlabel('Zeit [s]');
    legend('Stellgröße [V]', 'Regelgröße [mm]', 'Location', 'best', 'FontSize', 14);
    title('T_V = ' + string(T_V));
    hold off;
end
drawnow;
set(gcf, 'PaperOrientation', 'landscape', 'PaperPositionMode', 'auto');
exportgraphics(t, './lab5_rishabh/a3_pd_regler.pdf', 'Resolution', 300);
