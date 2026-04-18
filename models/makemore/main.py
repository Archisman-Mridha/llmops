import torch

class BigramModel:
  rng = torch.Generator( ).manual_seed(2147483647)

  def __init__(self, data_file_path: str):
    self.training_data = open(data_file_path, "r").read( ).splitlines( )

  def train(self):
    names = self.training_data

    characters = sorted(list(set("".join(names))))

    self.stoi = { s: i for i, s in enumerate(characters) }
    self.stoi["."] = 0

    self.itos = { i: s for s, i in self.stoi.items( ) }

    # Suppose, the characters corresponding to the mth row and nth column be a, b.
    # The (m, n)th entry here represents how many times we see the bigram ab.
    # Btw, we don't use the actual characters, but rather the character indices.
    self.bigram_occurence_counts = torch.zeros((28, 28), dtype= torch.int32)

    for name in names:
      name = ["."] + list(name) + ["."]
      for character_1, character_2 in zip(name, name[1:]):
        character_index_1 = self.stoi[character_1]
        character_index_2 = self.stoi[character_2]

        self.bigram_occurence_counts[character_index_1, character_index_2] += 1

    # We add 1 to self.bigram_occurence_counts for model smoothing.
    #
    # Consider the bigram : jq, which never appears in our training dataset.
    # When we take a log of that bigram's occurence probability, it evaluates to negative infinity.
    # And, makes the Normalized Negative Log Likehood infinity.
    #
    # We avoid this by model smoothing.
    b = (self.bigram_occurence_counts + 1).float( )
    self.bigram_probability_distributions = b / b.sum(1, keepdim=True)

  def generate(self):
    for _ in range(50):
      generated_name = [ ]

      character_index = 0
      while True:
        next_character_probability_distribution = self.bigram_probability_distributions[character_index]

        next_character_index = torch.multinomial(next_character_probability_distribution,
                                                num_samples=1,
                                                replacement=True,
                                                generator=self.rng).item( )
        next_character = self.itos[next_character_index]

        generated_name.append(next_character)

        if next_character_index == 0:
          break

        character_index = next_character_index

      generated_name = "".join(generated_name)
      print(generated_name)

  def loss(self):
    bigram_count = 0
    log_likelihood = 0

    name = ["."] + list(self.training_data[1]) + ["."]

    # We go through all the bigrams present in the name : multiplying the probabilities of each.
    # The product is called likelihood. And our goal is to maximize this likelihood.
    for character_1, character_2 in zip(name, name[1:]):
      character_index_1 = self.stoi[character_1]
      character_index_2 = self.stoi[character_2]

      bigram_count += 1

      bigram_probability = self.bigram_probability_distributions[character_index_1, character_index_2]

      bigram_log_probability = torch.log(bigram_probability)
      log_likelihood += bigram_log_probability

    negative_log_likelihood = -log_likelihood
    negative_log_likelihood /= bigram_count

    return negative_log_likelihood

def main( ):
  bigram_model = BigramModel("data/names.txt")

  bigram_model.train( )
  bigram_model.generate( )

  negative_log_likelihood = bigram_model.loss( )
  print("Negative Log Likelihood : ", negative_log_likelihood)

if __name__ == "__main__":
  main( )
