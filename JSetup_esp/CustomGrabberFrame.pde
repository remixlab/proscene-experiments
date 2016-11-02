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
      //case LEFT:
      case TargetMouseAgent.LEFT_ID:
        rotate(event);
        break;
      case TargetMouseAgent.CENTER_ID:
        screenRotate(event);
        break;
      case TargetMouseAgent.RIGHT_ID:
        translate(event);
        break;
      case TargetMouseAgent.WHEEL_ID:
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
        if (event.id() == TargetMouseAgent.LEFT_ID)
          center();
        if (event.id() == TargetMouseAgent.RIGHT_ID)
          align();
      }
    }
    
    @Override
    public void performInteraction(KeyboardEvent event) {
      if( event.isShiftDown() ) {
        //also possible here is to use Processing keys: UP
        if(event.id()  == TargetKeyAgent.UP_KEY)
          translateY(true);
        if(event.id()  == TargetKeyAgent.DOWN_KEY)
          translateY(false);
        if(event.id()  == TargetKeyAgent.LEFT_KEY)
          translateX(false);
        if(event.id()  == TargetKeyAgent.RIGHT_KEY)
          translateX(true);
      }
      else {
        if(event.id()  == TargetKeyAgent.UP_KEY)
          if(gScene.is3D())
            rotateX(true);
        if(event.id()  == TargetKeyAgent.DOWN_KEY)
          if(gScene.is3D())
            rotateY(false);
        if(event.id()  == TargetKeyAgent.LEFT_KEY)
          rotateZ(false);
        if(event.id()  == TargetKeyAgent.RIGHT_KEY)
          rotateZ(true);
      }
    }
  }