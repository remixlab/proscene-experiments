/**
 * Animation 2D.
 * by Jean Pierre Charalambos.
 * 
 * Documentation found on the online tutorial: https://github.com/nakednous/fpstiming/wiki/1.1.-Animation2D
 *
 * Press 'x' to speed up the camera animation.
 * Press 'y' to speed down the camera animation.
 * Press 'z' (the space bar) to toggle the camera animation.
 * Press '+' to speed up the particles animation.
 * Press '-' to speed down the particles animation.
 * Press ' ' (the space bar) to toggle the particles animation.
 */

import remixlab.fpstiming.*;

ParticleSystem system;
public TimingHandler handler;

public void setup() {
  size(640, 360, P3D);
  handler = new TimingHandler();
  system = new ParticleSystem(handler);
  smooth();
}

public void draw() {
  background(0);
  pushStyle();
  strokeWeight(3); // Default
  beginShape(POINTS);
  for (int i = 0; i < system.particle.length; i++) {
    system.particle[i].draw();
  }
  endShape();
  popStyle();
  handler.handle();
}

public void keyPressed() {
  if ((key == 'x') || (key == 'X'))
    system.setAnimationPeriod(system.animationPeriod()-2);
  if ((key == 'y') || (key == 'Y'))
    system.setAnimationPeriod(system.animationPeriod()+2);
  if ((key == 'z') || (key == 'Z'))
    system.toggleAnimation();
  if (key == '+')
    system.setParticlesAnimationPeriod(system.particlesAnimationPeriod()-2);
  if (key == '-')
    system.setParticlesAnimationPeriod(system.particlesAnimationPeriod()+2);
  if (key == ' ')
    system.toggleParticlesAnimation();
}