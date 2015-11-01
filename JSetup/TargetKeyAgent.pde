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
    currentEvent = new KeyboardEvent(e.getKey(), e.getModifiers(), e.getKeyCode());
    if (press) {
      updateTrackedGrabber(currentEvent);
      handle(currentEvent);
    }
  }
}