import coremltools as ct
import torch.nn.functional as F
import torch
import os
from transformers import RobertaForSequenceClassification, RobertaTokenizer

os.environ["TOKENIZERS_PARALLELISM"] = "false"

class ModifiedRobertaForSequenceClassification(RobertaForSequenceClassification):
    def forward(self, input_ids, attention_mask=None):
        outputs = super().forward(input_ids, attention_mask=attention_mask)        
        logits = outputs.logits
        print("logits", logits)
        probabilities = torch.nn.functional.softmax(logits, dim=1)
        print("probs", probabilities)
        return probabilities

def main():
    model_name = "j-hartmann/emotion-english-distilroberta-base"
    model = ModifiedRobertaForSequenceClassification.from_pretrained(model_name).eval()
    tokenizer = RobertaTokenizer.from_pretrained(model_name)

    # Set up a sample input to trace the model
    text = "it's"
    tokens = tokenizer(text, return_tensors='pt')
    print("tokens", tokens)
    input_names = list(tokens.keys())

    # Trace the model with the sample input
    traced_model = torch.jit.trace(model, [tokens['input_ids'], tokens['attention_mask']], strict=False)
    return

    # Set the input_shape to use RangeDim for each dimension.
    input_shape = ct.Shape(
        shape=(
            1,
            ct.RangeDim(lower_bound=3, upper_bound=300, default=3),
        )
    )
    attention_shape = ct.Shape(
        shape=(
            1,
            ct.RangeDim(lower_bound=3, upper_bound=300, default=3),
        )
    )

    # Convert to Core ML
    coreml_model = ct.convert(
        traced_model,
        source="pytorch",
        convert_to="mlprogram",
        inputs=[
            ct.TensorType(name=input_names[0], shape=input_shape, dtype=int),
            ct.TensorType(name=input_names[1], shape=attention_shape, dtype=int),
        ],
    )
    model_compressed = ct.compression_utils.affine_quantize_weights(coreml_model)

    # Save the Core ML model as an .mlpackage
    coreml_model.save("emotion-english-distilroberta-base.mlpackage")
    model_compressed.save("emotion-english-distilroberta-base-compressed.mlpackage")

if __name__ == "__main__":
    main()
