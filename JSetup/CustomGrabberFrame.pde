public class CustomGrabberFrame extends GenericFrame {
    public CustomGrabberFrame(AbstractScene _scene) {
      super(_scene);
    }

    public CustomGrabberFrame(Eye _eye) {
      super(_eye);
    }
    
    protected CustomGrabberFrame(CustomGrabberFrame otherFrame) {
      super(otherFrame);
    }

    @Override
    public CustomGrabberFrame get() {
      return new CustomGrabberFrame(this);
    }
    
    @Override
    public void performInteraction(MotionEvent event) {
      switch( event.shortcut().id() ) {
      //it's also possible to use Processing constants such as:
      case LEFT:
        rotate(event);
        break;
      case CENTER:
        screenRotate(event);
        break;
      case RIGHT:
        translate(event);
        break;
      case MouseEvent.WHEEL:
        if(scene().is3D() && isEyeFrame())
          translateZ(event);
        else
          scale(event);            
        break;
      }
    }

    @Override
    public void performInteraction(ClickEvent event) {
      if (event.clickCount() == 2) {
        if (event.id() == LEFT_ID)
          center();
        if (event.id() == RIGHT_ID)
          align();
      }
    }
    
    @Override
    public void performInteraction(KeyboardEvent event) {
      if( event.isShiftDown() ) {
        //also possible here is to use Processing keys: UP
        if(event.id()  == UP_KEY)
          translateY(true);
        if(event.id()  == DOWN_KEY)
          translateY(false);
        if(event.id()  == LEFT_KEY)
          translateX(false);
        if(event.id()  == RIGHT_KEY)
          translateX(true);
      }
      else {
        if(event.id()  == UP_KEY)
          if(gScene.is3D())
            rotateX(true);
        if(event.id()  == DOWN_KEY)
          if(gScene.is3D())
            rotateY(false);
        if(event.id()  == LEFT_KEY)
          rotateZ(false);
        if(event.id()  == RIGHT_KEY)
          rotateZ(true);
      }
    }
  }