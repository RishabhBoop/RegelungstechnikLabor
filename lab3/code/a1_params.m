% step block parameters
init_value = 0; % initial value 0V
final_value = 10; % final value 10V
step_time = 1; % jump at 1s
sample_time = 0;

% motor parameters
K=30e-3; % in Nm/A; 30 mN*m/A
J=0.4e9; % in m^2; 4000
R=6; % in ohm; 6 Ohm
L=120e-6; % in H; 120µH
