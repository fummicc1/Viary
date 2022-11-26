from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
import argparse

import warnings
warnings.filterwarnings("ignore")


tokenizer = AutoTokenizer.from_pretrained("Helsinki-NLP/opus-mt-ja-en")

model = AutoModelForSeq2SeqLM.from_pretrained("Helsinki-NLP/opus-mt-ja-en")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("text", default="")
    text = parser.parse_args().text
    batch = tokenizer([text], return_tensors="pt")
    generated_ids = model.generate(**batch)
    ret = tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]
    print(ret)