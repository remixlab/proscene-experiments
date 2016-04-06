/**
 * Timing Ellipses.
 * by Jean Pierre Charalambos.
 * 
 * Documentation found on the online tutorial: https://github.com/nakednous/fpstiming/wiki/1.4.-TimingEllipses
 *
 * Press 'c' to toggle the ellipses' color timer.
 * Press 'p' to toggle the ellipses' positioning timer.
 * Press 'r' to toggle the ellipses' set-radii timer.
 */

import remixlab.fpstiming.*;

Ellipse [] ellipses;
TimingHandler timingHandler;
TimingTask positionTask, radiiTask, colourTask;

void setup() {
  size(600, 600);
  timingHandler = new TimingHandler();
  ellipses = new Ellipse[50];
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i] = new Ellipse();
  positionTask = new TimingTask() {
    @Override
    public void execute() {
      setEllipsesPosition();
    }
  };
  timingHandler.registerTask(positionTask);
  positionTask.run(1000);
  radiiTask = new TimingTask() {
    @Override
    public void execute() {
      setEllipsesRadii();
    }
  };
  timingHandler.registerTask(radiiTask);
  radiiTask.run(100);
  colourTask = new TimingTask() {
    @Override
    public void execute() {
      setEllipsesColor();
    }
  };
  timingHandler.registerTask(colourTask);
  colourTask.run(50);
}

void setEllipsesColor() {
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i].setColor();
}

void setEllipsesPosition() {
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i].setPosition();
}

void setEllipsesRadii() {
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i].setRadii();
}

void draw() {
  background(25, 75, 125);
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i].draw();
  timingHandler.handle();
}

void keyPressed() {
  if (key == 'c')
    if (colourTask.isActive())
      colourTask.stop();
    else
      colourTask.run(50);
  if (key == 'p')
    if (positionTask.isActive())
      positionTask.stop();
    else
      positionTask.run(1000);
  if (key == 'r')
    if (radiiTask.isActive())
      radiiTask.stop();
    else
      radiiTask.run(100);
}
