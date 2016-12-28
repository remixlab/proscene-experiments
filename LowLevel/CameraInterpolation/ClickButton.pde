public class ClickButton extends Button2D {
  int path;

  public ClickButton(PVector p, PFont f, String t, int index) {
    super(p, f, t);
    path = index;
    iFrame.setClickBinding(this, LEFT, 1, "action");
  }

  public void action(InteractiveFrame frame) {
    scene.eye().playPath(path);
    //same as:
    //frame.scene().eye().playPath(path);
  }

  @Override
  public void display(PGraphics pg) {
    if (scene.eye().keyFrameInterpolator(path) == null)
      return;
    if (iFrame.grabsInput(scene.motionAgent())) {
      if (scene.eye().keyFrameInterpolator(path).numberOfKeyFrames() > 1)
        if (scene.eye().keyFrameInterpolator(path).interpolationStarted())
          setText("stop path " + String.valueOf(path));
        else
          setText("play path "  + String.valueOf(path));
      else
        setText("restore position " + String.valueOf(path));
    } else {
      if (scene.eye().keyFrameInterpolator(path).numberOfKeyFrames() > 1)
        setText("path " + String.valueOf(path));
      else
        setText("position " + String.valueOf(path));
    }
    super.display(pg);
  }

  @Override
  public void highlight(PGraphics pg) {
    if (scene.eye().keyFrameInterpolator(path) != null)
      super.highlight(pg);
  }
}