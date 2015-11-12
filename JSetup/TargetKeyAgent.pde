public class TargetKeyAgent extends Agent {
  public static final int LEFT_KEY  = PApplet.LEFT, RIGHT_KEY = PApplet.RIGHT, UP_KEY = PApplet.UP, DOWN_KEY = PApplet.DOWN;

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
    handle(release ? currentEvent.flush() : currentEvent);
  }
}