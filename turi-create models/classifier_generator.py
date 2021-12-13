import turicreate as tc

instruments = {
  "singing": "voi",
  "piano": "pia",
  "electricguitar": "gel",
  "acousticguitar": "gac",
  "violin": "vio",
  "cello": "cel",
  "saxophone": "sax",
  "flute": "flu",
  "clarinet": "cla",
  "trumpet": "tru",
  "drums": "dru"
}

def check_for_label(audio_path, label):
  labels_path = audio_path[:-3] + "txt"
  with open(labels_path) as f:
    return label in f.read()

# Calculate deep features in testing data
test = tc.load_audio("IRMAS-TestingData", with_path=True, recursive=True)
test["deep_features"] = tc.sound_classifier.get_deep_features(test["audio"])

# Calculate deep features in training data
train = tc.load_audio("IRMAS-TrainingData", with_path=True, recursive=True)
train["deep_features"] = tc.sound_classifier.get_deep_features(train["audio"])

for name, label in instruments.items():
  # Label the training data for target instrument
  train["target"] = ['[' + label + ']' in path for path in train["path"]]
  test["target"] = [check_for_label(path, label) for path in test["path"]]
  data = train.append(test)
  if name == "drums":
    data = train
  print(data)

  # Create and train the model
  model = tc.sound_classifier.create(data, target="target", feature="deep_features", batch_size=1024, validation_set=None)
  print(model)

  # Evaluate model
  # metrics = model.evaluate(test)
  # print(metrics)

  # Export to CoreML
  model.export_coreml(name + "_classifier.mlmodel")
