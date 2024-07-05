%% Pendulo de Furuta
%% formato name "APRBS_Furutapend_suave_x" x e (1:100)
dir = "D:\Escritorio\Paper auto calibracion Furuta\Entrada\furuta_pendulum_data_suave_media_fuerte\APRBS_Furutapend_exp_suave\";
name = "APRBS_Furutapend_suave_";
%% Frame IMU = BNO(acc , mag , vel , quat), MPU(acc , vel , mag)

for i=2:2

    archivo = strcat(dir, name, num2str(3), '.csv');
    datos_in = csvread(archivo,2);
    tiempo = datos_in(:,1);
    u = datos_in(:,2)*3;
     
    %% estructura entrada QUANSER
    entrada.signals.values = u; 
    entrada.time = tiempo;
    entrada.signals.dimensions = 1; 
    
    % Abrir la conexión
    fopen(server);
 
    qc_start_model('q_rotpen_mdl_student');  
    
    
    %% codigo escritura data IMU
    %% Leer datos del servidor
    cont = 1;
    while cont < 1000
        data = fgetl(server);

        cadena = strrep(data, '''', ''); % Eliminar comillas simples
        partes = strsplit(cadena, ',');
        vector = str2double(partes)

        matriz_datos(cont,:) = vector(1:23);
        cont = cont + 1;

        pause(0.1)
    end
    
    %% Cerrar la conexión
    fclose(server);

    filename = 'test_1.csv';
    csvwrite(filename, matriz_datos)
    %%
    pause(110)
    load salida;   
    datos=ans;
    t=datos(1,:)';
    alpha=datos(2,:)';
    beta=datos(3,:)';
    u_volt=datos(4,:)';
       
    s1=num2str(i);s2 = '_QUANSER.txt'; s = strcat(s1,s2);
    
    dlmwrite(s, [t alpha beta u_volt], 'delimiter', '\t');
    i
end