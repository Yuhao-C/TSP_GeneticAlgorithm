public class Population {
  private City[] cities;
  private int populationNum;
  private float mutationRate;
  private float crossoverRate;
  private DNA[] population = new DNA[populationNum];
  private DNA bestOne;
  private double shortestDistance;
  private double bestFitness;
  private double sumFitness;
  private int generationCount = 1;
  
  City[] getBestRoute() {
    return bestOne.getGenes();
  }
  
  public double getShortestDistance() {
    return this.shortestDistance;
  }
  public int getGenerationCount() {
    return this.generationCount;
  }
  
  Population(City[] cities, int populationNum, float crossoverRate, float mutationRate) {
    this.cities = cities;
    this.populationNum = populationNum;
    this.population = new DNA[populationNum];
    this.crossoverRate = crossoverRate;
    this.mutationRate = mutationRate;
    println("Generation " + generationCount);
    println("-----------------------------");
    for (int i = 0; i < populationNum; i++) {
      DNA dna = new DNA(this.cities, true);
      population[i] = dna;
    }
  }
  
  void calcFitness() {
    sumFitness = 0;
    sumFitness += population[0].calcFitness();
    shortestDistance = population[0].getDistance();
    bestFitness = population[0].getFitness();
    bestOne = population[0];
    for (int i = 1; i < populationNum; i++) {
      double currentFitness = population[i].calcFitness();
      sumFitness += currentFitness;
      if (currentFitness > bestOne.getFitness()) {
        shortestDistance = population[i].getDistance();
        bestFitness = currentFitness;
        bestOne = population[i];
      }
    }
    println("Shortest Distance: " + shortestDistance);
    println("Best Fitness: " + bestFitness);
    println();
  }
  
  void naturalSelection() {
    DNA[] nextGeneration = new DNA[populationNum];
    nextGeneration[0] = new DNA(bestOne.getGenes(),false);
    for (int i = 1; i < populationNum; i += 2) {
      DNA[] parents = new DNA[2];
      for (int j = 0; j < 2; j++) {
        double randomFitness = random((float)(sumFitness));
        int index = -1;
        while (randomFitness >= 0) {
          randomFitness -= population[++index].getFitness();
        }
        parents[j] = population[index];        
      }
      final int k = floor(random(cityNum)); //<>//
      final int j = floor(random(cityNum));
      final int start = min(k,j);
      final int end = max(k,j);
      DNA child1 = parents[0].crossover(parents[1], start, end, crossoverRate);
      DNA child2 = parents[1].crossover(parents[0], start, end, crossoverRate);
      child1 = child1.mutate(mutationRate);
      child2 = child2.mutate(mutationRate);
      nextGeneration[i] = child1;
      nextGeneration[i+1] = child2;
    }
    this.population = nextGeneration;
    println("Generation " + ++generationCount);
    println("-----------------------------");
  }
}
