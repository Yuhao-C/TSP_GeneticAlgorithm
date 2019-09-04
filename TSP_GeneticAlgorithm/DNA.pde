public class DNA {
  private City[] genes;
  private double fitness;
  private double distance;
  
  private double getFitness() {return this.fitness;}
  private double getDistance() {return this.distance;}
  
  private City[] getGenes() {
    return genes;
  }
  
  public DNA(City[] cities, boolean firstGeneration) {
    this.genes = deepCopy(cities);
    if (firstGeneration) {
      shuffleGenes(genes.length);
    }
  }
  
  private void shuffleGenes(int n) {
    for (int i = n-1; i > 0; i--) {
      int j = floor(random(i));
      swap(genes, i, j);
    }
  }
  
  private double calcFitness() {
    double distance = dist(genes[0].getX(), genes[0].getY(), genes[genes.length-1].getX(), genes[genes.length-1].getY());
    for (int i = 1; i < genes.length; i++) {
      distance += dist(genes[i-1].getX(), genes[i-1].getY(), genes[i].getX(), genes[i].getY());
    }
    this.distance = distance;
    this.fitness = pow((float)(10000 / distance), 4);
    return this.fitness;
  }
  
  private DNA crossover(DNA parent2, int start, int end, float crossoverRate) {
    if (random(1) < crossoverRate) {
      final int count = end - start + 1;
      City[] child = new City[cityNum];
      arrayCopy(subset(this.genes, start, count), 0, child, start, count);
      int insertIndex = end + 1;
      for (int k = 0; k < cityNum; k++) {
        int index = (k + end + 1) % cityNum;
        City city = parent2.getGenes()[index];
        if (contains(child, city)) {
          continue;
        } else {
          child[insertIndex % cityNum] = city;
          insertIndex++;
        }
      }
      return new DNA(child, false);  
    } else {
      return new DNA(this.genes, false);
    }
  }
  
  private DNA mutate(float mutationRate) {
    City[] newGenes;
    if (random(1) < mutationRate) {
      int i = floor(random(genes.length));
      int j = floor(random(genes.length));
      int start = min(i,j);
      int end = max(i,j);
      int count = end - start + 1;
      City[] before = (City[]) subset(genes,0,start);
      City[] after = (City[]) subset(genes, (end+1));
      City[] selectedSection = (City[]) subset(genes, start, count);
      selectedSection = (City[]) reverse(selectedSection);
      newGenes = (City[]) concat(before, selectedSection);
      newGenes = (City[]) concat(newGenes, after);
    } else {
      newGenes = this.genes;
    }
    return new DNA(newGenes, false);
  }
  
  void swap(City[] cities, int i, int j) {
    City temp = cities[i];
    cities[i] = cities[j];
    cities[j] = temp;
  }

  public City[] deepCopy(City[] genes) {
    City[] newGenes = new City[TSP_GeneticAlgorithm.cityNum];
    for (int i = 0; i < genes.length; i++) {
      newGenes[i] = genes[i];
    }
    return newGenes;
  }

  public boolean contains(City[] genes, City city) {
    boolean contains = false;
    for (City gene: genes) {
      if (city.equals(gene)) {
        contains = true;
        break;
      }
    }
    return contains;
  }
}
