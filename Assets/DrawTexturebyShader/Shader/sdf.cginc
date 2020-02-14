
float sdCircle(float2 p,float r){
  return length(p) - r;
}

float sdBox(float2 p, float2 s){
  float2 d = abs(p) - s;
  return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float sdLine(float2 p, float2 a, float2 b, float w){
  float2 pa = p - a;
  float2 ba = b - a;
  float h = clamp(dot(pa,ba)/dot(ba,ba),0.0,1.0);
  return length(pa - h * ba) - w;
}

float sdTriangleIsoscales(float2 p,float2 q){
  p.x = abs(p.x);
  float2 a = p - q * clamp(dot(p,q)/dot(q,q),0.0,1.0);
  float2 b = p - q * float2( clamp(p.x/q.x,0.0,1.0), 1.0);
  float s = -sign(q.y);
  float2 d = min( float2( dot(a,a), s*(p.x*q.y-p.y*q.x) ),
                float2( dot(b,b), s*(p.y-q.y)));
  return -sqrt(d.x)*sign(d.y);
}