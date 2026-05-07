% load parameters
params;
disp('Parameters loaded');

% simulate using simulink model
sim_outputs = sim('drehzahlregelung_pi_regler', 'StopTime', '20');
disp('Simulation completed.');

% extract data from simulink
y_f = sim_outputs.logsout.get('Führungsgröße').Values; % Führungsgröße extrahieren
y_s = sim_outputs.logsout.get('Stellgröße').Values; % Stellgröße extrahieren
y_r = sim_outputs.logsout.get('Regelgröße').Values; % Regelgröße extrahieren


% plot results 
figure('Name', 'Simulation der pi-Regelung');
hold on;
grid on;
plot(y_f.Time, y_f.Data, 'b', 'LineWidth', 1.5);
plot(y_s.Time, y_s.Data, 'r', 'LineWidth', 1.5);
plot(y_r.Time, y_r.Data, 'g', 'LineWidth', 1.5);
ylabel('Werte');
xlabel('Zeit [s]');
legend('Führungsgröße [rad/s]', 'Stellgröße [V]', 'Regelgröße [rad/s]', 'Location', 'best', 'FontSize', 14);
title('Simulationsergebnisse der pi-Regelung mit 100 rad/s Führungsgröße');
xlim([0, 20]);
hold off;
set(gcf, 'Position', [100, 100, 1200, 800]);
exportgraphics(gcf, './lab3/images/a3_pi_regelung_sim_100rad.png', 'Resolution', 300);


% ----------- b) -----------
final_value_regler_pi = 300; % final value 10V
% simulate using simulink model
sim_outputs = sim('drehzahlregelung_pi_regler', 'StopTime', '40');
disp('Simulation completed.');

% extract data from simulink
y_f = sim_outputs.logsout.get('Führungsgröße').Values; % Führungsgröße extrahieren
y_s = sim_outputs.logsout.get('Stellgröße').Values; % Stellgröße extrahieren
y_r = sim_outputs.logsout.get('Regelgröße').Values; % Regelgröße extrahieren


% plot results 
figure('Name', 'Simulation der pi-Regelung');
hold on;
grid on;
plot(y_f.Time, y_f.Data, 'b', 'LineWidth', 1.5);
plot(y_s.Time, y_s.Data, 'r', 'LineWidth', 1.5);
plot(y_r.Time, y_r.Data, 'g', 'LineWidth', 1.5);
ylabel('Werte');
xlabel('Zeit [s]');
legend('Führungsgröße [rad/s]', 'Stellgröße [V]', 'Regelgröße [rad/s]', 'Location', 'best', 'FontSize', 14);
title('Simulationsergebnisse der pi-Regelung mit 300 rad/s Führungsgröße');
hold off;
set(gcf, 'Position', [100, 100, 1200, 800]);
exportgraphics(gcf, './lab3/images/a3_pi_regelung_sim_300rad.png', 'Resolution', 300);


