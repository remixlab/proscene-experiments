public class CustomMatrixHelper extends MatrixHelper {
  PGraphicsOpenGL  pg;

  public CustomMatrixHelper(TargetScene scn, PGraphicsOpenGL renderer) {
    super(scn);
    pg = renderer;
  }

  public PGraphicsOpenGL pggl() {
    return pg;
  }

  @Override
  public void pushProjection() {
    pggl().pushProjection();
  }

  @Override
  public void popProjection() {
    pggl().popProjection();
  }

  @Override
  public void resetProjection() {
    pggl().resetProjection();
  }

  @Override
  public void printProjection() {
    pggl().printProjection();
  }

  @Override
  public Mat projection() {
    return toMat(pggl().projection.get());
  }

  @Override
  public Mat getProjection(Mat target) {
    if (target == null)
      target = toMat(pggl().projection.get()).get();
    else
      target.set(toMat(pggl().projection.get()));
    return target;
  }

  @Override
  public void applyProjection(Mat source) {
    pggl().applyProjection(toPMatrix(source));
  }

  @Override
  public void pushModelView() {
    pggl().pushMatrix();
  }

  @Override
  public void popModelView() {
    pggl().popMatrix();
  }

  @Override
  public void resetModelView() {
    pggl().resetMatrix();
  }

  @Override
  public Mat modelView() {
    return toMat((PMatrix3D) pggl().getMatrix());
  }

  @Override
  public Mat getModelView(Mat target) {
    if (target == null)
      target = toMat((PMatrix3D) pggl().getMatrix()).get();
    else
      target.set(toMat((PMatrix3D) pggl().getMatrix()));
    return target;
  }

  @Override
  public void printModelView() {
    pggl().printMatrix();
  }

  @Override
  public void applyModelView(Mat source) {
    pggl().applyMatrix(toPMatrix(source));
  }

  @Override
  public void translate(float tx, float ty) {
    pggl().translate(tx, ty);
  }

  @Override
  public void translate(float tx, float ty, float tz) {
    pggl().translate(tx, ty, tz);
  }

  @Override
  public void rotate(float angle) {
    pggl().rotate(angle);
  }

  @Override
  public void rotateX(float angle) {
    pggl().rotateX(angle);
  }

  @Override
  public void rotateY(float angle) {
    pggl().rotateY(angle);
  }

  @Override
  public void rotateZ(float angle) {
    pggl().rotateZ(angle);
  }

  @Override
  public void rotate(float angle, float vx, float vy, float vz) {
    pggl().rotate(angle, vx, vy, vz);
  }

  @Override
  public void scale(float s) {
    pggl().scale(s);
  }

  @Override
  public void scale(float sx, float sy) {
    pggl().scale(sx, sy);
  }

  @Override
  public void scale(float x, float y, float z) {
    pggl().scale(x, y, z);
  }

  @Override
  public void setProjection(Mat source) {
    pggl().setProjection(toPMatrix(source));
  }

  @Override
  public void setModelView(Mat source) {
    if (gScene.is3D())
      pggl().setMatrix(toPMatrix(source));// in P5 this caches projmodelview
    else {
      pggl().modelview.set(toPMatrix(source));
      pggl().projmodelview.set(Mat.multiply(gScene.eye().getProjection(false), gScene.eye().getView(false))
        .getTransposed(new float[16]));
    }
  }

  // estos helpers deberian ir en el TargetScene, pero Processing no lo deja hacer

  public PVector toPVector(Vec v) {
    return new PVector(v.x(), v.y(), v.z());
  }

  public Vec toVec(PVector v) {
    return new Vec(v.x, v.y, v.z);
  }

  public PMatrix3D toPMatrix(Mat m) {
    float[] a = m.getTransposed(new float[16]);
    return new PMatrix3D(a[0], a[1], a[2], a[3], 
      a[4], a[5], a[6], a[7], 
      a[8], a[9], a[10], a[11], 
      a[12], a[13], a[14], a[15]);
  }

  public Mat toMat(PMatrix3D m) {
    return new Mat(m.get(new float[16]), true);
  }

  public Mat toMat(PMatrix2D m) {
    return toMat(new PMatrix3D(m));
  }

  public PMatrix2D toPMatrix2D(Mat m) {
    float[] a = m.getTransposed(new float[16]);
    return new PMatrix2D(a[0], a[1], a[3], 
      a[4], a[5], a[7]);
  }
}