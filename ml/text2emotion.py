# -*- coding: utf-8 -*-
"""text2emotion.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/14m2_V6UhJ1L9ZMWL_vB7H1aF6wZXzzyH
"""

from transformers import pipeline
import argparse

model = pipeline("text-classification",
                 model="j-hartmann/emotion-english-distilroberta-base", return_all_scores=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("text", default="")
    text = parser.parse_args().text
    print(model(text))