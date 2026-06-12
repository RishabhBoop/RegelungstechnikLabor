% load parameters
params;
jump_time = 0; % Startzeitpunkt der Simulation
jump_init_val = 0; % Anfangswert der Schrittantwort
jump_end_val = 1; % Endwert der Schrittantwort
disp('Parameters loaded:');
disp("R = " + R + " Ohm");
disp("L = " + L + " H");
disp("m = " + m + " kg");
disp("ci = " + ci + " N/A");
disp("cy = " + cy + " N/m");
disp("Step Block: Start Time = " + jump_time + " s, Initial Value = " + jump_init_val + ", Final Value = " + jump_end_val);
% simulate using simulink model
sim_outputs = sim('regelstrecke_simulink', 'StopTime', '10');
disp('Simulation completed.');

% extract data from simulink
y_i = sim_outputs.logsout.get('i').Values; % Stromextrahieren
y_u = sim_outputs.logsout.get('u').Values; % Eingang (Spannung) extrahieren
y_v = sim_outputs.logsout.get('v').Values; % Geschwindigkeit extrahieren
y_y = sim_outputs.logsout.get('y').Values; % Y-Position extrahieren


% change units
y_i.Data = y_i.Data * 10; % convert A to 10 mA
y_v.Data = y_v.Data * 10; % convert m/s to 10 cm/s
y_y.Data = y_y.Data * 100; % convert m to cm

% plot results in one plot
figure('Name', 'Simulation der Regelstrecke');
hold on;
grid on;
plot(y_u.Time, y_u.Data, 'k', 'LineWidth', 1.5);
plot(y_i.Time, y_i.Data, 'b', 'LineWidth', 1.5);
plot(y_v.Time, y_v.Data, 'm', 'LineWidth', 1.5);
plot(y_y.Time, y_y.Data, 'c', 'LineWidth', 1.5);
ylabel('Werte');
xlabel('Zeit [s]');
ylim([0, 10]);
legend('Spannung u [V]', 'Strom i [10 mA]', 'Geschwindigkeit v [10 cm/s]', 'Y-Position y [cm]', 'Location', 'best', 'FontSize', 14);
title('Simulationsergebnisse der Regelstrecke');
hold off;
set(gcf, 'Position', [100, 100, 1200, 800]);

% export plot
exportgraphics(gcf, './lab5_rishabh/a1_regelstrecke_sim.png', 'Resolution', 300);
