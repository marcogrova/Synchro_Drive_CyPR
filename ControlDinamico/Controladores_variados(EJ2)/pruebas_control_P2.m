%% CONTROL ROBOCHITO
% close all;clear all;
sel=input('Que tipo de control desea probar:\n1.Control a un punto\n2.Control una linea\n3.Control por una trayectoria definida\n4.Control a una postura\n');

switch (sel)
    case 1
    % MOVER A UN PUNTO
    
    %Tiempo de simulacion
    tsim=100;

    % Añadir saturacion en velocidades angulares y lineales.
    % No se gira un volante a mas de 10-15 deg/sec, por tanto, ahí estará la saturación del movimiento
     omega_sat=[-0.2618 0.2618];%15 grados/segundo
     tetha_d_sat=[-0.75 0.75];%Velocidad lineal de 30 cm/seg

    % punto al que se debe mover
    selection='Asigne la variable X del punto objetivo: ';
    x_ref=input(selection);
    selection='Asigne la variable Y del punto objetivo: ';
    y_ref=input(selection);
    
    % Posiciones iniciales del integrador
    selection='�Comenzar orientado hacia ese punto?:\n 0:No\n 1:S�\n';
    if input(selection)>0 
     pos_init=[0;0;atan2(y_ref,x_ref)];
    else
        pos_init=[0;0;0];
    end
    % Se lanza la simulacion
    sim('sl_robot_sincrono_control_pto');

    % Se grafican resultados
    plot(posx,posy,x_ref,y_ref,'*','LineWidth',2);xlabel('Posici�n cartesiana X (m)');ylabel('Posici�n cartesiana Y (m)');title('Trayectoria de control a punto');grid;
    
    figure% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,1,1);plot(t,theta_d);xlabel('Tiempo (s)');ylabel('Velocidad de desplazamiento (rad/s)');title('Variaci�n de la velocidad angular de desplazamiento a lo largo de la trayectoria');grid;subplot(2,1,2);plot(t,omega);xlabel('Tiempo (s)');ylabel('Velocidad de rotaci�n (rad/s)');title('Variaci�n de la velocidad angular de rotaci�n a lo largo de la trayectoria');grid;
    figure
    subplot(2,1,1);plot(t,posx);xlabel('Tiempo (s)');ylabel('Posici�n cartesiana X (m)');title('Posici�n cartesiana X frente al tiempo');grid;subplot(2,1,2);plot(t,posy);xlabel('Tiempo (s)');ylabel('Posici�n cartesiana Y (m)');title('Posici�n cartesiana Y frente al tiempo');grid;
    case 2
    % MOVER POR UNA RECTA
    % Posiciones iniciales del integrador
     pos_init=[0;0;0];
    %Tiempo de simulacion
    tsim=100;

    % Añadir saturacion en velocidades angulares y lineales.
    % No se gira un volante a mas de 10-15 deg/sec, por tanto, ahí estará la saturación del movimiento
     omega_sat=[-0.2618 0.2618];%15 grados/segundo
     tetha_d_sat=[-0.75 0.75];%Velocidad lineal de 30 cm/seg    
     
     % Definicion de parametros de la recta
     disp('Introduzca los parametros de la recta con ec -> ax + by + c = 0');
     a=input('Parametro A: ');
     b=input('Parametro B: ');
     while(b==0)
         disp('El par�metro B no puede ser nulo. Introduzca otro:');
         b=input('Parametro B: ');
     end
     c=input('Parametro C: ');
     %a=-1; b=1; c=-1; % -> y=x+1
     
     % Se lanza la simulacion
     sim('sl_robot_sincrono_control_linea');

     % Se define la recta para comparar
     y_recta=-(1/b)*(c+a*t/10);
     % Se grafican resultados
     figure();plot(t/10,y_recta,'r','LineWidth',3);hold on;plot(posx,posy,'b','LineWidth',1);grid;...
         legend('Trayectoria referencia','Trayectoria robot','Location','BestOutside');title('Trayectoria de control a l�nea');...
         xlabel('Coordenada cartesiana X');ylabel('Coordenada cartesiana Y');
  
    figure% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,1,1);plot(t,theta_d);xlabel('Tiempo (s)');ylabel('Velocidad de desplazamiento (rad/s)');title('Variaci�n de la velocidad angular de desplazamiento a lo largo de la trayectoria');xlim([0 50]);grid;subplot(2,1,2);plot(t,omega);xlabel('Tiempo (s)');ylabel('Velocidad de rotaci�n (rad/s)');title('Variaci�n de la velocidad angular de rotaci�n a lo largo de la trayectoria');xlim([0 50]);grid;
     case 3
     % MOVER POR UNA TRAYECTORIA A CIERTA DISTACIA
     % %%%
     % SE PODRIA ENTENDER COMO, DANDOLE UNA CIERTA CANDIDAS DE PUNTOS, QUE
     % SIGA LA TRAYECTORIA QUE SIGUE TODOS ELLOS. SIN EMBARGO, EN ESTE
     % CASO, HE CREADO UN GENERADOR DE TRAYECTORIAS SIMPLÓN DE TODO.
%      Kv=0.5;Ki=0.01;Kh=2;
%      R=0.4;
    selection='Seleccione el tipo de trayectoria a implementar:\n0.Lineal.\n1.Interpolacion entre puntos dados.\n';
    sel=input(selection);
    while (sel >1)
       disp('Error. Parametro no valido\n')
        selection='Seleccione el tipo de trayectoria a implementar:\n0.Lineal.\n1.Interpolacion entre puntos dados.\n';
       sel=input(selection);
    end

    % Distancia a la que se quiere seguir la trayectoria
     d=0;
     
     % Inicializaci�n de variables
     A=[0;0];
     B=[0;0];
     C=[0;0];
    if sel==0
     % Posiciones iniciales del integrador
     pos_init=[0;0;0.0997];
     % Tiempo de simulacion
    tsim=130; 
    else
     % Posiciones iniciales del integrador
     pos_init=[0;0;0];
     
      % Recogida de los puntos por los que se desea que pase el robot.
      % RESTRICCION -> SOLO VALIDO EN EL PRIMER Y CUARTO CUADRANTE
     A_x=input('Introduzca la coord X del punto A: ');
     A_y=input('Introduzca la coord Y del punto A: ');
     A=[A_x;A_y];
     B_x=input('Introduzca la coord X del punto B: ');
     B_y=input('Introduzca la coord Y del punto B: ');
     B=[B_x;B_y];
     C_x=input('Introduzca la coord X del punto C: ');
     C_y=input('Introduzca la coord Y del punto C: ');
     C=[C_x;C_y];
     % Tiempo de simulacion
    tsim=1500; 
    end
    
    % Tiempo de muestreo
    Tm=0.1;

    % Añadir saturacion en velocidades angulares y lineales.
    % No se gira un volante a mas de 10-15 deg/sec, por tanto, ahí estará la saturación del movimiento
     omega_sat=[-0.2618 0.2618];%15 grados/segundo
     tetha_d_sat=[-0.75 0.75];%Velocidad lineal de 30 cm/seg        
     
     
     % Se lanza la simulacion
     sim('sl_robot_sincrono_control_trayect');
     
     % Se grafican resultados
     if sel==0
         figure;plot(x_tray,y_tray,'r','LineWidth',2);hold on;plot(posx,posy,'b');axis([0 1.2 0 0.045]);grid;...
         title('Control de seguimieto a trayectoria lineal');xlabel('Posici�n cartesiana X');ylabel('Posici�n cartesiana Y');...
         legend('Trayectoria referencia','Trayectoria robot','Location','BestOutside');
        figure;subplot(2,1,1);plot(t,theta_d);xlabel('Tiempo (s)');ylabel('Velocidad de desplazamiento (rad/s)');...
         title('Variaci�n de la velocidad angular de desplazamiento a lo largo de la trayectoria');xlim([0 120]);grid;...
         subplot(2,1,2);plot(t,omega);xlabel('Tiempo (s)');ylabel('Velocidad de rotaci�n (rad/s)');...
         title('Variaci�n de la velocidad angular de rotaci�n a lo largo de la trayectoria');xlim([0 120]);grid;
     else
         P=[A B C];
        figure;plot(P(1,:),P(2,:),'*r','LineWidth',2);hold on;plot(posx,posy,'b','LineWidth',1);grid;...
            title('Control de seguimieto a trayectoria por interpolaci�n');xlabel('Posici�n cartesiana X');ylabel('Posici�n cartesiana Y');
        figure;subplot(2,1,1);plot(t,theta_d);xlabel('Tiempo (s)');ylabel('Velocidad de desplazamiento (rad/s)');...
         title('Variaci�n de la velocidad angular de desplazamiento a lo largo de la trayectoria');xlim([0 1200]);grid;...
         subplot(2,1,2);plot(t,omega);xlabel('Tiempo (s)');ylabel('Velocidad de rotaci�n (rad/s)');...
         title('Variaci�n de la velocidad angular de rotaci�n a lo largo de la trayectoria');xlim([0 1200]);grid;
     end
     
     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    case 4
    % MOVER POR A UNA POSTURA
    % NO SE MUY BIEN COMO VERIFICAR ESTO LA VERDAD, CREO QUE FUNCIONA
    % PORQUE VA AL PUNTO QUE SE LE PIDE.
    % Posiciones iniciales del integrador
     pos_init=[0;0;0];
    % Tiempo de simulacion
    tsim=100; 
    % Tiempo de muestreo
    Tm=0.01;

    % Añadir saturacion en velocidades angulares y lineales.
    % No se gira un volante a mas de 10-15 deg/sec, por tanto, ahí estará la saturación del movimiento
     omega_sat=[-0.2618 0.2618];%15 grados/segundo
     tetha_d_sat=[-0.75 0.75];%Velocidad lineal de 30 cm/seg  
     
     % Definicion del punto objetivo y su angulo
     px_ref=input('Introduzca la coord X del punto objetivo: ');
     py_ref=input('Introduzca la coord Y del punto objetivo: ');
     ang_ref=input('Introduzca introduzca la orientaci�n deseada punto objetivo: ');
     
     % Se lanza la simulacion
     sim('sl_robot_sincrono_control_postura');
     
     % HE INTENTADO PINTAR UN VECTOR PARA VER SI LLEGA CON ESA DIRECCION
     % PERO NO HA HABIDO SUERTE.
     p0=[px_ref py_ref];
     p1=[px_ref+cos(ang_ref) py_ref+sin(ang_ref)];
     
     % Se grafican resultados
     figure();
     hold on;

u=cos(ang_phi(1));
v=1-u^2;
quiver(posx(1),posy(1),u,v,'*'); %Ploteo del vector de la velocidad Lineal.
u=cos(ang_phi(length(posx)));
v=1-u^2;
quiver(posx(length(posx)),posy(length(posy)),u,v,'*'); %Ploteo del vector de la velocidad Lineal.
plot(posx,posy,'k');title('Control de postura');xlabel('Posici�n cartesiana X');ylabel('Posici�n cartesiana Y');grid;
legend('Orientaci�n inicial','Orientaci�n final','Trayectoria','Location','BestOutside');
hold off;

        figure;subplot(2,1,1);plot(t,theta_d);xlabel('Tiempo (s)');ylabel('Velocidad de desplazamiento (rad/s)');...
         title('Variaci�n de la velocidad angular de desplazamiento a lo largo de la trayectoria');axis([0 60 0 0.8]);grid;...
         subplot(2,1,2);plot(t,omega);xlabel('Tiempo (s)');ylabel('Velocidad de rotaci�n (rad/s)');...
         title('Variaci�n de la velocidad angular de rotaci�n a lo largo de la trayectoria');axis([0 60 -0.05 0.3]);grid;
 
 
     
end