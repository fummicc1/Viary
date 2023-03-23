import argparse
from transformers import AutoModelForSequenceClassification, AutoTokenizer, pipeline

# モデルとトークナイザーのロード
model_name = "j-hartmann/emotion-english-distilroberta-base"
# model = AutoModelForSequenceClassification.from_pretrained(model_name)
model = pipeline(
    "text-classification",
    model=model_name,
    return_all_scores=True
)

# モデルとトークナイザーをローカルに保存
output_dir = "./emotion_classification_model"
model.save_pretrained(output_dir)
model.tokenizer.save_pretrained(output_dir)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("text", default="")
    text = parser.parse_args().text
    print(model(text))
