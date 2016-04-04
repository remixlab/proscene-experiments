public class HIDAgent extends Agent {
  // array of sensitivities that will multiply the sliders input
  // found pretty much as trial an error
  float [] sens = {10, 10, 10, 10, 10, 10};
  
  public HIDAgent(InputHandler handler) {
    super(handler);
    // the Profile.registerMotionID expects the degrees-of-freedom of the gesture and returns
    // an unique id that may be use to bind (frame) actions to the gesture, pretty much in
    // the same way as it's done with the LEFT and RIGHT mouse gestures.
    SN_ID = Profile.registerMotionID(this.getClass(), 6);
  }
  
  // we need to override the agent sensitivities method for the agent
  // to apply them to the input data gathered from the sliders
  @Override
  public float[] sensitivities(MotionEvent event) {
    if (event instanceof DOF6Event)
      return sens;
    else
      return super.sensitivities(event);
  }
  
  // polling is done by overriding the feed agent method
  // note that we pass the id of the gesture
  @Override
  public DOF6Event feed() {
    return new DOF6Event(sliderXpos.getValue(), sliderYpos.getValue(), sliderZpos.getValue(), sliderXrot.getValue(), sliderYrot.getValue(), sliderZrot.getValue(), BogusEvent.NO_MODIFIER_MASK, SN_ID);
  }
}
