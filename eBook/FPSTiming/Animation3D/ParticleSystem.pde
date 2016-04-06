class ParticleSystem extends AnimatorObject {
  int nbPart;
  AnimatedParticle[] particle;
  int rotation;

  public ParticleSystem(TimingHandler handler) {
    super(handler);
    nbPart = 2000;
    particle = new AnimatedParticle[nbPart];
    for (int i = 0; i < particle.length; i++)
      particle[i] = new AnimatedParticle(handler);
    startAnimation();
  }

  @Override
  public void animate() {
    float orbitRadius= mouseX/2+50;
    float ypos= mouseY/3;
    float xpos= cos(radians(rotation))*orbitRadius;
    float zpos= sin(radians(rotation))*orbitRadius;
    camera(xpos, ypos, zpos, 0, 0, 0, 0, -1, 0);
    rotation++;
  }
  
  public void setParticlesAnimationPeriod(long period) {
    for (int i = 0; i < particle.length; i++)
      particle[i].setAnimationPeriod(period);
  }
  
  public long particlesAnimationPeriod() {
    return particle[0].animationPeriod();
  }
  
  public void toggleParticlesAnimation() {
    for (int i = 0; i < particle.length; i++)
      particle[i].toggleAnimation();
  }
}