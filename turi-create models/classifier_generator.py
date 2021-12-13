import turicreate as tc
import os

instruments = {
  "singing": "voi",
  "piano": "pia",
  "electricguitar": "gac",
  "acousticguitar": "gel",
  "violin": "vio",
  "cello": "cel",
  "saxophone": "sax",
  "flute": "flu",
  "clarinet": "cla",
  "trumpet": "tru",
  "drums": "dru"
}

for name, label in instruments:
  # Load and label the training data
  train = tc.load_audio("IRMAS-TrainingData", with_path=True, recursive=True)
  train["path"] = [label in path for path in train["path"]]
  print(train)

  # Load and label the testing data
  test = tc.load_audio("ITMAS-TestingData", with_path=True)

  def check_for_label(audio_path, label):
    labels_path = audio_path[:-3] + "txt"
    with open(labels_path) as f:
      return label in f.read()

  test["path"] = [check_for_label(path, label) for path in test["path"]]
  print(test)

  # Create and train the model
  model = tc.sound_classifier.create(train, target="path", feature="audio")
  print(model)

  # Evaluate model
  metrics = model.evaluate(test)
  print(metrics)

  # Export to CoreML
  model.export_coreml(name + "_classifier.mlmodel")