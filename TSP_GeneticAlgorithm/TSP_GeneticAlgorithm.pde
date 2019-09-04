static int cityNum = 52;
City[] cities = new City[cityNum];
Population population;
BufferedReader reader;
String[] line;
int rateCount = 9;
int trialCount = 9;

void setup() {
  size(1800, 1200);
  frameRate(1000);
  reader = createReader("Berlin52.txt");
  try {
    for (int i = 0; i < cityNum; i++) {
      line = reader.readLine().split(",");
      float x = Float.valueOf(line[0]);
      float y = Float.valueOf(line[1]);
      City city = new City(x, y);
      this.cities[i] = city;
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
  population = new Population(cities, 999, 0.9, (float)rateCount/10);
  population.calcFitness();
}

void draw() {
  background(0);
  fill(255,150,0);
  for (City city : this.cities) {
    ellipse(city.getX(), city.getY(), 10, 10);
  }
  stroke(255,150,0);
  strokeWeight(3);
  noFill();
  beginShape();
  City[] bestRoute = population.getBestRoute();
  for (City city : bestRoute) {
    vertex(city.getX(), city.getY());
  }
  vertex(bestRoute[0].getX(), bestRoute[0].getY());
  endShape();
  
  population.naturalSelection(); //<>//
  population.calcFitness();
  if (population.getGenerationCount() == 5000) {
    trialCount++;
    if (trialCount == 11) {
      rateCount += 2;
      trialCount = 1;
      if (rateCount == 11) {
        System.exit(0);
      }
    }
    population = new Population(cities, 999, 0.9, (float)rateCount/10);
    population.calcFitness();
  }
}
