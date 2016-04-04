/**
 * Simple Callback.
 * by Jean Pierre Charalambos.
 * 
 * Documentation found on the online tutorial: https://github.com/nakednous/bias/wiki/1.1.-SimpleCallback
 */

import remixlab.bias.core.*;
import remixlab.bias.event.*;

MouseAgent agent;
InputHandler inputHandler;
Ellipse [] ellipses;

void setup() {
  size(800, 800);
  inputHandler = new InputHandler();
  agent = new MouseAgent(inputHandler);
  registerMethod("mouseEvent", agent);
  ellipses = new Ellipse[50];
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i] = new Ellipse(agent);
}

void draw() {
  background(255);
  for (int i = 0; i < ellipses.length; i++) {
    if ( ellipses[i].grabsInput(agent) )
      ellipses[i].draw(color(255, 0, 0));
    else
      ellipses[i].draw();
  }
  inputHandler.handle();
}