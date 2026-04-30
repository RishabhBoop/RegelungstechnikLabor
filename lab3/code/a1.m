% load parameters
params;
disp('Parameters loaded');

% simulate using simulink model
sim_outputs = sim('regelstrecke_simulink', 'StopTime', '20');
disp('Simulation completed.');

% extract data from simulink
y_i = sim_outputs.logsout.get('i').Values; % Strmo extrahieren
y_u = sim_outputs.logsout.get('u').Values; % Eingang (Spannung) extrahieren
y_w = sim_outputs.logsout.get('w').Values; % Drehzahl extrahieren
y_M = sim_outputs.logsout.get('M').Values; % Drehmoment extrahieren

% change units
y_w.Data = y_w.Data * (60/(2*pi)); % convert rad/s to rpm
y_M.Data = y_M.Data * 1e3; % convert Nm to mNm

% plot results in one plot
figure('Name', 'Simulation der Regelstrecke');
hold on;
grid on;
plot(y_i.Time, y_i.Data, 'b', 'LineWidth', 1.5);
plot(y_M.Time, y_M.Data, 'r', 'LineWidth', 1.5);
plot(y_w.Time, y_w.Data, 'g', 'LineWidth', 1.5);
ylabel('Werte');
xlabel('Zeit [s]');
legend('Strom i [A]', 'Moment M [mNm]', 'Drehzahl w [rpm]', 'Location', 'best');
title('Simulationsergebnisse der Regelstrecke');
hold off;

% export plot
% exportgraphics(gcf, './lab3/images/a1_regelstrecke_sim.png', 'Resolution', 300);

% plot results in separate subplots
figure('Name', 'Simulation der Regelstrecke - Einzeln');
subplot(3,1,1);
plot(y_i.Time, y_i.Data, 'b', 'LineWidth', 1.5);
grid on;
ylabel('Strom i [A]');
title('Stromverlauf');

subplot(3,1,2);
plot(y_M.Time, y_M.Data, 'r', 'LineWidth', 1.5);
grid on;
ylabel('Moment M [mNm]');
title('Drehmomentverlauf');

subplot(3,1,3);
plot(y_w.Time, y_w.Data, 'g', 'LineWidth', 1.5);
grid on;
ylabel('Drehzahl w [rpm]');
title('Drehzahlverlauf');
xlabel('Zeit [s]');

% Zeitkonstante aus Diagramm bestimmen
endwert = y_w.Data(end); % Endwert der Drehzahl
gesuchter_wert = 0.63 * endwert; % 63% des Endwerts
index_63 = find(y_w.Data >= gesuchter_wert, 1); % Index des ersten Werts >= 63% des Endwerts
zeit_63 = y_w.Time(index_63); % Zeit bei 63% des Endwerts
tau = zeit_63 - step_time; % Zeitkonstante tau
disp(['Zeitkonstante tau: ', num2str(tau), ' Sekunden']);