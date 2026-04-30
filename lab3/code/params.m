% ---------------- params for Motor ----------------
K=30e-3; % in Nm/A; 30 mN*m/A
J = 4e-4; % in kg*m^2; 4000 g*cm^2
R=6; % in ohm; 6 Ohm
L=120e-6; % in H; 120µH

% ---------------- params for Regelstrecke Simulation ----------------
% step block parameters for Regelstrecke
init_value = 0; % initial value 0V
final_value = 10; % final value 10V
step_time = 1; % jump at 1s
sample_time = 0;

% ---------------- params for saturation block ----------------
sat_min = -10; % minimum value
sat_max = 10; % maximum value

% ---------------- params for p-Regler ----------------
Kr = 0.1; % 10[V]/100[rad/s] => 0.1[V/rad/s]
init_value_regler = 0; % initial value 0V
final_value_regler = 100; % final value 10V
step_time_regler = 1; % jump at 1s
sample_time_regler = 0;

% ---------------- params for pi-Regler ----------------
Tn = 27; % in s; 27s (=> 1/TN = 0.037 1/s)
init_value_regler_pi = 0; % initial value 0V
final_value_regler_pi = 100; % final value 10V
step_time_regler_pi = 1; % jump at 1s
sample_time_regler_pi = 0;





