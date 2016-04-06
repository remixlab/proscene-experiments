class ParticleSystem extends AnimatorObject {
  int nbPart;
  Particle2D[] particle;

  public ParticleSystem() {
    nbPart = 2000;
    particle = new Particle2D[nbPart];
    for (int i = 0; i < particle.length; i++)
      particle[i] = new Particle2D();
  }

  // Define here your animation.
  @Override
  public void animate() {
    for (int i = 0; i < nbPart; i++)
      if (particle[i] != null)
        particle[i].animate();
  }
}