public class CustomScene extends TargetScene {
  public CustomScene(PApplet papplet) {
    super(papplet);
  }
  
  @Override
  protected void performInteraction(KeyboardEvent event) {
    if(event.key() == 's')
      eye().interpolateToFitScene();
    if( event.key() =='a')
      eye().addKeyFrameToPath(1);
    else if( event.key()=='r' )
      eye().deletePath(1);
    else if(event.key()=='1')
      eye().playPath(1);
  }
  
  @Override
  public boolean checkIfGrabsInput(KeyboardEvent event) {
    return event.key() == 's' || event.key() == 'a' || event.key() == 'r' || event.key() == '1';
  }
}