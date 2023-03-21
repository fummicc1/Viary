import torch
import numpy as np
from transformers import AutoModel, AutoTokenizer
import coremltools as ct

model_name = "emotion_classification_model"
model = AutoModel.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)


class WrappedModel(torch.nn.Module):
    def __init__(self, model):
        super(WrappedModel, self).__init__()
        self.model = model

    def forward(self, input_ids):
        # Ensure we only return the tensor from the output dictionary
        input_ids = input_ids.long()  # Convert input_ids to torch.long
        return self.model(input_ids)["last_hidden_state"]


# Wrap the model
wrapped_model = WrappedModel(model)

# Convert the model to TorchScript
dummy_input = "This is a sample text"
dummy_tokens = tokenizer.encode(dummy_input, return_tensors="pt")
traced_model = torch.jit.trace(wrapped_model, dummy_tokens)

# Set the input_shape to use RangeDim for each dimension.
input_shape = ct.Shape(
    shape=(
        ct.RangeDim(lower_bound=3, upper_bound=300, default=3),
        1
    )
)

# Convert to Core ML using the Unified Conversion API
mlmodel = ct.convert(
    model=traced_model,
    inputs=[ct.TensorType(shape=input_shape, dtype=np.int64)],
    outputs=[ct.TensorType(name="output")],
    source="pytorch"
)

# Save the Core ML model
mlmodel.save("emotion_classification_model.mlmodel")
