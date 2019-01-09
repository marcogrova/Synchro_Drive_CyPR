%% CONTROL ROBOCHITO
sel=input('Que tipo de control desea probar:\n1.Control a un punto\n2.Control una linea\n3.Control por una trayectoria definida\n4.Control a una postura\n');

switch (sel)
    case 1
    % MOVER A UN PUNTO
    % Posiciones iniciales del integrador
     pos_init=[0;0;0];
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
%     x_ref=-3;
%     y_ref=5;

    % Se lanza la simulacion
    sim('sl_robot_sincrono_control_pto');

    % Se grafican resultados
    plot(posx,posy,x_ref,y_ref,'*','LineWidth',2);grid;
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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
     c=input('Parametro C: ');
     %a=-1; b=1; c=-1; % -> y=x+1
     
     % Se lanza la simulacion
     sim('sl_robot_sincrono_control_linea');

     % Se define la recta para comparar
     y_recta=-(1/b)*(c+a*t);
     % Se grafican resultados
     figure();plot(t,y_recta,'r','LineWidth',3);hold on;plot(posx,posy,'b','LineWidth',1);grid;...
         legend('Trayectoria referencia','Trayectoria robot','Location','BestOutside');
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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
    
    if (sel==0)
     % Posiciones iniciales del integrador   
     pos_init=[0;0;0.0997];
    else
     % Posiciones iniciales del integrador   
     pos_init=[0;0;0.5608];
     
     % Recogida de los puntos por los que se desea que pase el robot
     A_x=input('Introduzca la coord X del punto A: ');
     A_y=input('Introduzca la coord Y del punto A: ');
     A=[A_x;A_y];
     B_x=input('Introduzca la coord X del punto B: ');
     B_y=input('Introduzca la coord Y del punto B: ');
     B=[B_x;B_y];
     C_x=input('Introduzca la coord X del punto C: ');
     C_y=input('Introduzca la coord Y del punto C: ');
     C=[C_x;C_y];
    end
    % Tiempo de simulacion
    tsim=1000; 
    % Tiempo de muestreo
    Tm=0.1;

    % Añadir saturacion en velocidades angulares y lineales.
    % No se gira un volante a mas de 10-15 deg/sec, por tanto, ahí estará la saturación del movimiento
     omega_sat=[-0.2618 0.2618];%15 grados/segundo
     tetha_d_sat=[-0.75 0.75];%Velocidad lineal de 30 cm/seg        
     
     % Distancia a la que se quiere seguir la trayectoria
     d=0;
     
     % Definicion de los ptos a seguir
     O=[0;0];
     P=[O A B C];
     
     % Se lanza la simulacion
     sim('sl_robot_sincrono_control_trayect');
     
     % Se grafican resultados
     figure();plot(P(1,:),P(2,:),'*r','LineWidth',2);hold on;plot(posx,posy,'b','LineWidth',1);grid;
     
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
     px_ref=2; py_ref=14;
     ang_ref=pi/2;
     
     % Se lanza la simulacion
     sim('sl_robot_sincrono_control_postura');
     
     % HE INTENTADO PINTAR UN VECTOR PARA VER SI LLEGA CON ESA DIRECCION
     % PERO NO HA HABIDO SUERTE.
     p0=[px_ref py_ref];
     p1=[px_ref+cos(ang_ref) py_ref+sin(ang_ref)];
     
     % Se grafican resultados
     figure();
     
    
     muestra_Orientacion=100;
     hold on;
     j=muestra_Orientacion;
     for i=1:length(posx)
         if(j==muestra_Orientacion)
             u=cos(ang_phi(i));
             v=1-u^2;
             quiver(posx(i),posy(i),u,v,'*'); %Ploteo del vector de la velocidad Lineal.
             j=0;
             
         else j=j+1;
         end
         
     end
     plot(posx,posy,'k');grid;
hold off;
 
     
end