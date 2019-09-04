int cityNum = 10; //<>//
City[] route = new City[cityNum];
float bestDistance;
City[] bestRoute = new City[cityNum];

void setup() {
  frameRate(99999999);
  size(1000, 600);
  for (int i = 0; i < cityNum; i++) {
    float x = random(width);
    float y = random(height);
    City city = new City(x, y);
    this.route[i] = city;
  }
  this.bestDistance = calcDistance(route);
  this.bestRoute = this.route;
  System.out.println(this.bestDistance);
}

void draw() {
  background(0); //<>//
  fill(255, 0, 255);
  stroke(255, 0, 255);
  for (City city : this.route) {
    ellipse(city.getX(), city.getY(), 10, 10);
  }
  int i = floor(random(route.length));
  int j = floor(random(route.length));
  swap(this.route, i, j);
  float distance = calcDistance(this.route);
  if (distance < this.bestDistance) {
    this.bestDistance = distance;
    this.bestRoute = route.clone();
    System.out.println(this.bestDistance);
  }
  drawBestRoute(bestRoute);
  drawRoute(route);
}

void drawBestRoute(City[] bestRoute) {
  stroke(255, 0, 255);
  strokeWeight(4);
  noFill();
  beginShape();
  for (City city : bestRoute) {
    vertex(city.getX(), city.getY());
  }
  vertex(bestRoute[0].getX(), bestRoute[0].getY());
  endShape();
}

void drawRoute(City[] route) {
  stroke(255);
  strokeWeight(1);
  noFill();
  beginShape();
  for (City city : route) {
    vertex(city.getX(), city.getY());
  }
  vertex(route[0].getX(), route[0].getY());
  endShape();
}

void swap(City[] route, int i, int j) {
  City temp =route[i];
  route[i] = route[j];
  route[j] = temp;
}

float calcDistance(City[] route) {
  float distance = dist(route[0].getX(), route[0].getY(), route[route.length-1].getX(), route[route.length-1].getY());;
  for (int i = 1; i < route.length; i++) {
    distance += dist(route[i-1].getX(), route[i-1].getY(), route[i].getX(), route[i].getY());
  }
  return distance;
}
