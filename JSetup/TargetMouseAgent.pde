public class TargetMouseAgent extends Agent {
  public static final int LEFT_ID  = PApplet.LEFT, CENTER_ID = PApplet.CENTER, RIGHT_ID = PApplet.RIGHT, WHEEL_ID = MouseEvent.WHEEL, NO_BUTTON = BogusEvent.NO_ID;
  
  protected boolean click2Pick;  
  protected DOF2Event  currentEvent, prevEvent;
  protected boolean    move, press, drag, release;
  
  public TargetMouseAgent(TargetScene scn) {
    super(scn.inputHandler());
  }
  
  public void mouseEvent(processing.event.MouseEvent e) {
    move = e.getAction() == processing.event.MouseEvent.MOVE;
    press = e.getAction() == processing.event.MouseEvent.PRESS;
    drag = e.getAction() == processing.event.MouseEvent.DRAG;
    release = e.getAction() == processing.event.MouseEvent.RELEASE;
    //better and more robust is to work without modifiers, which Processing don't report reliably
    if (move || press || drag || release) {
      currentEvent = new DOF2Event(prevEvent, e.getX() - scene.originCorner().x(), e.getY() - scene.originCorner().y(),
          /*e.getModifiers()*/BogusEvent.NO_MODIFIER_MASK, move ? BogusEvent.NO_ID : e.getButton());      
      if (move && !click2Pick)
        updateTrackedGrabber(currentEvent);
      handle(release ? currentEvent.flush() : currentEvent);      
      prevEvent = currentEvent.get();
      return;
    }
    if (e.getAction() == processing.event.MouseEvent.WHEEL) {// e.getAction() = MouseEvent.WHEEL = 8
      handle(new DOF1Event(e.getCount(), /*e.getModifiers()*/BogusEvent.NO_MODIFIER_MASK, WHEEL_ID));
      return;
    }
    if (e.getAction() == processing.event.MouseEvent.CLICK) {
      ClickEvent bogusClickEvent = new ClickEvent(e.getX() - scene.originCorner().x(), e.getY() - scene.originCorner().y(),
          /*e.getModifiers()*/BogusEvent.NO_MODIFIER_MASK, e.getButton(), e.getCount());
      if (click2Pick)
        updateTrackedGrabber(bogusClickEvent);
      handle(bogusClickEvent);
      return;
    }
  }
}