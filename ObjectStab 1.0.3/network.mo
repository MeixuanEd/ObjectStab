package Network "Network subpackage" 
  extends Modelica.Icons.Library;
  
  package Partials 
    "Contains uninstatiable classes related to network components" 
    extends Modelica.Icons.Library;
    
    partial model PilinkBase "Pilink" 
      extends Base.TwoPin;
      parameter Base.Resistance R=0.0 "Series Resistance";
      parameter Base.Reactance X=0.1 "Series Reactance";
      parameter Base.Susceptance B=0.1 "Shunt Susceptance";
      parameter Base.Conductance G=0.0 "Shunt Conductance";
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), 
        Window(
          x=0.45, 
          y=0.01, 
          width=0.54, 
          height=0.89), 
        Icon(
          Line(points=[100, 0; 60, 0], style(color=0)), 
          Text(extent=[100, 20; -100, 60], string="%name"), 
          Rectangle(extent=[-60, 20; 60, -20], style(color=0)), 
          Line(points=[-60, 0; -100, 0], style(color=0))));
    end PilinkBase;
    
    partial model ImpTransformer 
      extends ObjectStab.Base.TwoPin;
      parameter Base.Resistance R=0.0 "Leakage Resistance";
      parameter Base.Reactance X=0.1 "Leakage Reactance";
      annotation (
        Icon(
          Ellipse(extent=[-70, 40; 12, -40], style(color=0)), 
          Ellipse(extent=[-12, 40; 70, -40], style(color=0)), 
          Line(points=[70, 0; 100, 0], style(color=0)), 
          Line(points=[-100, 0; -70, 0], style(color=0)), 
          Text(extent=[-98, -40; 100, -80], string="%name")), 
        Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), 
        Window(
          x=0.4, 
          y=0.4, 
          width=0.6, 
          height=0.6));
      ObjectStab.Network.IdealTransformer Tr annotation (extent=[20, -20; 60, 
            20]);
      ObjectStab.Network.Impedance Imp(R=R, X=X) annotation (extent=[-60, -20; 
            -20, 20]);
    equation 
      connect(Imp.T1, T1) annotation (points=[-60, 0; -100, 0]);
      connect(Imp.T2, Tr.T1) annotation (points=[-20, 0; 20, 0]);
      connect(Tr.T2, T2) annotation (points=[60, 0; 100, 0]);
    end ImpTransformer;
    annotation (Coordsys(
        extent=[0, 0; 606, 415], 
        grid=[1, 1], 
        component=[20, 20]), Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6, 
        library=1, 
        autolayout=1));
    model Place32 "Place with two input and two output transitions" 
      parameter Boolean initialState=false "Initial value of state";
      Boolean state(final start=initialState) "State of place";
    protected 
      Boolean newState(final start=initialState);
    public 
      ModelicaAdditions.PetriNets.Interfaces.FirePortOut outTransition1 
        annotation (extent=[100, -70; 120, -50]);
      ModelicaAdditions.PetriNets.Interfaces.FirePortOut outTransition2 
        annotation (extent=[100, 70; 120, 50]);
      ModelicaAdditions.PetriNets.Interfaces.SetPortIn inTransition1 
        annotation (extent=[-140, -80; -100, -40]);
      ModelicaAdditions.PetriNets.Interfaces.SetPortIn inTransition2 
        annotation (extent=[-140, 80; -100, 40]);
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), 
        Window(
          x=0.21, 
          y=0.03, 
          width=0.6, 
          height=0.86), 
        Icon(
          Ellipse(extent=[-100, -100; 100, 100], style(color=41, fillColor=7))
            , 
          Line(points=[-100, 60; -80, 60], style(color=41)), 
          Line(points=[-100, -60; -80, -60], style(color=41)), 
          Line(points=[80, -60; 100, -60], style(color=41)), 
          Line(points=[82, 60; 102, 60], style(color=41)), 
          Text(extent=[0, 99; 0, 159], string="%name")), 
        Diagram(
          Ellipse(extent=[-100, -100; 100, 100], style(color=41)), 
          Line(points=[-100, 60; -80, 60], style(color=41)), 
          Line(points=[-100, -60; -80, -60], style(color=41)), 
          Line(points=[80, 60; 100, 60], style(color=41)), 
          Line(points=[80, -60; 100, -60], style(color=41))));
    public 
      ModelicaAdditions.PetriNets.Interfaces.SetPortIn inTransition3 
        annotation (extent=[100, 20; 140, -20], rotation=180);
    equation 
      // Set new state for next iteration
      state = pre(newState);
      newState = inTransition1.set or inTransition2.set or inTransition3.set
         or state and not (outTransition1.fire or outTransition2.fire);
      
      // Report state to input and output transitions
      inTransition1.state = state;
      inTransition2.state = inTransition1.state or inTransition1.set;
      inTransition3.state = inTransition1.state or inTransition1.set;
      outTransition1.state = state;
      outTransition2.state = outTransition1.state and not outTransition1.fire;
    end Place32;
    
    class BreakerBase 
      extends ObjectStab.Base.TwoPin;
      
      Boolean closed;
      
      parameter Real small=1e-6;
      
      //  Real s1;
      //  Real s2;
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), 
        Icon(
          Line(points=[44, 0; 100, 0], style(color=0)), 
          Line(points=[-40, 0; 32, 34], style(color=0)), 
          Ellipse(extent=[-44, 4; -36, -4], style(
              color=0, 
              fillColor=0, 
              fillPattern=1)), 
          Ellipse(extent=[36, 4; 44, -4], style(
              color=0, 
              fillColor=7, 
              fillPattern=1)), 
          Line(points=[-100, 0; -44, 0], style(color=0)), 
          Text(extent=[80, -60; -80, -20], string="%name")), 
        Window(
          x=0.04, 
          y=0.36, 
          width=0.87, 
          height=0.6));
    equation 
      
      
        //  [T1.va - T2.va; T1.vb - T2.vb] = (if closed then small*[1, -1; 1, 1] else [1
      //    , 0; 0, 1])*[s1; s2];
      
      
        //  [T1.ia; T1.ib] = (if closed then [1, 0; 0, 1] else small*[1, -1; 1, 1])*[s1
      //    ; s2];
      
      if closed then
        [T1.va - T2.va; T1.vb - T2.vb] = small*[1, -1; 1, 1]*[T1.ia; T1.ib];
      else
        [T1.ia; T1.ib] = small*[1, -1; 1, 1]*[T1.va - T2.va; T1.vb - T2.vb];
      end if;
      [T1.ia; T1.ib] = -[T2.ia; T2.ib];
    end BreakerBase;
  end Partials;
  
  package Controllers 
    "Contains controller classes related to network components" 
    extends Modelica.Icons.Library;
    
    partial model TCULController "Common definitions for TCUL control systems" 
      
      extends Modelica.Blocks.Interfaces.SI2SO(y(start=1));
      parameter Integer method=3 "Method number";
      parameter Base.TapRatio n=1 "Transformer Ratio";
      
      parameter ObjectStab.Base.TapRatio stepsize=0.01 "Step Size";
      parameter ObjectStab.Base.TapStep mintap=-12 "Minimum tap step";
      parameter ObjectStab.Base.TapStep maxtap=12 "Maximum tap step";
      
      parameter ObjectStab.Base.Duration Tm0=10 "Mechanical Time Delay";
      parameter ObjectStab.Base.Duration Td0=20 "Controller Time Delay 1";
      parameter ObjectStab.Base.Duration Td1=20 "Controller Time Delay 2";
      parameter ObjectStab.Base.Voltage DB=0.03 
        "TCUL Voltage Deadband (double-sided)";
      parameter ObjectStab.Base.Voltage Vref=1 "TCUL Voltage Reference";
      parameter ObjectStab.Base.Voltage Vblock=0.82 "Tap locking voltage";
      parameter Boolean InitByVoltage=false "Initialize to V=Vref?";
      Real tappos(start=(n - 1)/stepsize) "Current tap step [number]";
      ObjectStab.Base.Voltage udev;
      Boolean blocked=u2 < Vblock "Tap locked ?";
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), 
        Window(
          x=0.4, 
          y=0.4, 
          width=0.6, 
          height=0.6), 
        Documentation(info="Common definitions for TCUL control systems according to [1]. 
Using the parameter the characteristics of the mechanical delay time (Tm) 
and the controlled delay time (Td) the TCUL can be influenced according
to the table below:

----------------------------------
|method|    Td     |    Tm       |
----------------------------------
|  1   |  constant |  constant   |
|  2   |  inverse  |  constant   |
|  3   |  inverse  |  inverse    |
|  4   |  both     |  constant   |
----------------------------------

Use the subclasses TCULContinuous for continuous approximation (more computationally)
efficient or the the subclass TCULDiscrete for the true discrete realization.

The tap changer is locked if the primary side voltage decreases below the 
tap locking voltage specified in Vblock.

---
[1] P.W. Sauer and M.A. Pai, \"A comparison of discrete vs. continuous
dynamic models of tap-changing-under-load transformers\", in Proceedings
of NSF/ECC Workshop on Bulk power System Voltage Phenomena - III :
Voltage Stability, Security and Control,  Davos, Switzerland, 1994.
"));
    equation 
      tappos = (y - 1)/stepsize;
      udev = u1 - Vref;
    end TCULController;
    
    model TCULContinuous "Continuous approximation of TCUL control system" 
      extends TCULController;
      ObjectStab.Base.Time Tc;
      Modelica.Blocks.Continuous.LimIntegrator integrator(
        k={1}, 
        outMax={1 + maxtap*stepsize}, 
        outMin={1 + mintap*stepsize}, 
        y(start={n})) annotation (extent=[-20, -20; 20, 20]);
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), 
        Window(
          x=0.4, 
          y=0.4, 
          width=0.6, 
          height=0.6), 
        Icon(Text(extent=[-88, 36; 82, -36], string="Continuous")), 
        Documentation(info="Continuous implementation of Tap-Changing Under Load (TCUL) control 
system  according to method C1-C4 in [1] using a state-machine implementation 
of the control system and tap changer mechanism.


---
[1] P.W. Sauer and M.A. Pai, \"A comparison of discrete vs. continuous
dynamic models of tap-changing-under-load transformers\", in Proceedings
of NSF/ECC Workshop on Bulk power System Voltage Phenomena - III :
Voltage Stability, Security and Control,  Davos, Switzerland, 1994.
"), 
        Diagram(
          Text(extent=[-74, 10; -42, -14], string="input"), 
          Text(extent=[-80, -10; -28, -28], string="determined"), 
          Text(extent=[-74, -22; -30, -36], string="by equation"), 
          Text(extent=[-72, -36; -46, -56], string="layer")));
    equation 
      connect(integrator.outPort, outPort) annotation (points=[20, 0; 110, 0]);
      if (method == 2) then
        Tc = (Td0*DB/2 + Tm0*noEvent(abs(udev)))/stepsize;
      elseif (method == 3) then
        Tc = (Tm0 + Td0)*DB/2/stepsize;
      else
        Tc = (Td0*DB/2 + (Tm0 + Td1)*noEvent(abs(udev)))/stepsize;
      end if;
      if not blocked then
        integrator.u = {-udev/Tc};
      else
        integrator.u = {0};
      end if;
    initial equation 
      if InitByVoltage then
        der(integrator.y) = {0};
      else
        integrator.y = {n};
      end if;
    end TCULContinuous;
    
    model TCULDiscrete "Discrete implementation of TCUL control system" 
      extends TCULController;
      
      ObjectStab.Base.Time up_counter(start=-10, fixed=true);
      ObjectStab.Base.Time down_counter(start=-10, fixed=true);
      ObjectStab.Base.Time Td;
      ObjectStab.Base.Time Tm;
      
      ObjectStab.Network.Partials.Place32 wait(initialState=true) annotation (
          extent=[-10, 60; 10, 80], rotation=270);
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100], 
          grid=[2, 2], 
          component=[20, 20]), 
        Window(
          x=0.39, 
          y=0, 
          width=0.63, 
          height=0.95), 
        Icon, 
        Documentation(info="Discrete implementation of Tap-Changing Under Load (TCUL) control system 
according to method D1-D4 in [1] using a state-machine implementation of the 
control system and tap changer mechanism.

Ideally the variable 'tappos' should be initialized to give a voltage deviation
within the deadband at the start of the simulatation. Failure to do so may result in
convergence problems with the initial value solver.

---
[1] P.W. Sauer and M.A. Pai, \"A comparison of discrete vs. continuous
dynamic models of tap-changing-under-load transformers\", in Proceedings
of NSF/ECC Workshop on Bulk power System Voltage Phenomena - III :
Voltage Stability, Security and Control,  Davos, Switzerland, 1994.
"), 
        Diagram);
      ModelicaAdditions.PetriNets.Transition Tr1(condLabel="Verr<-DB/2") 
        annotation (extent=[-60, 20; -40, 40], rotation=270);
      ModelicaAdditions.PetriNets.Transition Tr2(condLabel="Verr>-DB/2") 
        annotation (extent=[-100, 20; -80, 40], rotation=90);
      ModelicaAdditions.PetriNets.Place12 countup annotation (extent=[-60, -20
            ; -40, 0], rotation=270);
      ModelicaAdditions.PetriNets.Transition Tr3(condLabel="Timer>Td") 
        annotation (extent=[-80, -60; -60, -40], rotation=270);
      ModelicaAdditions.PetriNets.Place11 actionup annotation (extent=[-80, -86
            ; -60, -66], rotation=270);
      ModelicaAdditions.PetriNets.Transition Tr4(condLabel="Timer>Td+Tm") 
        annotation (extent=[-40, -60; -20, -40], rotation=90);
      ModelicaAdditions.PetriNets.Transition Tr6(condLabel="Verr>DB/2") 
        annotation (extent=[40, 20; 60, 40], rotation=270);
      ModelicaAdditions.PetriNets.Transition Tr7(condLabel="Verr<DB/2") 
        annotation (extent=[80, 20; 100, 40], rotation=90);
      ModelicaAdditions.PetriNets.Place12 countdown annotation (extent=[40, -20
            ; 60, 0], rotation=270);
      ModelicaAdditions.PetriNets.Transition Tr8(condLabel="Timer>Td") 
        annotation (extent=[20, -60; 40, -40], rotation=90);
      ModelicaAdditions.PetriNets.Transition Tr9(condLabel="Timer>Td") 
        annotation (extent=[60, -60; 80, -40], rotation=270);
      ModelicaAdditions.PetriNets.Place11 actiondown annotation (extent=[60, -
            84; 80, -64], rotation=270);
      ModelicaAdditions.PetriNets.Place21 updatetap annotation (extent=[-10, -
            20; 10, 0], rotation=90);
      ModelicaAdditions.PetriNets.Transition Tr5(condLabel="") annotation (
          extent=[-10, 14; 10, 34], rotation=90);
    equation 
      connect(Tr1.outTransition, countup.inTransition) annotation (points=[-50
            , 25; -50, 2]);
      connect(countup.outTransition1, Tr2.inTransition) annotation (points=[-56
            , -21; -56, -28; -90, -28; -89.95, 23.95]);
      connect(countdown.inTransition, Tr6.outTransition) annotation (points=[50
            , 2; 50, 25]);
      connect(countdown.outTransition2, Tr7.inTransition) annotation (points=[
            56, -21.1; 56, -30; 90, -30; 90.05, 23.95]);
      connect(actionup.inTransition, Tr3.outTransition) annotation (points=[-70
            , -64; -70, -55]);
      connect(actiondown.inTransition, Tr9.outTransition) annotation (points=[
            70, -62; 70, -55]);
      connect(Tr8.inTransition, actiondown.outTransition) annotation (points=[
            30.05, -56.05; 30.05, -96; 70, -96; 70, -85]);
      connect(Tr3.inTransition, countup.outTransition2) annotation (points=[-
            70.05, -43.95; -70, -36; -44, -36; -44, -21.1]);
      connect(actionup.outTransition, Tr4.inTransition) annotation (points=[-70
            , -87; -70, -96; -30, -96; -29.95, -56.05]);
      connect(updatetap.inTransition2, Tr4.outTransition) annotation (points=[-
            6, -22; -6, -36; -30, -36; -30, -45]);
      connect(updatetap.inTransition1, Tr8.outTransition) annotation (points=[6
            , -22; 6, -34; 30, -34; 30, -45]);
      connect(Tr5.inTransition, updatetap.outTransition) annotation (points=[
            0.05, 17.95; 7.21645e-016, 1]);
      connect(Tr2.outTransition, wait.inTransition1) annotation (points=[-90, 
            35; -90, 92; -6, 92; -6, 82]);
      connect(Tr1.inTransition, wait.outTransition1) annotation (points=[-50.05
            , 36.05; -50, 48; -6, 48; -6, 59]);
      connect(wait.outTransition2, Tr6.inTransition) annotation (points=[6, 59
            ; 6, 48; 50, 48; 49.95, 36.05]);
      connect(Tr7.outTransition, wait.inTransition2) annotation (points=[90, 35
            ; 90, 92; 6, 92; 6, 82]);
      connect(Tr5.outTransition, wait.inTransition3) annotation (points=[
            2.77556e-016, 29; -2.22045e-015, 58]);
      connect(Tr9.inTransition, countdown.outTransition1) annotation (points=[
            69.95, -43.95; 70, -36; 44, -36; 44, -21]);
      if (method == 1) then
        Td = Td0;
        Tm = Tm0;
      elseif (method == 2) then
        Td = Td0*DB/2/noEvent(max(abs(udev), 1e-6));
        Tm = Tm0;
      elseif (method == 3) then
        Td = Td0*DB/2/noEvent(max(abs(udev), 1e-6));
        Tm = Tm0*DB/2/noEvent(max(abs(udev), 1e-6));
      else
        Td = Td1 + Td0*DB/2/noEvent(max(abs(udev), 1e-6));
        Tm = Tm0;
      end if;
      
      
        //  Td = if (method == 1) then Td0 else if (method == 2 or method == 3) then Td0*
      //    DB/2/abs(udev + 1e-6) else Td1 + Td0*DB/2/abs(1e-6 + udev);
      //  Tm = if method == 3 then Tm0*DB/2/abs(1e-6 + udev) else Tm0;
      
      Tr1.condition = (udev < -DB/2) and (tappos < maxtap) and not blocked;
      Tr2.condition = not ((udev < -DB/2) and (tappos < maxtap)) or blocked;
      Tr3.condition = time - up_counter > Td;
      Tr4.condition = time - up_counter > Td + Tm;
      Tr5.condition = not (abs(tappos - pre(tappos)) > stepsize/10);
      Tr6.condition = ((udev > DB/2) and (tappos > mintap));
      Tr7.condition = not ((udev > DB/2) and (tappos > mintap));
      Tr8.condition = time - down_counter > Td + Tm;
      Tr9.condition = time - down_counter > Td;
      
      when countup.state then
        up_counter = time;
      end when;
      
      when countdown.state then
        down_counter = time;
      end when;
      
      when updatetap.state then
        if (up_counter > down_counter) then
          tappos = pre(tappos) + 1;
        else
          tappos = pre(tappos) - 1;
        end if;
      end when;
    initial equation 
      if InitByVoltage then
        udev = 0;
      else
        tappos = (n - 1)/stepsize;
      end if;
      wait.state = true;
      countup.state = false;
      countdown.state = false;
      actionup.state = false;
      actiondown.state = false;
      updatetap.state = false;
    end TCULDiscrete;
    annotation (Coordsys(
        extent=[0, 0; 442, 394], 
        grid=[1, 1], 
        component=[20, 20]), Window(
        x=0.45, 
        y=0.01, 
        width=0.39, 
        height=0.58, 
        library=1, 
        autolayout=1));
  end Controllers;
  
  model Ground "Ground Point" 
    extends Base.OnePin;
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.23, 
        y=0.22, 
        width=0.6, 
        height=0.6), 
      Diagram(
        Line(points=[-40, 24; -40, -30]), 
        Line(points=[-20, 10; -20, -10]), 
        Line(points=[0, 4; 0, -2]), 
        Line(points=[-60, 40; -60, -40]), 
        Line(points=[-60, 0; -100, 0])), 
      Icon(
        Line(points=[-40, 24; -40, -30]), 
        Line(points=[-20, 10; -20, -10]), 
        Line(points=[0, 4; 0, -2]), 
        Line(points=[-60, 40; -60, -40]), 
        Line(points=[-60, 0; -100, 0])), 
      Documentation(info="This model can be used to define a ground point, i.e., a point where the voltage is
zero:

V = 0   <=> 1+va = 0, vb = 0

Several (or no) ground points may be used in a power system model.
"));
  equation 
    1 + T.va = 0;
    T.vb = 0;
  end Ground;
  
  model Impedance "Impedance model" 
    extends Base.TwoPin;
    
    parameter Base.Resistance R=0.0 "Resistance";
    parameter Base.Reactance X=0.1 "Reactance";
    
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6), 
      Icon(
        Rectangle(extent=[-60, 20; 60, -20], style(color=0)), 
        Line(points=[-60, 0; -100, 0], style(color=0)), 
        Line(points=[100, 0; 60, 0], style(color=0)), 
        Text(extent=[40, 20; -40, 60], string="%name")), 
      Documentation(info="The impedance model is governed by the equations:

           R+jX
           ----
V1, I1  ---    --- V2, I2
    ->     ----        <-


V1 - V2 = (R+jX) * I1
I1 + I2 = 0:


For numerical reasons, R and X may not both be set to zero.
"), 
      Diagram(
        Rectangle(extent=[-60, 20; 60, -20], style(color=0)), 
        Line(points=[-60, 0; -100, 0], style(color=0)), 
        Line(points=[100, 0; 60, 0], style(color=0)), 
        Text(extent=[40, 20; -40, 60], string="R+jX"), 
        Line(points=[-92, -10; -66, -10], style(arrow=1)), 
        Text(extent=[-60, -40; -100, -20], string="V1, I1"), 
        Text(extent=[100, -40; 60, -20], string="I2,V2"), 
        Line(points=[94, -12; 66, -12], style(arrow=1))));
  equation 
    [T1.va - T2.va; T1.vb - T2.vb] = [R, -X; X, R]*[T1.ia; T1.ib];
    [T1.ia; T1.ib] + [T2.ia; T2.ib] = [0; 0];
  end Impedance;
  
  model Admittance "Admittance Model" 
    extends Base.TwoPin;
    
    parameter Base.Conductance G=0.0 "Conductance";
    parameter Base.Susceptance B=0.1 "Susceptance";
    
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6), 
      Diagram(
        Rectangle(extent=[-60, 20; 60, -20], style(color=0)), 
        Line(points=[-60, 0; -100, 0], style(color=0)), 
        Line(points=[100, 0; 60, 0], style(color=0)), 
        Text(extent=[40, 20; -40, 60], string="G+jB"), 
        Text(extent=[-60, -40; -100, -20], string="V1, I1"), 
        Text(extent=[100, -40; 60, -20], string="I2,V2"), 
        Line(points=[-92, -10; -66, -10], style(arrow=1)), 
        Line(points=[94, -12; 66, -12], style(arrow=1))), 
      Icon(
        Rectangle(extent=[-60, 20; 60, -20], style(color=0)), 
        Line(points=[-60, 0; -100, 0], style(color=0)), 
        Line(points=[100, 0; 60, 0], style(color=0)), 
        Text(extent=[40, 20; -40, 60], string="%name")), 
      Documentation(info="The admittance model is governed by the equations:

           G+jB
           ----
V1, I1  ---    --- V2, I2
    ->     ----        <- 


I1 = (G+jB) * (V1-V2)
I1 + I2 = 0:

"));
  equation 
    [T1.ia; T1.ib] = [G, -B; B, G]*[T1.va - T2.va; T1.vb - T2.vb];
    [T1.ia; T1.ib] + [T2.ia; T2.ib] = [0; 0];
  end Admittance;
  
  class ShuntCapacitor "Shunt Capacitor" 
    extends ObjectStab.Base.OnePin;
    
    parameter ObjectStab.Base.Conductance G=0;
    parameter ObjectStab.Base.Susceptance B=0.5;
    Base.ActivePower Pg "Generated Active Power";
    Base.ReactivePower Qg "Generated Reactive Power";
    annotation (
      Icon(
        Line(points=[-100, 0; -10, 0], style(color=0)), 
        Line(points=[-10, 40; -10, -40], style(color=0)), 
        Line(points=[10, 40; 10, -40], style(color=0)), 
        Text(extent=[-100, -40; 100, -80], string="j%B")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.18, 
        y=0.38, 
        width=0.6, 
        height=0.6), 
      Diagram);
  equation 
    [T.ia; T.ib] = [G, -B; B, G]*[1 + T.va; T.vb];
    Pg = -((1 + T.va)*T.ia + T.vb*T.ib);
    Qg = -(T.vb*T.ia - (1 + T.va)*T.ib);
  end ShuntCapacitor;
  
  class ShuntReactor "Shunt Reactor" 
    extends ObjectStab.Base.OnePin;
    
    parameter ObjectStab.Base.Conductance G=0;
    parameter ObjectStab.Base.Susceptance B=-0.5;
    Base.ActivePower Pg "Generated Active Power";
    Base.ReactivePower Qg "Generated Reactive Power";
    annotation (
      Icon(
        Line(points=[-100, 0; -50, 0], style(color=0)), 
        Text(extent=[32, 46; -48, 86], string="%name"), 
        Line(points=[-50, 0; -40, 20; -20, -20; 0, 20; 18, -20; 30, 0], style(
              color=0)), 
        Text(extent=[-40, -20; 20, -60], string="j%B")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.04, 
        y=0.36, 
        width=0.6, 
        height=0.6), 
      Diagram);
  equation 
    [T.ia; T.ib] = [G, -B; B, G]*[1 + T.va; T.vb];
    Pg = -((1 + T.va)*T.ia + T.vb*T.ib);
    Qg = -(T.vb*T.ia - (1 + T.va)*T.ib);
  end ShuntReactor;
  
  model Pilink "Pilink Line Model" 
    extends Partials.PilinkBase;
    
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0, 
        y=0, 
        width=0.81, 
        height=0.87), 
      Icon);
  equation 
    [T1.ia; T1.ib] = [G, -B; B, G]/2*[1 + T1.va; T1.vb] + [R, X; -X, R]/(R^2 + 
      X^2)*[T1.va - T2.va; T1.vb - T2.vb];
    [T2.ia; T2.ib] = [G, -B; B, G]/2*[1 + T2.va; T2.vb] - [R, X; -X, R]/(R^2 + 
      X^2)*[T1.va - T2.va; T1.vb - T2.vb];
    
  end Pilink;
  
  model Pilink2 "Pilink transmission line model built using Basic Components" 
    extends Partials.PilinkBase;
    
    ObjectStab.Network.Impedance Imp(R=R, X=X) annotation (extent=[-20, -20; 20
          , 20]);
    ObjectStab.Network.Admittance T2Adm(G=G/2, B=B/2) annotation (extent=[40, -
          60; 80, -20], rotation=90);
    ObjectStab.Network.Admittance T1Adm(G=G/2, B=B/2) annotation (extent=[-80, 
          -62; -40, -22], rotation=90);
    ObjectStab.Network.Ground GT1 annotation (extent=[-70, -90; -50, -70], 
        rotation=270);
    ObjectStab.Network.Ground GT2 annotation (extent=[50, -90; 70, -70], 
        rotation=270);
  equation 
    connect(T2Adm.T1, GT2.T) annotation (points=[60, -60; 60, -70]);
    connect(GT1.T, T1Adm.T1) annotation (points=[-60, -70; -60, -62]);
    connect(T2, Imp.T2) annotation (points=[100, 0; 20, 0]);
    connect(T2Adm.T2, T2) annotation (points=[60, -20; 60, 0; 100, 0]);
    connect(T1, Imp.T1) annotation (points=[-100, 0; -20, 0]);
    connect(T1Adm.T2, T1) annotation (points=[-60, -22; -60, 0; -100, 0]);
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.38, 
        y=0.18, 
        width=0.6, 
        height=0.6), 
      Diagram(
        Text(extent=[-16, 28; 16, 14], string="R+jX"), 
        Text(extent=[-52, -34; -20, -48], string="(G+jB)/2"), 
        Text(extent=[12, -34; 44, -48], string="(G+jB)/2")), 
      Documentation(info="Transmission line modelled in pi-equivalent form according to [1,pp. 44-45]
realized using the Impedance and Admittance submodels.

For numerical reasons, the R+jX must not be set equal to zero.

---
[1] J. Machowski, J.W. Bialek, and J.R. Bumby, Power System Dynamics 
and Stability, Number ISBN 0-471-97174. Wiley, 1993.
"));
  end Pilink2;
  
  model OpenedPilink "Pilink model with breakers" 
    extends Partials.PilinkBase;
    
    parameter Base.Time OpenTime=10 "Time of branch opening";
    parameter Base.Duration CloseTime=1e10 "Duration of the branch opening";
    annotation (
      Icon(
        Line(points=[-94, 0; -70, 20], style(color=0)), 
        Line(points=[-94, 0; -70, 0], style(color=7)), 
        Line(points=[68, 0; 92, 0], style(color=7)), 
        Line(points=[68, 0; 92, 20], style(color=0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6), 
      Diagram, 
      Documentation(info="Breakers B1 and B2 opens simultaneously at simulation time OpenTime, and stays 
until time CloseTime, after which they are simultanously closed.

"));
    ObjectStab.Network.Pilink2 L1(
      R=R, 
      X=X, 
      B=B, 
      G=G) annotation (extent=[-20, -20; 20, 20]);
    ObjectStab.Network.Breaker B1(OpenTime=OpenTime, CloseTime=CloseTime) 
      annotation (extent=[-80, -20; -40, 20]);
    ObjectStab.Network.Breaker B2(OpenTime=OpenTime, CloseTime=CloseTime) 
      annotation (extent=[40, -20; 80, 20]);
  equation 
    connect(B1.T1, T1) annotation (points=[-80, 0; -100, 0]);
    connect(B1.T2, L1.T1) annotation (points=[-40, 0; -20, 0]);
    connect(B2.T1, L1.T2) annotation (points=[40, 0; 20, 0]);
    connect(T2, B2.T2) annotation (points=[100, 0; 80, 0]);
  end OpenedPilink;
  
  model Bus "Busbar model" 
    extends Base.OnePinCenter;
    Base.Voltage V=sqrt((1 + T.va)*(1 + T.va) + T.vb*T.vb) "Voltage Amplitude";
    Base.VoltageAngle theta=Modelica.Math.atan2(T.vb, (1 + T.va)) 
      "Voltage Angle";
    Real thetadeg=theta*180/Modelica.Constants.PI;
    
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.32, 
        y=0.08, 
        width=0.6, 
        height=0.6), 
      Diagram, 
      Icon(Rectangle(extent=[-12, 80; 10, -80], style(
            color=0, 
            fillColor=0, 
            fillPattern=1)), Text(extent=[98, -102; -98, -80], string="%name"))
      );
  equation 
    T.ia = 0;
    T.ib = 0;
  end Bus;
  
  model FaultedBus "Busbar model with shunt fault" 
    extends Base.OnePinCenter;
    Base.Voltage V=sqrt((1 + T.va)*(1 + T.va) + T.vb*T.vb) "Voltage Amplitude";
    Base.VoltageAngle theta=Modelica.Math.atan2(T.vb, (1 + T.va)) 
      "Voltage Angle";
    Real thetadeg=theta*180/Modelica.Constants.PI;
    parameter Base.Time FaultTime=10 "Time of fault occurence";
    parameter Base.Duration FaultDuration=1 "Duration of fault";
    parameter Base.Resistance FaultR=0.1 "Fault Resistance";
    parameter Base.Reactance FaultX=0 "Fault Reactance";
    Base.Current iFault "Fault Current";
    
    annotation (
      Icon(
        Rectangle(extent=[-12, 72; 10, -72], style(
            color=0, 
            fillColor=0, 
            fillPattern=1)), 
        Text(extent=[-20, 100; 20, 80], string="%name"), 
        Polygon(points=[24, 76; -30, -8; 38, 12; -4, -54; 70, 38; -10, 2; 24, 
              76], style(
            color=6, 
            gradient=2, 
            fillColor=1, 
            fillPattern=1)), 
        Polygon(points=[4, 64; -50, -20; 20, 2; -24, -66; 50, 26; -30, -10; 4, 
              64], style(
            color=6, 
            fillColor=6, 
            fillPattern=1)), 
        Text(extent=[-20, -80; 20, -100], string="Bus Fault")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6), 
      Documentation(info="The shunt fault is modelled as an impedance connected to ground through
a breaker. The fault is applied at simulation time FaultTime and stays
active for the duration of FaultDuration.

For numerical reasons, the fault impedance must not be exactly equal
to zero.
"), 
      Diagram(Text(extent=[-54, -18; -10, -46], string="FaultR+jFaultX")));
    ObjectStab.Network.Impedance Imp(R=FaultR, X=FaultX) annotation (extent=[-
          80, -50; -40, -10], rotation=90);
    ObjectStab.Network.Ground G annotation (extent=[-80, -100; -40, -60], 
        rotation=270);
    ObjectStab.Network.Breaker B1(OpenTime=FaultTime + FaultDuration, CloseTime
        =FaultTime) annotation (extent=[-60, -20; -20, 20]);
  equation 
    connect(Imp.T1, G.T) annotation (points=[-60, -50; -60, -60]);
    connect(Imp.T2, B1.T1) annotation (points=[-60, -10; -60, 0]);
    connect(B1.T2, T) annotation (points=[-20, 0; 0, 0]);
    iFault = sqrt(G.T.ia^2 + G.T.ib^2);
  end FaultedBus;
  
  model Breaker "Ideal Breaker model" 
    parameter Base.Time OpenTime=1 "Opening time";
    parameter Base.Time CloseTime=1e10 "Closing time";
    extends Partials.BreakerBase(closed(start=OpenTime < CloseTime));
    
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.33, 
        y=0.06, 
        width=0.6, 
        height=0.6), 
      Diagram, 
      Icon, 
      Documentation(info="The ideal breaker model is governed by the following models:
if breaker is closed then
  V1 = V2
  I1 + I2 = 0
else
  I1 = 0
  I2 = 0
"));
  equation 
    if (OpenTime > CloseTime) then
      closed = (time > CloseTime and time < OpenTime);
    else
      closed = (time < OpenTime or time > CloseTime);
    end if;
  end Breaker;
  
  model SeriesFault "Series Fault model" 
    extends Base.TwoPin;
    parameter Base.Time FaultTime=1 "Opening time";
    parameter Base.Duration FaultDuration=1 "Duration of Fault";
    
    ObjectStab.Network.Breaker B1(OpenTime=FaultTime, CloseTime=FaultTime + 
          FaultDuration) annotation (extent=[-20, -20; 20, 20]);
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.27, 
        y=0.1, 
        width=0.6, 
        height=0.6), 
      Icon(
        Polygon(points=[4, 64; -50, -20; 20, 2; -24, -66; 50, 26; -30, -10; 4, 
              64], style(
            color=6, 
            fillColor=6, 
            fillPattern=1)), 
        Polygon(points=[24, 76; -30, -8; 38, 12; -4, -54; 70, 38; -10, 2; 24, 
              76], style(
            color=6, 
            gradient=2, 
            fillColor=1, 
            fillPattern=1)), 
        Line(points=[-98, 0; 100, 0])), 
      Diagram, 
      Documentation(info="The series fault is realized using the ideal breaker model.
The fault becomes active (non-conductive) at time FaultTime
and stays non-conductive for the duration of FaultDuration seconds,
after which the fault is cleared.


"));
  equation 
    connect(T1, B1.T1) annotation (points=[-100, 0; -20, 0]);
    connect(B1.T2, T2) annotation (points=[20, 0; 100, 0]);
  end SeriesFault;
  
  model FaultedPilink "Pilink with shunt fault model" 
    extends Partials.PilinkBase;
    parameter Base.Time FaultTime=1 "Time of fault occurence [s]";
    parameter Base.Duration ClearTime=0.07 "Fault Clearing Time [s]";
    parameter Base.Time RecloseTime=1e60 "Time of Reclosing [s]";
    parameter Real alpha=0.5 "Position of Fault";
    parameter Base.Resistance FaultR=1e-5 "Fault Resistance";
    parameter Base.Reactance FaultX=0 "Fault Reactance";
    
    ObjectStab.Network.Pilink2 L1(
      R=R*alpha, 
      X=X*alpha, 
      B=B*alpha, 
      G=G*alpha) annotation (extent=[-50, -10; -30, 10]);
    ObjectStab.Network.Pilink2 L2(
      R=R*(1 - alpha), 
      X=X*(1 - alpha), 
      B=B*(1 - alpha), 
      G=G*(1 - alpha)) annotation (extent=[40, -10; 60, 10]);
    ObjectStab.Network.Breaker B1(OpenTime=FaultTime + ClearTime, CloseTime=
          RecloseTime) annotation (extent=[-80, -10; -60, 10]);
    ObjectStab.Network.Breaker B2(OpenTime=FaultTime + ClearTime, CloseTime=
          RecloseTime) annotation (extent=[68, -10; 88, 10]);
    ObjectStab.Network.Impedance FaultImp(R=FaultR, X=FaultX) annotation (
        extent=[-10, -72; 10, -52], rotation=90);
    ObjectStab.Network.Breaker B3(OpenTime=FaultTime + ClearTime, CloseTime=
          FaultTime) annotation (extent=[-10, -40; 10, -20], rotation=90);
    ObjectStab.Network.Ground Gr annotation (extent=[-10, -102; 10, -82], 
        rotation=270);
  equation 
    connect(B1.T1, T1) annotation (points=[-80, 0; -100, 0]);
    connect(B1.T2, L1.T1) annotation (points=[-60, 0; -50, 0]);
    connect(Gr.T, FaultImp.T1) annotation (points=[1.77636e-015, -82; -
          5.55112e-016, -72]);
    connect(FaultImp.T2, B3.T1) annotation (points=[5.55112e-016, -52; -
          5.55112e-016, -40]);
    connect(B2.T2, T2) annotation (points=[88, 0; 100, 0]);
    annotation (
      Diagram(Text(extent=[8, -48; 44, -72], string="FaultR+jFaultX"), Text(
            extent=[34, 28; 66, 2], string="(R+jX)*alpha")), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6), 
      Documentation(info="The model of the Pilink with a shunt fault is realized using the Pilink
models and the ideal breaker models.

At time FaultTime, the breaker B3 closes and the ground fault becomes active
for the duration of FaultDuration seconds, after which the line is disconnected
at both ends. The ground fault location is determined by alpha, where alpha=0
corresponds to a fault located at T1 and alpha=1 to a fault location at T2.

For numerical reasons the fault and pilink impedance may not be exactly zero,
and alpha not be equal to 0 or 1.


"), 
      Icon(Polygon(points=[24, 76; -30, -8; 38, 12; -4, -54; 70, 38; -10, 2; 24
              , 76], style(
            color=6, 
            gradient=2, 
            fillColor=1, 
            fillPattern=1)), Polygon(points=[4, 64; -50, -20; 20, 2; -24, -66; 
              50, 26; -30, -10; 4, 64], style(
            color=6, 
            fillColor=6, 
            fillPattern=1))));
    connect(B2.T1, L2.T2) annotation (points=[68, 0; 60, 0]);
    connect(L1.T2, B3.T2) annotation (points=[-30, 0; 0, 0; 5.55112e-016, -20])
      ;
    connect(B3.T2, L2.T1) annotation (points=[5.55112e-016, -20; 0, 0; 40, 0]);
  end FaultedPilink;
  
  model IdealTransformer 
    extends ObjectStab.Base.TwoPin;
    Base.TapRatio n(start=1);
    Modelica.Blocks.Interfaces.InPort inPort(final n=1) annotation (extent=[-10
          , -90; 10, -70], rotation=90);
    annotation (
      Diagram, 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.01, 
        y=0.1, 
        width=0.6, 
        height=0.6), 
      Icon(
        Ellipse(extent=[-70, 40; 12, -40], style(color=0)), 
        Ellipse(extent=[-12, 40; 70, -40], style(color=0)), 
        Line(points=[70, 0; 100, 0], style(color=0)), 
        Line(points=[-100, 0; -70, 0], style(color=0)), 
        Text(extent=[-60, 80; 60, 40], string="%name"), 
        Text(extent=[-10, -78; -50, -38], string="1"), 
        Text(extent=[20, -76; -20, -36], string=":"), 
        Text(extent=[50, -76; 10, -36], string="n")));
  equation 
    
    (1 + T1.va)*n = 1 + T2.va;
    T1.vb*n = T2.vb;
    T1.ia = -T2.ia*n;
    T1.ib = -T2.ib*n;
    n = inPort.signal[1];
  end IdealTransformer;
  
  model FixTransformer "Fixed Ratio Transformer" 
    extends Partials.ImpTransformer;
    parameter Base.TapRatio n=1 "Transformer Ratio";
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.4, 
        y=0.4, 
        width=0.6, 
        height=0.6), 
      Icon(
        Text(extent=[0, 40; -40, 80], string="1"), 
        Text(extent=[20, 40; -20, 80], string=":"), 
        Text(extent=[40, 40; 0, 80], string="n")));
  equation 
    Tr.n = n;
  end FixTransformer;
  
  model TCULCon 
    "Tap-Changing Under Load (TCUL) transformer with continuous implementation"
     
    
    extends Partials.ImpTransformer;
    
    parameter Base.TapRatio n=1 "Transformer Ratio";
    ObjectStab.Network.Controllers.TCULContinuous Controller(n=n) annotation (
        extent=[0, -60; 20, -40], rotation=0);
    annotation (
      Icon(
        Ellipse(extent=[-70, 40; 12, -40], style(color=0)), 
        Ellipse(extent=[-12, 40; 70, -40], style(color=0)), 
        Line(points=[70, 0; 100, 0], style(color=0)), 
        Line(points=[-100, 0; -70, 0], style(color=0)), 
        Line(points=[-60, -60; 0, 60], style(color=0)), 
        Polygon(points=[6, 72; -6, 60; 4, 56; 6, 72], style(color=0, fillColor=
                0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.15, 
        y=0.35, 
        width=0.6, 
        height=0.6), 
      Diagram, 
      Documentation(info="Continuous approximation of Tap-Changing Under Load (TCUL) according to
method C1-C4
"));
    ObjectStab.Base.VoltageMeasurement PrimaryVoltage annotation (extent=[-70, 
          -40; -50, -20], rotation=270);
    ObjectStab.Base.VoltageMeasurement SecondaryVoltage annotation (extent=[70
          , -20; 90, 0], rotation=270);
  equation 
    connect(Imp.T1, T1) annotation (points=[-60, 0; -100, 0]);
    connect(Imp.T2, Tr.T1) annotation (points=[-20, 0; 20, 0]);
    connect(Tr.T2, T2) annotation (points=[60, 0; 100, 0]);
    connect(SecondaryVoltage.T, T2) annotation (points=[80, 0; 100, 0]);
    connect(Controller.outPort, Tr.inPort) annotation (points=[21, -50; 40, -50
          ; 40, -16]);
    connect(PrimaryVoltage.T, Imp.T1) annotation (points=[-60, -20; -60, 0]);
    connect(Controller.inPort2, PrimaryVoltage.outPort) annotation (points=[-2
          , -56; -60, -56; -60, -30], style(color=3));
    connect(SecondaryVoltage.outPort, Controller.inPort1) annotation (points=[
          80, -10; 80, -30; -20, -30; -20, -44; -2, -44], style(color=3));
  end TCULCon;
  
  model TCULDis 
    "Tap-Changing Under Load (TCUL) transformer with discrete implementation" 
    
    extends Partials.ImpTransformer;
    
    parameter Base.TapRatio n=1 "Transformer Ratio";
    
    ObjectStab.Network.Controllers.TCULDiscrete Controller(n=n) annotation (
        extent=[0, -60; 20, -40], rotation=0);
    annotation (
      Icon(
        Ellipse(extent=[-70, 40; 12, -40], style(color=0)), 
        Ellipse(extent=[-12, 40; 70, -40], style(color=0)), 
        Line(points=[70, 0; 100, 0], style(color=0)), 
        Line(points=[-100, 0; -70, 0], style(color=0)), 
        Line(points=[-60, -60; 0, 60], style(color=0)), 
        Polygon(points=[6, 72; -6, 60; 4, 56; 6, 72], style(color=0, fillColor=
                0))), 
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Window(
        x=0.07, 
        y=0.34, 
        width=0.6, 
        height=0.6), 
      Diagram, 
      Documentation(info="Discrete implementation of Tap-Changing Under Load (TCUL) transformer according to
method D1-D4 using a state-machine implementation of the control system and
tap changer mechanism. See documentation for 'Controllers.TCULDiscrete' for
documentation on the control system.
Note that the tap position of a discrete tap changer is not properly 
initialized by the initial value solver in Dymola version 4.0c. 
This can by manually by adding e.g., the string: Controller(tappos(start=8))
in the 'Modifiers' field (initializes the tap to position 8).
"));
    ObjectStab.Base.VoltageMeasurement PrimaryVoltage annotation (extent=[-70, 
          -40; -50, -20], rotation=270);
    ObjectStab.Base.VoltageMeasurement SecondaryVoltage annotation (extent=[70
          , -20; 90, 0], rotation=270);
  equation 
    connect(Tr.T2, T2) annotation (points=[60, 0; 100, 0]);
    connect(Imp.T2, Tr.T1) annotation (points=[-20, 0; 20, 0]);
    connect(SecondaryVoltage.T, T2) annotation (points=[80, 0; 100, 0]);
    connect(PrimaryVoltage.T, Imp.T1) annotation (points=[-60, -20; -60, 0]);
    connect(Controller.inPort2, PrimaryVoltage.outPort) annotation (points=[-2
          , -56; -60, -56; -60, -30], style(color=3));
    connect(Controller.outPort, Tr.inPort) annotation (points=[22, -50; 40, -50
          ; 40, -18], style(color=3));
    connect(SecondaryVoltage.outPort, Controller.inPort1) annotation (points=[
          80, -10; 80, -32; -20, -32; -20, -44; -2, -44], style(color=3));
  end TCULDis;
  annotation (
    Coordsys(
      extent=[0, 0; 393, 297], 
      grid=[1, 1], 
      component=[20, 20]), 
    Window(
      x=0.4, 
      y=0.4, 
      width=0.6, 
      height=0.6, 
      library=1, 
      autolayout=1), 
    Documentation(info="The network subpackage contains the various network components.
"));
  model ExtBreaker 
    extends Partials.BreakerBase;
    
    annotation (
      Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), 
      Icon(Line(points=[0, 18; 0, 112; 0, 108], style(color=0, fillColor=0))), 
      Documentation(info="The ideal breaker model is governed by the following models:


if breaker is closed then
  V1 = V2
  I1 + I2 = 0

else
  I1 = 0
  I2 = 0

"), 
      Window(
        x=0.22, 
        y=0.04, 
        width=0.6, 
        height=0.78));
    Modelica.Blocks.Interfaces.BooleanInPort InPort annotation (extent=[-10, 
          100; 10, 120], rotation=270);
  equation 
    closed = InPort.signal[1];
  end ExtBreaker;
  
  model OpenedPilink2 "Pilink model with breakers" 
    extends Partials.PilinkBase;
    parameter Base.Time OpenTime=10 "Time of branch opening";
    parameter Base.Duration CloseTime=1e10 "Duration of the branch opening";
    
    annotation (Coordsys(
        extent=[-100, -100; 100, 100], 
        grid=[2, 2], 
        component=[20, 20]), Window(
        x=0.05, 
        y=0.15, 
        width=0.6, 
        height=0.6));
  equation 
    [T1.ia; T1.ib] = if time < OpenTime then [G, -B; B, G]/2*[1 + T1.va; T1.vb]
       + [R, X; -X, R]/(R^2 + X^2)*[T1.va - T2.va; T1.vb - T2.vb] else [0; 0];
    [T2.ia; T2.ib] = if time < OpenTime then [G, -B; B, G]/2*[1 + T2.va; T2.vb]
       - [R, X; -X, R]/(R^2 + X^2)*[T1.va - T2.va; T1.vb - T2.vb] else [0; 0];
  end OpenedPilink2;
end Network;
