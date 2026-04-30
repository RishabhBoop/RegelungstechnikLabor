% load parameters
params;
disp('Parameters loaded');

% simulate using simulink model
sim_outputs = sim('drehzahlregelung_p_regler', 'StopTime', '500');
disp('Simulation completed.');

% extract data from simulink
y_f = sim_outputs.logsout.get('Führungsgröße').Values; % Führungsgröße extrahieren
y_s = sim_outputs.logsout.get('Stellgröße').Values; % Stellgröße extrahieren
y_r = sim_outputs.logsout.get('Regelgröße').Values; % Regelgröße extrahieren


% plot results 
figure('Name', 'Simulation der p-Regelung');
hold on;
grid on;
plot(y_f.Time, y_f.Data, 'b', 'LineWidth', 1.5);
plot(y_s.Time, y_s.Data, 'r', 'LineWidth', 1.5);
plot(y_r.Time, y_r.Data, 'g', 'LineWidth', 1.5);
ylabel('Werte');
xlabel('Zeit [s]');
legend('Führungsgröße [rpm]', 'Stellgröße [V]', 'Regelgröße [rpm]', 'Location', 'best');
title('Simulationsergebnisse der p-Regelung');
xlim([0, 20]);
hold off;


% Regelkreis ist nicht stationäre genau, da die Regelgröße nie die Führungsgröße erreicht
