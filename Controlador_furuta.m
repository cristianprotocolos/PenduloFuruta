%% Furuta discreto

% Definición de las matrices del sistema continuo
A = [
    0.0, 1.0, 0.0, 0.0;
    0.0, -28.989, 81.495, 0.9316;
    0.0, 0.0, 0.0, 1.0;
    0.0, 27.869, -122.03, -1.3951
];

B = [
    0;
    51.9848;
    0;
    -49.9764
];

C = [0, 0, 1, 0];
D = [0];

% Parámetros del controlador PI  (Encontrados con sintonizador de simulink)
P = 0;
I = 4.03147840867822;

% Discretización del sistema con un tiempo de muestreo Ts
Ts = 0.01; % Tiempo de muestreo
sys_c = ss(A, B, C, D); % Sistema continuo
sys_d = c2d(sys_c, Ts); % Sistema discreto

% Matrices del sistema discreto
A_d = sys_d.A;
B_d = sys_d.B;
C_d = sys_d.C;
D_d = sys_d.D;

% Crear el controlador PI en el dominio discreto
% Usando la transformación Tustin
s = tf('s');
PI_controller_c = P + I/s;
PI_controller_d = c2d(PI_controller_c, Ts, 'tustin');

% Crear lazo cerrado con el controlador PI discreto
sys_cl_d = feedback(PI_controller_d * sys_d, 1);

% Simular la respuesta del sistema discreto
t = 0:Ts:10;  % Tiempo de simulación
r = ones(size(t));  % Referencia (escalón unitario)

% Simular respuesta del sistema a la entrada de referencia
[y, t, x] = lsim(sys_cl_d, r, t);

% Graficar resultados
figure;
subplot(2, 1, 1);
stairs(t, r, 'r--', 'LineWidth', 1.5); hold on;
stairs(t, y, 'b-', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Salida');
legend('Referencia', 'Salida del sistema');
title('Respuesta del sistema con controlador PI discreto');

subplot(2, 1, 2);
stairs(t, x);
xlabel('Tiempo (s)');
ylabel('Estados');
legend('Estado 1', 'Estado 2', 'Estado 3', 'Estado 4');
title('Evolución de los estados del sistema');