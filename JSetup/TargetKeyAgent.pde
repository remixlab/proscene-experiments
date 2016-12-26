public class TargetKeyAgent extends Agent {
  protected boolean        press, release, type;
  protected KeyboardEvent  currentEvent;

  public TargetKeyAgent(TargetScene scene) {
    super(scene.inputHandler());
    addGrabber(scene);
  }
  
  public void keyEvent(processing.event.KeyEvent e) {
    press = e.getAction() == processing.event.KeyEvent.PRESS;
    release = e.getAction() == processing.event.KeyEvent.RELEASE;
    type = e.getAction() == processing.event.KeyEvent.TYPE;
    if (type)
      currentEvent = new KeyboardEvent(e.getKey());
    else if (press || release)
      currentEvent = new KeyboardEvent(e.getModifiers(), e.getKeyCode());
    if (type || press)
      updateTrackedGrabber(currentEvent);
    handle(release ? currentEvent.flush() : currentEvent.fire());
  }
}