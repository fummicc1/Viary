import coremltools as ct
import torch.nn.functional as F
import torch
from transformers import RobertaForSequenceClassification, RobertaTokenizerFast

class ModifiedRobertaForSequenceClassification(RobertaForSequenceClassification):
    def forward(self, input_ids, attention_mask=None):
        outputs = super().forward(input_ids, attention_mask=attention_mask)
        logits = outputs.logits
        # Assuming logits is the output from the model
        probabilities = F.softmax(logits, dim=-1)
        return probabilities

def main():
    model_name = "j-hartmann/emotion-english-distilroberta-base"
    model = ModifiedRobertaForSequenceClassification.from_pretrained(model_name)
    tokenizer = RobertaTokenizerFast.from_pretrained(model_name)

    # Set up a sample input to trace the model
    text = "This is a sample input text."
    tokens = tokenizer(text, return_tensors='pt')
    input_names = list(tokens.keys())

    # Trace the model with the sample input
    traced_model = torch.jit.trace(model, [tokens['input_ids'], tokens['attention_mask']], strict=False)
    
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
        inputs=[
                ct.TensorType(name=input_names[0], shape=input_shape, dtype=int),
                ct.TensorType(name=input_names[1], shape=attention_shape, dtype=int),
            ],
        classifier_config=ct.ClassifierConfig(class_labels=list(model.config.id2label.values())),
    )

    # Save the Core ML model as an .mlpackage
    coreml_model.save("emotion-english-distilroberta-base.mlpackage")

if __name__ == "__main__":
    main()
