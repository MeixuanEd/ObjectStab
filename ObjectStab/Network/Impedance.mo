within ObjectStab.Network;
model Impedance "Impedance model"
  extends ObjectStab.Base.TwoPin;

  parameter ObjectStab.Base.Resistance R=0.0 "Resistance";
  parameter ObjectStab.Base.Reactance X=0.1 "Reactance";

equation
  [T1.va - T2.va; T1.vb - T2.vb] = [R, -X; X, R]*[T1.ia; T1.ib];
  [T1.ia; T1.ib] + [T2.ia; T2.ib] = [0; 0];
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(extent={{-60,20},{60,-20}}, lineColor={0,0,0}),
        Line(points={{-60,0},{-100,0}}, color={0,0,0}),
        Line(points={{100,0},{60,0}}, color={0,0,0}),
        Text(extent={{40,20},{-40,60}}, textString=
                                            "%name")}),
    Documentation(info="The impedance model is governed by the equations:

           R+jX
           ----
V1, I1  ---    --- V2, I2
    ->     ----        <-


V1 - V2 = (R+jX) * I1
I1 + I2 = 0:


For numerical reasons, R and X may not both be set to zero.
"), Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(extent={{-60,20},{60,-20}}, lineColor={0,0,0}),
        Line(points={{-60,0},{-100,0}}, color={0,0,0}),
        Line(points={{100,0},{60,0}}, color={0,0,0}),
        Text(extent={{40,20},{-40,60}}, textString=
                                            "R+jX"),
        Line(
          points={{-92,-10},{-66,-10}},
          color={0,0,255},
          arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-60,-40},{-100,-20}}, textString=
                                                "V1, I1"),
        Text(extent={{100,-40},{60,-20}}, textString=
                                              "I2,V2"),
        Line(
          points={{94,-12},{66,-12}},
          color={0,0,255},
          arrow={Arrow.None,Arrow.Filled})}));
end Impedance;
