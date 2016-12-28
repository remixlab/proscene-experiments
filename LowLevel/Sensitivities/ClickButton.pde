public class ClickButton extends Button2D {
  boolean increase;
  Sensitivity sensitivity;

  public ClickButton(PVector p, PFont font, String t, Sensitivity sens, boolean inc) {
    super(p, font, t);
    increase = inc;
    sensitivity = sens;
    iFrame.setClickBinding(this, LEFT, 1, "action");
  }

  public void action(InteractiveFrame frame) {
    if (increase)
      increaseSensitivity(sensitivity);
    else
      decreaseSensitivity(sensitivity);
  }
}
