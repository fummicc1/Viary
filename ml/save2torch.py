from transformers import AutoModelForSequenceClassification, AutoTokenizer

# モデルとトークナイザーのロード
model_name = "j-hartmann/emotion-english-distilroberta-base"
model = AutoModelForSequenceClassification.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# モデルとトークナイザーをローカルに保存
output_dir = "./emotion_classification_model"
model.save_pretrained(output_dir)
tokenizer.save_pretrained(output_dir)
